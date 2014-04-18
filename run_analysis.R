#############################################################################
# The goal of the script is to tidy data from a Samsung phones so that it
# can be used for later analysis
#
# Author:  Kevin Scarr
# Date:    April 2014
# Version: 
#######################################

############################# ASSIGNMENT DETAILS ############################
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# [Forum clarrification] 4. Appropriately labels the data set with descriptive variable or feature (column) names
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#
# Original Data Source
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Publication Acknowledgements (Dataset)
#  [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
#
#######################################


############################# Configuration Section ##########################

## Configuration Settings (source and target/merge filenames)
basedir  <- paste(".","/","UCI HAR Dataset","/",sep="")
mergedir <- paste(basedir,"merged","/",sep="")

## Setup source and target filenames
filename_activity_labels <- paste(basedir,"activity_labels.txt",sep="")
filename_features <- paste(basedir,"features.txt",sep="")
##
filename_xtrain <- paste(basedir,"train/X_train.txt", sep="")
filename_xtest <- paste(basedir,"test/X_test.txt", sep="")
filename_ytrain <- paste(basedir,"train/y_train.txt", sep="")
filename_ytest <- paste(basedir,"test/y_test.txt", sep="")
filename_subtrain <- paste(basedir,"train/subject_train.txt", sep="")
filename_subtest <- paste(basedir,"test/subject_test.txt", sep="")
##
filename_finalmerge <- paste(mergedir,"merged.csv", sep="")
filename_tidydata   <-paste(mergedir,"tidydata.csv", sep="")
##

#######################################


############################# Procedural Section #############################

#### STEP 1 - Create merged version of X datasets and Y datasets into new directory mergedir

## Create new merged directory (ignore warning if exists already)
dir.create( mergedir ,showWarnings=FALSE)

## Merging test and train values
dfx <- rbind( read.table(filename_xtrain) , read.table(filename_xtest) )
dfy <- rbind( read.table(filename_ytrain) , read.table(filename_ytest) )
dfsub <- rbind( read.table(filename_subtrain) , read.table(filename_subtest) )

## Load the Features list, identify columns with "-mean()"  or "-std()"
features_list <- read.table(filename_features)
colnames(dfx) <- features_list[,2]
colnames(dfy) <- "Activity"
colnames(dfsub) <- "Subject"

# Define the Grep filter to match -mean() and -std() to locate matching columns to retain
column_filter <- grepl( "^(.)*-mean\\(\\)$|^(.)*-std\\(\\)$" , features_list[,2] )

# Short list of mean and std col names
column_filter_names <- features_list[,2][column_filter]

#### STEP 2 - Extract mean and std deviation measurements
## Apply column filter/column retentions to dataset
dfx <- dfx[ column_filter ]
myData <- cbind(dfx,dfy,dfsub)

#### STEP 3 - Uses descriptive activity names to name the activities in the data set
## Now merge in the Activity values
activity_labels <- read.table(filename_activity_labels)[,2]
myData[,19] <- activity_labels[myData[,19]]

#### STEP 4 - Appropriately labels the data set with descriptive variable or feature (column) names
# Already done earlier in script
myData <- subset(myData, select=c(20,19,1:18) )
write.csv(myData,filename_finalmerge)

#### STEP 5 - Independent tidy dataset,Avg each variable, each activity and each subject
## Target Structure - Column 1 to be Activity, Column 2 to be Subject, remaining columns are the variables
## that means a maximum rowcount of 180 = (6 x 30) = (activities * subjects)
myAgg <- aggregate(myData[,3:20], by=list(myData$Activity,myData$Subject), FUN=mean )
colnames(myAgg)[1] <- "Activity"
colnames(myAgg)[2] <- "Subject"
write.csv(myAgg,filename_tidydata,row.names=FALSE)

############################# End ############################################

