## run_analysis.R
library(sqldf)
library(reshape2)

# Function to load data sets.
load_dataset <- function(dataset_name, features_df, filtered_features_df) {
    VALID_DATASETS <- factor(c("train", "test"))
    if (!(dataset_name %in% VALID_DATASETS)) stop("invalid dataset name")
    
    dataset_dir <- paste("./UCI HAR Dataset/", dataset_name, sep="")
    subject_fname <- paste(dataset_dir, "/subject_", dataset_name, ".txt", sep="")
    activity_fname <- paste(dataset_dir, "/y_", dataset_name, ".txt", sep="")
    measures_fname <- paste(dataset_dir, "/x_", dataset_name, ".txt", sep="")
    
    # Load the data set.
    subject_df <- read.table(subject_fname, header=FALSE, col.names=c("subject_id"))
    activity_df <- read.table(activity_fname, header=FALSE, col.names=c("activity_id"))
    measures_df <- read.table(measures_fname, header=FALSE, col.names=features_df$feature)

    # Filter the data set for measures we're interested in only.
    measures_df <- measures_df[, filtered_features_df$feature_id]
    
    # Merge data set.
    measures_df <- cbind(subject_df, activity_df, measures_df)
    measures_df
}

# Load activities and features reference/lookup data.
activities_df <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                            header=FALSE, 
                            col.names=c("activity_id", "activity"))
features_df <- read.table("./UCI HAR Dataset/features.txt", 
                          header=FALSE, 
                          col.names=c("feature_id", "feature"))

# Filter list of features for mean and std measurements only.
# Note: Intentionally excluding following based on assumption they are not
# means, rather functions using a mean as input.
# 80        555          angle(tBodyAccMean,gravity)
# 81        556 angle(tBodyAccJerkMean),gravityMean)
# 82        557     angle(tBodyGyroMean,gravityMean)
# 83        558 angle(tBodyGyroJerkMean,gravityMean)
# 84        559                 angle(X,gravityMean)
# 85        560                 angle(Y,gravityMean)
# 86        561                 angle(Z,gravityMean)
filtered_features_df <- sqldf("select * from features_df where feature like '%-mean%' or feature like '%-std%'")

# Steps 1-2
# Load each data set and filter it, then merge.
train_df <- load_dataset("train", features_df, filtered_features_df)
test_df <- load_dataset("test", features_df, filtered_features_df)
all_observations_df <- rbind(train_df, test_df)
str(all_observations_df)

# Step 3
# Use descriptive names for activities.
all_observations_df <- merge(activities_df, all_observations_df, by.x="activity_id")
all_observations_df <- all_observations_df[, c(3, 2, 4:82)]

# Step 5
# Average each varaible for each activity and subject.
melt_df <- melt(all_observations_df, id=c("subject_id", "activity"))
summary_df <- dcast(melt_df, subject_id + activity ~ variable, mean)
write.table(summary_df, "summary-tidy-data-set.txt", row.name=FALSE)
