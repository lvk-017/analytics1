---
  title: "Decision trees - rpart"
author: "Nikhlesh Daga"
date: "2/21/2019"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Decision trees

Decision trees are supervised learning algorithms i.e. they have a response variable to train the model as compared to unsupervised learning techniques like kmeans clustering which do not have a response variable. They work on the concept of splitting data in order to define homogeneous groups of data and then define the class based on majority vote. 

### Advantages 

1. Easy to understand
2. Can handle both numeric and categorical variable.
2. Can be used to highlight relationship between two variables and quickly identify important variables.
3. Not influenced by outliers and missing values.
4. Non-parametric method or does not depend on the underlying distribution.

### Disadvantages 

1. Prone to overfitting.
2. Might lose information as it tries to bin numeric variables.

### Which variable to split on?

1. Gini index

- used by default in rpart and can be changed within the parms function.
- performs only binary split
- higher the gini value, higher the homogenity
- calculated as (p^2 + q^2) where p is the probability of scuccess and q is the probability of failure
- calculate gini for split using weighted Gini score for each node. If the Gini value after split for one variable is higher than the second variable, first variable would be chosen for split.

2. Chi square

- calculates statistical significance for split with different variables
- higher the value of chi-square, higher the statistical difference between the child and parent node
- generates trees which ar ecalled CHAID(Chi-square automatic interaction detector)

3. Entropy or information gain

- if we have a pure node, the entropy is zero while if we have a node with 50-50% distribution of two classes, the entropy is 1.
- lesser the entropy due to split from parent to child node, better is the split.
- 1 - entropy is defined as information gain



## Required libraries

```{r,warning=FALSE}
library(rpart)
library(rpart.plot)
library(caret)
library(randomForest)
```

## Read in the data

#Read in the data. The model needs to be trained on the training data and the results need to be checked on the test data. 

```{r}
path = 'https://raw.githubusercontent.com/nikhlesh17/Training/master/titanic.csv'
titanic <- read.csv(path)
str(titanic)
```

## Data subset and train-test split

```{r}
data = titanic[,c(2,3,5,6)]
table(data$survived)
# the response variable needs to be a categorical variable for classification
data$survived <- as.factor(data$survived)
data$pclass <- as.factor(data$pclass)
set.seed(123)
indx <- createDataPartition(y = data$survived,
                            p = 0.8,
                            list = FALSE)
train <- data[ indx,]
test <- data[-indx,]
# Counts for suvived column
```




### Prepruning parameters

rpart.control(minsplit = 20, minbucket = round(minsplit/3), cp = 0.01, 
              maxcompete = 4, maxsurrogate = 5, usesurrogate = 2, xval = 10,
              surrogatestyle = 0, maxdepth = 30, ...)

**minsplit**	
  the minimum number of observations that must exist in a node in order for a split to be attempted.

**minbucket**	
  the minimum number of observations in any terminal <leaf> node. If only one of minbucket or minsplit is specified, the code either sets minsplit to minbucket*3 or minbucket to minsplit/3, as appropriate.

**cp**	
  complexity parameter. Any split that does not decrease the overall lack of fit by a factor of cp is not attempted. Essentially,the user informs the program that any split which does not improve the fit by cp will likely be pruned off by cross-validation, and that hence the program need not pursue it.

**maxcompete**	
  the number of competitor splits retained in the output. It is useful to know not just which split was chosen, but which variable came in second, third, etc.

**maxsurrogate**	
  the number of surrogate splits retained in the output. If this is set to zero the compute time will be reduced, since approximately half of the computational time (other than setup) is used in the search for surrogate splits.

**usesurrogate**	
  how to use surrogates in the splitting process. 0 means display only; an observation with a missing value for the primary split rule is not sent further down the tree. 1 means use surrogates, in order, to split subjects missing the primary variable; if all surrogates are missing the observation is not split. For value 2 ,if all surrogates are missing, then send the observation in the majority direction. A value of 0 corresponds to the action of tree, and 2 to the recommendations of Breiman et.al (1984).

**xval**	
  number of cross-validations.

