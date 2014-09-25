/*
        This function calculates the BMI for the height and weight given by the user.
        We assume that the maximum height is 132 inches and the maximum weight is 700 pounds
        */
        function calculateBMI() {
            try {

                //Get the element where the results need to be displayed from the page
                var bmiResultLabel = document.getElementById('bmi_result_lbl');
                bmiResultLabel.textContent = "";

                // Get the inputs provided by the user
                var heightFeet = parseInt(document.getElementById('height_ft_txt').value, 10);
                var heightInches = parseInt(document.getElementById('height_in_txt').value, 10);
                var weightPounds = parseInt(document.getElementById('weight_txt').value, 10);
                var bmi = 0;

                // Calculate the total height in inches
                var totalHeightInches = (heightFeet * 12) + heightInches;

                // Check if the input weight is a valid one
                if ((weightPounds > 15) && (weightPounds < 700)) {

                    // Check if the height is also a valid height assuming a maximu human height of 132 inches
                    if (totalHeightInches < 132) {

                        // Calcuate the BMI
                        bmi = (weightPounds / (totalHeightInches * totalHeightInches)) * 703.069;

                        // Display the result based on the above calculation
                        if (bmi < 18.5)
                            bmiResultLabel.textContent = "Your BMI is " + bmi.toFixed(2) + ". Your weight is less than normal for your height";
                        else if ((bmi >= 18.5) && (bmi <= 24.9))
                            bmiResultLabel.textContent = "Your BMI is " + bmi.toFixed(2) + ". Your weight is normal for your height. Your BMI is perfect!";
                        else if ((bmi >= 25) && (bmi <= 29.9))
                            bmiResultLabel.textContent = "Your BMI is " + bmi.toFixed(2) + ". Your weight is a bit more than normal for your height. Your need to shed some weight.";
                        else
                            bmiResultLabel.textContent = "Your BMI is " + bmi.toFixed(2) + ". Your weigh too much than normal for your height. Please consult a physician and follow a good diet.";

                    }
                    else {

                        bmiResultLabel.textContent = "Please enter a valid height";

                    }

                }
                else {
                    bmiResultLabel.textContent = "Please enter a valid weight in pounds";
                }

                bmiResultLabel.style.display = "block";

            }

            // Upon any exception, display a friendly message to the user
            catch (e) {

                bmiResultLabel.textContent = "Lets do it again.Please enter a valid height and weight";
                bmiResultLabel.style.display = "block";
            }
        }