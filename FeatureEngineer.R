library(readr)

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

## Fearther: passenger’s title
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

## Feather: family size
# add the number of siblings, spouses, parents and children
combi$FamilySize <- combi$SibSp + combi$Parch + 1
# add family names
combi$Surname <- sapply(combi$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
# combine family names with sizes
combi$FamilyID <- paste(combi$FamilySize, combi$Surname, sep="")
