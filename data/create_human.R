# Inka Ronkainen, 26.11.2021
# Data wrangling for IODS-course, chapter 4
library(dplyr)
library(stringr)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")
str(hd)
str(gii)
dim(hd)
dim(gii)
summary(hd)
summary(gii)

colnames(hd)
colnames(hd)[1] <- "HDI.R" #"HDI.Rank"
colnames(hd)[2] <- "COUNT" #"Country" 
colnames(hd)[3] <- "HDI" #"Human.Development.Index..HDI." 
colnames(hd)[4] <- "LEB" #"Life.Expectancy.at.Birth"
colnames(hd)[5] <- "EYE" #"Expected.Years.of.Education"
colnames(hd)[6] <- "MYE" #"Mean.Years.of.Education"    
colnames(hd)[7] <- "GNI" #"Gross.National.Income..GNI..per.Capita"
colnames(hd)[8] <- "GNI-HDI.R" #"GNI.per.Capita.Rank.Minus.HDI.Rank"  

colnames(gii)
colnames(gii)[1] <- "GII.R" #"GII.Rank" 
colnames(gii)[2] <- "COUNT" #"Country"
colnames(gii)[3] <- "GII" #"Gender.Inequality.Index..GII."    
colnames(gii)[4] <- "MMR" #"Maternal.Mortality.Ratio"
colnames(gii)[5] <- "ABR" #"Adolescent.Birth.Rate"
colnames(gii)[6] <- "PRP" #"Percent.Representation.in.Parliament"   
colnames(gii)[7] <- "PSE.F" #"Population.with.Secondary.Education..Female."
colnames(gii)[8] <- "PSE.M" #"Population.with.Secondary.Education..Male."  
colnames(gii)[9] <- "LFPR.F" #"Labour.Force.Participation.Rate..Female."  
colnames(gii)[10] <- "LFPR.M" #"Labour.Force.Participation.Rate..Male."

colnames(hd)
colnames(gii)

gii <- mutate(gii, PSE.R = (PSE.F / PSE.M))
gii <- mutate(gii, LFPR.R = (LFPR.F / LFPR.M))

human <- inner_join(hd, gii, by = "COUNT", suffix = c(".hd", ".gii"))
dim(human)

write.csv(human,"C:/LocalData/inkaronk/IODS-project/create_humancsv", row.names = FALSE)

# Continuing 2.12.2021
# Data wrangling for IODS-course, chapter 5
# The data is about human development and gender inequality.

str(human) # 195 obs. of  19 variables:
dim(human) # [1] 195  19

colnames(human)
# [1] "HDI.R"     "COUNT"     "HDI"       "LEB"       "EYE"      
#[6] "MYE"       "GNI"       "GNI-HDI.R" "GII.R"     "GII"      
#[11] "MMR"       "ABR"       "PRP"       "PSE.F"     "PSE.M"    
#[16] "LFPR.F"    "LFPR.M"    "PSE.R"     "LFPR.R"  

#These are shortened names from original dataset hd and gii:
# "HDI.Rank", "Country", "Human.Development.Index..HDI.", "Life.Expectancy.at.Birth", "Expected.Years.of.Education"
# "Mean.Years.of.Education", "Gross.National.Income..GNI..per.Capita", "GNI.per.Capita.Rank.Minus.HDI.Rank", "GII.Rank", "Gender.Inequality.Index..GII."    
# "Maternal.Mortality.Ratio", "Adolescent.Birth.Rate", "Percent.Representation.in.Parliament", "Population.with.Secondary.Education..Female.", Population.with.Secondary.Education..Male."  
# "Labour.Force.Participation.Rate..Female.", "Labour.Force.Participation.Rate..Male.", "Ratio of Female and Male populations with secondary education in each country", "Ratio of labour force participation of females and males in each country"

str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric
keep <- c("COUNT", "PSE.R", "LFPR.R", "EYE", "LEB", "GNI", "MMR", "ABR", "PRP")
human <- select(human, one_of(keep))
complete.cases(human)
data.frame(human[-1], comp = complete.cases(human))
human <- filter(human, complete.cases(human) == TRUE)
tail(human, 10)
last <- nrow(human) - 7
human_c <- human[1:last,]
rownames(human_c) <- human_c$COUNT
human_c <- select(human_c, -COUNT)

dim(human_c) # [1] 155   8 <- good!

write.csv(human_c,"C:/LocalData/inkaronk/IODS-project/create_humancsv", row.names = TRUE)
