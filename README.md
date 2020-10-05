---
title: "README"
author: "Serge Olivier Kotchi"
date: "05/10/2020"
output: html_document
---

## About the Project:
The purpose of the project is to collect, work with, and clean up a data set in order to prepare a tidy data set that can be used for later analysis. The original data sets are from a website contains data collected from the accelerometers from the Samsung Galaxy S smartphone. They are available at:  
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

## File descriptions
The deliverables of the project consist of the following files:  

**README.md**  
Information regarding the project and each file.  

**CodeBook.md**  
Describes the variables, the data, and any transformations or work that was performed to clean up the data and to create a tidy dataset.  

**run_analysis.R**  
Contains all of the code for loading, merging, and transforming the data. It's used to generate the tidy dataset tidy_data_set.txt  

**tidy_data_set.txt**  
The tidy dataset that is the output of the run_analysis.R script. It's consisted of the average of each variable for each activity and each subject.  
