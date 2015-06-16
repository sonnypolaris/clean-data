# clean-data
Coursera Clean Data Project

## Input Data
The data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: (
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The data was sourced from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]

## How this script works
1. Step 1 of the scripts downloads and unzips the data file
2. Step 2 reads in data.frame(s) for each of the following data sets
   + X_test (measure for each observation)
   + Y_test 
   + subject_test (used to identify subjects)
   + X_train (measures for each observation)
   + Y_train 
   + subject_train (used to identify subjects)
   + features - Used for column names (measure names)
   + activity_labels - Used for actviity labels (Walking, Sitting, etc)
3. Step 3 - Merge activity labels with the y test data set. 
   + The Y_test and Y_train have the same number of rows as  X_test and Y_test (repectively)
   + The Y_test/train data set is a link/map to the "activity_label" (walking, sitting, etc)
   + It is assumed that the Y_test/train data set can be added as a new column to the X_test/train data set
4. Step 4 - Merge the subjects and the activity labels to the X_test/train data set
   + The "subjects_test" and "subject_train" link observations in the test/train data set to the subjects. Thus they can be column-binded (cbind) to their corresponding x_test/train data set.
   + The data sets from step 3 can be column-binded to the their corresponding x_test/train data set.
```{r}
# Step 4 - Add the subjects and activity label to the x_test/x_train sets
x_test  <- cbind(x_test, subject_test)
x_test  <- cbind(x_test, h$V2)
x_train <- cbind(x_train, subject_train)
x_train <- cbind(x_train, j$V2)
```
5. Step 5 - row bind (rbind) the x_test and y_test data frames together
   + The number of columns and column names need to match
6. Step 6 - apply column names from the features
   + crate a function to remove '(', ')', '-', ','
   + set to lower case
   + create a list / vector of only the columns (measures) that we want. (std and mean)
   + add the subject and activity to the list of columns
7. Step 7 - Extract only the columns we want and apply the cleaned column names
8. Step 8 - Pivot the data
   + on subject and activity by using the reshaper2.melt () function
   + cast the data frame to get the mean() for each variable.
9. Step 9 - Export the data to a tab delimited file using write.table()

9. Step 9 - 