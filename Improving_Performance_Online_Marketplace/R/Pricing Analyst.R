#install.packages("readxl")
library(readxl)
library(dplyr)
library(rmarkdown)

date_list <- seq(as.Date('2023-03-01'),as.Date('2023-05-31'),by = 1)
daily_clicks_aggregated <- data.frame()
daily_transaction_aggregated <- data.frame()


for (dates in date_list) {
  date=format(as.Date(dates,origin="1970-01-01"))
  path_clicks <- "C://Users/subhr/Downloads/Business_Case_1_(1st_interview)-20240522T130433Z-001/Business Case 1 (1st interview)/daily_clicks/daily_clicks/"
  daily_clicks <- read.csv(paste(path_clicks, date ,'.csv',sep=""))
  daily_clicks['date'] = as.Date(date)
  daily_clicks_aggregated <- rbind(daily_clicks_aggregated, daily_clicks)
}

write.csv(daily_clicks_aggregated, "C://Users/subhr/Downloads/Business_Case_1_(1st_interview)-20240522T130433Z-001/Business Case 1 (1st interview)/daily_clicks/daily_clicks_aggregated.csv", row.names = FALSE)

for (dates in date_list) {
  date=format(as.Date(dates,origin="1970-01-01"))
  path_transactions <- "C://Users/subhr/Downloads/Business_Case_1_(1st_interview)-20240522T130433Z-001/Business Case 1 (1st interview)/daily_transaction/daily_transaction/"
  daily_transaction <- read_excel(paste(path_transactions, date ,'.xlsx',sep=""))
  daily_transaction['date'] = as.Date(date)
  daily_transaction_aggregated <- rbind(daily_transaction_aggregated, daily_transaction)
}

write.csv(daily_transaction_aggregated, "C://Users/subhr/Downloads/Business_Case_1_(1st_interview)-20240522T130433Z-001/Business Case 1 (1st interview)/daily_transaction/daily_transaction_aggregated.csv",row.names = FALSE)

cols_continuous <- c('total_margin','channel_fee',
                     'total_purchase', 'ancillary_margin', 'commission', 'surcharge','overrides')

corr <- transaction_data_aggregated[cols_continuous] %>% cor(use = "pairwise.complete.obs") %>% round(3)
ggcorrplot(corr, hc.order = TRUE , type = "upper", ggtheme = ggplot2::theme_gray,
           lab = TRUE, colors = c('#6D9EC1', 'white','#E46726'))

