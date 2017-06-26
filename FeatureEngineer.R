library(readr)
library(rpart) 
library(rpart.plot)

# set working directory
setwd("~/Documents/Projects/R_projects")

# import data
train <- read_csv("train.csv")
test <- read_csv("test.csv")

train$Name[1]

test$Survived <- NA

# combine the rows in train and test
combi <- rbind(train,test)

# cast names back to strings
# combi$Name <- as.character(combi$Name)
# combi$Name[1]

## Feature 1: passenger’s title
strsplit(combi$Name[1], split='[,.]')[[1]][2] #  []: regular expressions
combi$Title <- sapply(combi$Name, FUN = function(x) {strsplit(x, split='[,.]')[[1]][2]})
# delete space at the begining of Titles
combi$Title <-sub(' ', '', combi$Title)
table(combi$Title)

# combine Mme and Mlle since they are similar
#combi$PassengerId[combi$Title %in% c('Mme', 'Mlle')]
combi$Title[combi$Title %in% c('Mme', 'Mlle')] <- 'Mlle' 
#combi$PassengerId[combi$Title %in% c('Mlle')]
##%in%: element-wise logical OR operator
##c(): combine values into a vector or list

# combine rich men and women
#combi$PassengerId[combi$Title %in% c('Capt', 'Don', 'Major', 'Sir')]
combi$Title[combi$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
#combi$PassengerId[combi$Title %in% 'Sir']
combi$Title[combi$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'

## Feature 2: family size
# add the number of siblings, spouses, parents and children
combi$FamilySize <- combi$SibSp + combi$Parch + 1
# add family names
combi$Surname <- sapply(combi$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
# combine family names with sizes
combi$FamilyID <- paste(combi$FamilySize, combi$Surname, sep="")

# combine the IDs for small families
combi$FamilyID[combi$FamilySize < 3] <- 'Small'
table(combi$FamilyID) # some small families slip through the trimming

# convert table to a data frame and trim the small families
famIDs <- data.frame(table(combi$FamilyID))
# only keep the ones with small family size
famIDs <- famIDs[famIDs$Freq <= 2,]

combi$FamilyID[combi$FamilyID %in% famIDs$Var1] <- 'Small'
# convert FamilyID to factor
# factors are categorical variables which take on a limited number of different values;
# categorical variables enter insures the correct process of data by statistical modeling functions
combi$FamilyID <- factor(combi$FamilyID)

# split the data in combi back to train and test data
train <- combi[1:891,]
test <- combi[892:1309,]
# test factor
table(combi$FamilyID)
table(combi$train)
table(combi$test)

# generate survival information
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID,
             data=train,
             method="class")
# plot the decision tree
# plot(fit) # text(fit)
rpart.plot(fit)

# generate survival vector for test data using prediction in fit 
Survived <- predict(fit, test, type = "class")

# generate csv file which contains passeger Ids and survived data
submit <- data.frame(PassengerId = test$PassengerId, Survived)
write.csv(submit, file = "featureengineer.csv", row.names = FALSE)

