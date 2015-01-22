# Libraries
library(data.table)
library(dplyr)
library(plyr)

# Directories of the data
path <- "UCI HAR Dataset"
pathTrain <- paste(path,"train",sep="/")
pathTest  <- paste(path,"test" ,sep="/")
pathTrainF<- paste(pathTrain,"Inertial Signals",sep="/")
pathTestF <- paste(pathTest ,"Inertial Signals",sep="/")

# Read data
trainSubject <- read.table(paste(pathTrain,"subject_train.txt", sep="/"))
testSubject  <- read.table(paste(pathTest ,"subject_test.txt" , sep="/"))

trainX <- read.table(paste(pathTrain,"X_train.txt", sep="/"))
testX  <- read.table(paste(pathTest ,"X_test.txt" , sep="/"))

trainY <- read.table(paste(pathTrain,"y_train.txt", sep="/"))
testY  <- read.table(paste(pathTest ,"y_test.txt" , sep="/"))

features <- read.table(paste(path,"features.txt", sep="/"))
activities <- read.table(paste(path,"activity_labels.txt", sep="/"))

# Merge test and train
subject <- rbind(trainSubject,testSubject)
x <- rbind(trainX,testX)
y <- rbind(trainY,testY)

# Assign labels to data
features$V2 <- as.character(features$V2)
x <- setnames(x,paste("V",1:dim(x)[[2]],sep=""),features[[2]])
subject <- setnames(subject,"V1","idSubject")
y <- setnames(y,"V1","activity")

# Merge subject, activity, and features 
dt <- data.table(subject, y, x)

# Extract measurements
measurements <- union( grep("mean()",features$V2,fixed=TRUE),
                       grep("std()",features$V2,fixed=TRUE))
measurements <- union(c(1,2),measurements + 2)
dt <- select(dt,measurements)

# Use descreptive activity's names
dt$activity <- factor(dt$activity,labels=activities$V2)

#step 5
tidy <- ddply(dt,.(idSubject,activity), numcolwise(mean))

write.table(tidy,"tidy.txt", row.name=FALSE)
