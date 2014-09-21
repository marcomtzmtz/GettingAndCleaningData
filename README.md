GettingAndCleaningData
======================

This is the GitHub repo for the Getting And Cleaning Data Course Project

# These are the steps to conclude the activity for this Course

## Step 1. I merged the training and the test sets to create one data set (step 1).
###These are the commands:

training_set <- read.table("train/X_train.txt")

test_set <- read.table("test/X_test.txt")

step_1 <- rbind(training_set, test_set)

This step formed a data frame with 10,299 observations and 561 variables.
But this data frame has no names. The names of this data set was in the features.txt; the next commands include the names of the previous data set

features <- read.table("features.txt")

names(step_1) <- features[,2]

## Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.
Because of the “features info.txt” says that mean() and std() are the mean and standard deviation measurements I only extracted these values despite there are other variables with the mean value like meanFreq.
### Looking for "mean" and "std" values

mean_names <- grep("mean\\(\\)", tolower(names(step_1)))

std_names <- grep("std\\(\\)", tolower(names(step_1)))

mean_std <- c(mean_names, std_names)

This vector (mean_std) gives the number of the columns with mean() or std() included in their names, so
### To extract the data base for step 2, only with variables that include mean and std

step_2 <- step_1[, sort(mean_std)]

The step_2 data frame is a data frame with 10,299 observations and 66 variables

## 3. Uses descriptive activity names to name the activities in the data set
### I included to this data set (step_2) the subject and activity, because the train and test set were joined previously I had to join the subject (_train and _test) and the activity (_train and _test) before to bind with the step_2 data frame. 

subject_train <- read.table("train/subject_train.txt")

subject_test <- read.table("test/subject_test.txt")

activity_train <- read.table("train/y_train.txt")

activity_test <- read.table("test/y_test.txt")

subject <- rbind(subject_train, subject_test)

activity <- rbind(activity_train, activity_test)

step_2_complete <- cbind(step_2, subject, activity)

This step_2_complete data frame has 10,299 observations and 68 variables because includes the variables subject and activity

### I am going to put the names to the variables included (Are the variables 67 and 68)

names(step_2_complete)[67:68] <- c("Subject", "Activity")

The main activity in this step is the use of descriptive activity names. The activity variable that I included has the numbers one to six. The activity labels for this 1-6 numbers are in the activity_labels.txt

code_labels <- read.table("activity_labels.txt")
View(code_labels)

These are the values


1	WALKING

2	WALKING_UPSTAIRS

3	WALKING_DOWNSTAIRS

4	SITTING

5	STANDING

6	LAYING

### I am going to recode according the activity_labels

recode <- c(WALKING=1, WALKING_UPSTAIRS=2, WALKING_DOWNSTAIRS= 3, SITTING= 4, STANDING= 5, LAYING= 6)

step_2_complete$Activity <- factor(step_2_complete$Activity, levels= recode, labels= names(recode))

step_3 <- step_2_complete

### The step_3 data frame has the 10,299 observations and 68 variables with the activity labels included.

## Appropriately labels the data set with descriptive variable names. 
### Cleanining the names of the variables that were included in the first step, I only deleted the “-“ and the “()” because if I included more descriptions, the names will be large. I did not change the capital letters because I think that this help to distinguish the variable names.

names(step_3) <- gsub("-", " ", names(step_3))

names(step_3) <- gsub("\\(\\)", "", names(step_3))

step_4 <- step_3

### The step_4 data frame has 10,299 observations and 68 variables with “clean” names or appropriate labels.

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. These are the codes

library(plyr)

step_5 <- ddply(step_4, .(Activity, Subject), numcolwise(mean))

write.table(step_5, "step_5.txt", row.name=FALSE)

###I saved the step_5.txt file that include the mean of each variable for each activity and each subject (it has 180 observations and 68 variables).