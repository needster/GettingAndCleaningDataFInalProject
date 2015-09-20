# Getting and Cleaning Data Final Project
This file describes the project, input data, and various files contained within this directory, which were generated toward the completion of the final course project for Getting and Cleaning Data, which is a MOOC offered by Johns Hopkins University through Coursera.

### Project Overview
From the project description: "The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis."

In short, the goal of this project is to prepare a tidy data set from data located in various files, then perform computations on the data to create a second, smaller tidy data set. 

Formally, the project requirements are to create one R script called run_analysis.R that does the following: 
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


### Project Data Set
The dataset provided comes from the Smartphone-Based Recognition of Human Activities and Postural Transitions Data Set, which can be accessed at: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.

The dataset for the project can be obtained at: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.

The dataset provides data resulting from a series of experiments in which one of 30 subjects performed one of 6 activites while wearing a smartphone on the waist. The experiments were divided into 'train' and 'test' trials such that 70% of the subjects participated in train trials and 30% in test trials. The data for train and test trials are reported in separate files. The experimenters observed and recorded accelerometer and gyroscope signals from the smartphone for the X, Y and Z axis for each trial.

These raw signals were then used to estimate the following values for each trial:
* Time domain - Body acceleration signal (3 values - 1 for each axis)
* Time domain - Gravity acceleration signal (3 values - 1 for each axis)
* Time domain - Body acceleration jerk signal (3 values - 1 for each axis)
* Time domain - Body gyroscope signal (3 values - 1 for each axis)
* Time domain - Body gyroscope jerk signal (3 values - 1 for each axis)
* Time domain - Body acceleration magnitude
* Time domain - Gravity acceleration magnitude
* Time domain - Body acceleration jerk magnitude
* Time domain - Body gyroscope magnitude
* Time domain - Body gyroscope jerk magnitude
* Frequency domain - Body acceleration signal (3 values - 1 for each axis)
* Frequency domain - Body acceleration jerk signal (3 values - 1 for each axis)
* Frequency domain - Body gyroscope signal (3 values - 1 for each axis)
* Frequency domain - Body acceleration magnitude
* Frequency domain - Body acceleration jerk magnitude
* Frequency domain - Body gyroscope magnitude
* Frequency domain - Body gyroscope jerk magnitude

Note that in total, there are 33 values estimated.

For each value above, the researchers generated various statistics, which are reported as 'features' in the data set. For each trial, the researchers generated 561 such features, which are documented in the 'features.txt' file included with the dataset. For our purposes, we are interested in only the mean and standard deviation values generated for each of the 33 values estimated above, so in total, our goal is to extract 66 values from the trial data for each subject trial.


### Methodology

The data required to construct the desired dataset for this project is distrubuted across the following files in the project data set:
* activity_labels.txt - contains the 6 activities perfomed by the subjects (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
* features.txt - contains the names of the 561 features reported for each trial
* X_test.txt - contains the feature values for each test trial
* y_test.txt - contains the activity ID for each test trial
* subject_test.txt - contains the subject ID for each test trial
* X_train.txt - contains the feature values for each train trial
* y_train.txt - contains the activity ID for each train trial
* subject_train.txt - contains the subject ID for each train trial

For a detailed description of the data represented in each file, please refer to projectCodebook.md in this directory.

A data table was contsructed separately for the test and train data as follows:
* Read in the subject ID into the first column
* Read in the activity (converted to a string factor) into the second column
* Set the trial factor ('TEST' or 'TRAIN') in the third column - note that this column is not used for any functions of this project, but may be useful to have in the dataset for future analysis
* Read in the list of features and select the columns that correspond to the mean() and std() values that we are interested in
* Read in the trial data, select the 66 columns applicable to this project, and set these as columns 4 through 69.

These two tables were combined (using `rbind()`) to produce one data table containing test and train data for all activity trials for all subjects. This table was then converted to a data frame table so that dplyr functions could be used. Specifically, data subsets were `select()` -ed, then the subset was `group_by()` activity to comptute the activity average for each feature for each subject. The result of each subject subset was added to a data table, which is written to a file called `subjectByActivityFeatureMeans.txt` once complete. 

The output to this file is also included in this directory, although not required as part of the project.


### Project Files

The name and contents of the project files included in this directory are as follows:
* `README.md` - This file that describes the project, input data, and methodology
* `run_analysis.R` - The R script used to produce the tidy data set of feature averages for each subject by activity
* `projectCodebook.md` - A description of the data inputs to the function in run_analysis.R and description of the data set represented in `subjectByActivityFeatureMeans.txt`.
* `subjectByActivityFeatureMeans.txt` - the tidy data set of feature averages for each subject by activity output from run_analysis.R. Each row represnts feature averages for the trials in which a specific subject performs one of six activities.
