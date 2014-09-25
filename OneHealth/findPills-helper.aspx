<%@ Page Language="C#" %>
<%@ Import Namespace="edu.neu.ccis.rasala" %>
<%@ Import Namespace="System.Xml" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        
        // retrive the API key securley by using Prof. Rasala's tool
        string nihKey = KeyTools.GetKey(this, "pillbox");
        string xmlResponse = "";
        
        // form a dictonary to match the given colour with the FDA colour codes
        Dictionary<string, string> colourCodes = new Dictionary<string, string>
            {
                {"C48323", "Black"},
                {"C48333", "Blue"},
                {"C48332", "Brown"},
                {"C48324", "Gray"},
                {"C48329", "Green"},
                {"C48331", "Orange"},
                {"C48328", "Pink"},
                {"C48327", "Purple"},
                {"C48326", "Red"},
                {"C48334", "Turquoise"},
                {"C48325", "White"},
                {"C48330", "Yellow"}
            };

        // form another dictonary to match the given shape with the FDA shape codes
        Dictionary<string, string> shapeCodes = new Dictionary<string, string>
            {
                {"C48335", "Bullet"},
                {"C48336", "Capsule"},
                {"C48337", "Clover"},
                {"C48338", "Diamond"},
                {"C48339", "Double Circle"},
                {"C48340", "Free Form"},
                {"C48341", "Gear"},
                {"C48342", "Heptagon (7 sided)"},
                {"C48343", "Hexagon (6 sided)"},
                {"C48344", "Octagon(8 sided)"},
                {"C48345", "Oval"},
                {"C48346", "Pentagon (5 sided)"},
                {"C48347", "Rectangle"},
                {"C48348", "Round"},
                {"C48349", "Semi-Circle"},
                {"C48350", "Square"},
                {"C48351", "Tear"},
                {"C48352", "Trapezoid"},
                {"C48353", "Triangle"}
            };

        // form another dictonary to match the retived schedule code of the drug with the FDA schedule codes for drugs
        Dictionary<string, string> scheduleCodes = new Dictionary<string, string>
            {
                {"Schedule I", "C48672"},
                {"Schedule II", "C48675"},
                {"Schedule III", "C48676"},
                {"Schedule IV", "C48677"},
                {"Schedule V", "C48679"}
            };

        try
        {
            // Get the ndc number from the query string
            string ndc = Request.QueryString["ndc"];

            // Check if the ndc is valid. If found invalid, redirect the user to the home page
            if ((ndc == null) || ( (ndc.Length <9) && (ndc.Length >12)))
            {
                Response.Redirect("index.html");
            }
                
            else
            {
                
                // Form the API url with the given inputs
                string dynamicURL = "http://pillbox.nlm.nih.gov/PHP/pillboxAPIService.php?prodcode=" + Server.HtmlEncode(ndc) + "&key=" + nihKey;

                // Initialise a WebClient to create a request.
                System.Net.WebClient wc = new System.Net.WebClient();
                // Force the API to return the data in XML format
                wc.Headers["Accept"] = "application/xml";
                xmlResponse = wc.DownloadString(dynamicURL);

                // Initialise a XmlDocument object to store the sting as XML for easy operation
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(xmlResponse);

                // go to the required node.
                XmlNode recordNode = doc.DocumentElement.SelectSingleNode("/Pills/record_count");

                // If antleast one record is returned, proceed
                if (Convert.ToInt32(recordNode.InnerText) == 1)
                {
                    // Start retriving the values and set it to the display elements in the page.
                    XmlNode pillNode = doc.DocumentElement.SelectSingleNode("/Pills/pill");
                    
                    pcode.InnerText = pillNode.SelectSingleNode("PRODUCT_CODE").InnerText;
                    ndccode.InnerText = pillNode.SelectSingleNode("NDC9").InnerText;
                    fullname.InnerText = pillNode.SelectSingleNode("RXSTRING").InnerText;
                    manu_name.InnerText = pillNode.SelectSingleNode("AUTHOR").InnerText;

                    // Match the Schedule codes with the dictonary
                    if (pillNode.SelectSingleNode("DEA_SCHEDULE_CODE").InnerText.Length > 0)
                        dea_sche.InnerText = scheduleCodes[pillNode.SelectSingleNode("DEA_SCHEDULE_CODE").InnerText];
                    else
                        dea_sche.InnerText = "Not Scheduled Drug";

                    
                    imprint.InnerText = pillNode.SelectSingleNode("SPLIMPRINT").InnerText;
                    shape.InnerText = shapeCodes[pillNode.SelectSingleNode("SPLSHAPE").InnerText];
                    colour.InnerText = colourCodes[pillNode.SelectSingleNode("SPLCOLOR").InnerText];
                    size.InnerText = pillNode.SelectSingleNode("SPLSIZE").InnerText;
                    activeIng.InnerText = pillNode.SelectSingleNode("INGREDIENTS").InnerText;
                    inactiveIng.InnerText = pillNode.SelectSingleNode("SPL_INACTIVE_ING").InnerText;

                    // If image is found, render it on the page
                    if (pillNode.SelectSingleNode("image_id").InnerText.Length > 1)
                    {
                        string imgPath = @"http://pillbox.nlm.nih.gov/assets/large/" + pillNode.SelectSingleNode("image_id").InnerText + ".jpg";
                        imageDiv.InnerHtml = @"<img src=""" + imgPath + "\" style=\"width:100%;\"/>";
                    }
                    else
                    {
                        imageDiv.InnerHtml = "<p>Sorry! No Image Available for this pill</p>";
                    }



                }

                else
                {
                    tg.Visible = false;
                    errorMsg.Visible = true;

                }

            }


        }
        catch
        {
            tg.Visible = false;
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
                <h2>Pill Identifier</h2>
                <p><b>Disclaimer:</b> "This product uses publicly available data from the U.S. National Library of Medicine (NLM), National Institutes of Health, Department of Health and Human Services; NLM is not responsible for the product and does not endorse or recommend this or any other product."</p>

                <p id="errorMsg" runat="server" visible="false">Sorry! NLM does not have any details about this Drug at the moment</p>
                
                <table id="tg" runat="server" class="tg">
                    <tr>
                        <th>Product Code</th>
                        <th>9-Digit NDC</th>
                        <th>Full Drug Name</th>
                        <th>Manufacturer Name</th>
                        <th>DEA Schedule</th>

                    </tr>
                    <tr>
                        <td><span id="pcode" runat="server"></span></td>
                        <td><span id="ndccode" runat="server"></span></td>
                        <td><span id="fullname" runat="server"></span></td>
                        <td><span id="manu_name" runat="server"></span></td>
                        <td><span id="dea_sche" runat="server"></span></td>

                    </tr>
                    <tr>
                        <th>Imprint</th>
                        <th>Shape</th>
                        <th>Colour</th>
                        <th>Size</th>
                        <th>Active Ingredients</th>

                    </tr>
                    <tr>
                        <td><span id="imprint" runat="server"></span></td>
                        <td><span id="shape" runat="server"></span></td>
                        <td><span id="colour" runat="server"></span></td>
                        <td><span id="size" runat="server"></span></td>
                        <td><span id="activeIng" runat="server"></span></td>
                    </tr>
                    <tr>
                        <th colspan="5">Inactive Ingredients</th>
                    </tr>

                    <tr>
                        <td colspan="5"><span id="inactiveIng" runat="server"></span></td>
                    </tr>
                    <tr>
                        <th colspan="5">Image</th>
                    </tr>
                    <tr>
                        <td colspan="5">
                            <div id="imageDiv" runat="server"></div>
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
    </form>
</body>
</html>
