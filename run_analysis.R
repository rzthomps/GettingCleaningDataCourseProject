##Getting & Cleaning Data
##Course Project

##Merge Training & Test datasets to create one dataset

##Load dplyr package

library(dplyr)

##load training data, labels, subject 
trainx <- read.table("X_train.txt")

trainy <- read.table("y_train.txt")

trainsub <- read.table("subject_train.txt")

##load test data, labels, subject

testx <- read.table("X_test.txt")

testy <- read.table("y_test.txt")

testsub <- read.table("subject_test.txt")


##Combine data

comb_data <- rbind(trainx,testx)
comb_lab <- rbind(trainy,testy)
comb_sub <- rbind(trainsub,testsub)
colnames(comb_sub) <- c("Subject")

all_comb <- cbind(comb_lab,comb_data)

##Add column names to combined data

colfeatraw <- read.table("features.txt")
colfeatname <- colfeatraw[,2]
colnames(all_comb) <- c('Activity',as.character(colfeatname))

##Extracting ONLY the mean and standard deviation
mean <- c(1, as.integer((grep("-mean()", colfeatraw[,2], fixed = TRUE, value = FALSE) + 1))) 
std <- c(as.integer((grep("-std()", colfeatraw[,2], fixed = TRUE, value = FALSE) + 1)))
all_extdata <- cbind(all_comb[,mean],all_comb[,std])

##Add the activity names to the extracted mean / std dataset and add subjects

act <- read.table("activity_labels.txt")
act_factor = factor(act[,2])
act_name = factor(all_extdata[,1], labels = act_factor)
all_extdataname <- cbind(act_name, all_extdata)
all_extdataclean <- cbind(comb_sub, all_extdataname)
all_extdataclean$Activity <- NULL 

##Summarize the data by subject and act_name

final_data <- all_extdataclean %>% group_by(act_name,Subject) %>% summarise_each(funs(mean))
final_data_output <- data.frame(final_data)
write.table(final_data_output, file = "Final_Project_Data.txt", row.names = FALSE)
