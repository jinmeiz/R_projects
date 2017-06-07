library(readr)

# set working directory
setwd("~/Documents/Projects/R_projects")

# import training set
train <- read_csv("train.csv")
table_train_survived <- table(train$Survived)
prop.table(table_train_survived)

# import test set and add a survived column
test <- read_csv("test.csv")
test$Survived <- rep(0, 418)

# generate csv file which contains passeger Ids and survived data
submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file = "theyallperish.csv", row.names = FALSE)

