# This code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md

## Lines 9-10
Load reshape2 and plyr libraries

## Lines 12-38
Merges the training and the test sets to create one data set called data.set from features.txt, activity_labels.txt, subject_test.txt and subject_train.txt

## Lines 40-55 
Rename columns in data.set

## Lines 57-59 
Extracts only the measurements on the mean and standard deviation for each measurement. 


## Lines 61-63 
Uses descriptive activity names to name the activities in the data set

## Lines 65-68 
Appropriately labels the data set with descriptive variable names. 


## Lines 70-72 
From the data set in previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Lines 74-75 
Write tidy.mean into tidy_mean.txt

## Lines 77-78 
Write tidy to tidy.txt