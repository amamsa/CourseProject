CourseProject
=============

Course Project for Getting and Cleaning Data

This project performs analysis on the Human Activity Recognition Using Smartphones Data Set.  More information about this data set and the underlying experiments can be found here:  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

The run_analysis.R script performs the following:
1. Merges the training and the test data sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement -- there are a total of 561 measurements collected during these experiments, but we're only focused on a subset (~79).
3. Uses descriptive activity names to name the activities in the data set.
4. Labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set (summary-tidy-data-set.txt) with the average of each variable for each activity and each subject.

run_analysis.R assumes that the experimental results data are in the "UCI HAR Dataset" subdirectory within its working directory.

Example output (not all measurement variables shown):
  subject_id           activity tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z
1          1             LAYING         0.2215982      -0.040513953        -0.1132036
2          1            SITTING         0.2612376      -0.001308288        -0.1045442
3          1           STANDING         0.2789176      -0.016137590        -0.1106018
4          1            WALKING         0.2773308      -0.017383819        -0.1111481
5          1 WALKING_DOWNSTAIRS         0.2891883      -0.009918505        -0.1075662
6          1   WALKING_UPSTAIRS         0.2554617      -0.023953149        -0.0973020

