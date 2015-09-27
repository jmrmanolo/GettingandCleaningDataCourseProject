## Load the needed library
library(plyr)

# Read the data sets

a_train <- read.table("train/x_train.txt")
b_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

a_test <- read.table("test/x_test.txt")
b_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# Megre them
a_data <- rbind(a_train, a_test)
b_data <- rbind(b_train, b_test)
subject_data <- rbind(subject_train, subject_test)

# Extract the measurements on the mean and standard deviation for each measurement

features <- read.table("features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

a_data <- a_data[, mean_and_std_features]

names(a_data) <- features[mean_and_std_features, 2]

# Use activity names to name the activities 
activities <- read.table("activity_labels.txt")

b_data[, 1] <- activities[b_data[, 1], 2]

names(b_data) <- "activity"

# Label the data set with descriptive variable names

names(subject_data) <- "subject"

all_data <- cbind(a_data, b_data, subject_data)

# Create a independent tidy data set with the average 

averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

#write a txt file
write.table(averages_data, "averages.txt", row.name=FALSE)
