## This script achieves the following (not necessarily in this order):
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the 
##    mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

## Load necessary packages to complete following tasks     
library(data.table); library(dplyr)

## Load vectors with file locations
act <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt"
feat <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt"
tidyloc <- "./tidydata.txt" <- "./tidydata.txt"
tstsubloc <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt"
xtstloc <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt"
ytstloc <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt"
trnsubloc <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt"
xtrnloc <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt"
ytrnloc <- "./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt"

## Load the data from the files.
actdt <- tbl_df(read.table(act, header=FALSE, stringsAsFactors=FALSE))
featdt <- tbl_df(read.table(feat, header=FALSE, stringsAsFactors=FALSE))
trnsubdt <- tbl_df(read.table(trnsubloc, header=FALSE, stringsAsFactors=FALSE))
xtrndt <- tbl_df(read.table(xtrnloc, header=FALSE))
ytrndt <- tbl_df(read.table(ytrnloc, header=FALSE))
tstsubdt <- tbl_df(read.table(tstsubloc, header=FALSE, stringsAsFactors=FALSE))
xtstdt <- tbl_df(read.table(xtstloc, header=FALSE))
ytstdt <- tbl_df(read.table(ytstloc, header=FALSE))

## Merge Activity descriptions to codes.
ytrndt <- merge(ytrndt, actdt, by.x="V1" ,by.y="V1")
ytstdt <- merge(ytstdt, actdt, by.x="V1", by.y="V1")

## Create function() nameReplace.
nameReplace <- function(name = NULL){
     
     class_n <- class(name)
     
     if(nchar(name) <= 0 || class_n != "character"){                       ## Checking class & length
          stop("invalid name, expecting character class or length >= 1")   ## If not error
     }
     
     ## Find replace double text
     if (length(grep("BodyBody", name, value=FALSE)) == 1 ) {
          name <- sub("BodyBody", "Body", name)
     }
     
     ## Change "()" to ""
     if (length(grep("\\(\\)", name, value=FALSE)) == 1 ) {
          name <- sub("\\(\\)", "", name)
     }
     
     ## Change "-mean" to "Mean"
     if (length(grep("-mean", name, value=FALSE)) == 1 ) {
          name <- sub("-mean", "_mean", name)
     }
     
     ## Change "-std" to "Standard Deviation"
     if (length(grep("-std", name, value=FALSE)) == 1 ) {
          name <- sub("-std", "_std", name)
     }
     
     ## Change "-X" to "Axis-X"
     if (length(grep("-X", name, value=FALSE)) == 1 ) {
          name <- sub("-X", "_axis-X", name)
     }
     
     ## Change "-Y" to "Axis-Y"
     if (length(grep("-Y", name, value=FALSE)) == 1 ) {
          name <- sub("-Y", "_axis-Y", name)
     }
     
     ## Change "-Z" to "Axis-Z"
     if (length(grep("-Z", name, value=FALSE)) == 1 ) {
          name <- sub("-Z", "_axis-Z", name)
     }
     
     ## Change "-" to "_"
     if (length(grep("\\-", name, value=FALSE)) == 1 ) {
          name <- sub("\\-", "_", name)
     }
     
     return(name)
}

## Update the names in the features data.table to a friendlier read.
featdt <- mutate(featdt, V2=sapply(V2, nameReplace))

## Update the column names.
colnames(trnsubdt) <- "Subject_ID"
colnames(tstsubdt) <- "Subject_ID"
colnames(xtrndt) <- featdt$V2
colnames(xtstdt) <- featdt$V2

## Bind y/sub/x tables.
tstdt <- tbl_df(cbind(Activity_Name=ytstdt[,2], tstsubdt, xtstdt))
trndt <- tbl_df(cbind(Activity_Name=ytrndt[,2], trnsubdt, xtrndt))

## Bind final datasets, use dplyr group_by, dplyr summarise and write to table in two steps.
tdydt <- rbind(
     trndt[,names(select(tstdt, Activity_Name, Subject_ID, contains("_mean"), contains("_std"), -contains("Freq")))]
     ,tstdt[,names(select(tstdt, Activity_Name, Subject_ID, contains("_mean"), contains("_std"), -contains("Freq")))]
) 

tdydt_2 <- tdydt %>%
     select(Activity_Name, Subject_ID, contains("_mean"), contains("_std")) %>%
     group_by(Activity_Name, Subject_ID) %>%
     summarise_each(funs(mean))

write.table(tdydt_2, file=tidyloc, row.name=FALSE)			   

## How to read the tidydata.txt into R
tdydf <- data.frame(read.table(tidyloc, header = TRUE))
