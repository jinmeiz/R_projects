library(readr)
library(rpart) # rpart: Recursive Partitioning and Regression Trees
library(rpart.plot)

# set working directory
setwd("~/Documents/Projects/R_projects")

# import training and test set
train <- read_csv("train.csv")
test <- read_csv("test.csv")

# generate survival information
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
             data=train,
             method="class")
# plot the decision tree
# plot(fit) # text(fit)
rpart.plot(fit)

# generate survival vector for test data using prediction in fit 
Survived <- predict(fit, test, type = "class")

# generate csv file which contains passeger Ids and survived data
submit <- data.frame(PassengerId = test$PassengerId, Survived)
write.csv(submit, file = "myfirst_decisiontree.csv", row.names = FALSE)

