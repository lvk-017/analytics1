#comments starts by #
women
#help : ? mark before and execute by ctrl+Enter
?women
?mean
mtcars
mean(mtcars$mpg)
# function(Subset$column_name)
mean(mtcars$hp)
# to find the list of the columns in the set use *names* function
names(mtcars)
# mean of all the columns in the set
colMeans(mtcars)
# mean of row wise data
rowmeans(mtcars)
head(mtcars) # first 6 rows list
head(mtcars,1) # first row of the data
tail(mtcars) # last 6 rows list of the data
hist(mtcars$mpg) # draws the histogram for the columns selected
#vectors
x = c(2,5,15,17)
x
class (x)
# class defines the type of the data or vector
x2 = c(2L, 3L)
class (x2)

x3 = c("a", "B", "Vamsi")
class (x3)

x4 = c(TRUE, FALSE, T, F)
x5 = 1:1000
x5

x6 <- 2 #another way of assigning a value to the variable by symbol *<-*
(x7 = rnorm(100))
hist(x7)
mean(x7)
sd(x7) # standard deviation of the class
plot(density(x7)) # distribution curve of graph
hist(x7, freq = F) 
points(density(x7)) #Plotting the overlapping curves
(x8 = rnorm(100, mean = 60, sd = 10))
hist(x8, freq = F)
points(density(x8))

library(e1071)
kurtosis (x8)
library(e1071) #install the library for additional functions
kurtosis (x8)
skewness (x8)

#sorting the data
x9 = runif(100, 30, 80) # runif(#, #, #): function for(number of values, lower value, higher value) 
trunc(x9) # truncate the decimal values to integers
round(x9, 1) # round the values into 1 decimal
floor(x9) # lower value of each data
ceiling(x9) # higher value of each data
x10 = ceiling (x9)
x10
mean(x10)
median(x10)
sort(x10, decreasing = T) # sorting the data in ascending/descending order
x10 [x10 > 60] # values from the dataset that are greater than 60
x10 [1:10] # first 10 data values in the dataset
x10 [-c(1:10)]
x10
x10 [c(1,5,9)] # values at that particular position of [c(#, #, #, ...)]

#Matrices

m1 = matrix(1:24, nrow= 6) # number of data values, either row/column count
m1
dim (m1) # defines the dimensions of the matrix with number of rows & Columns

m2 = matrix (1:56, ncol= 8, byrow = T) # Default the arrangement is column can be changed into row wise
m2

colnames(m2) = month.abb[1:8] # Assign the column names with months
m2

rownames (m2) = paste('Product', 1:7, sep = "*") # Assign the row names with paste function to concatenate
m2

rowMeans (m2) # find the mean of each row
colMeans (m2) # find the mean of each column

m2 [ , 1:4] # only the columns from 1 to 4
m2[c(1,3,5), ] # extract the selective rows from the data

m2[ , c('Apr', 'Jun')]
min(m2)
max(m2)
range(m2)


#Data.frame
# combination of vectors of same length
n= 30
(rollno = paste('F', 1:30, sep = '_'))
(sname = paste('Student', 1:30, sep = '#'))
(gender = sample(c('M', 'F'), size = n, replace = T)) # replace makes the function for multiple iterations
table (gender)
(gender = sample(c('M', 'F'), size = n, replace = T, prob = c(.7, .3))) # define the probability of as required 
table (gender)
#setseed: start from setseed to get the same pattern
(t1= table (gender))
prop.table(t1)
(college = sample(c('SRCC', 'FMS', 'IIMA'), size = n, replace = T, prob = c(.3,.4,.3)))
(t2 = table(college))
prop.table(t2)
?rnorm

(marks1 = round(rnorm(n=n, mean = 60, sd =10)))
(marks2 = round(rnorm(n=n, mean = 55, sd = 15)))
rollno; sname; gender; college; marks1; marks2
students = data.frame (rollno, sname, gender, college, marks1, marks2)
class(students)
students
str(students)# structure
summary(students) # summary of the data frame 6 column summary data
quantile(students$marks1) #quartile percentile of the data after sorting
quantile (students $marks2, probs = seq(0,1,.1))# function format for every 10%ile
?seq
quantile (students $marks2, probs = seq(.6,1,.1)) # sequence function (Lowest, highest, difference)
students$rollno = as.character(students$rollno)
students$sname = as.character(students$sname)
students$gender =as.character(students$gender)
students$college = as.character(students$college)
str(students)
students$gender = as.factor(students$gender)
students$college = as.factor(students$college)
str(students)
students
write.csv(students, 'fms.csv', row.names = F) # export to csv file to view in excel
students2 = read.csv('fms.csv') # Import or read command: read.csv ('filename.csv')
students3 = read.csv(file.choose()) # instead of the filename file directions can be also mentioned
library(dplyr)
students[students$marks1 > 60, ]
students[students$gender == 'F', ]
students[students$gender =='F' | students$college == 'FMS', ]

#highest from all the college
students%>% filter(gender =='M')
students %>% filter (gender == 'M' & marks1 > 60)
students %>% group_by(gender) %>% summarise(max(marks1), max(marks2))  
students %>% group_by(college) %>% summarise (max(marks1), max(marks2))
students
