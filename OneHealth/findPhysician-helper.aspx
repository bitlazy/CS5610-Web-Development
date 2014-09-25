<%@ Page Language="C#" %>
<%@ Import Namespace="System.Xml" %>

<!DOCTYPE html>

<script runat="server">


    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            
            // API Endpoint for physician data
            string baseURL = "http://data.medicare.gov/resource/s63f-csi6.xml?";
            string xmlResponse = "";
            
            // Get the NPI number from the query string
            string npi = Request.QueryString["npi"];

            // Check if the npi number exists. If not, redirect the user to the index page
            if (npi == null)
            {
                Response.Redirect("index.html");
            }
                
            else
            {
                
                // Form the query string to retrive the physician details
                string query = "$select=frst_nm, lst_nm, gndr,cred, med_sch, grd_yr, pri_spec, npi, org_lgl_nm, adr_ln_1, cty, st, zip, assgn, erx, pqrs, ehr&$where=npi='"+npi+"'&$limit=1";
                
                System.Net.WebClient wc = new System.Net.WebClient();
                // Force the API to return the data in XML format
                wc.Headers["Accept"] = "application/xml";
                xmlResponse = wc.DownloadString(baseURL + query);

                // Initialise a XmlDocument object to store the sting as XML for easy operation
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(xmlResponse);

                
                // Retrive the records and set them to the display controls in the page.
                XmlNode recordNode = doc.DocumentElement.SelectSingleNode("/response/row/row");

                phy_name.InnerText = recordNode.SelectSingleNode("frst_nm").InnerText + " " + recordNode.SelectSingleNode("lst_nm").InnerText;
                phy_gender.InnerText = recordNode.SelectSingleNode("gndr").InnerText;
                
                
                phy_addr.InnerHtml = recordNode.SelectSingleNode("adr_ln_1").InnerText + "</br>" + recordNode.SelectSingleNode("cty").InnerText + "</br>" + recordNode.SelectSingleNode("st").InnerText + " - " + recordNode.SelectSingleNode("zip").InnerText;

                phy_school.InnerText = recordNode.SelectSingleNode("med_sch").InnerText;
                phy_grad_year.InnerText = recordNode.SelectSingleNode("grd_yr").InnerText;
                phy_pri_spec.InnerText = recordNode.SelectSingleNode("pri_spec").InnerText;

                phy_npi.InnerText = recordNode.SelectSingleNode("npi").InnerText;
                phy_org_name.InnerText = recordNode.SelectSingleNode("org_lgl_nm").InnerText;
                phy_medicare.InnerText = recordNode.SelectSingleNode("assgn").InnerText;

                phy_erx.InnerText = recordNode.SelectSingleNode("erx").InnerText;
                phy_pqrs.InnerText = recordNode.SelectSingleNode("pqrs").InnerText;
                phy_ehr.InnerText = recordNode.SelectSingleNode("ehr").InnerText;

                
                // Get the latitude and longitude of the physician's address by using the google's Geocoder library
                string googleGeoCoderPath = "https://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address=";
                string addrGeo = recordNode.SelectSingleNode("adr_ln_1").InnerText + ", " + recordNode.SelectSingleNode("cty").InnerText + ", " + recordNode.SelectSingleNode("st").InnerText;

                
                xmlResponse = wc.DownloadString(googleGeoCoderPath + addrGeo);
                XmlDocument doc2 = new XmlDocument();
                doc2.LoadXml(xmlResponse);

                // Get the values and set them to the hidden controls in the page so that the JavaScript on the page can access it from those controls
                hidden_lat.Value = doc2.DocumentElement.SelectSingleNode("/GeocodeResponse/result/geometry/location/lat").InnerText;
                hidden_lng.Value = doc2.DocumentElement.SelectSingleNode("/GeocodeResponse/result/geometry/location/lng").InnerText;

            
            }
        }
        catch
        {
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
    <link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon">
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
    
   

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
               <p id="errorMsg" runat="server" visible="false" style="text-align: center; background-color: skyblue; border: 1px dotted gray"></p>


<table class="tg">
  <tr>
    <th>Name</th>
    <th>Gender</th>
    <th>Address</th>
  </tr>
  <tr>
    <td id="phy_name" runat="server"></td>
    <td id="phy_gender" runat="server"></td>
    <td id="phy_addr" runat="server"></td>
  </tr>
  <tr>
    <th>Medical School Name</th>
    <th>Graduation Year</th>
    <th>Primary Speciality</th>
  </tr>
  <tr>
    <td id="phy_school" runat="server"></td>
    <td id="phy_grad_year" runat="server"></td>
    <td id="phy_pri_spec" runat="server"></td>
  </tr>
  <tr>
    <th>NPI#</th>
    <th>Organisation Legal Name</th>
    <th>Accepts Medicare Assignments?</th>
  </tr>
  <tr>
    <td id="phy_npi" runat="server"></td>
    <td id="phy_org_name" runat="server"></td>
    <td id="phy_medicare" runat="server"></td>
  </tr>
  <tr>
    <th>Participating in ERX?</th>
    <th>Participating in PQRS?</th>
    <th>Participating in EHR?</th>
  </tr>
  <tr>
    <td id="phy_erx" runat="server"></td>
    <td id="phy_pqrs" runat="server"></td>
    <td id="phy_ehr" runat="server"></td>
  </tr>
</table>
              <div id="map-canvas" style="width:100%; height:500px;"></div>


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
        <input type="hidden" id="hidden_lat" runat="server" />
        <input type="hidden" id="hidden_lng" runat="server" />
    </form>

    <script>

        // Need the script to be placed at the bottom of the page as the script requires values from hidden_lat and hidden_lng
        // If placed in a seperate file, the script executes before the hidden fields are populated and thus breaking the code.

        var map;
        // Retrive the latitude and longitude from the hidden controls
        var currentLatLng = new google.maps.LatLng(document.getElementById('hidden_lat').value, document.getElementById('hidden_lng').value);
              
        function initialize() {

            // Set the center and zoom factor
            var mapOptions = {
                zoom: 14,
                center: currentLatLng
            };

            // Set the icon used for the marker
            var customIcon = "http://maps.google.com/mapfiles/ms/icons/yellow.png";

            // set the map to the element on the page
            map = new google.maps.Map(document.getElementById('map-canvas'),
                mapOptions);

            // Disply the info window on the page
            var infowindow = new google.maps.InfoWindow();

            // Use the place marker to mark the place
            var yourPlaceMarker = new google.maps.Marker({
                position: currentLatLng,
                map: map,
                title: "You are here now !!",
                animation: google.maps.Animation.DROP,
                icon: customIcon
            });

            // Add the mouseover event so that the info window is displayed when hovered over the marker
            google.maps.event.addListener(yourPlaceMarker, 'mouseover', function () {
                infowindow.setContent(this.title);
                infowindow.open(map, this);
            });

        }

        google.maps.event.addDomListener(window, 'load', initialize);

    </script>
</body>
</html>
