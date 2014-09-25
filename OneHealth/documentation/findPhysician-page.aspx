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

            <h1>Physician Search</h1>
            <div class="main-content">

                <p>
                    The Physician search tool is capable of finding the details of any physician who is registered and is practicing with in the United States.
                </p>
                <h2>Features :</h2>
                <p>
                    The tool allows the user to search for physician details in three different types namely
                </p>
                <ul>
                    <li>Search by physician&#39;s name</li>
                    <li>Search by location</li>
                    <li>Advanced Search</li>
                </ul>
                <p>
                    The tool fetches up to 1000 physicians at a single query with basic information like
                </p>
                <ul>
                    <li>Name of the doctor</li>
                    <li>NPI licence number</li>
                    <li>Primary Specialty</li>
                    <li>City &amp; State of the doctor</li>
                </ul>
                <p>
                    If the user wishes to know more details about a particular physician, then he/she can click on the &quot;view details&quot; link to get more information about the physician. The in-depth details include :
                </p>
                <ul>
                    <li>Full address of the physician</li>
                    <li>Year of graduation &amp; the medical school</li>
                    <li>Physician&#39;s participation in ERx, EHR, PQRS &amp; Medicare programs</li>
                    <li>A map showing the physician&#39;s location</li>
                </ul>
                <h2>How the page works?</h2>
                <p>
                    The physician search page uses the <em>Physician Compare</em> dataset provided by <a href="https://data.medicare.gov/Physician-Compare/National-Downloadable-File/s63f-csi6" target="_blank">Medicare.gov</a>. The data set is queried through the SODA API
                </p>
                <p>
                    The end point of the API is : http://data.medicare.gov/resource/s63f-csi6.xml
                </p>
                <p>
                    When the user searches for a physician by any of the above three types of search, the page fetches the results from the dataset and binds it to a grid view control on the page.
                </p>
                <p>
                    If the user wishes to get more details of any particular physician from the displayed search results, the NPI number of that physician is passed as input to the <strong>findPhysician-helper.aspx</strong> page.
                </p>
                <p>
                    The findPhysician-helper.aspx page sends another call to the dataset with the npi number in the condition clause and reterives the entire information about the physician. These details are displayed in a table in the&nbsp;findPhysician-helper.aspx page.
                </p>
                <p>
                    A map powered by Google is plotted with the address of the physician that is retrieved from the dataset.
                </p>


                <h2>Sequence Diagram</h2>
                <img src="images/physician-search-sequence.jpg" style="width: 80%" />

                <h2>Source Code</h2>
                <ul>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/findPhysician.aspx">Find Physician ASPX</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/findPhysician-helper.aspx">Find Physician Helper ASPX</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/google_maps.js">Google Maps JS File</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/easyResponsiveTabs.js">Responsive Tabs JS File</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/tabKeeper.js">Tabs Tracker JS File</a></li>
                </ul>

                <h2>Reference</h2>
                <ul>
                    <li>
                        <a href="http://dev.socrata.com/" target="_blank">Socrata Open Data API (SODA)</a>
                    </li>
                    <li>
                        <a href="https://data.medicare.gov/Physician-Compare/National-Downloadable-File/s63f-csi6" target="_blank">Medicare.Gov's Physician Compare Dataset</a>
                    </li>
                    <li>
                        <a href="https://developers.google.com/maps/documentation/javascript/tutorial" target="_blank">Google Maps API Documentation</a></li>

                </ul>

                <h2>Screen Shots</h2>
                <a href="images/physician-search.png">
                    <img src="images/physician-search.png" style="width: 256px" /></a>
                <a href="images/physician-search-helper.png">
                    <img src="images/physician-search-helper.png" style="width: 256px" /></a>

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
