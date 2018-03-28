#run_analysis <- function()
#{
#	return 0
#}

build_dataset <- function()
{
	# convert data in y_train and y_test text files into activity labels
	# merge data into one column defined as activity_column
	train_activity_column <- get_activity_column("train")
	test_activity_column  <- get_activity_column("test")
	activity_column <- combine(train_activity_column, test_activity_column)
	
	features <- get_features_and_indices()
	
	train_data <- get_train_and_test_data("train", as.integer(features[2, ]))
	test_data  <- get_train_and_test_data("test", as.integer(features[2, ]))
	combined_data <- rbind(train_data, test_data)
	colnames(combined_data) <- c(features[1, ])
	
	library(dplyr)
	tidy_data <- tbl_df(combined_data)
	tidy_data <- mutate(tidy_data, activityLabels = activity_column)
}

get_activity_column <- function(typeof_data)
{
	if (typeof_data == "train")
	{
		file_name <- "./train/y_train.txt"
	}
	else
	{
		file_name <- "./test/y_test.txt"
	}
	
	raw_data <- read.table(file_name)
	raw_data <- as.character(unlist(raw_data))
	
	for (i in 1:length (raw_data))
	{
		if (raw_data[i] == "1")
		{
			raw_data[i] <- "WALKING"
		}
		else if (raw_data[i] == "2")
		{
			raw_data[i] <- "WALKING_UPSTAIRS"
		}
		else if (raw_data[i] == "3")
		{
			raw_data[i] <- "WALKING_DOWNSTAIRS"
		}
		else if (raw_data[i] == "4")
		{
			raw_data[i] <- "SITTING"
		}
		else if (raw_data[i] == "5")
		{
			raw_data[i] <- "STANDING"
		}
		else
		{
			raw_data[i] <- "LAYING"
		}
	}
	
	return(raw_data)
}

get_features_and_indices <- function()
{
	features_data <- read.table("features.txt")
	raw_features <- as.vector(features_data[, 2])
	raw_indices <- as.vector(features_data[1, ])
	target_features <- c()
	target_indices <- c()
	
	library(stringr)
	
	for (i in 1:length(raw_features))
	{
		regex <- str_extract(raw_features[i], "-mean\\(\\)|-std\\(\\)")
		if (!is.na(regex))
		{
			if (regex == "-mean()" | regex == "-std()")
			{
				target_features <- c(target_features, raw_features[i])	# target_features row is character, contains all features labeled mean/std
				target_indices <- c(target_indices, i)					# target_indices row is character, must be converted with as.integer before use
			}
		}
	}
	
	return(rbind(target_features, target_indices))
	
}

get_train_and_test_data <- function(typeof_data, indices) #indices is a vector of corresponding to features that contain either mean or std
{
	if (typeof_data == "train")
	{
		file_name <- "./train/X_train.txt"
	}
	else
	{
		file_name <- "./test/X_test.txt"
	}
	
	raw_data <- read.table(file_name)
	condensed_data <- matrix(, nrow = 0, ncol = length(indices))
	
	for (i in 1:nrow(raw_data))
	{
		#print(i)
		new_row <- c()
		for (j in 1:length(indices))
		{
			new_row <- c(new_row, raw_data[i, indices[j]])
		}
		condensed_data <- rbind(condensed_data, new_row)
	}
	return(condensed_data)
}






















