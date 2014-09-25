
        /* 
        gettips : Date -> (HTML) Age, Quote
        GIVEN: The birthday of a child
        WHERE: the child is between 1 to 5 years old
        RETURNS: 1)The Age of the child in years, weeks and days
                 2)Parental tip of the given week
        */
        function gettips() {
            try {

                // Identify the input value
                var input = document.getElementById('bday').value;
                var txt4totsresult = document.getElementById('txt4tots_result_lbl');
                txt4totsresult.style.display = "none";

                // Do a basic check on the validity of the input date
                if (input.length <= 0) {
                    txt4totsresult.textContent = "Please select your child's birthday!";
                    txt4totsresult.style.display = "block";
                }

                else {
                    var birthday = new Date(input);
                    var today = new Date();
                    // Check if the given date is greater than the current date
                    if (birthday >= today) {
                        txt4totsresult.textContent = "Birthday cannot be greater than or equal to today";
                        txt4totsresult.style.display = "block";
                    }
                    else {
                        // Find the difference in days between the current day and birthday
                        var diffdays = days_between(today, birthday);

                        // Get the Age in years
                        var age = Math.round((diffdays / 365), 0);

                        // Get the Age in Weeks
                        var ageinWeeks = Math.round((diffdays / 7), 0);

                        // Check if the age of the child is between 1 to 5 years old
                        if (ageinWeeks < 52 || ageinWeeks > 260) {
                            txt4totsresult.textContent = "Sorry, This tool provides parental tips for parents and caregivers of children, ages 1-5 years.\r\n Your child is now " + ageinWeeks + " week(s) old.";
                            txt4totsresult.style.display = "block";
                        }
                        else {

                            // Form the SQL query and keep it ready to pass to the ajax call
                            var params = {
                                sql: 'SELECT * from "a4b6327f-c90f-4653-86da-00d7c84d40b3" WHERE childsageinweeks=' + ageinWeeks
                            };

                            // Define and call the API
                            $.ajax({
                                url: 'http://hub.healthdata.gov/api/action/datastore_search_sql',
                                dataType: "jsonp",
                                data: params,
                                // On success, call the handleResponse() function to render the response data
                                success: handleResponse,
                                error: function (e) { console.log(e); }
                            });

                        }
                    }
                }
            }
            catch (err) {
                // If any exception is encountered, alert the user
                alert(err);
            }
        }


        /* handleResponse : JSON -> HTML
           GIVEN: a JSON response
           RETURNS: the response rendered into HTML
        */
        function handleResponse(response) {

            var txt4totsresult = document.getElementById('txt4tots_result_lbl');
            txt4totsresult.style.display = "none";
            //Convert the object
            data = eval(response);
            // Locate where the resultant quote needs to be displayed and display the quote
            // var resultParagraph = document.getElementById("resultParagraph");
            var msg = data.result.records[0].txt4totsmessage;
            // Remove redundant text
            txt4totsresult.textContent = msg.replace("TXT4Tots:", "");
            txt4totsresult.style.display = "block";

        }

        /*
        days_between : Date Date -> Days
        GIVEN : two dates
        RETURNS: the difference between two dates
        */
        function days_between(date1, date2) {

            // The number of milliseconds in one day
            var ONE_DAY = 1000 * 60 * 60 * 24

            // Convert both dates to milliseconds
            var date1_ms = date1.getTime()
            var date2_ms = date2.getTime()

            // Calculate the difference in milliseconds
            var difference_ms = Math.abs(date1_ms - date2_ms)

            // Convert back to days and return
            return Math.round(difference_ms / ONE_DAY)

        }