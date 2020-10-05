---
title: "Code Book"
author: "Serge Olivier Kotchi"
date: "04/10/2020"
output: html_document
---


The objective of the project is to prepare tidy data that can be used for later analysis by collecting, working with, and cleaning a dataset obtain from a website contains data collected from the accelerometers from the Samsung Galaxy S smartphone.


## Data and variables

A full description of the dataset is available at the website:  
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>  
The dataset is available at:  
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>  

The dataset comes from experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.  

The acceleration signal was separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ).  
The body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). The magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).  
A Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).  

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.  

- tBodyAcc-XYZ  
- tGravityAcc-XYZ  
- tBodyAccJerk-XYZ  
- tBodyGyro-XYZ  
- tBodyGyroJerk-XYZ  
- tBodyAccMag  
- tGravityAccMag  
- tBodyAccJerkMag  
- tBodyGyroMag  
- tBodyGyroJerkMag  
- fBodyAcc-XYZ  
- fBodyAccJerk-XYZ  
- fBodyGyro-XYZ  
- fBodyAccMag  
- fBodyAccJerkMag  
- fBodyGyroMag  
- fBodyGyroJerkMag  

The set of variables that were estimated from these signals include:  

- *mean()*: Mean value  
- *std()*: Standard deviation  
- *mad()*: Median absolute deviation  
- *max()*: Largest value in array  
- *min()*: Smallest value in array  
- *sma()*: Signal magnitude area  
- *etc.*   

The complete list of variables of each feature vector is available in 'features.txt'  

The dataset includes the following files:  

- *README.txt*  
- *features_info.txt*: Shows information about the variables used on the feature vector.  
- *features.txt*: List of all features.  
- *activity_labels.txt*: Links the class labels with their activity name.  
- *train/X_train.txt*: Training set.  
- *train/y_train.txt*: Training labels.  
- *test/X_test.txt*: Test set.  
- *test/y_test.txt*: Test labels.  


## Tasks and transformations performed to clean up the data  

The following tasks and transformations were done on the original data sets in order to produce a tidy data set:  

**1.** Download and read the data sets;  
**2.** Merge the training and the test sets to create one data set;  
**3.** Extract only the measurements on the mean and standard deviation for each measurement;  
**4.** Use descriptive activity nam??es to name the activities in the data set;  
**5.** Label the data set with descriptive variable names;  
**6.** Create a tidy data set with the average of each variable for each activity and each subject.

```{r}
## 1. Download and read the data
##------------------------------

## Download the zip file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/zipdata.zip", method="curl")
## Unzip the file in a folder
unzip(zipfile="./data/zipdata.zip", exdir="./data")
list.files("./data")
## Read the training and the test data sets from the folder
xtrain <- read.table(file = "./data/UCI HAR Dataset/train/X_train.txt")
xtest <- read.table(file = "./data/UCI HAR Dataset/test/X_test.txt")
ytrain <- read.table(file = "./data/UCI HAR Dataset/train/y_train.txt")
ytest <- read.table(file = "./data/UCI HAR Dataset/test/y_test.txt")
subjectrain <- read.table(file = "./data/UCI HAR Dataset/train/subject_train.txt")
subjectest <- read.table(file = "./data/UCI HAR Dataset/test/subject_test.txt")
## Read feature & activity info data
features <- read.table(file = "./data/UCI HAR Dataset/features.txt")
activitylabels <- read.table(file = "./data/UCI HAR Dataset/activity_labels.txt")

## 2. Merge the training and the test sets to create one data set
##---------------------------------------------------------------

xdata <- rbind(xtrain, xtest) # merge X_train and X_test data sets
ydata <- rbind(ytrain, ytest) # merge y_train and y_test data sets
subjectdata <- rbind(subjectrain, subjectest) # merge subject_train and subject_test data sets

## 3. Extract only the measurements on the mean and standard deviation for each measurement
##-----------------------------------------------------------------------------------------

MeanStdMeasurements <- grep("-(mean\\(\\)|std\\(\\)).*", as.character(features[,2])) # Identify measurements on the mean and standard deviation
xdata <- xdata[, MeanStdMeasurements] # Extracts measurements on the mean and standard deviation

## 4. Use descriptive activity names to name the activities in the data set
##-------------------------------------------------------------------------

onedataset <- cbind(subjectdata, ydata, xdata) # Merge x, y (activities) and subject data sets
onedataset[,1] <- as.factor(onedataset[,1]) # Convert the subject data as a factor data
onedataset[,2] <- factor(onedataset[,2], levels = activitylabels[,1], labels = activitylabels[,2]) # Use descriptive activity names from the activity labels file to name the activities (y data) in the data set

## 5. Label the data set with descriptive variable names
##------------------------------------------------------

variablenames <- features[MeanStdMeasurements, ] # Create descriptive variable names using the description of measurements on the mean and standard deviation
variablenames <- variablenames[,2]
variablenames <- as.character(variablenames)
variablenames <- gsub("-mean", "Mean", variablenames)
variablenames <- gsub("-std", "Std", variablenames)
variablenames <- gsub("[-()]", "", variablenames)
names(onedataset) <- c("Subject", "Activity", variablenames) # Label the data set with descriptive variable names

## 6. Create an independent tidy data set with the average of each variable for each activity and each subject
##------------------------------------------------------------------------------------------------------------

library(dplyr) # Load dplyr packages
tidyData <- tbl_df(onedataset) # Convert the data set to a 'data frame tbl'
tidyData <- group_by(tidyData, Subject, Activity) # Group the data by subject and activity
tidyData <- summarise_all(tidyData, list(mean)) # Create the tidy data set 
write.table(tidyData, "./tidy_data_set.txt", row.names = FALSE, quote = FALSE) # Export the tidy data set

summary(tidyData)
```

