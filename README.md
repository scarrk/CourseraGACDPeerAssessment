ReadMe for run_analysis project
========================================================

The "run_analysis.R" (referred to as 'the script') uses the Samsung accelerometer data from 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
based on the assignment from "Getting and Cleaning Data - April 2014" part of the Data Science track from John Hopkins University.

The script relies on the contents of the data zip files to be extracted to the working directory
e.g, there exists "UCI HAR Dataset" folder inside the working directory and beneath that exist the train and test sub-directories. The merged folder will be created by the script.

The script merges the test and training data sets along with the subjects (30 people) and
activities (6) to form a merged and tidied data-set.

This data-set is then filtered to contain only measurements whereby the measurement column
name ends with a "-mean()" or "-std()" using a dynamic mechanism.

This data-set is saved to a sub-directory called "merged" in a file called "merged.csv".

Finally the script, calculates the averages for each measurement type (from merged data set)
grouping together entries for each Activity and each Subject producing 180 rows by 20 columns.

**Publication Acknowledgement**
*[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*
