library(readr)

# set working directory
setwd("~/Documents/Projects/R_projects")

# import training set
train <- read_csv("train.csv")

table_train_survived <- table(train$Survived) # table: runs through given vector 
                                              #        and counts occurrence of each value
prop.table(table_train_survived) # proportion table command (default): divides each entry 
                                 #                                     by the total number
## check sex difference for survival rate
table(train$Sex)
prop.table(table(train$Sex, train$Survived),1) # generate proportions in 1st dimension 
                                               # (1 for rows,  2 for column)

## check age difference for survival rate
summary(train$Age)
# create a new variable: Child
train$Child <- 0
train$Child[train$Age < 18] <- 1
# aggregate: subsets dataframe over different possible combinations of age and gender variables 
# and applies sum function to Survived vector for each of these subsets.
aggregate(Survived ~ Child+Sex, data=train, FUN=sum)
aggregate(Survived ~ Child+Sex, data=train, FUN=length)
aggregate(Survived ~ Child+Sex, data=train, FUN=function(x) {sum(x)/length(x)})

## check fare differnce for survival rate
train$Fare2 <- '30+'
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$Fare2[train$Fare < 10] <- '<10'
aggregate(Survived ~ Fare2+Pclass+Sex, data=train, FUN = function(x) {sum(x)/length(x)})

## generate prediction 
# import test set
test <- read_csv("test.csv")
# add survival (prediction) column: everyone died
test$Survived <- 0  # test$Survived <- rep(0, 418)
# change survival column: all females survived
test$Survived[test$Sex == 'female'] <- 1  # []: a subset of total dataframe
# change survival column: females in class 3 and paid more than 20 died
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0

# generate csv file which contains passeger Ids and survived data
# and can be submitted to kaggle
submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file = "titanic_survival_prediction.csv", row.names = FALSE)

