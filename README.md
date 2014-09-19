---
title: "Getting and Cleaning Data - Course Project"
author: "walterpera@grandecom.net"
date: "Friday, September 19, 2014"
---

#####Discussion

This readme file provides the necessary information for obtaining the necessary files and walking through the steps to replicate the process used to create the output file required for the Getting and Cleaning Data Course Project.

The goal of this project is to take the data sourced at the [UC Irvine Machine Learning Repository](http://archive.ics.uci.edu/ml/index.html) and meet the following requirements:

1. Merge the Training and Test data sets.
2. Subset the data to only measurements with a Mean() or Standard Deviation() applied to them.
3. Use the activity labels file to name the activities in the data set.
4. Appropriately label the data set variables with descriptive names.
5. Create a tidy data output with the average for each of the subset variables.

Per discussion in this [forum thread](https://class.coursera.org/getdata-007/forum/thread?thread_id=49#comment-570) (must be logged into Coursera to view...) and looking at David Hood's diagram you can see that there are several files that need to be manipulated to get to the final result set. 

![](https://coursera-forum-screenshots.s3.amazonaws.com/ab/a2776024af11e4a69d5576f8bc8459/Slide2.png "Data set relationship")

This will be acheived by following the process outlined below.

#####Assumptions/Expectations
It is assumed that the following critera will be met:

* All necessary cran packages will be installed prior to running the process.
* The data set will be downloaded and unzipped into the working directory that will be used for evaluation of the project.
* Unzipped folder/'s will not be renamed; as this will cause the run_analysis.R to fail.
* The run_analysis.R will be "source()"-ed from within the same working directory that contains the unzipped data folder.

#####Included Files
The following files can be found within the github repository.

1. Readme.md
2. Codebook.md
3. run_analysis.R

#####Process
The following cran packages will be required beyond the basic install of R.

1. data.table version 1.9.2
2. dplyr version 0.2

#####Process

Starting with obtaining the data which can be downloaded from the following location: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. Unzip the data into the R's working directory along with the run_analysis.R file. 

Within R source the run_analysis.R script file.  This will start the script that will do the following: 

Note: it needs to be understood that while all the steps were acheived there were not followed in the same order outlined.  This was done to reduce the level of effort needed to achieve the outcome.

1. Merge the Training and Test data sets.
     a. Merge the activity labels to the y_test/y_train data.
     b. Create a function to update the variable names from the features.txt to a cleaner look.
          - Remove duplicate words.
          - Remove "()".
          - Replace "-" with "_".
          - Descriptor for the XYZ axis.


2. Use the activity labels file to name the activities in the data set.
     a. Add variable names to the subject and activity data.


3. Appropriately label the data set variables with descriptive names.
     a. Add variable names to the x_test/x_train data using the features data.


4. Subset the data to only measurements with a Mean() or Standard Deviation() applied to them.
     a. Upon review of the features_info.txt and the section "The set of variables..." it was determined that only the variable names with mean() or std() in them met the requirements to be subsetted. For example if we look at other variables containing the word mean:
          - meanFreq(): A weighted average of the frequency components. So not a true mean.
          - angle(): The angle between to vectors. While this uses a mean variable it is not a true mean either.
     b. Subset the data based on variable names with "_mean" or "_std" and not "Freq"


5. Create a tidy data output with the average for each of the subset variables.
     a. Using the subset data from the previous step create tidy dataset that stores the mean for each variable grouped by each activity and subject.
     b. Output this tidy data set for evaluation and consumption.

#####Reading output file

Should the output file need to be read into R the following R code will read it in. It is assumed that the the tidy file has been placed into the working directory of R.

```{r}
tdydf <- data.frame(read.table("./tidydata.txt", header = TRUE))
```


 
                                      
