build_dataset <- function()
{
	# convert data in y_train and y_test text files into activity labels
	# merge data into one column defined as activity_column
	print("getting activity data from y_train.txt and y_test.txt...")
	train_activity_column <- get_activity_column("train")
	test_activity_column  <- get_activity_column("test")
	activity_column <- combine(train_activity_column, test_activity_column)
	
	print("getting mean and standard deviation variables...")
	features <- get_features_and_indices()
	
	print("getting data from X_train.txt...")
	train_data <- get_train_and_test_data("train", as.integer(features[2, ]))
	print("getting data from X_test.txt...")
	test_data  <- get_train_and_test_data("test", as.integer(features[2, ]))
	combined_data <- rbind(train_data, test_data)
	
	print("renaming feature variables...")
	renamed_features <- alter_features(features[1, ])
	colnames(combined_data) <- c(renamed_features)
	
	print("tidying data...")
	library(dplyr)
	tidy_data <- tbl_df(combined_data)
	tidy_data <- mutate(tidy_data, activityLabels = activity_column)
	
	return(tidy_data)
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
			target_features <- c(target_features, raw_features[i])	# target_features row is character, contains all features labeled mean/std
			target_indices <- c(target_indices, i)					# target_indices row is character, must be converted with as.integer before use
		}
		#{
		#	if (regex == "-mean()" | regex == "-std()")
		#	{
		#		target_features <- c(target_features, raw_features[i])	# target_features row is character, contains all features labeled mean/std
		#		target_indices <- c(target_indices, i)					# target_indices row is character, must be converted with as.integer before use
		#	}
		#}
	}
	
	return(rbind(target_features, target_indices))
	
}

# for logic, refer to codebook.txt
alter_variable_name <- function(v)
{
	library(stringr)
	new_v <- ""		# initialize new variable name
	
	# mean, standard deviation, or neither?
	regex <- str_extract(v, "-mean\\(\\)|-std\\(\\)")
	if (regex == "-mean()")
	{
		new_v <- paste(new_v, "meanOf", sep = "")
	}
	else
	{
		if (regex == "-std()")
		{
			new_v <- paste(new_v, "stDevOf", sep = "")
		}
	}
	
	# time or frequency?
	regex <- str_extract(v, "^[tf]")
	if (regex == "t")
	{
		new_v <- paste(new_v, "Time", sep = "")
	}
	else
	{
		if (regex == "f")
		{
			new_v <- paste(new_v, "Frequency", sep = "")
		}
	}
	
	# 1 or 2 rigid bodies?
	regex <- str_extract(v, "BodyBody")
	if (!is.na(regex))
	{
		new_v <- paste(new_v, "BodyBody", sep = "")
	}
	else
	{
		regex <- str_extract(v, "Body")
		if (!is.na(regex))
		{
			new_v <- paste(new_v, "Body", sep = "")
		}
	}
	
	# gravity?
	regex <- str_extract(v, "Gravity")
	if (!is.na(regex))
	{
		new_v <- paste(new_v, "Gravity", sep = "")
	}
	
	# measurement via acceleromter?
	regex <- str_extract(v, "Acc")
	if (!is.na(regex))
	{
		new_v <- paste(new_v, "Accel", sep = "")
	}
	
	# measurement via gyroscope?
	regex <- str_extract(v, "Gyro")
	if (!is.na(regex))
	{
		new_v <- paste(new_v, "Gyro", sep = "")
	}
	
	# is test subject a jerk?
	regex <- str_extract(v, "Jerk")
	if (!is.na(regex))
	{
		new_v <- paste(new_v, "Jerk", sep = "")
	}
	
	# measure of vector magnitude?
	regex <- str_extract(v, "Mag")
	if (!is.na(regex))
	{
		new_v <- paste(new_v, "Mag", sep = "")
	}
	
	# alter axial direction
	regex <- str_extract(v, "-[XYZ]$")
	if (!is.na(regex))
	{
		if (regex == "-X")
		{
			new_v <- paste(new_v, "InX", sep = "")
		}
		else if (regex == "-Y")
		{
			new_v <- paste(new_v, "InY", sep = "")
		}
		else
		{
			if (regex == "-Z")
			{
				new_v <- paste(new_v, "InZ", sep = "")
			}
		}
	}
	
	return(new_v)
}

alter_features <- function(features)
{
	for (i in 1:length(features))
	{
		features[i] <- alter_variable_name(features[i])
	}
	return(features)
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

create_q5_dataset <- function(tidy_dataset)
{
	library(dplyr)
	means_walking <- create_mean_row("WALKING", tidy_dataset)
	means_walking_up <- create_mean_row("WALKING_UPSTAIRS", tidy_dataset)
	means_walking_dn <- create_mean_row("WALKING_DOWNSTAIRS", tidy_dataset)
	means_sitting <- create_mean_row("SITTING", tidy_dataset)
	means_standing <- create_mean_row("STANDING", tidy_dataset)
	means_laying <- create_mean_row("LAYING", tidy_dataset)
	
	return(rbind(means_walking, means_walking_up, means_walking_dn, means_sitting, means_standing, means_laying))
}

create_mean_row <- function(activity, dataset)
{
	filtered_ds <- filter(dataset, activityLabels == activity)
	means <- apply(filtered_ds[1:66], 2, mean)
	means$activityLabel <- activity
	return(means)
}






















