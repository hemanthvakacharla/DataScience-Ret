library(data.table)
library(dplyr)
library(ggplot2)
#library(stringr)
#library(DT)
library(tidyr)
library(knitr)
library(rmarkdown)
##Load Dataset
##First, Lets we Load & Examine Dataset

df_data <- fread('../input/data.csv')
glimpse(df_data)
## Observations: 541,909
## Variables: 8
## $ InvoiceNo   <chr> "536365", "536365", "536365", "536365", "536365", ...
## $ StockCode   <chr> "85123A", "71053", "84406B", "84029G", "84029E", "...
## $ Description <chr> "WHITE HANGING HEART T-LIGHT HOLDER", "WHITE METAL...
## $ Quantity    <int> 6, 6, 8, 6, 6, 2, 6, 6, 6, 32, 6, 6, 8, 6, 6, 3, 2...
## $ InvoiceDate <chr> "12/1/2010 8:26", "12/1/2010 8:26", "12/1/2010 8:2...
## $ UnitPrice   <dbl> 2.55, 3.39, 2.75, 3.39, 3.39, 7.65, 4.25, 1.85, 1....
## $ CustomerID  <int> 17850, 17850, 17850, 17850, 17850, 17850, 17850, 1...
## $ Country     <chr> "United Kingdom", "United Kingdom", "United Kingdo...
##Data Cleaning
##Delete all negative Quantity and Price. We also need to delete NA customer ID

df_data <- df_data %>% 
  mutate(Quantity = replace(Quantity, Quantity<=0, NA),
         UnitPrice = replace(UnitPrice, UnitPrice<=0, NA))

df_data <- df_data %>%
  drop_na()
##Recode variables
##We should do some recoding and convert character variables to factors.

df_data <- df_data %>% 
  mutate(InvoiceNo=as.factor(InvoiceNo), StockCode=as.factor(StockCode), 
         InvoiceDate=as.Date(InvoiceDate, '%m/%d/%Y %H:%M'), CustomerID=as.factor(CustomerID), 
         Country=as.factor(Country))

df_data <- df_data %>% 
  mutate(total_dolar = Quantity*UnitPrice)

glimpse(df_data)
## Observations: 397,884
## Variables: 9
## $ InvoiceNo   <fctr> 536365, 536365, 536365, 536365, 536365, 536365, 5...
## $ StockCode   <fctr> 85123A, 71053, 84406B, 84029G, 84029E, 22752, 217...
## $ Description <chr> "WHITE HANGING HEART T-LIGHT HOLDER", "WHITE METAL...
## $ Quantity    <int> 6, 6, 8, 6, 6, 2, 6, 6, 6, 32, 6, 6, 8, 6, 6, 3, 2...
## $ InvoiceDate <date> 2010-12-01, 2010-12-01, 2010-12-01, 2010-12-01, 2...
## $ UnitPrice   <dbl> 2.55, 3.39, 2.75, 3.39, 3.39, 7.65, 4.25, 1.85, 1....
## $ CustomerID  <fctr> 17850, 17850, 17850, 17850, 17850, 17850, 17850, ...
## $ Country     <fctr> United Kingdom, United Kingdom, United Kingdom, U...
## $ total_dolar <dbl> 15.30, 20.34, 22.00, 20.34, 20.34, 15.30, 25.50, 1...
##Calculate RFM
##To implement the RFM analysis, we need to further process the data set in by the following steps:

##Find the most recent date for each ID and calculate the days to the now or some other date, to get the Recency data
##Calculate the quantity of translations of a customer, to get the Frequency data
##Sum the amount of money a customer spent and divide it by Frequency, to get the amount per transaction on average, that is the Monetary data.
df_RFM <- df_data %>% 
  group_by(CustomerID) %>% 
  summarise(recency=as.numeric(as.Date("2012-01-01")-max(InvoiceDate)),
            frequenci=n_distinct(InvoiceNo), monitery= sum(total_dolar)/n_distinct(InvoiceNo)) 

summary(df_RFM)

kable(head(df_RFM))

##Recency
##Recency – How recently did the customer purchase?

hist(df_RFM$recency)


##Frequency
##Frequency – How often do they purchase?

hist(df_RFM$frequenci, breaks = 50)


##Monetary
##Monetary Value – How much do they spend?

hist(df_RFM$monitery, breaks = 50)
##Because the data is realy skewed, we use log scale to normalize

df_RFM$monitery <- log(df_RFM$monitery)
hist(df_RFM$monitery)


##Clustering
df_RFM2 <- df_RFM
row.names(df_RFM2) <- df_RFM2$CustomerID
## Warning: Setting row names on a tibble is deprecated.
df_RFM2$CustomerID <- NULL

df_RFM2 <- scale(df_RFM2)
summary(df_RFM2)

plot(c)


##Cut
members <- cutree(c,k = 8)

members[1:5]
## 12346 12347 12348 12349 12350 
##     1     2     2     1     3
table(members)
## members
##    1    2    3    4    5    6    7    8 
##  255 1878  368  404 1092  319    2   20
aggregate(df_RFM[,2:4], by=list(members), mean)