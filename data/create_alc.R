# Inka Ronkainen, 19.11.2021
# Logistic regression, data wrangling
# Data: student alcohol consumption in Portugal
# Data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

math <- read.csv(file = "C:/LocalData/inkaronk/IODS-project/student-mat.csv", sep = ";", header = TRUE)
por <- read.csv(file = "C:/LocalData/inkaronk/IODS-project/student-por.csv", sep = ";", header = TRUE)
str(math)
str(por)
dim (math)
dim(por)

library(dplyr)
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

free_cols <- c("id","failures","paid","absences","G1","G2","G3")
join_cols <- setdiff(colnames(por_id),free_cols)
pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

pormath <- por_id %>% 
  bind_rows(math_id) %>%
  group_by(.dots=join_cols) %>%  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     
    paid=first(paid),                   
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  filter(n==2, id.m-id.p>650) %>%  
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
  )

str(pormath)
dim(pormath)

colnames(pormath)
alc <- select(pormath, one_of(join_cols))

notjoined_columns <- colnames(math)[!colnames(math) %in% join_cols]

notjoined_columns

for(column_name in notjoined_columns) {
  two_columns <- select(pormath, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else { 
    alc[column_name] <- first_column
  }
}

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)

write.csv(alc,"C:/LocalData/inkaronk/IODS-project/joindata.csv", row.names = FALSE)
