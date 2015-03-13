library(dplyr)
# Set up the work directory where the data is stored

setwd("E:/Coursera/Getting and cleaning data/CourseProject/UCI HAR Dataset/")

############## PART I: Read data sets and check their structures ####################
# The dataset includes the following files:
#         =========================================
#         
#         - 'README.txt'
# 
# - 'features_info.txt': Shows information about the variables used on the feature vector.
# 
# - 'features.txt': List of all features.
# 
# - 'activity_labels.txt': Links the class labels with their activity name.
# 
# - 'train/X_train.txt': Training set.
# 
# - 'train/y_train.txt': Training labels.
#
# - 'train/subjects_train.txt': Training subjects.
# 
# - 'test/X_test.txt': Test set.
# 
# - 'test/y_test.txt': Test labels.
#
# - 'test/subject_test.txt': Test subjects.

#Check features.txt 
features <- read.table("./features.txt")
dim_features <- dim(features)

#Check activity_labels.txt
activity_labels <- read.table("./activity_labels.txt")
dim_activity_labels <- dim(activity_labels)

#Check training set: train/X_train.txt
X_train <- read.table("./train/X_train.txt")
dim_X_train <- dim(X_train)

#Check training labels: train/y_train.txt
y_train <- read.table("./train/y_train.txt")
dim_y_train <- dim(y_train)

#Check test set: test/X_test.txt
X_test <- read.table("./test/X_test.txt")
dim_X_test <- dim(X_test)

#Check test labels: test/y_test.txt
y_test <- read.table("./test/y_test.txt")
dim_y_test <- dim(y_test)

#Check train/subject_train.txt
subject_train <- read.table("./train/subject_train.txt")
dim_subject_train <- dim(subject_train)

#Check test/subject_test.txt
subject_test <- read.table("./test/subject_test.txt")
dim_subject_test <- dim(subject_test)

# By taking a look at the subject_train/subject_test data, you
# found they have the same dimensions as the y_train/y_test respectively.
# Each distingct number in the subject data represents the id of the 
# subject(person) who took the measurements of all 6 activities. 
# The id ranges from 1 to 30 (subjects 1 to 30). The training set and test 
# set were randomly selected from the measurement data of these participents.
# Accordingly, id of participants were divided into training and test group.
# Therefore, you may find id 1 and 3 in subjects_train file and id 2 and 24 
# in subjects_test file.


# The complete structure of both train and test data should be: 
# 1st col: subject ID, 2nd col: Activity Label, 3rd-end col: Measurement Features

########### PART II: Merge training and test sets to one dataset #################
#####################               AND                          #################
############ labels the data set with descriptive variable names #################

data_train <- cbind(subject_train, y_train, X_train)
data_test <- cbind(subject_test, y_test, X_test)

#name the cols (feature cols named by using the test labels in features file)
ColNames <- c("Subject_ID", "Activity", as.character(features[ ,2]))
colnames(data_train) <- ColNames
colnames(data_test) <- ColNames

#Merge the training and testing sets
data_comb <- rbind(data_train, data_test)


############# PART III: Extracts only the measurements on ########################
############   the mean and standard deviation for each measurement ##############

#Find the meaturement feature on the mean and standard deviation
#In other words, find colnames containing "mean()" or "std()"

feature_meanIndex <- grep("mean()", as.character(features[ ,2]))
feature_stdIndex <- grep("std()", as.character(features[ ,2]))

#As in data_comb, feature names are from 3rd to the end cols
feature_meanIndex <- feature_meanIndex + 2
feature_stdIndex <- feature_stdIndex + 2

#Extract only these measurements
data_extract <- data_comb[ , c(1, 2, feature_meanIndex, feature_stdIndex)]

#Convert class of measurements into numeric
data_extract[ ,3:dim(data_extract)[2]] <- sapply(data_extract[ ,3:dim(data_extract)[2]],
                                                 function(x) x=as.numeric(x))

############# PART IV: Rename activity labels to descriptive names ###############
################## by using activity_labels file #################################

descript <- as.character(activity_labels[ ,2])
data_extract$Activity <- sapply(data_extract$Activity, function(x) x=descript[as.integer(x)])



############# PART V: Creates an independent tidy data set with the average ##########
################ of each variable for each activity and each subject #################

# Group data_extract by subject and activity (from now on, I used dplyr package)

# Transfer the data frame to data table used in dplyr
data <- tbl_df(data_extract)

# Group by Subject_ID and Activity
data_group <-group_by(data, Subject_ID, Activity)

# Find measurement feature names
feature_name <- colnames(data_group)[3:dim(data_group)[2]]

# Get summary of the mean of each measurement for each activity and each subject
data_tidy <- summarise_each(data_group, funs(mean))

data_tidy <- as.data.frame(data_tidy)

# Write into a txt file and save to the working dir
write.table(data_tidy, file = "./data_tidy.txt")