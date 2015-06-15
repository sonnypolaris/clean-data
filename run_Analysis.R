# Cleaning data project
# package dependencies: 

# step 1 - Download & unzip the file
destZip <- "smartphone.zip"
# zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(zipUrl, destfile=destZip, method="curl")
# unzip(destZip,overwrite=TRUE,exdir=".")

# read in the data (test, train, subjects, features, and labels)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Apply labels to the activity
h <- merge(y_test, activity_labels, by.x="V1", by.y="V1", all.x = TRUE)
j <- merge(y_train, activity_labels, by.x="V1", by.y="V1", all.x = TRUE)

# Add the subjects and activity label to the x_test/x_train sets
x_test  <- cbind(x_test, subject_test)
x_test  <- cbind(x_test, h$V2)
x_train <- cbind(x_train, subject_train)
x_train <- cbind(x_train, j$V2)

# Fix column names
names(x_test)[562] <- "V562"
names(x_test)[563] <- "V563"
names(x_train)[562] <- "V562"
names(x_train)[563] <- "V563"

# stack/combine the test and train data frames.  These have the 
# subject and activity label applied to columns (562 & 563)
df <- rbind(x_test, x_train)
print (paste (nrow(df), " rows = ", nrow(x_test), "(X_test) + " , nrow(x_train), "(X_train)"))

# define function to remove unwanted characters from the varables names
cleanName <- function(x){
  x0 <- gsub("\\(","",x)
  x1 <- gsub("\\)","",x0)
  x2 <- gsub("\\-","",x1)
  x3 <- gsub("\\,","",x2)
}
# transform names to lower and then remove '(', ')l', '-'
namelist <- tolower(as.character(features$V2))

# make a vector of only the mean & std columns
idx <- grep("-mean()|-std()", namelist)
idx <- c(idx, 562, 563) # add in the last 2 columns (subject& activity)
colNames <- cleanName(namelist[idx])
colNames[80] <- "subject"
colNames[81] <- "activity"

# extract out only the columns needed
df <- df[,idx]

# assign names to the columns
names(df) <- colNames
v <- colNames[1:79]

# pivot the data & calc the mean of each variable
mdf <- melt(dat, id.vars = c("subject", "activity"),  measure.vars = v)
ddf <- dcast(mdf, subject + activity ~ variable, fun.aggregate=mean, na.rm=TRUE)

# write the output file
write.table(ddf, "activity_averages.txt", row.names = FALSE)

