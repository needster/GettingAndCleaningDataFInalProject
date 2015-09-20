# Project Codebook
This file describes the format and values of the data sets for the following:
* input data used by the run_analysis function
* resulting tidy data set produced by the run_analysis function


## Input data

The following files from the Smartphone-Based Recognition of Human Activities and Postural Transitions Data Set are used by the run_analysis function.

### activity_labels.txt
Contains a mapping of the 6 activities perfomed by the subjects.

Cases: 6                       
Record Length: 2

| NAME  | POSITION  |  DESCRIPTION | VALUES OR EXPLANATION  |
|---|---|---|---|
| V1  | 1  | Activity ID  | Numeric values: 1 - 6  |
| V2  | 2  | Activity description  | WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING |


### features.txt
Contains the names of the 561 features reported for each trial.

Cases: 561                     
Record Length: 2

| NAME  | POSITION  |  DESCRIPTION | VALUES OR EXPLANATION  |
|---|---|---|---|
| V1  | 1  | Feature ID  | Numeric values: 1 - 561  |
| V2  | 2  | Feature function  | Function name and signature used to generate the feature value. Example: fBodyAccMag-mean() |


### X_test.txt
Contains the feature values for the test trials.


### y_test.txt
Contains the activity ID for the test trials.


### subject_test.txt
Contains the subject ID for each test trial.

### X_train.txt
Contains the feature values for the train trials.


### y_train.txt
Contains the activity ID for the train trials.

### subject_train.txt
Contains the subject ID for each train trial.

## Project Result Data

The following files from the Smartphone-Based Recognition of Human Activities and Postural Transitions Data Set are used by the run_analysis function.


* `README.md`
