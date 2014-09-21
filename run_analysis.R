## Change the directory
setwd("/Users/marcomtzmtz/Documents/SkyDrive/Coursera/Specialization/Getting/assignment/UCI HAR Dataset")
# List the files to know the names
list.files()
## Step 1. Merges the training and the test sets to create one data set.
training_set <- read.table("train/X_train.txt")
test_set <- read.table("test/X_test.txt")
step_1 <- rbind(training_set, test_set)

### The step_1 data set is both data sets but with no variable names that I am going to include
features <- read.table("features.txt")
names(step_1) <- features[,2]

## Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.

### Looking for "mean" and "std" values
mean_names <- grep("mean\\(\\)", tolower(names(step_1)))
std_names <- grep("std\\(\\)", tolower(names(step_1)))
mean_std <- c(mean_names, std_names)

### I am going to extract the data base for step 2, only with variables that include mean and std
step_2 <- step_1[, sort(mean_std)]

### I am going to include to this data set the subject and activity
subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")
activity_train <- read.table("train/y_train.txt")
activity_test <- read.table("test/y_test.txt")
subject <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
step_2_complete <- cbind(step_2, subject, activity)

### I am going to put the names to the variables included
names(step_2_complete) ## Are the variables 67 and 68
names(step_2_complete)[67:68] <- c("Subject", "Activity")

## Step 3. Uses descriptive activity names to name the activities in the data set
code_labels <- read.table("activity_labels.txt")
View(code_labels)
### I am going to recode according the activity_labels
recode <- c(WALKING=1, WALKING_UPSTAIRS=2, WALKING_DOWNSTAIRS= 3, SITTING= 4, STANDING= 5, LAYING= 6)
step_2_complete$Activity <- factor(step_2_complete$Activity, levels= recode, labels= names(recode))
step_3 <- step_2_complete
## Step 4. Appropriately labels the data set with descriptive variable names. 
### Cleanining the names of the variables that were included in the first step
names(step_3) <- gsub("-", " ", names(step_3))
names(step_3) <- gsub("\\(\\)", "", names(step_3))
step_4 <- step_3

## Step 5
### First I charged dplyr and plyr packages
library(plyr)
step_5 <- ddply(step_4, .(Activity, Subject), numcolwise(mean))
write.table(step_5, "step_5.txt", row.name=FALSE)


