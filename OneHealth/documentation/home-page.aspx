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
    
         <h1>Home Page</h1>
         <div class="main-content">
             <p>
			The home page of the site contains the following common features which are used &quot;as is&quot; in all the other pages of the site as well.</p>
		<ul>
			<li>
				Site logo</li>
			<li>
				Social icons</li>
			<li>
				Responsive navigation menu</li>
		</ul>
		<p>
			The home page also showcases unique features like,</p>
		<ul>
			<li>
				Responsive jQuery carousal</li>
			<li>
				CSS3 animated flipping menu</li>
			<li>
				Parental tips using TXT4TOTS API</li>
			<li>
				Body Mass Index Calculator</li>
		</ul>
		<h2>
			Common Features</h2>
		<p>
			<strong>Site Logo</strong> : In my opinion, No site would be complete without a site logo. Hence I designed my own logo for the site using an online photo editor tool. The decided to give the logo a simple but elegant look. The logo contains a caduceus symbol that portrays that the site is something related to health and medicine niche.</p>
		<p>
			<strong>Social Icons</strong> : The power of social media has multiplied by leaps and bounds in the recent years. The social media plays a vital role in spreading the word about any site to the world. The OneHealth website also includes three powerful social media icons namely Facebook, Twitter and Google plus. <u>These icons are royalty free stock icons</u>. The icons initially appear in black and white mode. But when hovered with mouse, it reveals it original color. Just a small surprise to the user.</p>
		<p>
			<strong>Responsive Navigation Menu</strong> : This is the main navigation menu of the site. The menu is responsive and adapts to the screen size gracefully. The menu was entirely designed by me using pure CSS3 techniques. The menu shrinks to a one column vertical menu when browsed from a mobile device.</p>
		<h2>
			Home Page - Unique Feature</h2>
		<p>
			<b>Responsive jQuery carousal </b>: The responsive jQuery carousal features 4 slides that portrays the features of the site to the user. The carousal is a product of <a href="https://github.com/filamentgroup/responsive-carousel/" target="_blank">FilamentGroup</a>, an open source developers community and is released under GPL license.</p>
		<p>
			The carousal uses three javascript files for its smooth operation namely,</p>
		<ul>
			<li>
				responsive-carousel.js
				<ul>
					<li>
						This file contains the main methods of the carousal</li>
				</ul>
			</li>
			<li>
				responsive-carousel.autoplay.js
				<ul>
					<li>
						This file contains the methods to play the carousal with out user interaction based on time</li>
				</ul>
			</li>
			<li>
				responsive-carousel.autoinit.js
				<ul>
					<li>
						This file contains the initialization functions for the carousal</li>
				</ul>
			</li>
		</ul>
		<p>
			The slides used in the carousal are designed by me using an online photo editor tool. The images used in the slides are all stock images and royalty free. These images are collected from sites like 123RF.com and sxc.hu.</p>
		<p>
			<strong>CSS3 Animated Flipping Menu</strong> : This menu displays the four main functionalities of the site in a cool animated way. The four features represented by icons that depict that feature. Upon hovering the mouse over these icons, the image flips and shows a brief text about that feature. The site takes the user to that feature&#39;s page upon a click. The animation is performed purely by CSS3 and is based on my <a href="http://net4.ccs.neu.edu/home/sand89/experiments/CSS3/CSS3-Flipper.html" target="_blank">CSS3-Image flipper experiment</a></p>
		<p>
			<strong>Parental tips using TXT4TOTS API</strong> : This is a small tool that I placed on the home page of my site as a widget. This tool provides age-appropriate nutrition and physical activity reminders to caregivers of children aged between 1 to 5 years. The tool uses the TXT4Tots Message Library datasets API provided by <a href="http://www.healthdata.gov/data-api" target="_blank">HealthData.gov</a>. The tool is uses javascript to retrive data from the API.</p>
		<p>
			This tool is based on my experiment <a href="http://net4.ccs.neu.edu/home/sand89/experiments/JSON/txt4tots.html" target="_blank">Parental Tips using JSONP</a></p>
		<p>
			<strong>Body Mass Index Calculator</strong> : The body mass index calculator is another widget placed on the home page which is based on javascript. The widget takes the height and weight of the user as inputs and calculates the BMI of that user. The widget displays the BMI value and his/her obesity level (normal, overweight, under weight, obesity). The formula used to calculate the BMI is :</p>
		<p>
			<span style="font-family: monospace; white-space: pre-wrap;">bmi = (weightPounds / (totalHeightInches * totalHeightInches)) * 703.069; </span></p>
		<p>
			The obesity is calculated by the chart provided by <a href="http://www.nhlbi.nih.gov/guidelines/obesity/bmi_tbl.htm" target="_blank">National Heart Lung and Blood Institute</a></p>
		<h2>
			Problems Faced :</h2>
		<p>
			While programming the Body Mass Index calculator, I had to get the height and weight inputs from the user and convert it into string. But, the conversion using Number() function didn&#39;t provide the expected result. Then I learned that parseInt() function should be used with a radix parameter of 10 that indicates the decimal numbers. After including this in the code, the widget worked perfectly.</p>
		<h2>
			Source Code :</h2>
		<p>
			Main Home Page - <a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/index.html">index.html</a></p>
		<p>
			Carousal Files :</p>
		<ul>
			<li>
				<a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/responsive-carousel.js">responsive-carousel.js</a></li>
			<li>
				<a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/responsive-carousel.autoplay.js">responsive-carousel.autoplay.js</a></li>
			<li>
				<a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/responsive-carousel.autoinit.js">responsive-carousel.autoinit.js</a></li>
		</ul>
		<p>
			CSS File - <a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/StyleSheet.css">StyleSheet.css</a></p>
        <p>Script Files :</p>

             <ul>
                 <li>
                     <a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/bmi_calculator.js">bmi_calculator.js</a>
                 </li>
                 <li>
                     <a href="http://net4.ccs.neu.edu/home/sand89/fileview/Default.aspx?~/project/js/text4tots.js">text4tots.js</a>
                 </li>
             </ul>
		<h2>
			References:</h2>
		<ul>
			<li>
				<a href="http://www.healthdata.gov/data-api" target="_blank">HealthData.Gov Data API</a></li>
			
                <li>
				<a href="http://www.nhlbi.nih.gov/guidelines/obesity/bmi_tbl.htm" target="_blank">National Heart Lung and Blood Institute</a></li>
			<li>
				<a href="http://www.StackOverflow.com" target="_blank">StackOverflow.com</a></li>
		</ul>
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
