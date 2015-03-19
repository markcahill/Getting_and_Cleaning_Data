## Create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


library(reshape2)
library(plyr)

root.dir <- "UCI HAR Dataset"
data.set <- list()

# 1. Merges the training and the test sets to create one data set called data.set.
message("loading features.txt into data.set$features")
data.set$features <- read.table(paste(root.dir, "features.txt", sep="/"), col.names=c('id', 'name'), stringsAsFactors=FALSE)

# View(data.set$features)  

message("loading activity_features.txt into data.set$activity_labels")
data.set$activity_labels <- read.table(paste(root.dir, "activity_labels.txt", sep="/"), col.names=c('id', 'Activity'))

# View(data.set$activity_labels)  

message("loading subject_test.txt into data.set$subject_test ")
data.set$subject_test <- cbind(subject=read.table(paste(root.dir, "test", "subject_test.txt", sep="/"), col.names="Subject"),
                       y=read.table(paste(root.dir, "test", "y_test.txt", sep="/"), col.names="Activity.ID"),
                       x=read.table(paste(root.dir, "test", "x_test.txt", sep="/")))

# View(data.set$subject_test)  


message("loading train set into data.set$train_set")
data.set$train_set <- cbind(subject=read.table(paste(root.dir, "train", "subject_train.txt", sep="/"), col.names="Subject"),
                        y=read.table(paste(root.dir, "train", "y_train.txt", sep="/"), col.names="Activity.ID"),
                        x=read.table(paste(root.dir, "train", "X_train.txt", sep="/")))
# View(data.set$train_set) 

# Rename columns in data.set
rename.features <- function(col) {
    col <- gsub("tBody", "Time.Body", col)
    col <- gsub("tGravity", "Time.Gravity", col)

    col <- gsub("fBody", "FFT.Body", col)
    col <- gsub("fGravity", "FFT.Gravity", col)

    col <- gsub("\\-mean\\(\\)\\-", ".Mean.", col)
    col <- gsub("\\-std\\(\\)\\-", ".Std.", col)

    col <- gsub("\\-mean\\(\\)", ".Mean", col)
    col <- gsub("\\-std\\(\\)", ".Std", col)

    return(col)
}

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
tidy <- rbind(data.set$subject_test, data.set$train_set)[,c(1, 2, grep("mean\\(|std\\(", data.set$features$name) + 2)]
# View(tidy)

# 3. Uses descriptive activity names to name the activities in the data set
names(tidy) <- c("Subject", "Activity.ID", rename.features(data.set$features$name[grep("mean\\(|std\\(", data.set$features$name)]))
# View(tidy)

# 4. Appropriately labels the data set with descriptive variable names. 
tidy <- merge(tidy, data.set$activity_labels, by.x="Activity.ID", by.y="id")
tidy <- tidy[,!(names(tidy) %in% c("Activity.ID"))]
# View(tidy)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy.mean <- ddply(melt(tidy, id.vars=c("Subject", "Activity")), .(Subject, Activity), summarise, MeanSamples=mean(value))
View(tidy.mean)

message("Write tidy.mean into tidy_mean.txt")
write.csv(tidy.mean, file = "tidy_mean.txt",row.names = FALSE)

message("Write tidy to tidy.txt")
write.csv(tidy, file = "tidy.txt",row.names = FALSE)