## Descriptions of the tidy data set  

The tidy data set is consist of two (2) identifiers and sixty six (60) measurements.  

**Identififiers**  

- *Subject:* the ID of the Subject;  
- *Activity:* the name of the activity performed by the subject when measurements were taken.  

**Description of activity names**  

- *WALKING:* subject was walking during the test;  
- *WALKING_UPSTAIRS:* subject was walking up a staircase during the test;  
- *WALKING_DOWNSTAIRS:* subject was walking down a staircase during the test;  
- *SITTING:* subject was sitting during the test;  
- *STANDING:* subject was standing during the test;  
- *LAYING:* subject was laying down during the test.  

**Description of the measurements in the tidy data set**  

- *tBodyAccMeanX: *Time Body Accelerometer Mean X  
- *tBodyAccMeanY: *Time Body Accelerometer Mean Y  
- *tBodyAccMeanZ: *Time Body Accelerometer Mean Z  
- *tBodyAccStdX: *Time Body Accelerometer Standard Deviation X  
- *tBodyAccStdY: *Time Body Accelerometer Standard Deviation Y  
- *tBodyAccStdZ: *Time Body Accelerometer Standard Deviation Z  
- *tGravityAccMeanX: *Time Gravity Accelerometer Mean X  
- *tGravityAccMeanY: *Time Gravity Accelerometer Mean Y  
- *tGravityAccMeanZ: *Time Gravity Accelerometer Mean Z  
- *tGravityAccStdX: *Time Gravity Accelerometer Standard Deviation X  
- *tGravityAccStdY: *Time Gravity Accelerometer Standard Deviation Y  
- *tGravityAccStdZ: *Time Gravity Accelerometer Standard Deviation Z  
- *tBodyAccJerkMeanX: *Time Body Accelerometer Jerk Mean X  
- *tBodyAccJerkMeanY: *Time Body Accelerometer Jerk Mean Y  
- *tBodyAccJerkMeanZ: *Time Body Accelerometer Jerk Mean Z  
- *tBodyAccJerkStdX: *Time Body Accelerometer Jerk Standard Deviation X  
- *tBodyAccJerkStdY: *Time Body Accelerometer Jerk Standard Deviation Y  
- *tBodyAccJerkStdZ: *Time Body Accelerometer Jerk Standard Deviation Z  
- *tBodyGyroMeanX: *Time Body Gyroscope Mean X  
- *tBodyGyroMeanY: *Time Body Gyroscope Mean Y  
- *tBodyGyroMeanZ: *Time Body Gyroscope Mean Z  
- *tBodyGyroStdX: *Time Body Gyroscope Standard Deviation X  
- *tBodyGyroStdY: *Time Body Gyroscope Standard Deviation Y  
- *tBodyGyroStdZ: *Time Body Gyroscope Standard Deviation Z  
- *tBodyGyroJerkMeanX: *Time Body Gyroscope Jerk Mean X  
- *tBodyGyroJerkMeanY: *Time Body Gyroscope Jerk Mean Y  
- *tBodyGyroJerkMeanZ: *Time Body Gyroscope Jerk Mean Z  
- *tBodyGyroJerkStdX: *Time Body Gyroscope Jerk Standard Deviation X  
- *tBodyGyroJerkStdY: *Time Body Gyroscope Jerk Standard Deviation Y  
- *tBodyGyroJerkStdZ: *Time Body Gyroscope Jerk Standard Deviation Z  
- *tBodyAccMagMean: *Time Body Accelerometer Magnitude Mean  
- *tBodyAccMagStd: *Time Body Accelerometer Magnitude Standard Deviation  
- *tGravityAccMagMean: *Time Gravity Accelerometer Magnitude Mean  
- *tGravityAccMagStd: *Time Gravity Accelerometer Magnitude Standard Deviation  
- *tBodyAccJerkMagMean: *Time Body Accelerometer Jerk Magnitude Mean  
- *tBodyAccJerkMagStd: *Time Body Accelerometer Jerk Magnitude Standard Deviation  
- *tBodyGyroMagMean: *Time Body Gyroscope Magnitude Mean  
- *tBodyGyroMagStd: *Time Body Gyroscope Magnitude Standard Deviation  
- *tBodyGyroJerkMagMean: *Time Body Gyroscope Jerk Magnitude Mean  
- *tBodyGyroJerkMagStd: *Time Body Gyroscope Jerk Magnitude Standard Deviation  
- *fBodyAccMeanX: *Frequency Body Accelerometer Mean X  
- *fBodyAccMeanY: *Frequency Body Accelerometer Mean Y  
- *fBodyAccMeanZ: *Frequency Body Accelerometer Mean Z  
- *fBodyAccStdX: *Frequency Body Accelerometer Standard Deviation X  
- *fBodyAccStdY: *Frequency Body Accelerometer Standard Deviation Y  
- *fBodyAccStdZ: *Frequency Body Accelerometer Standard Deviation Z  
- *fBodyAccJerkMeanX: *Frequency Body Accelerometer Jerk Mean X  
- *fBodyAccJerkMeanY: *Frequency Body Accelerometer Jerk Mean Y  
- *fBodyAccJerkMeanZ: *Frequency Body Accelerometer Jerk Mean Z  
- *fBodyAccJerkStdX: *Frequency Body Accelerometer Jerk Standard Deviation X  
- *fBodyAccJerkStdY: *Frequency Body Accelerometer Jerk Standard Deviation Y  
- *fBodyAccJerkStdZ: *Frequency Body Accelerometer Jerk Standard Deviation Z  
- *fBodyGyroMeanX: *Frequency Body Gyroscope Mean X  
- *fBodyGyroMeanY: *Frequency Body Gyroscope Mean Y  
- *fBodyGyroMeanZ: *Frequency Body Gyroscope Mean Z  
- *fBodyGyroStdX: *Frequency Body Gyroscope Standard Deviation X  
- *fBodyGyroStdY: *Frequency Body Gyroscope Standard Deviation Y  
- *fBodyGyroStdZ: *Frequency Body Gyroscope Standard Deviation Z  
- *fBodyAccMagMean: *Frequency Body Accelerometer Magnitude Mean  
- *fBodyAccMagStd: *Frequency Body Accelerometer Magnitude Standard Deviation  
- *fBodyBodyAccJerkMagMean: *Frequency Body Accelerometer Jerk Magnitude Mean  
- *fBodyBodyAccJerkMagStd: *Frequency Body Accelerometer Jerk Magnitude Standard Deviation  
- *fBodyBodyGyroMagMean: *Frequency Body Gyroscope Magnitude Mean  
- *fBodyBodyGyroMagStd: *Frequency Body Gyroscope Magnitude Standard Deviation  
- *fBodyBodyGyroJerkMagMean: *Frequency Body Gyroscope Jerk Magnitude Mean  
- *fBodyBodyGyroJerkMagStd: *Frequency Body Gyroscope Jerk Magnitude Standard Deviation  
