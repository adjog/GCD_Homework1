## Codebook for getdata-014 coursework

This work derives data from [UCH HAR Dataset](
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The
included source files "UCI HAR Dataset/README.txt" and "UCI HAR
Dataset/features_info.txt" contain more information about the original
data and its meaning. I shall not repeat that information here.

_Unzipping the file created a directory "UCI HAR Dataset" which
I renamed on the command line to "UCI_HAR_Dataset", because
spaces inside file names are evil._

### My data and analysis (run_analysis.R)###

####Initial steps: creating `activityData` dataframe#####

1. Read the names of the 561 measured values, from the provided features.txt

2. For each of the test and training set, create a single data frame
containing the contents of _subject_{test,train}.txt_ (just one value
per entry, the subject id), _y_{test,train}.txt_ (just one value, the
coded activity type), and _X_{test, train}.txt_ (the 561 measurements).
The test and training data frame were combined to give `activityData`
which is a single data frame with 10299 rows and 561 columns.

3) Column names are as in the provided _features.txt_, except that R
does not like certain punctuation characters such as "()-,". Any
sequence of one or more such characters are replaced by a single underscore
"_".

Thus, the schema for activityData is:

1. subject integer 1-30 (person being measured)

2. activity integer 1-6 (coded activity)

3. tBodyAcc_mean_X numeric units "g" - time domain X-axis body acceleration, mean

4. tBodyAcc_mean_X numeric units "g" - time domain Y-axis body acceleration, mean

5. tBodyAcc_mean_X numeric units "g" - time domain Z-axis body acceleration, mean

6. tBodyAcc_mean_X numeric units "g" - time domain X-axis body acceleration, standard deviation

7. ... the remaining 357 measurements are exactly as described in the original
data set, albeit with the punctuation translation described above

####Next: `activityDataMS` with only means and standard deviations####

Next, a smaller data set `activityDataMS` is created that only contain
measurements corresponding to the mean and standard deviations in the
original set (ignoring, etc. mean-absolute devision, max, min, sma,
energy(), iqr(), and other statistics). These variables are identified
in the original data set with "-mean()" and "-std()" substrings. In
the translated names, these become "_mean_" and "_std" substrings,
which I identify using R's "grep" command. Note that this
intentionally omits the "meanFreq()" variables - it is not clear from
the specification whether these are desired or not, so I made the
decision to omit them.

To aid interpretability, I read the human-readable names
for the six activity levels (from the provided file "activity_labels.txt")
and merge these into "activityDataMS" so that it has a column activityName.

Thus the schema for activityDataMS is (for units and semantics please
see the original data set files as listed above):


 1. activity  integer 1-6

 1. activityName factor "LAYING","SITTING"...

 1. subject 1-30 person being measured

 1. tBodyAcc_mean_X units "g" time domain X-axis body acceleration, mean

 1. tBodyAcc_mean_Y &etc. See original data set

 1. tBodyAcc_mean_Z         

 1. tBodyAcc_std_X          

 1. tBodyAcc_std_Y          

 1. tBodyAcc_std_Z          

 1. tGravityAcc_mean_X      

 1. tGravityAcc_mean_Y      

 1. tGravityAcc_mean_Z      

 1. tGravityAcc_std_X       

 1. tGravityAcc_std_Y       

 1. tGravityAcc_std_Z       

 1. tBodyAccJerk_mean_X     

 1. tBodyAccJerk_mean_Y     

 1. tBodyAccJerk_mean_Z     

 1. tBodyAccJerk_std_X      

 1. tBodyAccJerk_std_Y      

 1. tBodyAccJerk_std_Z      

 1. tBodyGyro_mean_X        

 1. tBodyGyro_mean_Y        

 1. tBodyGyro_mean_Z        

 1. tBodyGyro_std_X         

 1. tBodyGyro_std_Y         

 1. tBodyGyro_std_Z         

 1. tBodyGyroJerk_mean_X    

 1. tBodyGyroJerk_mean_Y    

 1. tBodyGyroJerk_mean_Z    

 1. tBodyGyroJerk_std_X     

 1. tBodyGyroJerk_std_Y     

 1. tBodyGyroJerk_std_Z     

 1. tBodyAccMag_mean_       

 1. tBodyAccMag_std_        

 1. tGravityAccMag_mean_    

 1. tGravityAccMag_std_     

 1. tBodyAccJerkMag_mean_   

 1. tBodyAccJerkMag_std_    

 1. tBodyGyroMag_mean_      

 1. tBodyGyroMag_std_       

 1. tBodyGyroJerkMag_mean_  

 1. tBodyGyroJerkMag_std_   

 1. fBodyAcc_mean_X         

 1. fBodyAcc_mean_Y         

 1. fBodyAcc_mean_Z         

 1. fBodyAcc_std_X          

 1. fBodyAcc_std_Y          

 1. fBodyAcc_std_Z          

 1. fBodyAccJerk_mean_X     

 1. fBodyAccJerk_mean_Y     

 1. fBodyAccJerk_mean_Z     

 1. fBodyAccJerk_std_X      

 1. fBodyAccJerk_std_Y      

 1. fBodyAccJerk_std_Z      

 1. fBodyGyro_mean_X        

 1. fBodyGyro_mean_Y        

 1. fBodyGyro_mean_Z        

 1. fBodyGyro_std_X         

 1. fBodyGyro_std_Y         

 1. fBodyGyro_std_Z         

 1. fBodyAccMag_mean_       

 1. fBodyAccMag_std_        

 1. fBodyBodyAccJerkMag_mean_

 1. fBodyBodyAccJerkMag_std_

 1. fBodyBodyGyroMag_mean_  

 1. fBodyBodyGyroMag_std_     

 1. fBodyBodyGyroJerkMag_mean_

 1. fBodyBodyGyroJerkMag_std_ 

####Final summarization: output is _activity_summary.txt_, data frame is `as`####

Finally, we use dplyr group_by and summarise_each functions to
aggregate by all compbinations of activityName and subject, and with
each such combination take the mean of each of the remaining columns
(ecluding "activity").  This is saved in a _wide_ table "as", written
out to a text file "activity_summary.txt" with write.table. 

Note that I have intentionally not changed the names of the
measured variables, except that they are now the means of
the invidivual values from before.

 1. activityName  factor "LAYING","SITTING"...

 1. subject  number 1-30 identifying person being measured

 1. tBodyAcc_mean_X  units "g" time domain X-axis body acceleration, mean of the invididual mean values

 1. tBodyAcc_mean_Y analogous       

 1. tBodyAcc_mean_Z analogous 

 1. tBodyAcc_std_X  units "g" time domain X-axis body acceleration, mean of the invididual standard deviations       

 1. tBodyAcc_std_Y analogous

 1. tBodyAcc_std_Z analogous           

 1. ...etc  

