<%@ Page Language="C#" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Xml" %>

<!DOCTYPE html>

<script runat="server">


    // API endpoint for hospital's general information
    string hospital_general_information_base_url = "http://data.medicare.gov/resource/v287-28n3.xml?";
    
    // API endpoint for hospital's detailed information
    string hospital_HCAHPS_base_url = "http://data.medicare.gov/resource/rj76-22dk.xml?";

    string xmlResponse = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            // retrive the hospital's provider id from the query string
            string provider_id = Request.QueryString["provider_id"];

            // Check if no provider id is passed
            if (provider_id == null)
            {
                Response.Redirect("index.html");
            }
            else
            {
                
                // Form the query to retrive the basic details of the hospital
                string query1 = "$select=hospital_name, address_1, city, state, zip_code, phone_number, hospital_type, hospital_owner, emergency_services&$where=provider_number='" + provider_id + "'";

                System.Net.WebClient wc = new System.Net.WebClient();
                // Force the API to return the data in XML format
                wc.Headers["Accept"] = "application/xml";
                xmlResponse = wc.DownloadString(hospital_general_information_base_url + query1);

                // Initialise a XmlDocument object to store the sting as XML for easy operation
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(xmlResponse);

                XmlNode recordNode = doc.DocumentElement.SelectSingleNode("/response/row/row");

                // Set the retrived details to elements in the page
                hospital_name.InnerText = recordNode.SelectSingleNode("hospital_name").InnerText;
                hospital_phone.InnerText = recordNode.SelectSingleNode("phone_number").Attributes["phone_number"].Value;
                hospital_type.InnerText = recordNode.SelectSingleNode("hospital_type").InnerText;
                hospital_ownership.InnerText = recordNode.SelectSingleNode("hospital_owner").InnerText;
                emergency_services.InnerHtml = "<img src= images/" + recordNode.SelectSingleNode("emergency_services").InnerText + ".png />";

                hospital_address.InnerHtml = recordNode.SelectSingleNode("address_1").InnerText + "</br>" + recordNode.SelectSingleNode("city").InnerText + "</br>" + recordNode.SelectSingleNode("state").InnerText + " - " + recordNode.SelectSingleNode("zip_code").InnerText;


                // Form the query to get the HCAHPS survey response results from the HCAHPS dataset using the second API
                string query2 = "$select=percent_of_patients_who_reported_that_their_nurses_always_communicated_well_, percent_of_patients_who_reported_that_their_nurses_usually_communicated_well_, percent_of_patients_who_reported_that_their_nurses_sometimes_or_never_communicated_well_, " +
                               "percent_of_patients_who_reported_that_their_doctors_always_communicated_well_, percent_of_patients_who_reported_that_their_doctors_usually_communicated_well_, percent_of_patients_who_reported_that_their_doctors_sometimes_or_never_communicated_well_, " +
                               "percent_of_patients_who_reported_that_they_always_received_help_as_soon_as_they_wanted_, percent_of_patients_who_reported_that_they_usually_received_help_as_soon_as_they_wanted_, percent_of_patients_who_reported_that_they_sometimes_or_never_received_help_as_soon_as_they_wanted_, " +
                               "percent_of_patients_who_reported_that_their_pain_was_always_well_controlled_, percent_of_patients_who_reported_that_their_pain_was_usually_well_controlled_, percent_of_patients_who_reported_that_their_pain_was_sometimes_or_never_well_controlled_, " +
                               "percent_of_patients_who_reported_that_their_room_and_bathroom_were_sometimes_or_never_clean_, percent_of_patients_who_reported_that_their_room_and_bathroom_were_usually_clean_, percent_of_patients_who_reported_that_their_room_and_bathroom_were_always_clean_, " +
                               "percent_of_patients_who_reported_that_the_area_around_their_room_was_always_quiet_at_night_, percent_of_patients_who_reported_that_the_area_around_their_room_was_usually_quiet_at_night_, percent_of_patients_who_reported_that_the_area_around_their_room_was_sometimes_or_never_quiet_at_night_, " +
                               "percent_of_patients_who_gave_their_hospital_a_rating_of_9_or_10_on_a_scale_from_0_lowest_to_10_highest_, percent_of_patients_who_gave_their_hospital_a_rating_of_7_or_8_on_a_scale_from_0_lowest_to_10_highest_, percent_of_patients_who_gave_their_hospital_a_rating_of_6_or_lower_on_a_scale_from_0_lowest_to_10_highest_," +
                               "percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_, percent_of_patients_who_reported_yes_they_would_probably_recommend_the_hospital_, percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_&$where=provider_number='" + provider_id + "'";

                query2 = hospital_HCAHPS_base_url + query2;
                xmlResponse = wc.DownloadString(query2);

                // Initialise a XmlDocument object to store the sting as XML for easy operation
                XmlDocument doc2 = new XmlDocument();
                doc2.LoadXml(xmlResponse);

                XmlNode recordNode2 = doc2.DocumentElement.SelectSingleNode("/response/row/row");

                // Set the retrived data to the hidden controls on the page so that the chart can be plotted
                hidden1.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_nurses_always_communicated_well_").InnerText;
                hidden2.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_nurses_usually_communicated_well_").InnerText;
                hidden3.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_nurses_sometimes_or_never_communicated_well_").InnerText;

                hidden4.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_doctors_always_communicated_well_").InnerText;
                hidden5.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_doctors_usually_communicated_well_").InnerText;
                hidden6.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_doctors_sometimes_or_never_communicated_well_").InnerText;

                hidden7.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_they_always_received_help_as_soon_as_they_wanted_").InnerText;
                hidden8.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_they_usually_received_help_as_soon_as_they_wanted_").InnerText;
                hidden9.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_they_sometimes_or_never_received_help_as_soon_as_they_wanted_").InnerText;


                hidden10.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_pain_was_always_well_controlled_").InnerText;
                hidden11.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_pain_was_usually_well_controlled_").InnerText;
                hidden12.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_pain_was_sometimes_or_never_well_controlled_").InnerText;

                hidden13.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_room_and_bathroom_were_always_clean_").InnerText;
                hidden14.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_room_and_bathroom_were_usually_clean_").InnerText;
                hidden15.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_their_room_and_bathroom_were_sometimes_or_never_clean_").InnerText;

                hidden16.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_the_area_around_their_room_was_always_quiet_at_night_").InnerText;
                hidden17.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_the_area_around_their_room_was_usually_quiet_at_night_").InnerText;
                hidden18.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_that_the_area_around_their_room_was_sometimes_or_never_quiet_at_night_").InnerText;

                hidden19.Value = recordNode2.SelectSingleNode("percent_of_patients_who_gave_their_hospital_a_rating_of_9_or_10_on_a_scale_from_0_lowest_to_10_highest_").InnerText;
                hidden20.Value = recordNode2.SelectSingleNode("percent_of_patients_who_gave_their_hospital_a_rating_of_7_or_8_on_a_scale_from_0_lowest_to_10_highest_").InnerText;
                hidden21.Value = recordNode2.SelectSingleNode("percent_of_patients_who_gave_their_hospital_a_rating_of_6_or_lower_on_a_scale_from_0_lowest_to_10_highest_").InnerText;


                hidden22.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_").InnerText;
                hidden23.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_yes_they_would_probably_recommend_the_hospital_").InnerText;
                hidden24.Value = recordNode2.SelectSingleNode("percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_").InnerText;


            }




        }
        catch
        {
            // Display a friendly error message to the user
            errorMsg.InnerText = "An error occured while loading the page! Please try again later";
            errorMsg.Visible = true;
        }
    }
    
    



