## Housekeeping
setwd("C:/Users/Brad/Documents/R/Coursera/UCI HAR Dataset/")

## Gather the data
features <- read.table("features.txt", header=FALSE, colClasses="character")
activity_labels <- read.table("./activity_labels.txt", header=FALSE, colClasses="character")[,2]

X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/y_test.txt")
Sub_test <- read.table("./test/subject_test.txt")

X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/y_train.txt")
Sub_train <- read.table("./train/subject_train.txt")

##Add activity labels
Y_test[,2] = activity_labels[Y_test[,1]]
names(Y_test) = c("Activity_ID", "Activity_Label")

Y_train[,2] = activity_labels[Y_train[,1]]
names(Y_train) = c("Activity_ID", "Activity_Label")

## Combine the data
All_test <- cbind(X_test, Y_test, Sub_test)
All_train <- cbind(X_train, Y_train, Sub_train)
All_data <- rbind(All_test, All_train)

## Add descriptive variable names
colnames(All_data) <- c(features$V2, "ActivityID", "Activity", "Subject")
All_data <- subset(All_data, select = -c(ActivityID))

## Extract only mean and std measurements
Cols_needed <- grepl("mean|std", features$V2)
Needed_data <- All_data[,Cols_needed]

## Make data set with average of each variable
Tidy <- group_by(Needed_data, Subject, Activity) %>%
        summarise_each(funs(mean), matches("()"))

## Save the data set
write.table(Tidy, file = "final.txt",  row.name=FALSE)
