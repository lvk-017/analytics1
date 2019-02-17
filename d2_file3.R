#graphs

mtcars
names(mtcars)
table(mtcars$cyl)
table(mtcars$cyl, mtcars$am)
mtcars$mpg
#continous data - histogram, boxplot
hist(mtcars$mpg)
boxplot(mtcars$mpg)
boxplot(mpg ~ gear, data = mtcars, col=3:5)
t1 = table(mtcars$gear)
t1
barplot(t1, col = 1:3)
barplot(c(10,3,5))
pie(c(10,3,5))
students
t2 = table(students$college)
t2
barplot(t2, col = 1:3)
t3 = table(students$gender)
t3
pie(t3, col = 1:2) 
