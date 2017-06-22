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

strsplit(combi$Name[1], split='[,.]')[[1]][2] #  []: regular expressions

combi$Title <- sapply(combi$Name, FUN = function(x) {strsplit(x, split='[,.]')[[1]][2]})
# delete space at the begining of Titles
combi$Title <-sub(' ', '', combi$Title)

# %in% checks to see if a value is part of the vector

combi$Title[combi$Title %in% c('Mme', 'Mlle')] <- 'Mlle' 
