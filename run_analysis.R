##Load packages
library("reshape2")

##Load the data
setwd("C:/Users/aggel/OneDrive/Documents/Coursera/Project3")

download.file(
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
  "~/Coursera/Project3/data.zip"
  )
unzip("data.zip")

xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Name the variables
names(subjecttest) <- "ID"
names(subjecttrain) <- "ID"

features <- read.table("./UCI HAR Dataset/features.txt")
names(xtest) <- features$V2
names(xtrain) <- features$V2

names(ytest) <- "activity"
names(ytrain) <- "activity"

##TASK 1: Merge the datasets
test <- cbind(subjecttest, ytest, xtest)
train <- cbind(subjecttrain, ytrain, xtrain)
data <- rbind(train,test)

##TASK 2: Extract the mean and standard deviation for each measurement
meanstdcols <- grepl("mean\\(\\)", names(data)) |
  grepl("std\\(\\)", names(data))
meanstdcols[1:2] <- TRUE
data <- data[, meanstdcols]

##Task 3 and 4: Label the activities
labels<- read.table("./UCI HAR Dataset/activity_labels.txt")
data$activity <- factor(data$activity,
                    levels = c(1,2,3,4,5,6),
                    labels = labels$V2
)

##Task 5: Create a tidy dataset
dataclean <- melt(data, id=c("ID","activity"))
tidydata <- dcast(dataclean, ID+activity ~ variable, mean)

##Export the file
write.table(tidydata, "tidydata.txt", row.name=FALSE)