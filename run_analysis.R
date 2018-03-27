#run_analysis <- function()
#{
#	return 0
#}

get_activity_column <- function()
{
	train_data <- read.table("./train/y_train.txt")
	test_data  <- read.table("./test/y_test.txt")
	
	train_data <- unlist(train_data, use.names = FALSE)		# call unlist function on raw_data sets to make indexing easier
	test_data  <- unlist(test_data, use.names = FALSE)
	
	train_data <- as.character(train_data)						# convert lists to character lists
	test_data  <- as.character(test_data)
	
	for (i in 1:length(raw_train_data))
	{
		if (raw_train[i] == "1")
		{
			raw_train[i] <- "WALKING"
		}
		else if (raw_train[i] == "2")
		{
			raw_train[i] <- "WALKING_UPSTAIRS"
		}
		else if (raw_train[i] == "3")
		{
			raw_train[i] <- "WALKING_DOWNSTAIRS"
		}
		else if (raw_train[i] == "4")
		{
			raw_train[i] <- "SITTING"
		}
		else if (raw_train[i] == "5")
		{
			raw_train[i] <- "STANDING"
		}
		else
		{
			raw_train[i] <- "LAYING"
		}
	}
	return(combine(train_data, test_data))
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

















