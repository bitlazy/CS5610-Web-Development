<%@ Page Language="C#" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>


<script runat="server">


    // API Endpoint for Hospital dataset
    string baseURL = "http://data.medicare.gov/resource/v287-28n3.xml?";
    string xmlResponse = "";
    string hidden;

    /* fetchFromAPI : String -> Void
     * GIVEN: a query that needs to be passed to the API and query the hospital data set
     * EFFECTS: returns the query results from the API and sets it to the gridview control
     *          in the page
     */
    public void fetchFromAPI(string query)
    {
        try
        {
            // Create a new data set
            DataSet RunDS = new DataSet();

            // Initialise a WebClient to create a request.
            System.Net.WebClient wc = new System.Net.WebClient();
            // Force the API to return the data in XML format
            wc.Headers["Accept"] = "application/xml";
            xmlResponse = wc.DownloadString(baseURL + query);


            // Remove the <response></response> tags from the response to avoid extra blank rows in the result
            xmlResponse = xmlResponse.Replace("<response>", " ");
            xmlResponse = xmlResponse.Replace("</response>", "");

            // transform the XML string into the data set
            RunDS.ReadXml(new System.IO.StringReader(xmlResponse));


            if (RunDS.Tables.Count != 0)
            {
                // Set the datasource of the grid view to data set
                GridView1.DataSource = RunDS;

                GridView1.DataBind();

                // Allocate width to each column in the grid view
                GridView1.Columns[0].ItemStyle.Width = Unit.Percentage(50);
                GridView1.Columns[1].ItemStyle.Width = Unit.Percentage(10);
                GridView1.Columns[2].ItemStyle.Width = Unit.Percentage(5);
                GridView1.Columns[3].ItemStyle.Width = Unit.Percentage(25);
                GridView1.Columns[4].ItemStyle.Width = Unit.Percentage(10);
                GridView1.Visible = true;
            }
            else
            {
                // Display a friendly message to the user
                errorMsg.InnerText = "Sorry! No hosiptals found in this location!";
                errorMsg.Visible = true;
            }
        }
        catch
        {
            // Display a friendly message to the user
            errorMsg.InnerText = "Sorry!An unexpected error occured! Please try again later";
            errorMsg.Visible = true;
        }


    }


    /* fetchFromDBAndSetToCity_ddl : String -> Void
     * GIVEN: the query string that needs to be passed to the Hospital API
     * EFFECTS: retrives the city list for the given state and sets it 
     *          to the drop down list on the page
     */ 
    public void fetchFromDBAndSetToCity_ddl(string query)
    {
        try
        {           
            city_ddl.Items.Add("All Cities");
            // Create a connection object by retriving the connection string from the web.config file
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["prodConString"].ToString()))
            {
                SqlCommand city_cmd = new SqlCommand(query, con);

                // open the connection
                con.Open();

                SqlDataReader dr2 = city_cmd.ExecuteReader();
                while (dr2.Read())
                {
                    // Add each string to the city_ddl  drop down list
                    city_ddl.Items.Add(dr2[0].ToString());
                }
                // Close the connection
                con.Close();
            }
        }
        catch
        {
            // display a friendly message to the user.
            errorMsg.InnerText = "Sorry! An unexpected error has occured! Please try again.";
            errorMsg.Visible = true;
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {       

        try
        {
            // Create a connection object by retriving the connection string from the web.config file
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["prodConString"].ToString()))
            {
                // With the above connection, create a SQLCommand to select the states
                SqlCommand cmd = new SqlCommand("SELECT DISTINCT STATE, STATE_ABBR FROM sand89.LOC(NOLOCK) ORDER BY STATE", con);

                // Open the connection
                con.Open();

                // Execute the command and start parsing it using a SQLDataReader
                SqlDataReader dr1 = cmd.ExecuteReader();


                while (dr1.Read())
                {
                    // Set the first column (index 0) values to the state dropdownlist
                    ListItem li = new ListItem(dr1[0].ToString(), dr1[1].ToString());
                    state_ddl.Items.Add(li);

                }

                // Close the connection
                con.Close();

            }

            // Call the fetchFromDBAndSetToCity_ddl() and get the cites in Alabama city 
            string initialCityQuery = "SELECT DISTINCT CITY FROM sand89.LOC(NOLOCK) WHERE STATE_ABBR LIKE 'AL' ORDER BY CITY";

            // Call the fetchFromDBAndSetToCity_ddl() function and pass the above formed query as input
            fetchFromDBAndSetToCity_ddl(initialCityQuery);
            
        }
        catch
        {
            
            // display a friendly message to the user
            errorMsg.InnerText = "Sorry! An unexpected error has occured! Please try again.";
            errorMsg.Visible = true;


        }


    }

    protected void state_ddl_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Clear the city drop down list before populating them        
        city_ddl.Items.Clear();
        
        // Form the query to select the cities based on the state selected
        string initialCityQuery = "SELECT DISTINCT CITY FROM sand89.LOC(NOLOCK) WHERE STATE_ABBR LIKE '" + state_ddl.SelectedItem.Value + "' ORDER BY CITY";

        // call the fetchFromDBAndSetToCity_ddl() function by passing the above formed query
        fetchFromDBAndSetToCity_ddl(initialCityQuery);
        
        // Keep track of the tab from which the request came
        currentTab.Value = "Tab2";
        
    }

    protected void search_by_hospital_name_Click(object sender, EventArgs e)
    {
        
        // hide the error message and gridview from the user
        errorMsg.Visible = false;
        GridView1.Visible = false;
        
        // get the hospital name from the page text box
        string hospital_name = hospital_name_txtbox.Text.Trim();

        // Do a basic validation on the given input
        if (hospital_name.Length <= 3)
        {
            errorMsg.InnerText = "Hospital name cannot be less than 3 characters";
            errorMsg.Visible = true;

        }
            
        else
        {
            // Form the query to fetch the results from the API
            string query = "$select=provider_number, hospital_name, city,state, hospital_type&$where=hospital_name='" + HttpUtility.UrlEncode(hospital_name) + "'";

            // call the fetchFromAPI() from the above formed query
            fetchFromAPI(query);
        }

    }

    protected void search_by_hospital_location_Click(object sender, EventArgs e)
    {
        // hide the error message and gridview from the user
        errorMsg.Visible = false;
        GridView1.Visible = false;
        
        // Get the state and city values from the drop down lists
        string query = "";
        string state = state_ddl.SelectedItem.Value;
        string city = city_ddl.SelectedItem.Text;

        // Form the query based on the above given values
        if (city != "All Cities")
            query = "$select=provider_number, hospital_name, city, state, hospital_type&$where=state='" + state + "' AND city='" + city + "'";
        else
            query = "$select=provider_number, hospital_name, city, state, hospital_type&$where=state='" + state + "'";

        // call the fetchFromAPI() from the above formed query
        fetchFromAPI(query);
        
        // Keep track of the tab from which the request came.
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
    <script src="js/tabKeeper.js" type="text/javascript"></script>
      
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


            <div class="content" style="text-align: left; min-height: 300px">
                <h2>Hospital Search</h2>
                <p><b>Note:</b> The ratings of hospitals represented here are provided by the Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS). HCAHPS is a national, standardized survey of hospital patients about their experiences during a recent inpatient hospital stay.</p>
                
            <div id="Tab">
            <ul class="resp-tabs-list">
              <li id="Tab1">Search By Hospital Name</li>
              <li id="Tab2">Search Hospital By Location</li>
            </ul>

            <div class="resp-tabs-container">
                <div>               
                      <p>Enter Hospital Name:</p>
                      <p><asp:TextBox ID="hospital_name_txtbox" runat="server"></asp:TextBox></p>
                      <p><asp:Button ID="search_by_hospital_name" runat="server" Text="Search" OnClick="search_by_hospital_name_Click" /></p>
                    <br />  
                    <p>Example: Carney Hospital, Tufts Medical Center</p>
                </div>
                <div>
                    <p>Select State :</p>
                    <p><asp:DropDownList ID="state_ddl" runat="server" AutoPostBack="true" OnSelectedIndexChanged="state_ddl_SelectedIndexChanged"></asp:DropDownList></p>
                    <p>Select City :</p>
                    <p><asp:DropDownList ID="city_ddl" runat="server"></asp:DropDownList></p>
                    <p><asp:Button ID="search_by_hospital_location" runat="server" Text="Search" OnClick="search_by_hospital_location_Click" /></p>
                </div>
                
            </div>
        </div>

            </div>


            <div class="result" style="display: block; width: 100%; min-height: 300px; margin-top:10px;">
                <p id="errorMsg" runat="server" visible="false" style="text-align: center; background-color: skyblue; border: 1px dotted gray"></p>

                <asp:GridView ID="GridView1" runat="server" Visible="false" AutoGenerateColumns="False"
                    Style="width: 100%" CellPadding="1" ForeColor="#333333" GridLines="None">
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <RowStyle BackColor="#EFF3FB" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:BoundField ReadOnly="True" HeaderText="Hospital Name"
                            DataField="hospital_name"></asp:BoundField>
                        <asp:BoundField HeaderText="City"
                            DataField="city"></asp:BoundField>
                        <asp:BoundField HeaderText="State"
                            DataField="state"></asp:BoundField>
                        <asp:BoundField HeaderText="Hospital Type"
                            DataField="hospital_type"></asp:BoundField>
                        <asp:HyperLinkField DataNavigateUrlFields="provider_number" DataNavigateUrlFormatString="findHospital-helper.aspx?provider_id={0}" HeaderText="More" Text="View Details" Target="_blank" />
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
     <input type="hidden" id="currentTab" runat="server"/>
</body>
</html>

