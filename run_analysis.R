# Robert Michaelis 
# Getting and Cleaning Data 
# Johns Hopkins Coursera 


setwd("~/Personal/Datasets/UCI HAR Dataset/train") 
# Set working directory to local train folder

train_x <- read.table("X_train.txt")
train_y <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")
# Read in data sets from training folder into separate tables

setwd("~/Personal/Datasets/UCI HAR Dataset/test")
# Set working directory to local test folder
test_x <- read.table("X_test.txt")
test_y <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")
# Read in data sets from test folder into separate tables

setwd("~/Personal/Datasets/UCI HAR Dataset")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
# Swtich working directories and read in the features plus activity labels

colnames(train_x) <- features[,2] 
colnames(train_y) <-"activityId"
colnames(subject_train) <- "subjectId"
# Adding Column names to train data

colnames(test_x) <- features[,2] 
colnames(test_y) <- "activityId"
colnames(subject_test) <- "subjectId"
# Adding Column names to test data

colnames(activity_labels) <- c('activityId','activityType')
# Adding Column names to activity levels

train_merge <- cbind(train_x, subject_train, train_y)
test_merge <- cbind(test_x, subject_test, test_y)
full_merge <- rbind(train_merge, test_merge)
# Merge all train and test data 

col_names <- colnames(full_merge)
# Read the column names

mean_std <- (grepl("activityId" , col_names) | 
                   grepl("subjectId" , col_names) | 
                   grepl("mean.." , col_names) | 
                   grepl("std.." , col_names) 
)
# Using grepl function to define a vector capturing ID, mean, and standard deviation

setForMean_Std <- full_merge[ , mean_std == TRUE]
# Create the subset data from the merged training plus test

setWithActivity_names <- merge(setForMean_Std, activity_labels,
                              by='activityId',
                              all.x=TRUE)
# Add activity names to the data set

tidyData <- aggregate(. ~subjectId + activityId, setWithActivity_names, mean)
tidyData <- tidyData[order(tidyData$subjectId, tidyData$activityId),]
# Create final tidy data set with averages for each variable and activity for each subject

write.table(tidyData, "tidyData.txt", row.name=FALSE)
# Generate the result in a text file

