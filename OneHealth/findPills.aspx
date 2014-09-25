<%@ Page Language="C#" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="edu.neu.ccis.rasala" %>

<!DOCTYPE html>

<script runat="server">


    string sqlQuery = "";
    DataSet RunDS = new DataSet();

    /* fetchFromDB : String -> Void
     * GIVEN: a SQL query string that needs to be executed in the sand89 database's NDC_PRODUCT table
     * EFFECTS: set the query results to the grid view on the page.
     */
    public void fetchFromDB(string query)
    {
        try
        {

            using (SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["prodConString"].ToString()))
            {
                SqlCommand cmd = new SqlCommand(query, cn);
                cn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();

                da.Fill(ds, "sand89.NDC_PRODUCT");

                GridView1.DataSource = ds.Tables["sand89.NDC_PRODUCT"];
                GridView1.DataBind();
                GridView1.Visible = true;

            }
        }
        catch
        {

            errorMsg.InnerText= "Unable to establish connection with the database!";
                
            errorMsg.Visible = true;

        }
    }

    /* fetchFromAPI : String -> Void
     * GIVEN: a sql query that needs to be passed to the API and query the API's dataset
     * EFFECTS: retrives the query results from the API and sets it to the grid view on the page 
     */
    public void fetchFromAPI(string query)
    {


        // Use Prof. Rasala's utility to securley get the pillbox API key.
        string nihKey = KeyTools.GetKey(this, "pillbox");
        string xmlResponse = "";

        // Initialise a WebClient to create a request.
        System.Net.WebClient wc = new System.Net.WebClient();
        // Force the API to return the data in XML format
        wc.Headers["Accept"] = "application/xml";
        xmlResponse = wc.DownloadString(query + nihKey);

        try
        {
            // Clear the data set before populating new values
            RunDS.Clear();
            RunDS.ReadXml(new System.IO.StringReader(xmlResponse));
            
            // Bind the details to result grid view
            GridView2.DataSource = RunDS.Tables[1];
            GridView2.DataBind();
            // Allocate width to each column so that they render gracefully
            GridView2.Columns[0].ItemStyle.Width = Unit.Percentage(10);
            GridView2.Columns[1].ItemStyle.Width = Unit.Percentage(80);
            GridView2.Columns[2].ItemStyle.Width = Unit.Percentage(10);

            //Set the gridview's visiblity to true
            GridView2.Visible = true;
        }
        catch
        {
            errorMsg.InnerText = "Sorry! No matching pills found";
            errorMsg.Visible = true;
        }
    }
    

    protected void search_by_pill_name_Click(object sender, EventArgs e)
    {
        
        // Hide the result and error controls from the user
        errorMsg.Visible = false;
        GridView1.Visible = false;

        // get the pill name from the text box
        string pillName = pillname_txtbox.Text.Trim();
        
        // Do a basic validation
        if (pillName.Length <= 3)
        {
            errorMsg.InnerText = "Please enter atleast 4 characters of the pill's name!";
            errorMsg.Visible = true;
        }
        else
        {
            // Form the query to search the pill details in the sand89 database
            sqlQuery = @"SELECT * FROM sand89.NDC_PRODUCT(NOLOCK) WHERE PROPRIETARYNAME LIKE '%" + Server.HtmlEncode(pillName) + "%'";

            // call the fetchFromDB function to execute the query
            fetchFromDB(sqlQuery);
        }

        // Remember the tab from which the request came so that the same tab remains active after postback.
        currentTab.Value = "Tab1";
    }

    protected void search_by_ndc_Click(object sender, EventArgs e)
    {
        // Hide the result and error controls from the user
        errorMsg.Visible = false;
        GridView1.Visible = false;

        string ndcCode = pillndc_txtbox.Text.Trim();
        if (ndcCode.Length < 8)
        {
            errorMsg.InnerText = "The NDC you provided seems to be invalid.Please verify the NDC code.";
            errorMsg.Visible = true;

        }

        else
        {
            // Form the query to search the pill details in the sand89 database
            sqlQuery = @"SELECT * FROM sand89.NDC_PRODUCT(NOLOCK) WHERE PRODUCTNDC='" + Server.HtmlEncode(ndcCode) + "'";

            // call the fetchFromDB function to execute the query
            fetchFromDB(sqlQuery);
        }
        
        // Remember the tab from which the request came so that the same tab remains active after postback.
        currentTab.Value = "Tab2";

    }

    protected void search_by_shape_colour_Click(object sender, EventArgs e)
    {
        // Hide the result and error controls from the user
        errorMsg.Visible = false;
        GridView2.Visible = false;
        GridView1.Visible = false;

        // Get the shape and color from the respective drop down lists
        string shape = shape_ddl.SelectedItem.Value;
        string colour = colour_ddl.SelectedItem.Value;

        // Start forming the API request URL with the inputs and Key. 
        // Make sure the input is Htmlencoded to avoid hacking attempts.
        string dynamicURL = "http://pillbox.nlm.nih.gov/PHP/pillboxAPIService.php?shape=" + Server.HtmlEncode(shape) + "&color=" + Server.HtmlEncode(colour) + "&key=";

        // call the fetchFromAPI function to execute the query
        fetchFromAPI(dynamicURL);

        // Remember the tab from which the request came so that the same tab remains active after postback.
        currentTab.Value = "Tab3";

    }

    protected void adv_pill_search_Click(object sender, EventArgs e)
    {
        // Hide the result and error controls from the user
        errorMsg.Visible = false;
        
        // Have the base URL handy
        string tempURL = "";
        string baseURL = "http://pillbox.nlm.nih.gov/PHP/pillboxAPIService.php?";

        
        // Get the input from the user based on the details provided
        if ((adv_color_ddl.SelectedItem.Value == "-1") && (adv_shape_ddl.SelectedItem.Value == "-1") &&
            (adv_size_ddl.SelectedItem.Value == "-1") && (advActiveIng.Text.Length == 0))
        {
            errorMsg.InnerText = "Please enter atleast one search criteria";
            errorMsg.Visible = true;
        }
        else
        {
            // Form the query string based on the inputs provided
            if (adv_color_ddl.SelectedItem.Value != "-1")
                tempURL = tempURL + "&color=" + adv_color_ddl.SelectedItem.Value;
            if (adv_shape_ddl.SelectedItem.Value != "-1")
                tempURL = tempURL + "&shape=" + adv_shape_ddl.SelectedItem.Value;
            if (adv_size_ddl.SelectedItem.Value != "-1")
                tempURL = tempURL + "&size=" + adv_size_ddl.SelectedItem.Value;
            if (advActiveIng.Text.Length > 0)
                tempURL = tempURL + "&ingredient=" + advActiveIng.Text;
            if (has_image_chkbx.Checked == true)
                tempURL = tempURL + "&has_image=1";

            // remove the leading "&" sign from the query
            tempURL = tempURL.Substring(tempURL.IndexOf("&") + 1);

            // call the fetchFromAPI function to execute the query
            fetchFromAPI(baseURL + tempURL + "&key=");
        }

        // Remember the tab from which the request came so that the same tab remains active after postback.
        currentTab.Value = "Tab4";
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

            <div class="content" style="text-align: left; min-height: 600px">
                <h2>Pill Identifier</h2>
                <p><b>Disclaimer:</b> "This product uses publicly available data from the U.S. National Library of Medicine (NLM), National Institutes of Health, Department of Health and Human Services; NLM is not responsible for the product and does not endorse or recommend this or any other product."</p>
               
                    <div id="Tab">
                        <ul class="resp-tabs-list">
                            <li id="Tab1">Search By Pill Name</li>
                            <li id="Tab2">Search By NDC</li>
                            <li id="Tab3">Search Pill By Shape & Colour</li>
                            <li id="Tab4">Advanced Pill Search</li>
                        </ul>
                        <div class="resp-tabs-container">
                            <div>
                                <p>Enter Pill's Name </p>
                                <p><asp:TextBox ID="pillname_txtbox" runat="server"></asp:TextBox></p>
                                <p><asp:Button ID="search_by_pill_name" runat="server" Text="Search" OnClick="search_by_pill_name_Click" /></p>

                                <p>Examples: Amoxapine, Leucovorin</p>
                            </div>


                            <div>

                                <p>Enter NDC# </p> 
				                <p><asp:TextBox ID="pillndc_txtbox" runat="server"></asp:TextBox></p>
                                <p><asp:Button ID="search_by_ndc" runat="server" Text="Search" OnClick="search_by_ndc_Click" /></p>
                                <p>Example 1: 36800-700</p><p> Example 2: 0078-0176</p>
                            </div>



                            <div>

                                <p>Select Shape:</p>
                               <p><asp:DropDownList ID="shape_ddl" runat="server">
                                    <asp:ListItem Value="C48335">Bullet</asp:ListItem>
                                    <asp:ListItem Value="C48336">Capsule</asp:ListItem>
                                    <asp:ListItem Value="C48337">Clover</asp:ListItem>
                                    <asp:ListItem Value="C48338">Diamond</asp:ListItem>
                                    <asp:ListItem Value="C48339">Double Circle</asp:ListItem>
                                    <asp:ListItem Value="C48340">Free Form</asp:ListItem>
                                    <asp:ListItem Value="C48341">Gear</asp:ListItem>
                                    <asp:ListItem Value="C48342">Heptagon (7 sided)</asp:ListItem>
                                    <asp:ListItem Value="C48343">Hexagon (6 sided)</asp:ListItem>
                                    <asp:ListItem Value="C48344">Octagon(8 sided)</asp:ListItem>
                                    <asp:ListItem Value="C48345">Oval</asp:ListItem>
                                    <asp:ListItem Value="C48346">Pentagon (5 sided)</asp:ListItem>
                                    <asp:ListItem Value="C48347">Rectangle</asp:ListItem>
                                    <asp:ListItem Value="C48348">Round</asp:ListItem>
                                    <asp:ListItem Value="C48349">Semi-Circle</asp:ListItem>
                                    <asp:ListItem Value="C48350">Square</asp:ListItem>
                                    <asp:ListItem Value="C48351">Tear</asp:ListItem>
                                    <asp:ListItem Value="C48352">Trapezoid</asp:ListItem>
                                    <asp:ListItem Value="C48353">Triangle</asp:ListItem>
                                </asp:DropDownList></p>


                                    <p>Colour:</p>
                                 <p><asp:DropDownList ID="colour_ddl" runat="server">
                                    <asp:ListItem Value="C48323">Black</asp:ListItem>
                                    <asp:ListItem Value="C48333">Blue</asp:ListItem>
                                    <asp:ListItem Value="C48332">Brown</asp:ListItem>
                                    <asp:ListItem Value="C48324">Gray</asp:ListItem>
                                    <asp:ListItem Value="C48329">Green</asp:ListItem>
                                    <asp:ListItem Value="C48331">Orange</asp:ListItem>
                                    <asp:ListItem Value="C48328">Pink</asp:ListItem>
                                    <asp:ListItem Value="C48327">Purple</asp:ListItem>
                                    <asp:ListItem Value="C48326">Red</asp:ListItem>
                                    <asp:ListItem Value="C48334">Turquoise</asp:ListItem>
                                    <asp:ListItem Value="C48325">White</asp:ListItem>
                                    <asp:ListItem Value="C48330">Yellow</asp:ListItem>
                                </asp:DropDownList></p>
                                <p><asp:Button ID="search_by_shape_colour" runat="server" Text="Search" OnClick="search_by_shape_colour_Click" /></p>

                            </div>


                            <div>

                                <p>Select Shape:</p>
                                 <p><asp:DropDownList ID="adv_shape_ddl" runat="server">
                                    <asp:ListItem Value="-1">All Shapes</asp:ListItem>
                                    <asp:ListItem Value="C48335">Bullet</asp:ListItem>
                                    <asp:ListItem Value="C48336">Capsule</asp:ListItem>
                                    <asp:ListItem Value="C48337">Clover</asp:ListItem>
                                    <asp:ListItem Value="C48338">Diamond</asp:ListItem>
                                    <asp:ListItem Value="C48339">Double Circle</asp:ListItem>
                                    <asp:ListItem Value="C48340">Free Form</asp:ListItem>
                                    <asp:ListItem Value="C48341">Gear</asp:ListItem>
                                    <asp:ListItem Value="C48342">Heptagon (7 sided)</asp:ListItem>
                                    <asp:ListItem Value="C48343">Hexagon (6 sided)</asp:ListItem>
                                    <asp:ListItem Value="C48344">Octagon(8 sided)</asp:ListItem>
                                    <asp:ListItem Value="C48345">Oval</asp:ListItem>
                                    <asp:ListItem Value="C48346">Pentagon (5 sided)</asp:ListItem>
                                    <asp:ListItem Value="C48347">Rectangle</asp:ListItem>
                                    <asp:ListItem Value="C48348">Round</asp:ListItem>
                                    <asp:ListItem Value="C48349">Semi-Circle</asp:ListItem>
                                    <asp:ListItem Value="C48350">Square</asp:ListItem>
                                    <asp:ListItem Value="C48351">Tear</asp:ListItem>
                                    <asp:ListItem Value="C48352">Trapezoid</asp:ListItem>
                                    <asp:ListItem Value="C48353">Triangle</asp:ListItem>
                                </asp:DropDownList></p>

                                   <p>Colour:</p>
                                   <p><asp:DropDownList ID="adv_color_ddl" runat="server">
                                    <asp:ListItem Value="-1">All Colours</asp:ListItem>
                                    <asp:ListItem Value="C48323">Black</asp:ListItem>
                                    <asp:ListItem Value="C48333">Blue</asp:ListItem>
                                    <asp:ListItem Value="C48332">Brown</asp:ListItem>
                                    <asp:ListItem Value="C48324">Gray</asp:ListItem>
                                    <asp:ListItem Value="C48329">Green</asp:ListItem>
                                    <asp:ListItem Value="C48331">Orange</asp:ListItem>
                                    <asp:ListItem Value="C48328">Pink</asp:ListItem>
                                    <asp:ListItem Value="C48327">Purple</asp:ListItem>
                                    <asp:ListItem Value="C48326">Red</asp:ListItem>
                                    <asp:ListItem Value="C48334">Turquoise</asp:ListItem>
                                    <asp:ListItem Value="C48325">White</asp:ListItem>
                                    <asp:ListItem Value="C48330">Yellow</asp:ListItem>
                                </asp:DropDownList></p>
                                    <p>Size:</p>
                                    <p><asp:DropDownList ID="adv_size_ddl" runat="server">
                                        <asp:ListItem Value="-1">All Sizes</asp:ListItem>
                                        <asp:ListItem Value="1">~ 1 mm</asp:ListItem>
                                        <asp:ListItem Value="2">~ 2 mm</asp:ListItem>
                                        <asp:ListItem Value="3">~ 3 mm</asp:ListItem>
                                        <asp:ListItem Value="4">~ 4 mm</asp:ListItem>
                                        <asp:ListItem Value="5">~ 5 mm</asp:ListItem>
                                        <asp:ListItem Value="6">~ 6 mm</asp:ListItem>
                                        <asp:ListItem Value="7">~ 7 mm</asp:ListItem>
                                        <asp:ListItem Value="8">~ 8 mm</asp:ListItem>
                                        <asp:ListItem Value="9">~ 9 mm</asp:ListItem>
                                        <asp:ListItem Value="10">~ 10 mm</asp:ListItem>
                                        <asp:ListItem Value="11">~ 11 mm</asp:ListItem>
                                        <asp:ListItem Value="12">~ 12 mm</asp:ListItem>
                                    </asp:DropDownList></p><br/>
                                <p>Contains Ingredient :</p>
                                    <p><asp:TextBox ID="advActiveIng" runat="server"></asp:TextBox></p><br />
                                <p>Show only pills with images<asp:CheckBox ID="has_image_chkbx" runat="server" /></p>

                               <p><asp:Button ID="adv_pill_search" runat="server" Text="Search" OnClick="adv_pill_search_Click" /></p>

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
                        <asp:BoundField ReadOnly="True" HeaderText="NDC#"
                            DataField="PRODUCTNDC"></asp:BoundField>
                        <asp:BoundField HeaderText="Drug Type"
                            DataField="PRODUCTTYPENAME"></asp:BoundField>
                        <asp:BoundField HeaderText="Name"
                            DataField="PROPRIETARYNAME"></asp:BoundField>
                        <asp:BoundField HeaderText="Dosage Form"
                            DataField="DOSAGEFORMNAME"></asp:BoundField>
                        <asp:HyperLinkField DataNavigateUrlFields="PRODUCTNDC" DataNavigateUrlFormatString="findPills-helper.aspx?ndc={0}" HeaderText="More" Text="View Details" Target="_blank" />
                    </Columns>
                </asp:GridView>

                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="false" Visible="false"
                    Style="width: 100%" CellPadding="5" ForeColor="#333333" GridLines="None">
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <RowStyle BackColor="#EFF3FB" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:BoundField ReadOnly="True" HeaderText="NDC#"
                            DataField="PRODUCT_CODE"></asp:BoundField>
                        <asp:BoundField ReadOnly="True" HeaderText="Name"
                            DataField="RXSTRING"></asp:BoundField>
                        <asp:HyperLinkField DataNavigateUrlFields="PRODUCT_CODE" DataNavigateUrlFormatString="findPills-helper.aspx?ndc={0}" HeaderText="More" Text="View Details" Target="_blank" />
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
