# getdata-014 Course Project 1; please see code book and
# README for details.

library(dplyr)

# these are just the feature names and corresponding indices
features<-read.table("UCI_HAR_Dataset/features.txt", 
                     col.names=c("index", "name")
                    )

activityData <- data.frame() # currently empty :-)

# "loop" twice (test, train) reading the corresponding
# files, creating a data frame, them adding (rbinding) to
# activityData which is our final anser.

for (directory in c("test", "train")) {

    subfile <- paste("UCI_HAR_Dataset/",
                     directory,
                     "/subject_",
                     directory,
                     ".txt",
                     sep="")
    print(subfile)
    stopifnot(file.exists(subfile))
    s <- read.table(subfile,
                   col.names=c("subject")
                   );

    actfile <- paste("UCI_HAR_Dataset/",
                     directory,
                     "/y_",
                     directory,
                     ".txt",
                     sep="")
    stopifnot(file.exists(actfile))
    a <- read.table(actfile,
                   col.names=c("activity")
                   )

    msrfile <- paste("UCI_HAR_Dataset/",
                     directory,
                     "/X_",
                     directory,
                     ".txt",
                     sep="")
    stopifnot(file.exists(msrfile))
    
    # we use the feature names we already have to get something
    # relatively meaningful right away. Note however that R does not
    # leave the feature names entirely unchanged; it modifies certain
    # puncutation characters (e.g. "()-") into dots ("."). We will
    # clean this up later.
    m <- read.table(msrfile,
                   col.names=as.vector(features$name)
                   )
    d <- cbind(s, a, m)

    activityData=rbind(activityData, d)
}

# Remember what I said above about the dots? Clean this up
# by replacing any sequence of one or more dots in variable names
# by a single underscore.
names(activityData) <- gsub("[.]+", "_", names(activityData))

# The variables we want had labels containging "-mean()" or "-std()"
# originally. After the punctuation rewrite (described above)
# these will show up as "_mean_" or "_std_" instead.
meansAndStds <- grep("_(mean|std)_", names(activityData))

# dplyr select gives us a smaller data frame, with only subject,
# activity, and the variables just picked out (means and stds)
activityDataMS <- select(activityData,
                         subject,
                         activity,
                         meansAndStds);

# Read the friendly activity lables file
activities <- read.table("UCI_HAR_Dataset/activity_labels.txt", 
                         col.names=c("activity", "activityName")
                      )

# And add these names to our small data frame
activityDataMS <- merge(activities, activityDataMS, by="activity")

# Again, pick out the columns with mean and std (but now these are all
# those except activity, activityName, and subject, so another way to
# go would be to exclude those three)
meansAndStds2 <- grep("_(mean|std)_", names(activityDataMS))

# dplyr again: we group by activityName and subject, and within
# this two dimensional grouping we want to get a summary (using
# the mean as our summarization function) of every variable
# just found. The labels on the new table are fairly descriptive,
# so long as you remember that they now contain means not raw
# values (well, the original values weren't raw either, but
# means of means or means of stds).

as <- activityDataMS %>% 
      group_by(activityName, subject) %>% 
      summarise_each(funs(mean), meansAndStds2)

# finally write output. This can be read again with read.table
write.table(as, "activity_summary.txt", row.name=FALSE);
