setwd("D:/WIE2003 Intro to DS/Assignment/Group/student/grade")
# Read the csv
d1=read.table("student-mat.csv",sep=";",header=TRUE)
# Display for number of rows and columns
dim(d1)
# Check for class of the data 
class(d1)
# Check for names of columns with its respective type
str(d1)
# Check for existence of null value inside the data
sum(is.na(d1))
# Remove duplicate data
d1 <- unique(d1)
# Check for summary for whole data
summary(d1)
# Look at preview
head(d1)

# Remove school, reason choose the school, Weekly and Daily alcohol consumption (columns)
# columns school and reason choose the school removed for uselessness in deciding factor school
# columns alcohol consumption dropped since in side of global, proportion of consuming alcohol between students is quite low
d1 <- subset(d1, select=-c(Dalc, Walc, school, reason))
# Remove grade at period 1,2 and 3 where an average result column is added in
total <- d1$G1 + d1$G2 + d1$G3
Result <- total / 3
d1$Average.result <- Result
d1 <- subset(d1, select=-c(G1, G2, G3))
# Set yes/no as boolean
d1[d1 == "no"] <- "FALSE"
d1[d1 == "yes"] <- "TRUE"
# Renaming column 
names(d1)[names(d1) == "sex"] <- "Sex"
names(d1)[names(d1) == "age"] <- "Age"
names(d1)[names(d1) == "address"] <- "Address"
names(d1)[names(d1) == "famsize"] <- "Family.size"
names(d1)[names(d1) == "Pstatus"] <- "Parent.s.cohabition.status"
names(d1)[names(d1) == "Medu"] <- "Mother.s.education"
names(d1)[names(d1) == "Fedu"] <- "Father.s.education"
names(d1)[names(d1) == "Mjob"] <- "Mother.s.job"
names(d1)[names(d1) == "Fjob"] <- "Father.s.job"
names(d1)[names(d1) == "guardian"] <- "Guardian"
names(d1)[names(d1) == "traveltime"] <- "Time.from.home.to.school"
names(d1)[names(d1) == "studytime"] <- "Weekly.study.time"
names(d1)[names(d1) == "failures"] <- "Number.of.past.class.failures"
names(d1)[names(d1) == "schoolsup"] <- "Extra.educational.support"
names(d1)[names(d1) == "famsup"] <- "Family.educational.support"
names(d1)[names(d1) == "paid"] <- "Extra.paid.class"
names(d1)[names(d1) == "activities"] <- "Extra.curricular.activity"
names(d1)[names(d1) == "nursery"] <- "Attended.nursery.school"
names(d1)[names(d1) == "higher"] <- "Aims.for.higher.education"
names(d1)[names(d1) == "internet"] <- "Internet.access"
names(d1)[names(d1) == "romantic"] <- "In.romantic.relationship"
names(d1)[names(d1) == "famrel"] <- "Evaluation.for.family.relationship"
names(d1)[names(d1) == "freetime"] <- "Evaluation.for.free.time.after.school"
names(d1)[names(d1) == "goout"] <- "Frequent.going.out.with.friends"
names(d1)[names(d1) == "health"] <- "Current.health.status"
names(d1)[names(d1) == "absences"] <- "Number.of.school.absences"

# Make all columns except "Age", "Number of school absences" and "Average result" to be factor
col_names <- names(d1)
col_names <- col_names [-c(2, 26, 27)]
d1[col_names] <- lapply(d1[col_names], factor)

# EDA
# Load library for visualization
library(ggplot2)

# Plotting for column Sex and Average Result 
data1 <- data.frame(Sex = d1$Sex, Average.result = d1$Average.result)
p1 <- ggplot(data1) + geom_col(aes(x=Sex, y=Average.result), position="dodge", fill ="blue") 
p1 <- p1 + labs(title = "Plot of Sex against Average result", x = "Sex", y = "Average result")
p1
# not much different between the 2 "Sex" category, remove Sex column, causing meaningless data

# summary of columns Guardian, Mother's job and Father's job
summary(d1$Guardian)
summary(d1$Mother.s.job)
summary(d1$Father.s.job)
# pie chart for Guardian
countG <- c(90, 273, 32)
labG <- c("father", "mother", "other")
percentG <- round(countG / sum(countG)*100)
labG <- paste(labG, percentG)
labG <- paste(labG, "%", sep = " ")
pG <- pie(countG, labels = labG, col=rainbow(length(labG)), main = "Pie Chart of Guardian")
# pie chart for Mother's job
countM <- c(59, 24, 141, 103, 58)
labM <- c("at_home", "health", "other", "services", "teacher")
percentM <- round(countM / sum(countM)*100)
labM <- paste(labM, percentM)
labM <- paste(labM, "%", sep = " ")
pM <- pie(countM, labels = labM, col=rainbow(length(labM)), main = "Pie Chart of Mother's job")
# pie chart for Father's job
countF <- c(20, 18, 217, 111, 29)
labF <- c("at_home", "health", "other", "services", "teacher")
percentF <- round(countF / sum(countF)*100)
labF <- paste(labF, percentF)
labF <- paste(labF, "%", sep = " ")
pF <- pie(countF, labels = labF, col=rainbow(length(labF)), main = "Pie Chart of Father's job")
# proportion for Status: Mother is very high
# proportion for Mother's job: Other and services are too high, causing meaningless data
# proportion for Father's job: Other and services are too high, causing meaningless data

# same as column Sex, results shown that across Guardian, not much difference on Average result
data2 <- data.frame(Guardian = d1$Guardian, Average.result = d1$Average.result)
p2 <- ggplot(data2) + geom_col(aes(x=Guardian, y=Average.result), position="dodge", fill = "red") 
p2 <- p2 + labs(title="Plot of Guardian against Average result", x="Guardian", y="Average result")
p2

# remove column Guardian, Mother's job, and Father's job
d1 <- d1[-c(1,7,8,9)]

# check for the data before storing
summary(d1)

# Writing the data set cleaned and processed to new spreadsheet
write.csv(d1, "Cleaned.csv", row.names=FALSE)




