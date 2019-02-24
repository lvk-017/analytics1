library(arules)
library(arulesViz)
library(datasets)


data('Groceries') #different format - transaction format
arules::inspect(Groceries[1:5])
df<-read.csv("Cosmetics.csv",header=TRUE, sep=",")
head(df)

#getwd() : This function helps to know the directory path in the system
#setwd() : This is a function to change the location path of the directory on the system 

# Few quick definitions -
#   
# Support - number of times(or percent of times) the antecedent(if) and the consequent(then) occur together. 
#            Can be used to consider only the combinations which occur atleast a certain number of times or with higher frequency.
# Confidence - percent of antecedent(if) transactions that also have the consequent(then) item set or P(C|A) = p(C and A)/P(A) or 
#            number of transactions with both antecedent and consequent/number of transactions with antecedent items
# Lift ratio - We can get higher confidence numbers just because of items which are essentially just picked up without any relevance with other items being picked e.g. milk, bread etc. 
#            Lift ratio is defined as lift(x->y) = support(x and y)/(support(x) * support(y))
# Lift ratio greater than 1 is a good sign of association.

rules = apriori(as.matrix(df[,2:15]), parameter=list(support=0.15, confidence=0.65,minlen=2))
rulesc <- sort (rules, by="confidence", decreasing=TRUE)
inspect(rulesc[1:5])

frequentItems = eclat (Groceries, parameter = list(supp = 0.01, minlen= 2, maxlen = 5))
inspect(sort (frequentItems, by="count", decreasing=TRUE)[1:25])
dev.off()
itemFrequencyPlot(Groceries,topN = 15,type = 'absolute')
rules2 = apriori (Groceries, parameter = list (supp = 0.001, conf = 0.5, minlen=2, maxlen=3)) 
rules2
rules
inspect(rules2[1:15])

subset1 = subset(rules2, subset=rhs %in% "whole milk")
inspect(subset1[1:10]) # rhs has milk
subset1 = subset(rules2, subset=rhs %in% 'bottled beer' )
inspect(subset1) #rhs has beer
subset2 = subset(rules2, subset=lhs %ain% c('baking powder','soda') )
inspect(subset2) # all items  %ain%
subset2a = subset(rules2, subset=lhs %in% c('baking powder','soda') )
inspect(subset2a[1:10]) # any of the items %in%
subset3 = subset(rules2, subset=rhs %in% 'bottled beer' & confidence > .5, by = 'lift', decreasing = T)
inspect(subset3)  #sometimes there may be no rules, change few parameters
subset4 = subset(rules2, subset=lhs %in% 'bottled beer' & rhs %in% 'whole milk' )
inspect(subset4)
subset4b = subset(rules2, subset=rhs %in% 'bottled beer'  )
inspect(subset4b) #no such rules

?itemFrequencyPlot

#?read.transactions
## read demo data (skip comment line)
#tr <- read.transactions("fintransactions.csv", format = "single", sep=",",cols = c(1,2))

# library(arulesViz)
# plot(rules)
# plot(rules,method = "graph")
# inspect(rules)


##https://medium.com/@GalarnykMichael/accessing-data-from-twitter-api-using-r-part1-b387a1c7d3e

#library("curl")
library("twitteR")
library("ROAuth")
library("syuzhet") #library for sentiment analysis - comparison

consumer_key='uRDuync3BziwQnor1MZFBKp0x'
consumer_secret='t8QPLr7RKpAg4qa7vth1SBsDvoPKawwwdEhNRjdpY0mfMMdRnV'
access_token='14366551-Fga25zWM1YefkTb2TZYxsrx2LVVSsK0uSpF08sugW'
access_token_secret='3ap8BZNVoBhE2GaMGLfuvuPF2OrHzM3MhGuPm96p3k6Cz'

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_token_secret)

no.of.tweets <- 100

tweets <- searchTwitter("bitcoin", n=no.of.tweets,lang="en")
tweets
tweets[1:10]
tweets_user = twListToDF(tweets) 

tweets.df2 <- gsub("http.*","",tweets_user$text)
tweets.df2 <- gsub("https.*","",tweets.df2)
tweets.df2 <- gsub("#.*","",tweets.df2)
tweets.df2 <- gsub("@.*","",tweets.df2)

tweets = userTimeline("imVkohli", n=100)
tweets[1:5]
n.tweet <- length(tweets)
n.tweet
tweets.df = twListToDF(tweets) 
head(tweets.df)
summary(tweets.df)
#Remove hashtags & unnecessary characters
tweets.df2 <- gsub("http.*","",tweets.df$text)
tweets.df2 <- gsub("https.*","",tweets.df2)
tweets.df2 <- gsub("#.*","",tweets.df2)
tweets.df2 <- gsub("@.*","",tweets.df2)

head(tweets.df2)

library("syuzhet") #library for sentiment analysis - comparison
word.df <- as.vector(tweets.df2)
emotion.df <- get_nrc_sentiment(word.df)
emotion.df2 <- cbind(tweets.df2, emotion.df) 
head(emotion.df2)
emotion.df2
word.df

#-----
sent.value <- get_sentiment(word.df)
sent.value
tweets[c(16,62)]
most.positive <- word.df[sent.value == max(sent.value)]
most.positive
most.negative<- word.df[sent.value <= min(sent.value)] 
most.negative
sent.value

#-----
positive.tweets <- word.df[sent.value > 0]
head(positive.tweets)
negative.tweets <- word.df[sent.value < 0] 
head(negative.tweets)
neutral.tweets <- word.df[sent.value == 0]
head(neutral.tweets)
#----




#install.packages('lubridate')
library(lubridate)

tday <- today()
tday

#Extract year month day from a date

year(tday)
month(tday)
day(tday)

#Extract weekday - Sunday is 1
wday(tday)
wday(tday, label = TRUE)

#Date time 
memt <- now()
memt

hour(memt)
minute(memt)
second(memt)

#Date parsing or conversions

class(tday)

# Pass a string to be read as date
dat1 <- ymd("2017-12-23")
dat1

class(dat1)

dat2 <- ymd("2017 May 25")
dat2


now()
now("EST")
# Origin is the date-time for 1970-01-01 UTC in POSIXct format. 
# This date-time is the origin for the numbering system used by POSIXct, POSIXlt, chron, and Date classes.
origin

#x days since origin
origin + days(1)
origin + months(11)
origin + years(2)

#next date
today() + days(1)
today() + months(1)

#next date
now() + days(1)

#previous day
today() - days(1)

#Sequence of next 9 days
today() + c(0:9) * days(1)

#Sequence of alternate day ---- simialr logic for months etc. as well
today() + c(0:9) * days(2)

#first date of month
floor_date(today(),"month")

#first day of next month
floor_date(today(),"month") + months(1)

#last day of current month
(floor_date(today(),"month") + months(1)) - days(1)

#first day of this year
floor_date(today(),"year")

# last day of current year
(floor_date(today(),"year") + months(1)) - days(1)

# difference between two dates in days
d1 <- today() + years(5)
d1 - today()

d2 <- today() + days(1)
d2 - today()

yearsdiff <- year(d2) - year(as.Date("2017-02-23"))
monthsdiff <- month(d2) - month(as.Date("2017-03-23"))
daysdiff <- day(d2) - day(as.Date("2017-02-23"))


length(seq(from=today(), to=d2, by="month")) - 1
length(seq(from=today(), to=d1, by="year")) - 1

