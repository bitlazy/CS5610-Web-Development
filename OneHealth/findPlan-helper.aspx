<%@ Page Language="C#" %>

<%@ Import Namespace="System.Xml" %>

<!DOCTYPE html>

<script runat="server">


    // API Endpoint for health insurance plan dataset
    string baseURL = "http://data.healthcare.gov/resource/b8in-sz6k.xml?";
    string xmlResponse = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            // retrive the plan id and county from the query string
            string plan_id = Request.QueryString["plan_id"];
            string county = Request.QueryString["county"];

           // check if the plan_id is null. if yes, redirect the user to home page
            if (plan_id == null)
            {
                Response.Redirect("index.html");
            }
            else
            {
                // form the query required to get the details from the API
                string query = "$select=state, county, issuer_name, plan_id_standard_component, plan_marketing_name, plan_type, metal_level, customer_service_phone_number_toll_free, network_url, " +
                    "plan_brochure_url, summary_of_benefits_url, medical_deductible_individual_standard, drug_deductible_individual_standard, medical_deductible_family_standard, drug_deductible_family_standard, " +
                    "medical_maximum_out_of_pocket_individual_standard, drug_maximum_out_of_pocket_individual_standard, medical_maximum_out_of_pocket_family_standard, drug_maximum_out_of_pocket_family_standard, " +
                    "primary_care_physician_standard, specialist_standard, emergency_room_standard, inpatient_facility_standard, inpatient_physician_standard&$where=plan_id_standard_component='" + plan_id + "' AND county='" + county + "'";

                // Initialise a web client object to make a http request
                System.Net.WebClient wc = new System.Net.WebClient();
                
                // Force the API to return the data in XML format
                wc.Headers["Accept"] = "application/xml";
                
                // Download the response
                xmlResponse = wc.DownloadString(baseURL + query);

                // Initialise a XmlDocument object to store the sting as XML for easy operation
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(xmlResponse);

                XmlNode recordNode = doc.DocumentElement.SelectSingleNode("/response/row/row");
               
                
                // parse through the xml and set each value to the elements in the page.
                state.InnerText = recordNode.SelectSingleNode("state").InnerText;
                county_td.InnerText = recordNode.SelectSingleNode("county").InnerText;
                plan_type.InnerText = recordNode.SelectSingleNode("plan_type").InnerText;
                plan_id_th.InnerText = recordNode.SelectSingleNode("plan_id_standard_component").InnerText;
                plan_name.InnerText = recordNode.SelectSingleNode("plan_marketing_name").InnerText;
                issuer_name.InnerText = recordNode.SelectSingleNode("issuer_name").InnerText;
                metal_level.InnerText = recordNode.SelectSingleNode("metal_level").InnerText;
                phone.InnerText = recordNode.SelectSingleNode("customer_service_phone_number_toll_free").InnerText;
                network_url.InnerHtml = "<a href=\""+ recordNode.SelectSingleNode("network_url").Attributes["url"].Value +"\" target=_blank>Visit Network</a>";
                plan_brochure.InnerHtml = "<a href=\"" + recordNode.SelectSingleNode("plan_brochure_url").Attributes["url"].Value + "\" target=_blank>View Plan Brochure</a>";
                sum_benifits.InnerHtml = "<a href=\"" + recordNode.SelectSingleNode("summary_of_benefits_url").Attributes["url"].Value + "\" target=_blank>View Summary Of Benefits</a>";
                pri_care_phy.InnerText = recordNode.SelectSingleNode("primary_care_physician_standard").InnerText;
                med_deductable_ind.InnerText = recordNode.SelectSingleNode("medical_deductible_individual_standard").InnerText;
                drug_deductable_ind.InnerText = recordNode.SelectSingleNode("drug_deductible_individual_standard").InnerText;
                med_max_oop_ind.InnerText = recordNode.SelectSingleNode("medical_maximum_out_of_pocket_individual_standard").InnerText;
                drug_max_oop_ind.InnerText = recordNode.SelectSingleNode("drug_maximum_out_of_pocket_individual_standard").InnerText;
                med_deductable_fam.InnerText = recordNode.SelectSingleNode("medical_deductible_family_standard").InnerText;
                drug_deductable_fam.InnerText = recordNode.SelectSingleNode("drug_deductible_family_standard").InnerText;
                med_max_oop_fam.InnerText = recordNode.SelectSingleNode("medical_maximum_out_of_pocket_family_standard").InnerText;
                drug_max_oop_fam.InnerText = recordNode.SelectSingleNode("drug_maximum_out_of_pocket_family_standard").InnerText;
                specialist.InnerText = recordNode.SelectSingleNode("specialist_standard").InnerText;
                emerg_room.InnerText = recordNode.SelectSingleNode("emergency_room_standard").InnerText;
                inpatient_facility.InnerText = recordNode.SelectSingleNode("inpatient_facility_standard").InnerText;
                inpatient_physician.InnerText = recordNode.SelectSingleNode("inpatient_physician_standard").InnerText;
                
            
            }
        }
        catch
        {
           // display a friemdly message to the user.
            tg.Visible = false;
            errorMsg.InnerText = "Sorry! No plan details found";
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

            <div class="content" style="text-align: left; min-height: 600px">
                <h2>Health Insurance Plan Finder</h2>
                <b>Note:</b>
                <ul>
                    <li>This tool shows individual and family health plans available in states where the federal government is operating the Marketplace. States not represented here run their own Marketplaces.</li>
                    <li>The prices here don’t reflect the lower costs an applicant may qualify for based on household size and income. Many people who apply will qualify for reduced costs through tax credits that are automatically applied to monthly premiums. These credits will significantly lower the prices shown for many of those applying. Final price quotes are available only after someone has completed a Marketplace application.</li>
                </ul>
                <p id="errorMsg" runat="server" visible="false" style="text-align: center; background-color: skyblue; border: 1px dotted gray"></p>


                <table class="tg" id="tg" runat="server">

                    <tr>
                        <th>State</th>
                        <th>County</th>
                        <th>Plan Type</th>
                        <th>Plan ID</th>
                    </tr>
                    <tr>
                        <td id="state" runat="server"></td>
                        <td id="county_td" runat="server"></td>
                        <td id="plan_type" runat="server"></td>
                        <td id="plan_id_th" runat="server"></td>
                    </tr>
                    <tr>
                        <th>Plan Name</th>
                        <th>Issuer Name</th>
                        <th>Metal Level</th>
                        <th>Customer Care Phone# (Toll Free)</th>
                    </tr>
                    <tr>
                        <td id="plan_name" runat="server"></td>
                        <td id="issuer_name" runat="server"></td>
                        <td id="metal_level" runat="server"></td>
                        <td id="phone" runat="server"></td>
                    </tr>
                    <tr>
                        <th>Network URL</th>
                        <th>Plan Brochure URL</th>
                        <th>Summary Of Benefits URL</th>
                        <th>Primary Care Physician (Standard)</th>
                    </tr>
                    <tr>
                        <td id="network_url" runat="server"></td>
                        <td id="plan_brochure" runat="server"></td>
                        <td id="sum_benifits" runat="server"></td>
                        <td id="pri_care_phy" runat="server"></td>
                    </tr>
                    <tr>
                        <th>Medical Deductible Individual (Standard)</th>
                        <th>Drug Deductible Individual (Standard)</th>
                        <th>Medical Maximum Out Of Pocket Individual (Standard)</th>
                        <th>Drug Maximum Out Of Pocket Individual (Standard)</th>
                    </tr>
                    <tr>
                        <td id="med_deductable_ind" runat="server"></td>
                        <td id="drug_deductable_ind" runat="server"></td>
                        <td id="med_max_oop_ind" runat="server"></td>
                        <td id="drug_max_oop_ind" runat="server"></td>
                    </tr>
                    <tr>
                        <th>Medical Deductible Family (Standard)</th>
                        <th>Drug Deductible Family (Standard)</th>
                        <th>Medical Maximum Out Of Pocket Family (Standard)</th>
                        <th>Drug Maximum Out Of Pocket Family (Standard)</th>
                    </tr>
                    <tr>
                        <td id="med_deductable_fam" runat="server"></td>
                        <td id="drug_deductable_fam" runat="server"></td>
                        <td id="med_max_oop_fam" runat="server"></td>
                        <td id="drug_max_oop_fam" runat="server"></td>
                    </tr>

                    <tr>
                        <th>Specialist (Standard)</th>
                        <th>Emergency Room (Standard)</th>
                        <th>Inpatient Facility (Standard)</th>
                        <th>Inpatient Physician (Standard)</th>
                    </tr>
                    <tr>
                        <td id="specialist" runat="server"></td>
                        <td id="emerg_room" runat="server"></td>
                        <td id="inpatient_facility" runat="server"></td>
                        <td id="inpatient_physician" runat="server"></td>
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
    </form>
</body>
</html>
