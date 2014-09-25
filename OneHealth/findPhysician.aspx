<%@ Page Language="C#" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>


<script runat="server">
    // Declare the required variables
    string fName = "";
    string lName = "";
    string city = "";
    string state = "";
    string speciality = "";
    DataSet RunDS = new DataSet();
    static string xmlResponse;

    // API Endpoint for physician details
    static string baseURL = @"http://data.medicare.gov/resource/s63f-csi6.xml?$select=frst_nm, lst_nm, npi, pri_spec, cty, st&$where=";




    /* makeAPIRequest : String -> Void
     * GIVEN: the API URL along with the query that needs to be passed to the API
     * EFFECTS: retrives the query results from the API and sets it to the data gridview on the page
     */
    public void makeAPIRequest(string apiURL)
    {
        try
        {
            // Initialise a WebClient to create a request.
            System.Net.WebClient wc = new System.Net.WebClient();
            // Force the API to return the data in XML format
            wc.Headers["Accept"] = "application/xml";
            xmlResponse = wc.DownloadString(apiURL);

            
            // Remove the <response></response> element from the result to avoid extra spaces in the result
            xmlResponse = xmlResponse.Replace("<response>", " ");
            xmlResponse = xmlResponse.Replace("</response>", "");

            
            // Check if atleast one physician is returned by checking for the presence of the first name.
            if (xmlResponse.Contains("frst_nm"))
            {
                // transform the XML string into the data set
                RunDS.ReadXml(new System.IO.StringReader(xmlResponse));

                // Set the datasource of the grid view to data set
                GridView1.DataSource = RunDS;
                GridView1.DataBind();
                GridView1.Visible = true;
            }
            else
            {
                errorMsg.InnerText = "Sorry! No results found";
                errorMsg.Visible = true;
            }
        }
        catch
        {
            errorMsg.InnerText = "Sorry! An error occured while loading the page!";
            errorMsg.Visible = true;
        }
    }


    /* populateCities : String Integer -> Void
     * GIVEN: the name of the state to which the cities need to be retrived and the control flag
     * WHERE: the control flag indicates to which dropdownlist the cities needs to be populated
     *         0 indicates adv_city_ddl
     *         1 indicates city_ddl
     * EFFECTS: queries the data set and retrives all the distinct city names for the given state and
     *          populates the respective dropdown list
     */
    public void populateCities(string state, int controlFlag)
    {
        try
        {
            
            // Clear the city drop down lists before populating them
            city_ddl.Items.Clear();
            adv_city_ddl.Items.Clear();
            // Create a connection object by retriving the connection string from the web.config file
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["prodConString"].ToString()))
            {
                // With the above connection, create a SQLCommand to select the states
                SqlCommand cmd = new SqlCommand("SELECT DISTINCT CITY FROM sand89.LOC(NOLOCK) WHERE STATE LIKE '" + state + "' ORDER BY CITY", con);
                // Open the connection
                con.Open();

                // Execute the command and start parsing it using a SQLDataReader
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    // Set the first column (index 0) values to the state dropdownlist
                    if (controlFlag == 1)
                        city_ddl.Items.Add(dr[0].ToString());
                    else
                        adv_city_ddl.Items.Add(dr[0].ToString());
                }
                // Close the connection
                con.Close();

            }
        }
        catch
        {

            errorMsg.InnerText = "Sorry! An error occured! Please try again";
            errorMsg.Visible = true;

        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            // Populate the state dropdown list on page load
            // Create a connection object by retriving the connection string from the web.config file
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["prodConString"].ToString()))
            {
                // With the above connection, create a SQLCommand to select the states
                SqlCommand cmd = new SqlCommand("SELECT DISTINCT STATE, STATE_ABBR FROM sand89.LOC(NOLOCK) ORDER BY STATE", con);
                // Open the connection
                con.Open();

                // Execute the command and start parsing it using a SQLDataReader
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    // Set the first column (index 0) values to the state dropdownlist
                    ListItem li = new ListItem(dr[0].ToString(), dr[1].ToString());
                    state_ddl.Items.Add(li);
                    adv_state_ddl.Items.Add(li);

                }
                // Close the connection
                con.Close();

            }
        }
        catch
        {

            errorMsg.InnerText = "An error occured during page load! Please try again later";
            errorMsg.Visible = true;

        }
    }

    protected void search_by_physician_name_Click(object sender, EventArgs e)
    {
        try
        {
            errorMsg.Visible = false;
            // Clear the data set so that any old data would be purged
            RunDS.Clear();

            // Set the Grid View and the status label visibility to false
            GridView1.Visible = false;

            // Check if the first name and last
            if ((firstname_txtbox.Text.Length < 2) || (lastname_txtbox.Text.Length < 2))
            {
                errorMsg.InnerText = "Please enter atleast three characters of the first name and last name of the physician";
                errorMsg.Visible = true;
            }
            else
            {
                // Get the first name and the last name from the respective text boxes
                fName = Server.HtmlEncode(firstname_txtbox.Text.Trim());
                lName = Server.HtmlEncode(lastname_txtbox.Text.Trim());
                
                // Get the primary speciality of the physician from the drop down list
                speciality = speciality_ddl.SelectedItem.Text;
                string apiURL="";

                // For the query based on the inputs
                if (speciality != "All")
                    apiURL = baseURL + "pri_spec='" + speciality + "' AND frst_nm='" + fName + "' AND lst_nm='" + lName + "'";
                else
                    apiURL = baseURL + "frst_nm='" + fName + "' AND lst_nm='" + lName + "'";


                // Call the makeAPIRequest() function and pass the above formed URL to fetch the results
                makeAPIRequest(apiURL);

            }
        }
        catch
        {
            errorMsg.InnerText = "Sorry! We encountered an error! Please try again.";
            errorMsg.Visible = true;
        }
        finally
        {
            currentTab.Value = "Tab1";
        }
    }


    protected void state_ddl_SelectedIndexChanged(object sender, EventArgs e)
    {
        
        // Get the cities based on the value selected in the states ddl
        populateCities(state_ddl.SelectedItem.Text, 1);
        
        // Keep track of the tab from which the request came
        currentTab.Value = "Tab2";
    }


    protected void adv_state_ddl_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Get the cities based on the value selected in the states ddl
        populateCities(adv_state_ddl.SelectedItem.Text, 0);

        // Keep track of the tab from which the request came
        currentTab.Value = "Tab3";

    }



    protected void Submit_Click(object sender, EventArgs e)
    {
        errorMsg.Visible = false;
        // Clear the data set so that any old data would be purged
        RunDS.Clear();

        // Set the Grid View and the status label visibility to false
        GridView1.Visible = false;
        if (city_ddl.SelectedItem.Value == "-1")
        {
            errorMsg.InnerText = "Please selecte atleast a state and a city";
            errorMsg.Visible = true;
        }
        else
        {
            // Get the selected city, state and speciality
            state = state_ddl.SelectedItem.Value.ToString();
            city = city_ddl.SelectedItem.Text;
            speciality = speciality2_ddl.SelectedItem.Text;
            string apiURL = "";
            
            // form the API request based on the inputs
            if(speciality!= "All")
            apiURL = baseURL + "pri_spec='" + speciality + "' AND st='" + state + "' AND cty='" + city + "'";
            else
               apiURL = baseURL + "st='" + state + "' AND cty='" + city + "'"; 

            // Call the makeAPIRequest() function and pass the above formed URL
            makeAPIRequest(apiURL);

        }
        
        // Keep track of the tab from which the request came
        currentTab.Value = "Tab2";
    }

 
    protected void adv_physician_search_Click(object sender, EventArgs e)
    {
        errorMsg.Visible = false;
        // Clear the data set so that any old data would be purged
        RunDS.Clear();

        // Set the Grid View and the status label visibility to false
        GridView1.Visible = false;

        string state = "", city = "";
        string URLChunk = "",

        // Get the inputs from the controls on the advance search tab
        fName = advfname_txtbx.Text.Trim();
        lName = advlname_txtbx.Text.Trim();
        speciality = speciality3_ddl.SelectedItem.Text;
        state = adv_state_ddl.SelectedItem.Value.ToString(); ;
        city = adv_city_ddl.SelectedItem.Text;


        // Form the API request based on the inputs
        if (fName.Length > 0)
            URLChunk = "frst_nm='" + fName + "' AND";
        if (lName.Length > 0)
            URLChunk = URLChunk + " lst_nm='" + lName + "' AND";

        URLChunk = URLChunk + " pri_spec='" + speciality + "' AND st='" + state + "'";

        if (city != "Select State First")
            URLChunk = URLChunk + " AND cty='" + city + "'";

        if (EHR_chkbx.Checked == true)
            URLChunk = URLChunk + " AND ehr='Y'";
        if (ERX_chkbx.Checked == true)
            URLChunk = URLChunk + " AND erx='Y'";
        if (PQRS_chkbx.Checked == true)
            URLChunk = URLChunk + " AND pqrs='Y'";

        
        
        // Call the makeAPIRequest() function the fetch the results
        makeAPIRequest(baseURL + URLChunk.Trim());

        
        // Keep track of the tab from which the request came
        currentTab.Value = "Tab3";

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
                <h2>Physician Search</h2>


                <div id="Tab">
                    <ul class="resp-tabs-list">
                        <li id="Tab1">Search By Physician Name</li>
                        <li id="Tab2">Search Physician By Location</li>
                        <li id="Tab3">Advanced Search</li>
                    </ul>
                    <div class="resp-tabs-container">

                        <div>
                            <p>First Name</p>
                            <p><asp:TextBox ID="firstname_txtbox" runat="server"></asp:TextBox></p>
                            <p>Last Name</p>
                            <p><asp:TextBox ID="lastname_txtbox" runat="server"></asp:TextBox></p>
                            <p>Primary Speciality</p>
                            <p><asp:DropDownList ID="speciality_ddl" runat="server">
                                <asp:ListItem>All</asp:ListItem>
                                <asp:ListItem>INTERNAL MEDICINE</asp:ListItem>
                                <asp:ListItem>PATHOLOGY</asp:ListItem>
                                <asp:ListItem>ANESTHESIOLOGY</asp:ListItem>
                                <asp:ListItem>NURSE PRACTITIONER</asp:ListItem>
                                <asp:ListItem>PHYSICAL THERAPIST</asp:ListItem>
                                <asp:ListItem>FAMILY PRACTICE</asp:ListItem>
                                <asp:ListItem>OBSTETRICS/GYNECOLOGY</asp:ListItem>
                                <asp:ListItem>GENERAL SURGERY</asp:ListItem>
                                <asp:ListItem>OCCUPATIONAL THERAPIST</asp:ListItem>
                                <asp:ListItem>CARDIAC SURGERY</asp:ListItem>
                                <asp:ListItem>PHYSICIAN ASSISTANT</asp:ListItem>
                                <asp:ListItem>CARDIOVASCULAR DISEASE (CARDIOLOGY)</asp:ListItem>
                                <asp:ListItem>DERMATOLOGY</asp:ListItem>
                                <asp:ListItem>CERTIFIED REGISTERED NURSE ANESTHETIST</asp:ListItem>
                                <asp:ListItem>OPTOMETRY</asp:ListItem>
                                <asp:ListItem>PAIN MANAGEMENT</asp:ListItem>
                                <asp:ListItem>PHYSICAL MEDICINE AND REHABILITATION</asp:ListItem>
                                <asp:ListItem>RADIATION ONCOLOGY</asp:ListItem>
                                <asp:ListItem>INFECTIOUS DISEASE</asp:ListItem>
                                <asp:ListItem>ORTHOPEDIC SURGERY</asp:ListItem>
                                <asp:ListItem>CLINICAL NURSE SPECIALIST</asp:ListItem>
                                <asp:ListItem>ENDOCRINOLOGY</asp:ListItem>
                                <asp:ListItem>CHIROPRACTIC</asp:ListItem>
                                <asp:ListItem>DIAGNOSTIC RADIOLOGY</asp:ListItem>
                                <asp:ListItem>NEUROLOGY</asp:ListItem>
                                <asp:ListItem>NEPHROLOGY</asp:ListItem>
                                <asp:ListItem>CLINICAL SOCIAL WORKER</asp:ListItem>
                                <asp:ListItem>CLINICAL PSYCHOLOGIST</asp:ListItem>
                                <asp:ListItem>HAND SURGERY</asp:ListItem>
                                <asp:ListItem>PSYCHIATRY</asp:ListItem>
                                <asp:ListItem>PULMONARY DISEASE</asp:ListItem>
                                <asp:ListItem>OTOLARYNGOLOGY</asp:ListItem>
                                <asp:ListItem>PLASTIC AND RECONSTRUCTIVE SURGERY</asp:ListItem>
                                <asp:ListItem>GENERAL PRACTICE</asp:ListItem>
                                <asp:ListItem>REGISTERED DIETITIAN OR NUTRITION PROFESSIONAL</asp:ListItem>
                                <asp:ListItem>OSTEOPATHIC MANIPULATIVE MEDICINE</asp:ListItem>
                                <asp:ListItem>OPHTHALMOLOGY</asp:ListItem>
                                <asp:ListItem>AUDIOLOGIST</asp:ListItem>
                                <asp:ListItem>EMERGENCY MEDICINE</asp:ListItem>
                                <asp:ListItem>PEDIATRIC MEDICINE</asp:ListItem>
                                <asp:ListItem>GERIATRIC MEDICINE</asp:ListItem>
                                <asp:ListItem>UROLOGY</asp:ListItem>
                                <asp:ListItem>NEUROSURGERY</asp:ListItem>
                                <asp:ListItem>GASTROENTEROLOGY</asp:ListItem>
                                <asp:ListItem>THORACIC SURGERY</asp:ListItem>
                                <asp:ListItem>SPEECH LANGUAGE PATHOLOGIST</asp:ListItem>
                                <asp:ListItem>PODIATRY</asp:ListItem>
                                <asp:ListItem>HEMATOLOGY/ONCOLOGY</asp:ListItem>
                                <asp:ListItem>ORAL SURGERY (DENTIST ONLY)</asp:ListItem>
                                <asp:ListItem>PREVENTATIVE MEDICINE</asp:ListItem>
                                <asp:ListItem>CERTIFIED NURSE MIDWIFE</asp:ListItem>
                                <asp:ListItem>CRITICAL CARE (INTENSIVISTS)</asp:ListItem>
                                <asp:ListItem>MEDICAL ONCOLOGY</asp:ListItem>
                                <asp:ListItem>NUCLEAR MEDICINE</asp:ListItem>
                                <asp:ListItem>SURGICAL ONCOLOGY</asp:ListItem>
                                <asp:ListItem>ALLERGY/IMMUNOLOGY</asp:ListItem>
                                <asp:ListItem>ANESTHESIOLOGY ASSISTANT</asp:ListItem>
                                <asp:ListItem>INTERVENTIONAL RADIOLOGY</asp:ListItem>
                                <asp:ListItem>HOSPICE/PALLIATIVE CARE</asp:ListItem>
                                <asp:ListItem>RHEUMATOLOGY</asp:ListItem>
                                <asp:ListItem>VASCULAR SURGERY</asp:ListItem>
                                <asp:ListItem>HEMATOLOGY</asp:ListItem>
                                <asp:ListItem>CARDIAC ELECTROPHYSIOLOGY</asp:ListItem>
                                <asp:ListItem>MAXILLOFACIAL SURGERY</asp:ListItem>
                                <asp:ListItem>INTERVENTIONAL PAIN MANAGEMENT</asp:ListItem>
                                <asp:ListItem>SPORTS MEDICINE</asp:ListItem>
                                <asp:ListItem>SLEEP LABORATORY/MEDICINE</asp:ListItem>
                                <asp:ListItem>COLORECTAL SURGERY (PROCTOLOGY)</asp:ListItem>
                                <asp:ListItem>GERIATRIC PSYCHIATRY</asp:ListItem>
                                <asp:ListItem>ADDICTION MEDICINE</asp:ListItem>
                                <asp:ListItem>GYNECOLOGICAL ONCOLOGY</asp:ListItem>
                                <asp:ListItem>NEUROPSYCHIATRY</asp:ListItem>
                                <asp:ListItem>PERIPHERAL VASCULAR DISEASE</asp:ListItem>
                                <asp:ListItem>UNDEFINED PHYSICIAN TYPE (SPECIFY)</asp:ListItem>
                                <asp:ListItem>UNDEFINED NON-PHYSICIAN TYPE (SPECIFY)</asp:ListItem>
                            </asp:DropDownList>
                            </p>

                                <p><asp:Button ID="search_by_physician_name" runat="server" Text="Search Physician" OnClick="search_by_physician_name_Click" /></p>

                        </div>

                        <div>
                            <p>Select State</p>
                    <p><asp:DropDownList ID="state_ddl" runat="server" AutoPostBack="true" OnSelectedIndexChanged="state_ddl_SelectedIndexChanged" OnTextChanged="state_ddl_SelectedIndexChanged">
                    </asp:DropDownList></p>
                              <p>Select City</p>
                   <p><asp:DropDownList ID="city_ddl" runat="server">
                        <asp:ListItem Value="-1">Select City</asp:ListItem>
                    </asp:DropDownList></p>
                            
                            <p>Primary Speciality</p>
                            <p><asp:DropDownList ID="speciality2_ddl" runat="server">
                                <asp:ListItem>All</asp:ListItem>
                                    <asp:ListItem>INTERNAL MEDICINE</asp:ListItem>
                                    <asp:ListItem>PATHOLOGY</asp:ListItem>
                                    <asp:ListItem>ANESTHESIOLOGY</asp:ListItem>
                                    <asp:ListItem>NURSE PRACTITIONER</asp:ListItem>
                                    <asp:ListItem>PHYSICAL THERAPIST</asp:ListItem>
                                    <asp:ListItem>FAMILY PRACTICE</asp:ListItem>
                                    <asp:ListItem>OBSTETRICS/GYNECOLOGY</asp:ListItem>
                                    <asp:ListItem>GENERAL SURGERY</asp:ListItem>
                                    <asp:ListItem>OCCUPATIONAL THERAPIST</asp:ListItem>
                                    <asp:ListItem>CARDIAC SURGERY</asp:ListItem>
                                    <asp:ListItem>PHYSICIAN ASSISTANT</asp:ListItem>
                                    <asp:ListItem>CARDIOVASCULAR DISEASE (CARDIOLOGY)</asp:ListItem>
                                    <asp:ListItem>DERMATOLOGY</asp:ListItem>
                                    <asp:ListItem>CERTIFIED REGISTERED NURSE ANESTHETIST</asp:ListItem>
                                    <asp:ListItem>OPTOMETRY</asp:ListItem>
                                    <asp:ListItem>PAIN MANAGEMENT</asp:ListItem>
                                    <asp:ListItem>PHYSICAL MEDICINE AND REHABILITATION</asp:ListItem>
                                    <asp:ListItem>RADIATION ONCOLOGY</asp:ListItem>
                                    <asp:ListItem>INFECTIOUS DISEASE</asp:ListItem>
                                    <asp:ListItem>ORTHOPEDIC SURGERY</asp:ListItem>
                                    <asp:ListItem>CLINICAL NURSE SPECIALIST</asp:ListItem>
                                    <asp:ListItem>ENDOCRINOLOGY</asp:ListItem>
                                    <asp:ListItem>CHIROPRACTIC</asp:ListItem>
                                    <asp:ListItem>DIAGNOSTIC RADIOLOGY</asp:ListItem>
                                    <asp:ListItem>NEUROLOGY</asp:ListItem>
                                    <asp:ListItem>NEPHROLOGY</asp:ListItem>
                                    <asp:ListItem>CLINICAL SOCIAL WORKER</asp:ListItem>
                                    <asp:ListItem>CLINICAL PSYCHOLOGIST</asp:ListItem>
                                    <asp:ListItem>HAND SURGERY</asp:ListItem>
                                    <asp:ListItem>PSYCHIATRY</asp:ListItem>
                                    <asp:ListItem>PULMONARY DISEASE</asp:ListItem>
                                    <asp:ListItem>OTOLARYNGOLOGY</asp:ListItem>
                                    <asp:ListItem>PLASTIC AND RECONSTRUCTIVE SURGERY</asp:ListItem>
                                    <asp:ListItem>GENERAL PRACTICE</asp:ListItem>
                                    <asp:ListItem>REGISTERED DIETITIAN OR NUTRITION PROFESSIONAL</asp:ListItem>
                                    <asp:ListItem>OSTEOPATHIC MANIPULATIVE MEDICINE</asp:ListItem>
                                    <asp:ListItem>OPHTHALMOLOGY</asp:ListItem>
                                    <asp:ListItem>AUDIOLOGIST</asp:ListItem>
                                    <asp:ListItem>EMERGENCY MEDICINE</asp:ListItem>
                                    <asp:ListItem>PEDIATRIC MEDICINE</asp:ListItem>
                                    <asp:ListItem>GERIATRIC MEDICINE</asp:ListItem>
                                    <asp:ListItem>UROLOGY</asp:ListItem>
                                    <asp:ListItem>NEUROSURGERY</asp:ListItem>
                                    <asp:ListItem>GASTROENTEROLOGY</asp:ListItem>
                                    <asp:ListItem>THORACIC SURGERY</asp:ListItem>
                                    <asp:ListItem>SPEECH LANGUAGE PATHOLOGIST</asp:ListItem>
                                    <asp:ListItem>PODIATRY</asp:ListItem>
                                    <asp:ListItem>HEMATOLOGY/ONCOLOGY</asp:ListItem>
                                    <asp:ListItem>ORAL SURGERY (DENTIST ONLY)</asp:ListItem>
                                    <asp:ListItem>PREVENTATIVE MEDICINE</asp:ListItem>
                                    <asp:ListItem>CERTIFIED NURSE MIDWIFE</asp:ListItem>
                                    <asp:ListItem>CRITICAL CARE (INTENSIVISTS)</asp:ListItem>
                                    <asp:ListItem>MEDICAL ONCOLOGY</asp:ListItem>
                                    <asp:ListItem>NUCLEAR MEDICINE</asp:ListItem>
                                    <asp:ListItem>SURGICAL ONCOLOGY</asp:ListItem>
                                    <asp:ListItem>ALLERGY/IMMUNOLOGY</asp:ListItem>
                                    <asp:ListItem>ANESTHESIOLOGY ASSISTANT</asp:ListItem>
                                    <asp:ListItem>INTERVENTIONAL RADIOLOGY</asp:ListItem>
                                    <asp:ListItem>HOSPICE/PALLIATIVE CARE</asp:ListItem>
                                    <asp:ListItem>RHEUMATOLOGY</asp:ListItem>
                                    <asp:ListItem>VASCULAR SURGERY</asp:ListItem>
                                    <asp:ListItem>HEMATOLOGY</asp:ListItem>
                                    <asp:ListItem>CARDIAC ELECTROPHYSIOLOGY</asp:ListItem>
                                    <asp:ListItem>MAXILLOFACIAL SURGERY</asp:ListItem>
                                    <asp:ListItem>INTERVENTIONAL PAIN MANAGEMENT</asp:ListItem>
                                    <asp:ListItem>SPORTS MEDICINE</asp:ListItem>
                                    <asp:ListItem>SLEEP LABORATORY/MEDICINE</asp:ListItem>
                                    <asp:ListItem>COLORECTAL SURGERY (PROCTOLOGY)</asp:ListItem>
                                    <asp:ListItem>GERIATRIC PSYCHIATRY</asp:ListItem>
                                    <asp:ListItem>ADDICTION MEDICINE</asp:ListItem>
                                    <asp:ListItem>GYNECOLOGICAL ONCOLOGY</asp:ListItem>
                                    <asp:ListItem>NEUROPSYCHIATRY</asp:ListItem>
                                    <asp:ListItem>PERIPHERAL VASCULAR DISEASE</asp:ListItem>
                                    <asp:ListItem>UNDEFINED PHYSICIAN TYPE (SPECIFY)</asp:ListItem>
                                    <asp:ListItem>UNDEFINED NON-PHYSICIAN TYPE (SPECIFY)</asp:ListItem>
                                </asp:DropDownList></p>
                           <p><asp:Button ID="Submit" runat="server" Text="Search Physician" OnClick="Submit_Click" /></p>


                        </div>


                        <div>

                                                            
                                    <p>First Name</p>
                                    <p><asp:TextBox ID="advfname_txtbx" runat="server"></asp:TextBox></p>
                                    <p>Last Name</p>
                                    <p><asp:TextBox ID="advlname_txtbx" runat="server"></asp:TextBox></p>

                                    <p>State</p>
                                    <p><asp:DropDownList ID="adv_state_ddl" runat="server" AutoPostBack="true" OnSelectedIndexChanged="adv_state_ddl_SelectedIndexChanged"></asp:DropDownList></p>
                                    <p>City</p>
                                    <p><asp:DropDownList ID="adv_city_ddl" runat="server">
                                            <asp:ListItem Value="-1">Select State First</asp:ListItem>
                                        </asp:DropDownList></p><br />

                                    <p>Primary Speciality</p>
                                    <p><asp:DropDownList ID="speciality3_ddl" runat="server">
                                         <asp:ListItem>All</asp:ListItem>
                                            <asp:ListItem>INTERNAL MEDICINE</asp:ListItem>
                                            <asp:ListItem>PATHOLOGY</asp:ListItem>
                                            <asp:ListItem>ANESTHESIOLOGY</asp:ListItem>
                                            <asp:ListItem>NURSE PRACTITIONER</asp:ListItem>
                                            <asp:ListItem>PHYSICAL THERAPIST</asp:ListItem>
                                            <asp:ListItem>FAMILY PRACTICE</asp:ListItem>
                                            <asp:ListItem>OBSTETRICS/GYNECOLOGY</asp:ListItem>
                                            <asp:ListItem>GENERAL SURGERY</asp:ListItem>
                                            <asp:ListItem>OCCUPATIONAL THERAPIST</asp:ListItem>
                                            <asp:ListItem>CARDIAC SURGERY</asp:ListItem>
                                            <asp:ListItem>PHYSICIAN ASSISTANT</asp:ListItem>
                                            <asp:ListItem>CARDIOVASCULAR DISEASE (CARDIOLOGY)</asp:ListItem>
                                            <asp:ListItem>DERMATOLOGY</asp:ListItem>
                                            <asp:ListItem>CERTIFIED REGISTERED NURSE ANESTHETIST</asp:ListItem>
                                            <asp:ListItem>OPTOMETRY</asp:ListItem>
                                            <asp:ListItem>PAIN MANAGEMENT</asp:ListItem>
                                            <asp:ListItem>PHYSICAL MEDICINE AND REHABILITATION</asp:ListItem>
                                            <asp:ListItem>RADIATION ONCOLOGY</asp:ListItem>
                                            <asp:ListItem>INFECTIOUS DISEASE</asp:ListItem>
                                            <asp:ListItem>ORTHOPEDIC SURGERY</asp:ListItem>
                                            <asp:ListItem>CLINICAL NURSE SPECIALIST</asp:ListItem>
                                            <asp:ListItem>ENDOCRINOLOGY</asp:ListItem>
                                            <asp:ListItem>CHIROPRACTIC</asp:ListItem>
                                            <asp:ListItem>DIAGNOSTIC RADIOLOGY</asp:ListItem>
                                            <asp:ListItem>NEUROLOGY</asp:ListItem>
                                            <asp:ListItem>NEPHROLOGY</asp:ListItem>
                                            <asp:ListItem>CLINICAL SOCIAL WORKER</asp:ListItem>
                                            <asp:ListItem>CLINICAL PSYCHOLOGIST</asp:ListItem>
                                            <asp:ListItem>HAND SURGERY</asp:ListItem>
                                            <asp:ListItem>PSYCHIATRY</asp:ListItem>
                                            <asp:ListItem>PULMONARY DISEASE</asp:ListItem>
                                            <asp:ListItem>OTOLARYNGOLOGY</asp:ListItem>
                                            <asp:ListItem>PLASTIC AND RECONSTRUCTIVE SURGERY</asp:ListItem>
                                            <asp:ListItem>GENERAL PRACTICE</asp:ListItem>
                                            <asp:ListItem>REGISTERED DIETITIAN OR NUTRITION PROFESSIONAL</asp:ListItem>
                                            <asp:ListItem>OSTEOPATHIC MANIPULATIVE MEDICINE</asp:ListItem>
                                            <asp:ListItem>OPHTHALMOLOGY</asp:ListItem>
                                            <asp:ListItem>AUDIOLOGIST</asp:ListItem>
                                            <asp:ListItem>EMERGENCY MEDICINE</asp:ListItem>
                                            <asp:ListItem>PEDIATRIC MEDICINE</asp:ListItem>
                                            <asp:ListItem>GERIATRIC MEDICINE</asp:ListItem>
                                            <asp:ListItem>UROLOGY</asp:ListItem>
                                            <asp:ListItem>NEUROSURGERY</asp:ListItem>
                                            <asp:ListItem>GASTROENTEROLOGY</asp:ListItem>
                                            <asp:ListItem>THORACIC SURGERY</asp:ListItem>
                                            <asp:ListItem>SPEECH LANGUAGE PATHOLOGIST</asp:ListItem>
                                            <asp:ListItem>PODIATRY</asp:ListItem>
                                            <asp:ListItem>HEMATOLOGY/ONCOLOGY</asp:ListItem>
                                            <asp:ListItem>ORAL SURGERY (DENTIST ONLY)</asp:ListItem>
                                            <asp:ListItem>PREVENTATIVE MEDICINE</asp:ListItem>
                                            <asp:ListItem>CERTIFIED NURSE MIDWIFE</asp:ListItem>
                                            <asp:ListItem>CRITICAL CARE (INTENSIVISTS)</asp:ListItem>
                                            <asp:ListItem>MEDICAL ONCOLOGY</asp:ListItem>
                                            <asp:ListItem>NUCLEAR MEDICINE</asp:ListItem>
                                            <asp:ListItem>SURGICAL ONCOLOGY</asp:ListItem>
                                            <asp:ListItem>ALLERGY/IMMUNOLOGY</asp:ListItem>
                                            <asp:ListItem>ANESTHESIOLOGY ASSISTANT</asp:ListItem>
                                            <asp:ListItem>INTERVENTIONAL RADIOLOGY</asp:ListItem>
                                            <asp:ListItem>HOSPICE/PALLIATIVE CARE</asp:ListItem>
                                            <asp:ListItem>RHEUMATOLOGY</asp:ListItem>
                                            <asp:ListItem>VASCULAR SURGERY</asp:ListItem>
                                            <asp:ListItem>HEMATOLOGY</asp:ListItem>
                                            <asp:ListItem>CARDIAC ELECTROPHYSIOLOGY</asp:ListItem>
                                            <asp:ListItem>MAXILLOFACIAL SURGERY</asp:ListItem>
                                            <asp:ListItem>INTERVENTIONAL PAIN MANAGEMENT</asp:ListItem>
                                            <asp:ListItem>SPORTS MEDICINE</asp:ListItem>
                                            <asp:ListItem>SLEEP LABORATORY/MEDICINE</asp:ListItem>
                                            <asp:ListItem>COLORECTAL SURGERY (PROCTOLOGY)</asp:ListItem>
                                            <asp:ListItem>GERIATRIC PSYCHIATRY</asp:ListItem>
                                            <asp:ListItem>ADDICTION MEDICINE</asp:ListItem>
                                            <asp:ListItem>GYNECOLOGICAL ONCOLOGY</asp:ListItem>
                                            <asp:ListItem>NEUROPSYCHIATRY</asp:ListItem>
                                            <asp:ListItem>PERIPHERAL VASCULAR DISEASE</asp:ListItem>
                                            <asp:ListItem>UNDEFINED PHYSICIAN TYPE (SPECIFY)</asp:ListItem>
                                            <asp:ListItem>UNDEFINED NON-PHYSICIAN TYPE (SPECIFY)</asp:ListItem>
                                        </asp:DropDownList>
                                    </p>

                                   <br /> <p>Participates in ERx</p>
                                    <p><asp:CheckBox ID="ERX_chkbx" runat="server" /></p>

                                   <br />  <p>Participates in PQRS</p>
                                    <p><asp:CheckBox ID="PQRS_chkbx" runat="server" /></p>

                                    <br /> <p>Participates in  in EHR</p>
                                    <p><asp:CheckBox ID="EHR_chkbx" runat="server" /></p><br /> 

                           <p><asp:Button ID="adv_physician_search" runat="server" Text="Search Physician" OnClick="adv_physician_search_Click" /></p>


                        </div>




                    </div>
               </div>

                    <p id="errorMsg" runat="server" visible="false" style="text-align: center; background-color: skyblue; border: 1px dotted gray"></p>


                    <div class="result" style="display: block; width: 100%">

                        <asp:GridView ID="GridView1" runat="server" Visible="false" AutoGenerateColumns="False"
                            Style="width: 100%" CellPadding="1" ForeColor="#333333" GridLines="None">
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <RowStyle BackColor="#EFF3FB" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField ReadOnly="True" HeaderText="First Name"
                                    DataField="frst_nm"></asp:BoundField>
                                <asp:BoundField HeaderText="Last Name"
                                    DataField="Lst_nm"></asp:BoundField>
                                <asp:BoundField HeaderText="NPI"
                                    DataField="npi"></asp:BoundField>
                                <asp:BoundField HeaderText="Primary Speciality"
                                    DataField="pri_spec"></asp:BoundField>
                                <asp:BoundField HeaderText="City"
                                    DataField="cty"></asp:BoundField>

                                <asp:BoundField HeaderText="State"
                                    DataField="st"></asp:BoundField>
                                <asp:HyperLinkField DataNavigateUrlFields="npi" DataNavigateUrlFormatString="findPhysician-helper.aspx?npi={0}" HeaderText="More" Text="View Details" Target="_blank" />
                            </Columns>
                        </asp:GridView>

                    </div>
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
