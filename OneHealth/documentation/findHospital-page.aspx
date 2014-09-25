<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html>
<head>
    <title>OneHealth - Simplifying Life</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <link rel="stylesheet" href="../StyleSheet.css" />
    <link rel="shortcut icon" href="../images/favicon.ico" type="image/x-icon">
</head>
<body>
    <form id="form1" runat="server">
        <div class="pad">
            <div class="header">

                <div id="logo">
                    <img id="logo_img" src="../images/logo1.png" />
                </div>

                <div id="social_icons">

                    <div id="gplus">
                        <img class="grayscale" src="../images/google-plus-icon.png" />
                    </div>

                    <div id="twitter">
                        <img class="grayscale" src="../images/twitter-icon.png" />
                    </div>

                    <div id="fbook">
                        <img class="grayscale" src="../images/facebook-icon.png" />
                    </div>

                </div>

            </div>

            <h1>Find Hospital</h1>
            <div class="main-content">
                <p>
                    The hospital search feature enables the user to search for the details of any hospital located with in United states. The search can be performed based on the name of the hospital or based on a location. The former retrieves either one result or no result while the later type of search returns a list of hospitals or no results.
                </p>

                <p>
                    The hospital search basically uses two API endpoints provided by the Medicare.gov namely,
                </p>
                <ul>
                    <li>Hospital General Information Dataset
				<ul>
                    <li>URL : https://data.medicare.gov/Hospital-Compare/Hospital-General-Information/v287-28n3</li>
                </ul>
                    </li>
                    <li>Survey of Patients's Hospital Experiences (HCAHPS) Dataset
				<ul>
                    <li>URL : https://data.medicare.gov/Hospital-Compare/Survey-of-Patients-Hospital-Experiences-HCAHPS-/rj76-22dk</li>
                </ul>
                    </li>
                </ul>
                <p>
                    Both the data sets are provided by Medicare.gov and implements <strong>Socrata Open Data API (SODA)</strong>. More of SODA API can <a href="http://dev.socrata.com/" target="_blank">read here</a>
                </p>
                <p>
                    The Hospital General Information Dataset provides information such as the name, provider id, address, ownership type, phone number etc.
                </p>
                <p>
                    The Survey of Patients's Hospital Experiences (HCAHPS) Dataset provides the hospital ratings for the Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS). HCAHPS is a national, standardized survey of hospital patients about their experiences during a recent inpatient hospital stay.
                </p>
                <h2>How the Hospital Search Tool Works?</h2>
                <p>
                    On Page load event, We populate the state and city details in to the respective drop down lists from the sand89.LOC table.
                </p>
                <p>
                    When searched by hospital name, The name of the hospital is searched against the Hospital General Information Dataset. If the hospital is found, the following details are retrieved and bound to a grid view in the page.
                </p>
                <ul>
                    <li>Hospital name</li>
                    <li>City</li>
                    <li>State</li>
                    <li>Hospital Type</li>
                </ul>
                <p>
                    Along with the above details, the provider Id of the hospital is also retrived but not shown to the user. When the user choose to see more details about a particular hospital, the provider id is pass as a query string parameter to the <strong>findHospital-helper.aspx</strong> page.
                </p>
                <p>
                    In findHospital-helper.aspx page, we use the Survey of Patients ' Hospital Experiences (HCAHPS) Dataset to retrieve the survey results of the hospital and plot it in Google bar charts.
                </p>
                <p>
                    The same technique is followed while searching by location except that the location is passed as parameter to the API instead of the hospital name.
                </p>

                <h2>Sequence Diagram</h2>
                <img src="images/hospital-search-sequence.jpg" style="width: 80%" />

                <h2>Source Code</h2>
                <ul>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/findHospital.aspx">Find Hospital ASPX</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/findHospital-helper.aspx">Find Hospital Helper ASPX</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/google_charts.js">Google Charts JS File</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/easyResponsiveTabs.js">Responsive Tabs JS File</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/tabKeeper.js">Tabs Tracker JS File</a></li>

                </ul>

                <h2>Reference</h2>
                <ul>
                    <li>
                        <a href="http://dev.socrata.com/" target="_blank">Socrata Open Data API (SODA)</a>
                    </li>

                    <li><a href="https://google-developers.appspot.com/chart/interactive/docs/quick_start" target="_blank">Google Charts API Documentation</a></li>

                </ul>

                <h2>Screen Shots</h2>
                <a href="images/hospital-search.png">
                    <img src="images/hospital-search.png" style="width: 256px" /></a>
                <a href="images/hospital-search-helper.png">
                    <img src="images/hospital-search-helper.png" style="width: 256px" /></a>


            </div>


            <br />
            <br />
            <div class="footer">
                <div id="footer_middle">
                    &copy; Sandeep Ramamoorthy<br />
                    College of Computer and Information Science
                </div>
            </div>


        </div>
    </form>
</body>
</html>