**surrogatestyle**	
  controls the selection of a best surrogate. If set to 0 (default) the program uses the total number of correct classification for a potential surrogate variable, if set to 1 it uses the percent correct, calculated over the non-missing values of the surrogate. The first option more severely penalizes covariates with a large number of missing values.

**maxdepth**	
  Set the maximum depth of any node of the final tree, with the root node counted as depth 0. Values greater than 30 rpart will give nonsense results on 32-bit machines.

```{r}
set.seed(123)
fit <- rpart(survived ~ ., data = train, method = 'class',control = rpart.control(cp = .0001))
fit
rpart.plot(fit,cex=.8,nn=T, extra=104)
printcp(fit)
test$pred <- predict(fit, test, type = "class")
table(test$pred,test$survived)
accuracy1 <- mean(test$pred == test$survived)
plotcp(fit)
```


### Prune the tree

We initially grow the tree using a very low value of cp. The tree fully grows and then we prune it back to avoid overfitting. We use the lowest value of cp.      

```{r}
prunetree2 = prune(fit, cp=0.005)
printcp(prunetree2)
rpart.plot(prunetree2, cex=.8,nn=T, extra=104)
test$pred <- predict(prunetree2, test, type = "class")
accuracy1 <- mean(test$pred == test$survived)
table(test$pred,test$survived)
```

## CHAID 

Chi-square automatic interaction detector

Both are decision tree kind of algorithms but have a different way of deciding splits.

While CART can only handle binary response variable, CHAID can produce multiple branches of a single root/parent node. 
While CART uses training data to train the model and then checks the accuracy on test data, CHAID runs on one dataset only. 
In CART, the entire tree is grown and then its pruned back to get the ideal tree while CHAID uses statistical significance(Chi square test of idependence) to decide where to stop.Using a pre-specified significance level, if the test shows that the splitted variable and the response are independent, the algorithm stops the tree growth.

```{r}
install.packages("CHAID", repos="http://R-Forge.R-project.org")
#you may need partykit from CRAN also
library(CHAID)  #library for performing CHAID decision tree
data(USvote)  #from lib CHAID
head(USvote)
str(USvote)
#Quick CHAID analysis
set.seed(101)
sample1 = USvote[sample(1:nrow(USvote), 1000),]
head(sample1)
str(sample1)
chaidModel <- chaid(vote3 ~ ., data = sample1, control=chaid_control(minbucket = 10, minsplit=20, minprob=0))
print(chaidModel)
plot(chaidModel)
```



## Random forest

Random forests are tree based algorithms and fall under the category called ensemble learning. They work on the concept of building lots of weak learners and then combining them to get the final output. They are based on bagging algorithm and uses a random set of rows and columns for each tree to avoid overfitting. The trees are allowed to grow deep and then the results from various trees are combined to give the final output.

```{r}
fit <- randomForest(survived ~ ., data = train,ntree=500,na.action = na.omit) #na.action = na.omit implies that the missing values in the data which are to be ignored use of this function
predicted= predict(fit,test)
table(predicted,test$survived)
varImpPlot(fit)
```

library(NbClust)
data(iris)
head(iris)
dim(iris)

data = iris[, -5] 

#Scaling the data --- (x - mean)/sd
normalized_data <- scale(data)
head(normalized_data)

set.seed(123)
fit =  kmeans(normalized_data, centers=3)

fit

#fit$cluster      # A vector of integers (from 1:k) indicating the cluster to which each point is allocated.
#fit$centers      # A matrix of cluster centres.
#fit$totss        # The total sum of squares.
#fit$withinss     # Vector of within-cluster sum of squares, one component per cluster.
#fit$tot.withinss # Total within-cluster sum of squares, i.e. sum(withinss).
#fit$betweenss    # The between-cluster sum of squares, i.e. totss-tot.withinss.
#fit$size         # The number of points in each cluster.
#fit$iter         # The number of (outer) iterations.

plot(iris,col = iris$Species)
plot(iris,col = fit$cluster)
#nstart is the number of sets of configurations to make for different samples
Cluster_Variability <- matrix(nrow=5, ncol=1)
for (i in 1:5) Cluster_Variability[i] <- kmeans(normalized_data,centers=i, nstart=4)$tot.withinss
plot(1:5, Cluster_Variability, type="b", xlab="Number of clusters", ylab="Within groups sum of squares") 

