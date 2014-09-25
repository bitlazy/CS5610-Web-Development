<%@ Page Language="C#" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Xml" %>

<!DOCTYPE html>

<script runat="server">

    string baseURL = "http://data.healthcare.gov/resource/b8in-sz6k.xml?";
    string xmlResponse = "";


    /* fetchFromAPI : String String -> List
     * GIVEN: the query to be executed on the API and the node name from which 
     * the details needs to be extracted
     * RETURNS: a list with the text retrived from the given node name
     */    
    public List<string> fetchFromAPI(string query, string item)
    {
        try
        {
            // Initialise a list to hold the result
            List<string> myList = new List<string>();

            // create a web client object to make a http request
            System.Net.WebClient wc = new System.Net.WebClient();
            // Force the API to return the data in XML format
            wc.Headers["Accept"] = "application/xml";
            xmlResponse = wc.DownloadString(baseURL + query);

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xmlResponse);
            XmlNodeList Nodes = doc.DocumentElement.SelectNodes("/response/row/row");

            // For each item in the list, Add the retrived records to the list
            foreach (XmlNode node in Nodes)
            {
                myList.Add(node.SelectSingleNode(item).InnerText);
            }

            // return the list
            return myList;
        }
        catch
        {
           // display a friendly message to the user
            errorMsg.InnerText = "Sorry! An unexpected error occured. Please try again later";
            errorMsg.Visible = true;
            return null;
            
        }
    }


   /* fetchAndBindToGridView : String -> Void
    * GIVEN: a query string that needs to be passed to the API
    * EFFECTS: retrives the result from the API dataset and sets it to the result grid view
    */
    public void fetchAndBindToGridView(string query)
    {
        try
        {
            // Initialise a new dataset to hold the results
            DataSet RunDS = new DataSet();

            // Create a web client object to make a request
            System.Net.WebClient wc = new System.Net.WebClient();
            // Force the API to return the data in XML format
            wc.Headers["Accept"] = "application/xml";
            xmlResponse = wc.DownloadString(baseURL + query);

            // remove the  <response></response> tags form the result to avoid blank lines showing up in the results
            xmlResponse = xmlResponse.Replace("<response>", " ");
            xmlResponse = xmlResponse.Replace("</response>", "");

            // read the xml response into the data set.
            RunDS.ReadXml(new System.IO.StringReader(xmlResponse));

            // Bind the dataset table to the grid view and make it visible
            GridView1.DataSource = RunDS.Tables[0];
            GridView1.DataBind();
            GridView1.Visible = true;


        }
        catch
        {
            
            // display a friendly message to the user
            errorMsg.InnerText = "Sorry! No matching plans found";
            errorMsg.Visible = true;
        }


    }


    protected void Page_Load(object sender, EventArgs e)
    {
    
        try
        {
           // If the page is loading for the first time, then query the API to get the list of states that are participating in the Health insurance market place run by the federal government.
            if (!IsPostBack)
            {
                ind_state_ddl.Items.Clear();
                fam_state_ddl.Items.Clear();
                string query = "$select=state&$group=state";
                
               // Call the fetchFromAPI() function to populate the drop down lists
                ind_state_ddl.DataSource = fetchFromAPI(query, "state");
                fam_state_ddl.DataSource = fetchFromAPI(query, "state");
                ind_state_ddl.DataBind();
                fam_state_ddl.DataBind();

            }

        }
        catch
        {
            // Display a friendly message to the user.
            errorMsg.InnerText = "An unexpected error occured! Please try again later!";
            errorMsg.Visible=true;
        }
    }

    protected void ind_state_ddl_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Clear the county ddl before populating with new values
        ind_county_ddl.Items.Clear();
        
        // Form the query to pull the list of counties in that state
        string query = "$select=county&$where=state='" + ind_state_ddl.SelectedItem.Text + "'&$group=county";

        // populate the county ddl by using fetchFromAPI() function
        ind_county_ddl.DataSource = fetchFromAPI(query, "county");
        ind_county_ddl.DataBind();
    }

    protected void fam_state_ddl_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Clear the county ddl before populating with new values
        fam_county_ddl.Items.Clear();

        // Form the query to pull the list of counties in that state
        string query = "$select=county&$where=state='" + fam_state_ddl.SelectedItem.Text + "'&$group=county";

        // Populate the county drop down list by callingn the fetchFromAPI() function and passing the above formed query
        fam_county_ddl.DataSource = fetchFromAPI(query, "county");
        fam_county_ddl.DataBind();
        
        // Keep track of the tab from which the request came so that the same tab is retained upon postback
        currentTab.Value = "Tab2";
    }

    protected void ind_search_Click(object sender, EventArgs e)
    {
        
        // hide the error and result controls from the user
        errorMsg.Visible = false;
        GridView1.Visible = false;

        // declare the required variables
        string state, county, age, premium_column;
        int premium;

        // Check if the county is selected or not
        if (ind_county_ddl.SelectedItem.Value == "-1")
        {
            errorMsg.InnerText = "Please select your county";
            errorMsg.Visible = true;
        }
        // Check if the premium is selected    
        else if (Convert.ToInt32(hidden.Value) == 0)
        {
            errorMsg.InnerText = "Please choose the maximum payable premium";
            errorMsg.Visible = true;
        }
            
        else
        {
            // Get the inputs from the page
            state = ind_state_ddl.SelectedItem.Text;
            county = ind_county_ddl.SelectedItem.Text;
            premium = Convert.ToInt32(hidden.Value);
            age = ind_age_ddl.SelectedItem.Value;

            // Determine the column that which need to be queried based on the individual's age.
            if (age == "20")
                premium_column = "premium_child";
            else
                premium_column = "premium_adult_individual_age_" + age;


            // Form the API request with the collected details
            string query = "$select=plan_id_standard_component, plan_marketing_name, metal_level, " + premium_column + " as premium, county&$where=state='" + state + "' AND county='" + county + "' AND " + premium_column + "<=" + premium + "&$order=" + premium_column;

            // Call the fetchAndBindToGridView() function to retrive the suitable health plans from the API and set it to the grid view
            fetchAndBindToGridView(query);
            
            // reset the premium range control back to zero
            hidden.Value = "0";


        }
    }


    protected void fam_search_Click(object sender, EventArgs e)
    {
        // hide the error and result controls from the user
        errorMsg.Visible = false;
        GridView1.Visible = false;

        // declare the required variables
        string state, county, premium_column;
        int premium;

        // Check if the county is selected or not
        if (fam_county_ddl.SelectedItem.Value == "-1")
        {
            errorMsg.InnerText = "Please select your county";
            errorMsg.Visible = true;
        }
        // Check if the premium is selected 
        else if (Convert.ToInt32(hidden.Value) == 0)
        {
            errorMsg.InnerText = "Please choose the maximum payable premium";
            errorMsg.Visible = true;
        }
        else
        {
            // Get the inputs from the page
            state = fam_state_ddl.SelectedItem.Text;
            county = fam_county_ddl.SelectedItem.Text;
            premium_column = fam_type_ddl.SelectedItem.Value;
            premium = Convert.ToInt32(hidden.Value);

            // Form the API request with the collected details
            string query = "$select=plan_id_standard_component, plan_marketing_name, metal_level, " + premium_column + " as premium, county&$where=state='" + state + "' AND county='" + county + "' AND " + premium_column + "<=" + premium + "&$order=" + premium_column;

            // Call the fetchAndBindToGridView() function to retrive the suitable health plans from the API and set it to the grid view
            fetchAndBindToGridView(query);

            // reset the premium range control back to zero
            hidden.Value = "0";
        }
        
        // Keep track of the tab from which the request came so that the same tab is retained on postback.
        currentTab.Value = "Tab2";
    }
        
        
   
