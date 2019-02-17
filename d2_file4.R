#Modelling
# Linear Regression - Simple, Multiple
#y ~ x1 (SLR); y ~ x1 + x2 ...(MLR)
# y ~ Dependent Variable; x ~ Independent Variable

head(women)
# y ~ Weight ; x ~ Height
cor(women$height, women$weight) #Determines the strength and direction of relationship; value 1 denotes strongly related
cov(women$height, women$weight) #Defines the direction of the relation either positive/Negative; doesnt matter the magnitude
plot(women$height, women$weight)
#linear modelling
fit1 = lm(weight ~ height, data = women)
summary (fit1)
# F stats p-Value << 0.05 : linear model exists
# at least one Independent variable is significant in predicting Dependent variable
# Multiple Rsquare = .991 Coefficient of determination & Adjusted Rsquare is used when there is more than Independent Variable
# 99% of the variation in Y is explained by X.
# y = mx + c; y = - 87.5 + 3.45 * Height for women data

range(women$height)
# only interpolation in the range can only be executed and not extrapolation
(y = - 87.5 + 3.45 * women$height) 
# predicted weights for actual heights
women$weight
fitted(fit1)
residuals(fit1) # difference between predicted and actual weights
summary(residuals(fit1))
summary(students$gender)
summary(students$marks1)
(newdata1 = data.frame(height = c(60.4, 55.9))) # creating data frame with the desired heights
(p1 = predict(fit1, newdata = newdata1, type = 'response')) #weights being calculated for respective heights
cbind(newdata1, p1) # cbind: column bind is used to bind the data as data frame format similarly it can be done for row binding as well
#check for assumptions of Linear Regression