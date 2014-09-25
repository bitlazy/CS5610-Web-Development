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
    
         <h1>Health Insurance Plan Search</h1>
         <div class="main-content">
             <p>
			The Health insurance plan search tool allows the users to search for an insurance plan based on the state in which the user resides, the number of people to be covered in the plan and the maximum premium payable by the user per month.</p>
		<p>
			This tool allows the user to search plans in two types.</p>
		<ul>
			<li>
				Search Health Insurance plan for individuals</li>
			<li>
				Search Health Insurance plan for family</li>
		</ul>
		<p>
			The tool uses the Health Plan Information provided by HealthCare.gov of 33 states participating in the marketplace operated by the federal government.</p>
		<p>
			The information is provided through Socrata Open Data API. The API end point for plan search is</p>
		<p>
			<a href="https://data.healthcare.gov/dataset/QHP-Landscape-Individual-Market-Medical/b8in-sz6k" target="_blank">https://data.healthcare.gov/dataset/QHP-Landscape-Individual-Market-Medical/b8in-sz6k</a></p>
		<p>
			A detailed documentation on how to use the SODA API can be found <a href="http://dev.socrata.com" target="_blank">here</a>.</p>
		<h2>
			How the tool works?</h2>
		<p>
			STEP 1 : Since the health insurance plans differ from state to state and not all states are participating in this marketplace, We first query the API and get the list of participating states on the page load event.</p>
		<p>
			STEP 2 : When the user searches with any of the above two methods, the matching results from the API are retrieved from the data set and is binded to a grid view on the page. The results include :</p>
		<ul>
			<li>
				Plan Name</li>
			<li>
				Metal Level</li>
			<li>
				Premium payable per month</li>
		</ul>
		<p>
			STEP 3: Upon user&#39;s request to view more details for a selected plan, the plan id and the county are passed as query string parameters to<strong> findPlan-helper.aspx</strong>.</p>
		<p>
			STEP 4: The findPlan-helper.aspx page queries the API with the plan id and the county and retrieves numerous other information regarding that plan including the phone number of the insurance provider.</p>
		<h2>
			Sequence Diagram</h2>
             <img src="images/plan-search-sequence.jpg" />

             <h2>Problems Faced</h2>
           <p>  While trying to access the value of the HTML5 range control in C#, the control was not recogonized by the language as it is not yet included into the .Net framework. Hence I had to think of how to access the control's value in an indirect way. 
             Then I decided to use a hidden field in the page and included a small javascript function that updates the value of the hidden field whenever the value of the range control changes. I then read the value of the hidden field from C sharp.</p>




             <h2>Source Code</h2>
              <ul>  
                  <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/findPlan.aspx">Find Plan ASPX</a></li>
                  <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/findPlan-helper.aspx">Find Plan Helper ASPX</a></li>
             
                   <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/rangeControlReader.js">Range Control Reader JS File</a></li>
                 <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/easyResponsiveTabs.js">Responsive Tabs JS File</a></li>
                <li><a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/tabKeeper.js">Tabs Tracker JS File</a></li>
                   </ul>

             <h2>Reference</h2>
             <ul>
                    <li>
                        <a href="http://dev.socrata.com/" target="_blank">Socrata Open Data API (SODA)</a>
                    </li>

                    <li><a href="http://www.Stackoverflow.com" target="_blank">Stackoverflow.com</a></li>
             </ul>


             <h2>ScreenShots</h2>
             <a href="images/hospital-search.png" ><img src="images/plan-search.png" style="width:256px"/></a>
                <a href="images/hospital-search-helper.png" ><img src="images/plan-search-helper.png" style="width:256px"/></a>

             </div>

         <br /><br />
                <div class="footer">
                    <div id="footer_middle">&copy; Sandeep Ramamoorthy<br />
                College of Computer and Information Science</div>
                </div>


    </div>
    </form>
</body>
</html>