numclust = NbClust(data, distance="euclidean",min.nc=2, max.nc=15, method="average")  

table(iris$Species,fit$cluster)

#Missing Values Treatment
---
  title: "Missing values"
author: "Nikhlesh Daga"
date: "2/22/2019"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

Missing value treatment is an important step in any modeling exercise. While some of the algorithms can handle missing values well, others cannot. We cannot always just remove the rows or columns because getting data is a costly and time consuming exercise.


## Required packages

```{r,warning=FALSE}
library(Hmisc)
library(rpart)
library(DMwR)
library(mice)
```

## Read in the data


```{r}
path = 'https://raw.githubusercontent.com/nikhlesh17/Training/master/titanic.csv'
titanic <- read.csv(path)
```
#sum(is.na(titanic$age)) ---- This functions gives the value of number of missing values in the particular function

```{r}
sapply(titanic,function(x) sum(is.na(x))) # apply family is the substitute for "for loops"
mean(titanic$age)
mean(titanic$age,na.rm = T) # na.rm function is used to remove the missing values and continue with the function
complete.cases(titanic)  # which row have complete data in T/ F
sum(complete.cases(titanic))  # no of rows have which no missing data
sum(!complete.cases(titanic))  # no of rows which have missing data
titanic_cc <- titanic[complete.cases(titanic),]  #rows which are complete
titanic_ncc <- titanic[!complete.cases(titanic),] #rows which have missing values
str(titanic_cc)
str(titanic_ncc)
```

## Missing value mechanisms

**Missing completely at random (MCAR)**: data are missing independently of both observed and unobserved data; such cases can be thrown out without biasing the results
Example: a student is absent due to accident on way to school.

**Missing at random (MAR)**: nonresponse depends on the information in the available data
Example: the chance of "income" data missing varies by age, gender, etc., information on which are recorded.

**Missing Not at Random (MNAR)**: missing observations related to values of missing data themselves 
Example 1: A student is absent in a test because he is a bad student and/or has not prepared well. Missingness depends on the unobserved score in the test he is absent.

Its very easy to ignore the MCAR data but for MNAR, we need to understand the reason behind missingness and fix accordingly.

## Major ways of handling missing values

1. **Delete the variable**
  
  If we have enough data available and the column in question is not an important column, we can just go ahead and delete the corresponding column or do not include that column in your analysis.

2. **Delete the rows**
  
  Once again, if we have enough data available, we can delete the rows with missing data or do not include them in our analysis. 

3. **Imputation with mean/median values**
  
  In this technique, we impute the missing values with mean/median values. In some cases, we might want to impute with median values e.g. when the data is skewed.


```{r}
impute(titanic$age,mean) # imputes the mean value to the missing value; it can be observed with asterick on those values 
impute(titanic$age,median)
impute(titanic$age,100)   # Specific value
```

4. **KNN imputation**
  
  This method make use of K nearest neighbors concept. For every value to be imputed, the algorithm identifies the k nearest neighbor based on euclidean distance and impute sthe value based on weighted average. We can impute multiple columns at one go but we also need to be careful that we ar enot using the response variable while imputing.

```{r}
library(DMwR)
knnOutput <- knnImputation(titanic[, !names(titanic) %in% "survived"])  
anyNA(knnOutput)
```

5. **MICE**
  
  MICE or multivariate Imputation by Chained equations is one step ahead with missing value treatment. It uses the mice() function to produce multiple copies of the dataframe, each with different imputations of the data. The complete() function returns the imputed data and we can select one of them as the complete data.

```{r}
# takes time to run
#mice1 <- mice(titanic[, !names(titanic) %in% "survived"], method="rf")  # perform mice imputation, based on random forests.
#This is where we can see the values
#mice1$imp$age
# Pick the one which seems fine 
#miceOutput <- complete(mice1,1)  # generate the completed data(by default first)
#anyNA(miceOutput)
```
References - 
  
  https://www.r-bloggers.com/missing-value-treatment/