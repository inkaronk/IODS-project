# Inka Ronkainen, 10.11.2021
# Data wrangling for IODS-course
data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
str(data)
dim(data)
#Data has 60 columns and 183 rows.
library(dplyr)
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
deep_columns <- select(data, one_of(deep_questions))
data$deep <- rowMeans(deep_columns)
surface_columns <- select(data, one_of(surface_questions))
data$surf <- rowMeans(surface_columns)
strategic_columns <- select(data,one_of(strategic_questions))
data$stra <- rowMeans(strategic_columns)

keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
data1 <- select(data, one_of(keep_columns))
str(data1)
data1 <- filter(data1, Points > 0)
str(data1)

write.csv(data1,"C:/LocalData/inkaronk/IODS-project/learning.2014csv", row.names = FALSE)
data2 <- read.csv(file = "C:/LocalData/inkaronk/IODS-project/learning.2014csv", header = TRUE)