</script>

<html>
<head>
    <title>OneHealth - Simplifying Life</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <link rel="stylesheet" href="StyleSheet.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon">

    <script src="js/easyResponsiveTabs.js" type="text/javascript"></script>

    <%--Script to keep track of tabs--%>
    <script src="js/tabKeeper.js" type="text/javascript"></script>
    <%--Script to read the value of range control--%>
    <script src="js/rangeControlReader.js" type="text/javascript"></script>


    <script>
        
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="pad">


            <!-- LOGO START-->
            <div class="header">

                <div id="logo">
                    <img id="logo_img" src="images/logo1.png" />
                </div>

                <div id="social_icons">

                <div id="gplus">
                <a href="http://plus.google.com/" target="_blank"><img class="grayscale" src="images/google-plus-icon.png" /></a>
                </div>

                <div id="twitter">
                  <a href="http://www.twitter.com/" target="_blank"><img class="grayscale" src="images/twitter-icon.png" /></a>
                </div>

                <div id="fbook">
                  <a href="http://www.facebook.com" target="_blank"><img class="grayscale" src="images/facebook-icon.png" /></a>
                </div>

            </div>

        </div>
        <!-- LOGO END -->


        <!-- MENU START -->
        <nav>
            <ul>
                <li><a href="index.html">Home</a></li>
                <li><a href="findPills.aspx">Pill Identifier</a></li>
                <li><a href="findPhysician.aspx">Find Physician</a></li>
                <li><a href="findHospital.aspx">Find Hospital</a></li>
                <li><a href="findPlan.aspx">Find A Health Plan</a></li>
                <li><a href="http://net4.ccs.neu.edu/home/sand89/story/index.htm?../project/documentation/">Documentation</a></li>
            </ul>
        </nav>
            <!-- MENU END -->

            <div class="content" style="text-align: left; min-height: 800px">
                <h2>Health Insurance Plan Finder</h2>
                <b>Note:</b>
                <ul>
                    <li>This tool shows individual and family health plans available in states where the federal government is operating the Marketplace. States not represented here run their own Marketplaces.</li>
                    <li>The prices here don’t reflect the lower costs an applicant may qualify for based on household size and income. Many people who apply will qualify for reduced costs through tax credits that are automatically applied to monthly premiums. These credits will significantly lower the prices shown for many of those applying. Final price quotes are available only after someone has completed a Marketplace application.</li>
                </ul>

                     <div id="Tab">
                        <ul class="resp-tabs-list">
                            <li id="Tab1">Search Plans For Individuals</li>
                            <li id="Tab2">Search Plans For Family</li>
                        </ul>
                        <div class="resp-tabs-container">
                            <div>
                             <p>Select State: </p>
                               <p><asp:DropDownList ID="ind_state_ddl" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ind_state_ddl_SelectedIndexChanged"></asp:DropDownList></p>
                                  <p>Select County:</p>
                               <p><asp:DropDownList ID="ind_county_ddl" runat="server">
                                    <asp:ListItem Value="-1" Text="Select City"></asp:ListItem>
                                </asp:DropDownList> </p>
                                <p>Select the age of the applicant:</p> 

                                <p><asp:DropDownList ID="ind_age_ddl" runat="server">
                                        <asp:ListItem Value="20" Text="Less than 20 years"></asp:ListItem>
                                        <asp:ListItem Value="21" Text="Between 21 and 26"></asp:ListItem>
                                        <asp:ListItem Value="27" Text="Between 27 and 29"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="Between 30 and 39"></asp:ListItem>
                                        <asp:ListItem Value="40" Text="Between 40 and 49"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="Between 50 and 59"></asp:ListItem>
                                        <asp:ListItem Value="60" Text="Between 60 and 64"></asp:ListItem>
                                    </asp:DropDownList>
                                </p>

                                <p>What is the maximum premium you can pay/month?</p>
                                <p><input id="ind_premium_range" type="range" min="0" max="3000" value="0" step="1" onchange="rangechange('ind')"><span id="ind_range_span">0$</span></p>
                                <p><input type="hidden" id="hidden" runat="server" value="0" /></p><br />
                                <p><asp:Button ID="ind_search" runat="server" Text="Search" OnClick="ind_search_Click" /></p>
                                
                            </div>


                            <div>
                                <p>Select State:</p>
                                <p><asp:DropDownList ID="fam_state_ddl" runat="server" AutoPostBack="true" OnSelectedIndexChanged="fam_state_ddl_SelectedIndexChanged"></asp:DropDownList></p>
                                    <p>Select County:</p>
                                <p><asp:DropDownList ID="fam_county_ddl" runat="server" >
                                    <asp:ListItem Value="-1" Text="Select City"></asp:ListItem>
                                </asp:DropDownList></p><br />
                                <p>Select your family type & the maximum age of the member to be covered:</p>
                                   <p><asp:DropDownList ID="fam_type_ddl" runat="server">
                                         <asp:ListItem Value="individual_1_child_age_21" Text="Individual + 1 Child - Age between 21 to 29"></asp:ListItem>
                                         <asp:ListItem Value="individual_1_child_age_30" Text="Individual + 1 Child - Age between 30 to 39"></asp:ListItem>
                                         <asp:ListItem Value="individual_1_child_age_40" Text="Individual + 1 Child - Age between 40 to 49"></asp:ListItem>
                                         <asp:ListItem Value="individual_1_child_age_50" Text="Individual + 1 Child - Age between 50 to 59"></asp:ListItem>
                                         <asp:ListItem Value="individual_2_children_age_21" Text="Individual + 2 Children - Age between 21 to 29"></asp:ListItem>
                                         <asp:ListItem Value="individual_2_children_age_30" Text="Individual + 2 Children - Age between 30 to 39"></asp:ListItem>
                                         <asp:ListItem Value="individual_2_children_age_40" Text="Individual + 2 Children - Age between 40 to 49"></asp:ListItem>
                                         <asp:ListItem Value="individual_2_children_age_50" Text="Individual + 2 Children - Age between 50 to 59"></asp:ListItem>
                                         <asp:ListItem Value="individual_3_or_more_children_age_21" Text="Individual + 3 or more Children - Age between 21 to 29"></asp:ListItem>
                                         <asp:ListItem Value="individual_3_or_more_children_age_30" Text="Individual + 3 or more Children - Age between 30 to 39"></asp:ListItem>
                                         <asp:ListItem Value="individual_3_or_more_children_age_40" Text="Individual + 3 or more Children - Age between 40 to 49"></asp:ListItem>
                                         <asp:ListItem Value="individual_3_or_more_children_age_50" Text="Individual + 3 or more Children - Age between 50 to 59"></asp:ListItem>
                                         <asp:ListItem Value="premium_couple_21" Text="Couple - Age between 21 to 29"></asp:ListItem>
                                         <asp:ListItem Value="premium_couple_30" Text="Couple - Age between 30 to 39"></asp:ListItem>
                                         <asp:ListItem Value="premium_couple_40" Text="Couple - Age between 40 to 49"></asp:ListItem>
                                         <asp:ListItem Value="premium_couple_50" Text="Couple - Age between 50 to 59"></asp:ListItem>
                                         <asp:ListItem Value="premium_couple_60" Text="Couple - Age between 60 to 64"></asp:ListItem>
                                         <asp:ListItem Value="couple_1_child_age_21" Text="Couple + 1 Child - Age between 21 to 29"></asp:ListItem>
                                         <asp:ListItem Value="couple_1_child_age_30" Text="Couple + 1 Child - Age between 30 to 39"></asp:ListItem>
                                         <asp:ListItem Value="couple_1_child_age_40" Text="Couple + 1 Child - Age between 40 to 49"></asp:ListItem>
                                         <asp:ListItem Value="couple_1_child_age_50" Text="Couple + 1 Child - Age between 50 to 59"></asp:ListItem>
                                         <asp:ListItem Value="couple_2_children_age_21" Text="Couple + 2 Children - Age between 21 to 29"></asp:ListItem>
                                         <asp:ListItem Value="couple_2_children_age_30" Text="Couple + 2 Children - Age between 30 to 39"></asp:ListItem>
                                         <asp:ListItem Value="couple_2_children_age_40" Text="Couple + 2 Children - Age between 40 to 49"></asp:ListItem>
                                         <asp:ListItem Value="couple_2_children_age_50" Text="Couple + 2 Children - Age between 50 to 59"></asp:ListItem>
                                         <asp:ListItem Value="couple_3_or_more_children_age_21" Text="Couple + 3 or more Children - Age between 21 to 29"></asp:ListItem>
                                         <asp:ListItem Value="couple_3_or_more_children_age_30" Text="Couple + 3 or more Children - Age between 30 to 39"></asp:ListItem>
                                         <asp:ListItem Value="couple_3_or_more_children_age_40" Text="Couple + 3 or more Children - Age between 40 to 49"></asp:ListItem>
                                         <asp:ListItem Value="couple_3_or_more_children_age_50" Text="Couple + 3 or more Children - Age between 50 to 59"></asp:ListItem>
                                     </asp:DropDownList>
                                </p>

                                <p>What is the maximum premium you can pay/month?  </p>
                                   <p><input id="fam_premium_range" type="range" min="0" max="3000" value="0" step="1" onchange="rangechange('fam')"><span id="fam_range_span">0$</span></p>
                                <br />
                                <p><asp:Button ID="fam_search" runat="server" Text="Search" OnClick="fam_search_Click" /></p>

                            </div>

                    </div>
                </div>
                <p id="errorMsg" runat="server" visible="false" style="text-align: center; background-color: skyblue; border: 1px dotted gray"></p>

                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                    Style="width: 100%" CellPadding="5" ForeColor="#333333" GridLines="None">
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <RowStyle BackColor="#EFF3FB" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:BoundField ReadOnly="True" HeaderText="Plan name"
                            DataField="plan_marketing_name"></asp:BoundField>
                        <asp:BoundField HeaderText="Metal Level"
                            DataField="metal_level"></asp:BoundField>
                        <asp:BoundField HeaderText="Premium (US$)"
                            DataField="premium"></asp:BoundField>
                        <asp:HyperLinkField DataNavigateUrlFields="plan_id_standard_component, county" DataNavigateUrlFormatString="findPlan-helper.aspx?plan_id={0}&county={1}" HeaderText="More" Text="View Details" Target="_blank" />
                    </Columns>
                </asp:GridView>

            </div>


            <div class="footer">
            <div id="footer_left">
                 &copy; Sandeep Ramamoorthy<br />
                College of Computer and Information Science
            </div>

            <div id="footer_middle">
                 Northeastern University,<br />
                Boston, MA
            </div>
            
            <div id="footer_right">
                Site is best viewed in <br /><img src="images/chrome.png" style="width:24px" />
            </div>

        </div>

        </div>
    </form>

   <input type="hidden" id="currentTab" runat="server" />

</body>
</html>
