#Peer-graded Assignment: Getting and Cleaning Data Course Project

#dowloads and unpacks assignment data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "getdata_projectfiles_UCI HAR Dataset.zip")
unzip("getdata_projectfiles_UCI HAR Dataset.zip") 

#loads data sets
dataTest <- read.table("UCI HAR Dataset\\test\\X_test.txt")
dataTestActivity <- read.table("UCI HAR Dataset\\test\\y_test.txt")
dataTestSubject <- read.table("UCI HAR Dataset\\test\\subject_test.txt")

dataTrain <- read.table("UCI HAR Dataset\\train\\X_train.txt")
dataTrainActivity <- read.table("UCI HAR Dataset\\train\\y_train.txt")
dataTrainSubject <- read.table("UCI HAR Dataset\\train\\subject_train.txt")

#loads and vectorizes features
features <- read.table("UCI HAR Dataset\\features.txt")
features <- features[,"V2"]
features <- as.character(features)
#loads and vectorizes activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels <- activityLabels[,"V2"]
activityLabels <- as.character(activityLabels)

#1. Merges the training and the test sets to create one data set.
names(dataTest) <- features
names(dataTrain) <- features

testData <- cbind(dataTestActivity, dataTestSubject, dataTest)
trainData <- cbind(dataTrainActivity, dataTrainSubject, dataTrain)

data <- rbind(testData, trainData)
names(data)[1] <- "Activity"
names(data)[2] <- "Subject"

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
fMean <- features[grepl("ean", features, fixed=TRUE)]
fStd <- features[grepl("std", features, fixed=TRUE)]
data <- data[,c("Activity", "Subject", fMean, fStd)]

#3. Uses descriptive activity names to name the activities in the data set
for(i in 1:length(activityLabels)){
    data$Activity[data$Activity == i] <- activityLabels[i]
}

#4. Appropriately labels the data set with descriptive variable names.
# See step 1:
# names(dataTest) <- features
# names(dataTrain) <- features
# names(data)[1] <- "Activity"
# names(data)[2] <- "Subject"

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData <- aggregate(. ~ Activity + Subject, data, mean)
write.table(tidyData, "tidyData.txt", row.name=FALSE)


