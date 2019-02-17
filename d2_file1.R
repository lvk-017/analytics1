students
# bookmark can be made using 4 dashes '----'
# loading of the packages can be done by using the function "library(package)"
# %>% pipe operator acts like a filter
# assigning the value '=' and to check the value use the syntax '=='
students %>% group_by(gender, college) %>% summarise(countTotal = n())
library(dplyr)
# group_by function is used to group the selected attributes and then execute the conditions mentioned after that
# summarise function is used to summarise the data with functions like the count, mean etc
students %>% mutate(TotalMarks = marks1 + marks2)
students
students %>% mutate(totalmarks = marks1 + 1.5 * marks2) %>% arrange(-totalmarks)
# mutate is used to view the data moified in the console and doesnot alter the data frame
# sort the data in the descending order by using the arrange function('-''column name')
# use the head function at the end to get the top few rows by head(n = #)
students %>% mutate(totalmarks = marks1 + 1.5 * marks2) %>% arrange(-totalmarks) %>% head(n=4)
# to get the selected rows use the slice function
students %>% slice(1:5)
# to get the every alternate rows use the slice and sequence functions
students %>% slice(seq(1,30,2))
# sample data can be taken from the data using the sample_n function
students %>% sample_n(5)
# sample data can be taken from the data using the sample fraction function as well
students %>% sample_frac(.2) #random fraction of the data can be extracted
students %>% mutate(totalmarks = marks1 + marks2) %>%filter(totalmarks == max(totalmarks))



