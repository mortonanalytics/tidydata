##download and unzip folder
library("downloader")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = ".")

##set working directory
setwd("./UCI HAR Dataset/")

##set column names for data
data.names <- read.table("features.txt")
headers <- data.names$V2

##create training data table, data gets column names from "headers" object
train.data <- read.table("./train/X_train.txt", col.names = headers)
train.labels <- read.table("./train/y_train.txt", col.names = "label")
train.subjects <- read.table("./train/subject_train.txt", col.names = "subject", colClasses = "factor")
train.data <- cbind(train.labels, train.data)
train.data <- cbind(train.subjects, train.data)

##creat test data table, data gets column names from "headers" object
test.data <- read.table("./test/X_test.txt", col.names = headers)
test.labels <- read.table("./test/y_test.txt", col.names = "label")
test.subjects <- read.table("./test/subject_test.txt", col.names = "subject", colClasses = "factor")
test.data <- cbind(test.labels, test.data)
test.data <- cbind(test.subjects, test.data)

##merge data sets into single data set
df <- rbind(train.data, test.data, make.row.names = FALSE)

##Select columns for only label, subject, mean, and standard deviation (std)
column.select <- colnames(df)
mydf <- df[ ,grep("label|subject|mean|std", x = column.select)]

##Add activity names using "labels" column and "activity_labels.txt"; 
##activity becomes the last column
label.names <- read.table("activity_labels.txt", col.names = c("label", "activity"))
library("plyr")
mydf <- join(mydf, label.names, by = "label")
mydf <- mydf[, -2]

##Modify variable names to more descriptive language and remove symbols
names(mydf) <- gsub("\\.", "", names(mydf))
names(mydf) <- gsub("^t", "time.", names(mydf))
names(mydf) <- gsub("^f", "freq.", names(mydf))
names(mydf) <- gsub("Acc", "Accelerometer.", names(mydf))
names(mydf) <- gsub("Gyro", "Gyroscope.", names(mydf))
names(mydf) <- gsub("mean", "Mean.", names(mydf))
names(mydf) <- gsub("Mag", "Magnitude.", names(mydf))
names(mydf) <- gsub("std", "StandardDeviation.", names(mydf))

##Create new data set for an average for each subject-activity pair on all 
##remaining variables
library("dplyr")
tidy.df <- mydf %>%
     group_by(subject, activity) %>%
     summarise_each(funs(mean))

##Write text file to the working directory
write.table(tidy.df, "tidydata.txt", row.names = FALSE)
