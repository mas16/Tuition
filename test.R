setwd("/Users/matthewstetz/Documents/Projects/Tuition/")
tuition <- read.csv("./tuition.csv", header=TRUE, colClasses=rep("numeric",8))
tuition <- data.frame(tuition)

colnames(tuition)

# Fit Models
test <- list(NA)
for (i in seq(ncol(tuition[, -1]))) {
        test[[i]] <- lm(tuition[, i+1] ~ Date, data=tuition)
}


