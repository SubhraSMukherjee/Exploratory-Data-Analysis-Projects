
library('fastDummies')
library(dplyr)



housing_anywhere_data <- read.csv("C://Users/subhr/Downloads/Ha_Data_Clean.csv")
head(housing_anywhere_data)
colnames(housing_anywhere_data)
unique(housing_anywhere_data$balcony)


housing_anywhere_data_dummies <- dummy_cols(housing_anywhere_data, select_columns = c('category','furnished','registration_possible','washing_machine','tv','balcony','garden','terrace'))
columns_to_keep <- c('price','total_size', 'category_Apartment',  'category_Private Room',  'category_Studio',
                     'furnished_no', 'furnished_yes'
                     ,'registration_possible_no','registration_possible_yes','tv_no','tv_yes',
                     'balcony_no','balcony_private','balcony_shared',
                     'garden_no','garden_private','garden_shared',
                     'terrace_no','terrace_private','terrace_shared')

housing_anywhere_data_dummies <- housing_anywhere_data_dummies[columns_to_keep]
linear_model <- lm(as.numeric(housing_anywhere_data_dummies$price)~.,housing_anywhere_data_dummies)
summary(linear_model)
  