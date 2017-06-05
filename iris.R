library(readr)
iris <- read_csv("iris.csv")
tapply(iris$Petal.Length,iris$Species,mean)
