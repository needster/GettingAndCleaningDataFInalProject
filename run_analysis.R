# This script is used to create a dataset of means for features from the
# Smartphone-Based Recognition of Human Activities and Postural Transitions Data Set
# This data set was made available  from the Getting and Cleaning Data course website at:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# but can also be downloaded from the source at
# http://archive.ics.uci.edu/ml/datasets/
#   Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions
#
# The dataset generated from this script represents the average of mean and standard
# feature data for each activity for each subject. This dataset is written to a .txt 
# file and saved to the working directoy.Since there were 30 subjects
# perfoming 6 activities, there are a total of 180 rows in the output, where each row 
# reports the average of selection of 66 features for a subject and activity.
# A complete overview of the features selected from the dataset are described in
# the README.md file that accompanies this script.
#
# Preconditions:
# This script assumes that the source files are contained within the working directory
# in a folder named 'SamsungDataset'. Before running this script, downlaod the zip 
# file from one of the source above and unzip the file. Move the unzipped folder
# into the same directory as this script and rename it 'SamsungDataset'.
# Once RStudio has been launched, set the working directory to the directory 
# that contains this script and the 'SamsungDataset' folder, then source the script by
# typing the following in the console:
# > source("run_analysis.R")
#
# Execution: verified on RStudio Version 0.99.467 and OSX Version 10.10.4
# Once the script has been sourced, execute the run_analysis function
# by typing the following in the console:
# > run_analysis()
#
# Postconditions:
# After executing the command above, a .txt file named 'subjectByActivityFeatureMeans.txt'
# containing the dataset as descibed above will be located in the working directory

# function to create a dataset of selected feature averages for each activity performed
# by each subject and save the data to to a .txt file named 'subjectByActivityFeatureMeans.txt'
# in the working directory
run_analysis <- function() {
    # Our first step is to read in the data for each trail, which
    # is spread across different files. Additionaly, a trial may be a 
    # train trial or a test trial, whose data are also stored in separate folders
    # the data we need for each train and test trial are
    # 1 - the subject of the trial entry
    # 2 - the activity performed for the trial entry
    # 3 - the feature data for the trial entry
    
    # get the activities labels from the activity_labels.txt file
    activities <- read.table("./SamsungDataset/activity_labels.txt")
    
    # read in the file that contains the activity identifiers
    # for the train and test data
    activityDataTrain <- read.table("./SamsungDataset/train/Y_train.txt")
    activityDataTest <- read.table("./SamsungDataset/test/Y_test.txt")
    
    # convert the activity data to factors
    activityDataTrain$V1 <- as.factor(activityDataTrain$V1)
    activityDataTest$V1 <- as.factor(activityDataTest$V1)
    
    # rename the factor levels according to the activity labels
    levels(activityDataTrain$V1) <- activities$V2
    levels(activityDataTest$V1) <- activities$V2
    
    # get the feature labels
    features <- read.table("./SamsungDataset/features.txt")
    
    # subset the features by finding all the labels that contain
    # mean() and std()
    meanColumns <- subset(features, grepl("mean()", features$V2, fixed = TRUE))
    sdColumns <- subset(features, grepl("std()", features$V2, fixed = TRUE))
    
    # rbind the results to form one data frame
    desiredColumns <- rbind(meanColumns, sdColumns)
    
    # clean the labels of characters that are not letters
    desiredColumns$V2 <- gsub("-","",desiredColumns$V2)
    desiredColumns$V2 <- gsub("\\(","",desiredColumns$V2)
    desiredColumns$V2 <- gsub("\\)","",desiredColumns$V2)
    
    # get the train feature data and subset on the rows in desiredColumns
    trainData <- read.table("./SamsungDataset/train/X_train.txt")
    trainDataSubset <- subset(trainData, select=desiredColumns$V1)
    # add the colum names
    colnames(trainDataSubset) <- desiredColumns$V2
    
    # read in the files that contains the subject identifiers
    # for the train and test data
    trainSubjects <- read.table("./SamsungDataset/train/subject_train.txt")
    testSubjects <- read.table("./SamsungDataset/test/subject_test.txt")
    
    # create a train table with the subject identifier in the first colum
    # and activity in the second colunm
    resultTrain <- cbind(trainSubjects,activityDataTrain$V1)
    # create a third column representin the trial (TRAIN or TEST)
    # and add it to the table as the third column
    resultTrain$trial <- "TRAIN"
    # set the column names
    colnames(resultTrain) <- c("subject","activity", "trial")
    # bind the feature data table to the table just created
    # to bring together all data for the TRAIN trials
    resultTrain <- cbind(resultTrain,trainDataSubset)
    
    # get the test feature data and subset on the rows in desiredColumns
    testData <- read.table("./SamsungDataset/test/X_test.txt")
    testDataSubset <- subset(testData, select=desiredColumns$V1)
    # add the colum names
    colnames(testDataSubset) <- desiredColumns$V2

    # create a test table with the subject identifier in the first colum
    # and activity in the second colunm
    resultTest <- cbind(testSubjects,activityDataTest$V1)
    # create a third column representin the trial (TRAIN or TEST)
    # and add it to the table as the third column
    resultTest$trial <- "TEST"
    # set the column names
    colnames(resultTest) <- c("subject","activity", "trial")
    # bind the feature data table to the table just created
    # to bring together all data for the TEST trials
    resultTest <- cbind(resultTest,testDataSubset)

    # combine the rows of the resultTrain table and resultTest table
    # to form a larger table containing the data we are interested in
    completeData <- rbind(resultTrain, resultTest)
    # convert the trail column into a factor, which is not part of the
    # assignment, but could be useful for data analysis of trial vs
    # test data
    completeData$trial <- as.factor(completeData$trial)
    
    #################################################################
    # At this point we have created one table of all the train and test
    # trials for all the subjects that includes the 33 mean() and 33 std()
    # features. (66 features in total)
    #
    # Now we want to summarize this data by taking the average of each of 
    # the 66 features by subject and activity.
    
    # convert into a data frame table so we can use dplyr functions
    library(dplyr)
    completeDataDFT <- tbl_df(completeData)
    
    # create an empty table that we will used to return the final data set
    finalDataset = completeDataDFT[FALSE,]
    
    # for each subject, extract a subset of their data and find the
    # average of the selected features by activity
    for(currentSubject in 1:30) {
        
        # get a subset of the data for each subject
        subjectSubset <- filter(completeDataDFT, subject==currentSubject)
        
        # group the data by activity and comptute the activity average
        # for each feature
        by_activity <- group_by(subjectSubset, activity)
        subjectResult <- summarise_each(by_activity, funs(mean), c(4:69))
        
        # construct a temporary table for each subject with the first column 
        # = subject number and the rest of the columns as generated from the
        # summarize_each function above
        column1 <- rep(currentSubject, each = 6)
        # combine the columns into a 6 x 68 data table
        # where the first column is the subject number, 
        # the second column is the activity, and columns 3 through
        # 68 are the selected feature averages for the subject by activity
        subjectTable <- cbind(column1,subjectResult)
        colnames(subjectTable)[1] <- "subject"

        # add the temporary subject table to the final data set
        finalDataset <- rbind(finalDataset,subjectTable)

    }

    # write the final data set to a file named "./subjectByActivityFeatureMeans.txt"
    # in the working directory, but do not include the row names
    write.table(finalDataset, file="./subjectByActivityFeatureMeans.txt",
            row.names = FALSE)
    
}