INSTRUCTIONS
##########

1. Download and unzip the file "UCI HAR Dataset" from here: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

2. From the github repository, download the file run_analysis.R and save to the directory "UCI HAR Dataset" from step 1

3. Open R Studio and set the working directory to the "UCI HAR Dataset" file from step 1

4. In the R Studio console, type the command "source("run_analysis.R")" so that functions from the run_analysis.R file can be used

5. Call the function build_dataset() and set it equal to a variable

6. Notes about the build_dataset() function (refer to the run_analysis.R file):

	- At line 6, the get_activity_column function is called, which opens the y_train.txt and y_test.txt files, reads in the numbers, and creates a vector of activities associated with the numbers. The numbers 1-6 pertain to one of the six different activities. For more details, refer to lines 4-12 in codebook.txt.
	
	- At line 8, data extracted from both y_train.txt and y_test.txt is combined into one vector.
	
	- At line 11, the get_features_and_indices function is called, which extracts data from the features.txt file. It extracts both the first column, which consists of numbers, as well as the variable names associated with each number. The for loop at line 86 loops through the extracted data and, using the regex command at line 88, extracts only the variable names that contain a "-mean()" or a "-std()" string. New vectors are then created. The target_features vector, initialized at line 81, contains only variable names that satisfy the regex conditions. The target_indices vector contains the variables' corresponding indices.
	
	- At lines 14 and 16, the function get_train_and_test_data() is called. One of the arguments it takes is a vector of integers denoting which columns to extract from the "X_train.txt" and "X_test.txt" files. For example, if the vector equals c(1, 3, 7), then only the first, third, and seventh numbers from each row from each file will be extracted. This integer vector corresponds to the variable names from the features.txt file that contain a "-mean()" or a "-std()" string.
	
	- At line 17, the datasets extracted from "X_train.txt" and "X_test.txt" are combined to form one dataset.
	
	- At line 20, the variable names are renamed so that they are more descriptive. This occurs in the alter_features function, which returns the renamed variables in a vector. See the codebook (codebook.txt) for notes on how the original variable names are reformatted. At line 21, the vector is used for the column names of the dataset created at line 17.
	
	- At line 25, the dataset is made tidy with the tbl_df function from the dplyr package.
	
	- At line 26, a new column is added (using dplyr's mutate function) and is labeled activityLabels. This column's data contains the vector of activites created in line 8.
	
	- This dataset is now tidy and conforms to the first four requirements from the assignment's "Instructions" page (located at the bottom).

7. After calling the function build_dataset() in the R Studio console, a tidy dataset is returned. Use that dataset, run the command create_q5_dataset(tidy_data), and set it equal to a new variable.

8. Notes about the create_q5_dataset() function (refer to the run_analysis.R file):

	- The create_mean_row function, defined at line 264, takes a dataset and an activity as parameters. First, at line 266, the dataset is filtered such that the dataset only contains data where the value in the activityLabels column is equal to the activity parameter (such as "WALKING", for example). The apply function is then called at line 267 to create a vector of values, where each value is the average of one of the columns from the dataset. A new column is then added to that vector containg the activity parameter, and then that vector is returned.
	
	- Lines 254 through 259 call the create_mean_row function six times, once for each different activity, to find the averages of every variable while the activityLabels column equals a particular activity.

9. After calling the create_q5_dataset() function in the R Studio console, a tidy dataset is returned that satisfies requirement 5 from the assignment's "Instructions" page (located at the bottom).

















