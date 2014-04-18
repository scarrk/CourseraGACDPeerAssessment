CodeBook for run_analysis.R
========================================================

Overview
--------

This document describes the data-set labelled "merged/tidydata.csv" which is produced by the "run_analysis.R" script. It uses measurements from 30 volunteers within an age bracket of 19-48 years, with each person performing one of six activities wearing a smartphone on their waist.

Publication Acknowledgements to the below as this is the source raw dataset.
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

*[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*


Variables
---------
The format of the "merged/tidydata.csv" file is that variables suffixed with -mean() represent a Mean value and -std() represents a Standard deviation for the measurement type observed, the column ordering is as follows, and contains this information as a header row in the file:-

1. Activity - One of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
2. Subject - Range from 1 to 30 representing an individual
3. tBodyAccMag-mean()
4. tBodyAccMag-std()
5. tGravityAccMag-mean()
6. tGravityAccMag-std()
7. tBodyAccJerkMag-mean()
8. tBodyAccJerkMag-std()
9. tBodyGyroMag-mean()
10. tBodyGyroMag-std()
11. tBodyGyroJerkMag-mean()
12. tBodyGyroJerkMag-std()
13. fBodyAccMag-mean()
14. fBodyAccMag-std()
15. fBodyBodyAccJerkMag-mean()
16. fBodyBodyAccJerkMag-std()
17. fBodyBodyGyroMag-mean()
18. fBodyBodyGyroMag-std()
19. fBodyBodyGyroJerkMag-mean()
20. fBodyBodyGyroJerkMag-std()


Pre-conditions
--------------
* Zip file (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) extracted to working directory (e.g, the "./UCI HAR Dataset/" exists in your current directory)
* run_analysis.R


Transformations
---------------

The script sets the directory and filenames to be used, if the target "merged" directory doesn't exist it is created (see script for all filename variables created).

```{r}
basedir  <- paste(".","/","UCI HAR Dataset","/",sep="")
mergedir <- paste(basedir,"merged","/",sep="")
```

The test and train values are loaded and merged, but are not all joined yet, where dfx represents
the x value files, dfy the mrged y value files and dfsub the merged subject identifiers.
```{r}
dfx <- rbind( read.table(filename_xtrain) , read.table(filename_xtest) )
dfy <- rbind( read.table(filename_ytrain) , read.table(filename_ytest) )
dfsub <- rbind( read.table(filename_subtrain) , read.table(filename_subtest) )
```

The features list (measurements labels) are loaded from a reference file and is used to identify
which columns to retain in the data-set based on their name ending with "-mean()" or "-std()". This is achieved using a regular expression and builds a list of boolean
values which will be used to narrow the columns of the data-frame (dfx).
It then merges the test+train; x (measurements), y (activitity) and subject (person id) values

```{r}
column_filter <- grepl( "^(.)*-mean\\(\\)$|^(.)*-std\\(\\)$" , features_list[,2] )
column_filter_names <- features_list[,2][column_filter]
dfx <- dfx[ column_filter ]
myData <- cbind(dfx,dfy,dfsub)
```

Descriptive labels are then applied to the data-set, and columns are re-organised and the activity numerical values are swapped for string literals and then saved as "merged/merged.csv".
```{r}
activity_labels <- read.table(filename_activity_labels)[,2]
myData[,19] <- activity_labels[myData[,19]] # Resolve lookup of ID to TextualMeaning
myData <- subset(myData, select=c(20,19,1:18) )
write.csv(myData,filename_finalmerge)
```

Finally the data is aggregated, using the "Activity" and "Subject" and calculating a mean average
for all measurements identified in the previous steps.
Thus it has a total number of rows of 6 * 30 (activities * subjects) and with 18 measurement columns and 2 additional columns holding the Activity and Subject values (column 1 & 2 respectively).

```{r}
myAgg <- aggregate(myData[,3:20], by=list(myData$Activity,myData$Subject), FUN=mean )
colnames(myAgg)[1] <- "Activity"
colnames(myAgg)[2] <- "Subject"
write.csv(myAgg,filename_tidydata,row.names=FALSE)
```

The script saves the aggregate data into a file called "merged/tidydata.csv".

