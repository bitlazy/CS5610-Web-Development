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

            <h1>Pill Identifier</h1>
            <div class="main-content">

                <p>
                    The pill identifier tools allows the user to search for any FDA approved drug&#39;s details including the latest image of the pill. This tool uses two data sources for its search namely,
                </p>
                <ul>
                    <li>Source 1 - sand89 database located at our college server</li>
                    <li>Source 2 - The PillBox API</li>
                </ul>
                <h2>Source 1 - sand89.NDC_PRODUCT</h2>
                <p>
                    The sand89 database contains the NDC_PRODUCT table which contains the details of 77,171 FDA approved drugs. The details of the 77,171 drugs are provided by the U.S. Food &amp; Drug Administration.(<a href="http://www.fda.gov" target="_blank">www.fda.gov</a>). The contents include
                </p>
                <p>
                    <strong>NDC number</strong> : A unique number assigned to each drug by FDA to for identification
                </p>
                <p>
                    <strong>Type of the drug</strong>: A drug is categorized in to one of the following
                </p>
                <ul>
                    <li>Vaccine</li>
                    <li>Cellular Therapy</li>
                    <li>Human Prescription Drug</li>
                    <li>Non-Standardized Allergenic</li>
                    <li>Standardized Allergenic</li>
                    <li>Plasma Derivative</li>
                    <li>Human OTC Drug</li>
                </ul>
                <p>
                    <strong>Drug&#39;s full name </strong>: The full name of the drug as mentioned in the FDA database
                </p>
                <p>
                    <strong>Dosage form</strong> : The way through which the drug is consumed (example: Syrup, Cream, Aerosol, Foam etc)
                </p>
                <h2>Source 2 - PillBox API</h2>
                <p>
                    The PillBox API is a data set containing much advanced information about pills and tablets along with the latest image of that drug. The PillBox API is maintained by the National Library Of Medicine(<a href="http://pillbox.nlm.nih.gov" target="_blank">pillbox.nlm.nih.gov</a>), part of the National Institutes of Health, U.S. Department of Health and Human Services. It requires to obtain an API key to access their data.
                </p>
                <p>
                    A detailed documentation of the PillBox API can be found <a href="https://github.com/HHS/pillbox_docs/wiki/Pillbox-API-documentation" target="_blank">here</a>
                </p>
                <h2>How Our Tool Works?</h2>
                <p>
                    The <strong>findPills.aspx</strong> is the page at which the user performs the search. The search can be performed is four different way as mentioned below
                </p>
                <ul>
                    <li>
                        <strong>Search by Drug Name</strong>
                        <ul>
                            <li>The user can perform a search based on the drug name that is printed on his/her medication bottle</li>
                        </ul>
                    </li>
                    <li>
                        <strong>Search by NDC code</strong>
                        <ul>
                            <li>Perform search based on the NDC number that is printed at the back of the pill bottle</li>
                        </ul>
                    </li>
                    <li>
                        <strong>Search by the shape &amp; colour of the pill</strong>
                        <ul>
                            <li>Retrieves all pills that match the given shape &amp; colour</li>
                        </ul>
                    </li>
                    <li>
                        <strong>Advanced Pill Search</strong>
                        <ul>
                            <li>Retrieves the matching pills as per the various conditions provided by the user</li>
                        </ul>
                    </li>
                </ul>
                <p>
                    The first two searches i.e. Search by name and search by NDC code hits the sand89.NDC_PRODUCT table to retrieve the results. To get more in-depth details of the drug and to see the image of the pill, we then redirect the user to the <strong>findPills-helper.aspx </strong>page by passing the NDC code of the drug as query string. The findPills-helper.aspx page in turn hits the PillBox API to fetch the sophisticated details about that pill.
                </p>
                <h4>Why We first query the database before hitting the PillBox API?</h4>
                <p>
                    The sand89.NDC_PRODUCT table contains the basic details of the drug like its medication form etc where as the PillBox API does not provide these details. Hence, we would need to combine the power of both the database and the API to provide the user with a complete detail.
                </p>
                <h2>Sequence Diagram : Search by drug name, Search By Drug code
                </h2>
                <img src="images/pill-search1-sequence.jpg" style="width: 80%" />
                <p>
                    The next two searches namely, Search by Shape &amp; Colour and Advanced Pill Seach direcly hit the Pill Box API to fetch the results as there is no sufficient information available in the sand89.NDC_PRODUCT table to perform these searches.
                </p>

                <h2>Sequence Diagram : Search by shape & color, Advanced Search
                </h2>
                <img src="images/pill-search2-sequence.jpg" style="width: 80%" />

                <h2>Problems Faced :</h2>
                <p>
                    After designing and programming the entire pill identifier page, The API went offline and the page became useless. I contacted the API&#39;s support team over email, twitter and finally over phone. They informed that they are already working towards the fix and it would be restored in 2 days time.
                </p>
                <p>
                    Another problem I faced in this page (and in all the other pages) is that after post back, the page shows the first tab instead of the tab from which the search was performed. After hours thinking and experiments, I finally decided to use a hidden field that would record the current active tab and after postback, a small java script function will programmatically click the current tab.
                </p>


                <h2>Source Code :</h2>
                <ul>
                    <li>
                        <a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/findPills.aspx">Find Pills aspx page</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/findPills-helper.aspx">Find Pills Helper aspx page</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/easyResponsiveTabs.js">Responsive Tabs JS File</a></li>
                    <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/tabKeeper.js">Tabs Tracker JS File</a></li>

                </ul>
                <h2>References :</h2>
                <ul>
                    <li>
                        <a href="https://github.com/HHS/pillbox_docs/wiki/Pillbox-API-documentation" target="_blank">Pill Box API Documentation</a>
                    </li>
                    <li>(<a href="http://www.fda.gov" target="_blank">U.S. Food &amp; Drug Administration</a></li>
                </ul>
                <h2>Screen Shots :</h2>
                <a href="images/pill-identifier.png">
                    <img src="images/pill-identifier.png" style="width: 256px" /></a>
                <a href="images/pill-identifier-helper.png">
                    <img src="images/pill-identifier-helper.png" style="width: 256px" /></a>

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
