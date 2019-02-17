women
k1 =sample(x = 1: nrow(women), size = .7* nrow(women))
train1 = women[k1, ]
test1 = women[-k1, ]
nrow(train1)
nrow(test1)
nrow(train1) + nrow(test1)
train1
fit1 = lm(weight ~ height, data = train1)
summary(fit1)
p4= predict(fit1, newdata = test1, type = 'response')
cbind(p4, test1$weight)
# assign names to the columns as below
cbind(predicted = p4, actual = test1$weight)
