#1 Merges the training and the test sets to create one data set.
#read from the train part
personintrain<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt",sep="",header=FALSE)
activityintrain<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt",sep="",header=FALSE)
datasetintrain<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",sep="",header=FALSE)
#read from the test part
personintest<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt",sep="",header=FALSE)
activityintest<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt",sep="",header=FALSE)
datasetintest<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",sep="",header=FALSE)
#merg both parts
person<-rbind(personintrain,personintest)
rm(personintrain,personintest)
activity<-rbind(activityintrain,activityintest)
rm(activityintrain,activityintest)
dataset<-rbind(datasetintrain,datasetintest)
rm(datasetintrain,datasetintest)
#build a whole data and save as a csv file. This file is the data set we want in 1st question.
wholedata<-cbind(person,activity,dataset)
write.table(wholedata,file="wholedata.txt",sep=",",row.names=F)

#2 Extracts only the measurements on the mean and standard deviation for each measurement.
features<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt",sep="",header=FALSE)
meanindex<-grep("tBodyAcc-mean|tBodyGyro-mean",features$V2)
stdindex<-grep("tBodyAcc-std|tBodyGyro-std",features$V2)
newdata<-cbind(person,activity,dataset[,meanindex],dataset[,stdindex])

#3 Uses descriptive activity names to name the activities in the data set
activitynames<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)
for (i in 1:6){
    newdata[,2]<-gsub(i,activitynames[i,2],newdata[,2])
}
    
#4 Appropriately labels the data set with descriptive activity names. 
colnames(newdata)<-c("person","activity",as.character(features[mean_index,2]),as.character(features[std_index,2]))

#5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
avgbyactandsubj<-aggregate(x = newdata[,3:14], by = list(newdata$activity,newdata$person), FUN = "mean")
colnames(avgbyactandsubj)[1:2]<-c("activity","subject")
write.table(avgbyactandsubj,file="average values by acitivity and subject.txt",sep=",",row.names=F)
