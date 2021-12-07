# Inka Ronkainen, 7.12.2021
# Chapter 6: Data wrangling for IODS-course

library(dplyr)
library(tidyr)

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

colnames(BPRS)
# "treatment" "subject"   "week0"     "week1"     "week2"    "week3"     "week4"     "week5"     "week6"     "week7"    "week8"    
colnames(RATS)
# "ID"    "Group" "WD1"   "WD8"   "WD15"  "WD22"  "WD29"  "WD36" "WD43"  "WD44"  "WD50"  "WD57"  "WD64" 

glimpse(BPRS)
glimpse(RATS)
str(BPRS)
str(RATS)

#First row has column names and information comes after that. In Long format we want column names on the top row, so information comes below the variable names.

write.csv(BPRS,"C:/LocalData/inkaronk/IODS-project/BPRS.csv", row.names = T)
write.csv(RATS,"C:/LocalData/inkaronk/IODS-project/RATS.csv", row.names = T)

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

glimpse(BPRS) #Rows: 40, columns: 11
glimpse(BPRSL) #Rows: 360, columns: 5
glimpse(RATS) #Rows: 13, columns: 13
glimpse(RATSL) #Rows: 176, columns: 5

colnames(BPRSL)
#"treatment" "subject"   "weeks"     "bprs"      "week"     
colnames(RATSL)
#"ID"     "Group"  "WD"     "Weight" "Time"  

#Changing the form gathers multiple variables into one. Using long and wide formats is already clear to me, since I work with them on a daily basis.