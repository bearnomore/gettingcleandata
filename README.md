
## This is an explanation for the script of run_analysis.R that prepare tidy data from "Human Activity Recognition Using Smartphones Dataset"

### The original dataset include two general info files 

    1. 'README.txt' 

    2. 'feature_info.txt' 

### Two data info files:

    1. 'features.txt': List of all features.
 
    2. 'activity_labels.txt': Links the class labels with their activity name.

### Three data files for training set and test set

    1. 'X_train/test.txt': train or test data

    2. 'y_train/test.txt': train or test labels 

    3. 'subjects_train/test.txt': train or test subject ids
###============================================================
### The script has five parts to create an independant tidy data

    PART I: Read data sets and check their structures

        #### You have an idea of how the entire data looks like.

    PART II: Merge training and test sets to one dataset and labels the data set with descriptive variable names
         
        #### You have one dataset that combine all data sets from the original resource

    PART III: Extracts only the measurements on the mean and standard deviation for each measurement

        #### From the combined dataset, you have a subset that includes only the "mean" and "std" measurements as                      
        #### measurement features.