</script>

<html>
<head>
    <title>OneHealth - Simplifying Life</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <link rel="stylesheet" href="StyleSheet.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script src="js/google_charts.js" type="text/javascript"></script>
    <link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon">
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

            <div class="content" style="text-align: left; min-height: 600px">
                <h2>Hospital Search</h2>
                <p><b>Note:</b> The ratings of hospitals represented here are provided by the Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS). HCAHPS is a national, standardized survey of hospital patients about their experiences during a recent inpatient hospital stay.</p>
                <p id="errorMsg" runat="server" visible="false" style="text-align: center; background-color: skyblue; border: 1px dotted gray"></p>

                <table class="tg" runat="server">
                    <tr>
                        <th>Hospital Name</th>
                        <th>Address</th>
                        <th>Phone Number</th>
                    </tr>
                    <tr>
                        <td id="hospital_name" runat="server"></td>
                        <td id="hospital_address" runat="server"></td>
                        <td id="hospital_phone" runat="server"></td>
                    </tr>
                    <tr>
                        <th>Hospital Type</th>
                        <th>Emergency Services</th>
                        <th>Hospital Ownership</th>
                    </tr>
                    <tr>
                        <td id="hospital_type" runat="server"></td>
                        <td id="emergency_services" runat="server"></td>
                        <td id="hospital_ownership" runat="server"></td>
                    </tr>
                </table>

                <h4>HCAHPS Survey Results :</h4>

                <table>
                    <tr>
                        <td>Percent of patients who reported that their nurses communicated well</td>
                        <td>
                            <div id="Div1"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>Percent of patients who reported that their doctors communicated well</td>
                        <td>
                            <div id="Div2"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>Percent of patients who reported that they received help as soon as they wanted</td>
                        <td>
                            <div id="Div3"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>Percent of patients who reported that their pain was well controlled</td>
                        <td>
                            <div id="Div4"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>Percent of patients who reported that their room & bathroom were clean</td>
                        <td>
                            <div id="Div5"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>Percent of patients who reported that the area around their room was quiet at night</td>
                        <td>
                            <div id="Div6"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>Percent of patients who rated their hospital out of 10 on a scale from 0 being lowest</td>
                        <td>
                            <div id="Div7"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>Percent of patients who reported they would recommend the hospital </td>
                        <td>
                            <div id="Div8"></div>
                        </td>
                    </tr>
                </table>

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

        <input type="hidden" id="hidden1" runat="server" />
        <input type="hidden" id="hidden2" runat="server" />
        <input type="hidden" id="hidden3" runat="server" />

        <input type="hidden" id="hidden4" runat="server" />
        <input type="hidden" id="hidden5" runat="server" />
        <input type="hidden" id="hidden6" runat="server" />

        <input type="hidden" id="hidden7" runat="server" />
        <input type="hidden" id="hidden8" runat="server" />
        <input type="hidden" id="hidden9" runat="server" />

        <input type="hidden" id="hidden10" runat="server" />
        <input type="hidden" id="hidden11" runat="server" />
        <input type="hidden" id="hidden12" runat="server" />

        <input type="hidden" id="hidden13" runat="server" />
        <input type="hidden" id="hidden14" runat="server" />
        <input type="hidden" id="hidden15" runat="server" />

        <input type="hidden" id="hidden16" runat="server" />
        <input type="hidden" id="hidden17" runat="server" />
        <input type="hidden" id="hidden18" runat="server" />

        <input type="hidden" id="hidden19" runat="server" />
        <input type="hidden" id="hidden20" runat="server" />
        <input type="hidden" id="hidden21" runat="server" />

        <input type="hidden" id="hidden22" runat="server" />
        <input type="hidden" id="hidden23" runat="server" />
        <input type="hidden" id="hidden24" runat="server" />


    </form>
</body>
</html>
