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



            <h1>OneHealth - Project Overview</h1>
            <div class="main-content">
                <p>
                    <strong>OneHealth</strong> is a website that helps users to search and retrieve vital information about drugs, health insurance plans, physician details and hospital details. The site allows to search in multiple formats so that the user can easily narrow down to the results that he/she needs. The site also features two widgets in the homepage that helps the user to determine his/her body mass index and to get parental tips for nursing children aged between 1 - 5 years.
                </p>
                <p>
                    The site is designed  keeping the mobile first concept in mind. The website will work on any device irrespective of the screen size. All.All media queries were written by me without using bootstrap.
                </p>
                <p>
					<strong>Design Features:</strong></p>
				<p>
					Below are a few of the standards and practices I have followed while creating this project</p>
				<ul>
					<li>
						Fully Responsive - No Bootstrap used</li>
					<li>
						Separate files for JavaScript</li>
					<li>
						Proper exception handling inside functions and friendly error messages.</li>
		</ul>
		
		<p>
					<strong>Functional Features:</strong></p>
                <p>
                    The main features of this site are as listed below:
                </p>
                <p>
                    <strong>Pill Identifier</strong> : The pill identifier tool enables the users to search for any FDA approved pill/drug and retrieve all the vital information about that pill along with the images of that pill for visual verification.
                </p>
                <p>
                    <strong>Physician Search</strong> : The physician search allows the user to search for any physician practicing with in the United States and retrieve all the particulars about that physician including his/her graduation year and the medical school from which the physician graduated. The results also display the map of the physician location to the user.
                </p>
                <p>
                    <strong>Hospital Search</strong> : This feature helps the user to search for any hospital located with in the United states and shows the important details of that particular hospital. The result also includes the HCAHPS answers from the patients about the infrastructure and quality of treatment provided by that hospital. This enables the user to know in depth about that hospital and helps in make a decision.
                </p>
                <p>
                    <strong>Health Insurance Plan Search</strong> : This search feature allows the user find a suitable health insurance plan that is available for him or his family based on the state in which he/she resides and the maximum amount of monthly premium the user would be able to pay. The results include all the details that any person would like to know before enrolling in an insurance plan.
                </p>

                <br /><br />
                <div class="footer">
                    <div id="footer_middle">&copy; Sandeep Ramamoorthy<br />
                College of Computer and Information Science</div>
                </div>









            </div>

        </div>
    </form>
</body>
</html>
