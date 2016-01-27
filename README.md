# tidydata
The Assignment for Coursera.org course for Getting and Cleaning Data

The script for run_analysis.r takes raw data downloaded from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Once downloaded, it was unzipped in R. From the new working directory of the unzipped folder,
all training and test data, labels, and subject identifiers wer downloaded and combined into
a single data frame.

Labels were added to columns using the featurs.txt file then modified to be more readable using
several gsub() command lines. Activity codes were also replaced by the activity names.

The script then selected only columns that measured the mean or standard deviation.

Using the 'dplyr' package, the remaining measurements were grouped by subject and activity to
create the output "tidydata.txt" to the working directory.

Codebook for "tidydata.txt"

subject: a numeric code for the subject performing the activities
activity: the description of the activity being measured
Columns 3:81 are the mean of all recorded data for that particular measurement as described in the heading
