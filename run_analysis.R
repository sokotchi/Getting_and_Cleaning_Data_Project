## The objective of this script is to prepare tidy data that can be used 
## for later analysis by collecting, working with, and cleaning a data sets 
## obtain from a website contains data collected from the accelerometers from 
## the Samsung Galaxy S smartphone.

## A full description of the data sets is available at the website:
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## The data sets are available at:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## The script accomplishes the following tasks to reach its objective:
## 1. Downloads and read the data sets.
## 2. Merges the training and the test sets to create one data set.
## 3. Extracts only the measurements on the mean and standard deviation 
##    for each measurement.
## 4. Uses descriptive activity names to name the activities in the data set
## 5. Appropriately labels the data set with descriptive variable names.
## 6. From the data set in step 5, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

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
