# DataScience


customer churn problem


a.The data about telecommunications churn  analysed. Observations on 3333 of 20 Variables clients are analysed.
Training Set and Test Set are subsets derived from the original data.


b.Varibles 
'state' 'account_length' 'area_code' 'international_plan' 'voice_mail_plan' 'number_vmail_messages' 'total_day_minutes' 'total_day_calls' 'total_day_charge' 'total_eve_minutes' 'total_eve_calls' 'total_eve_charge' 'total_night_minutes' 'total_night_calls' 'total_night_charge' 'total_intl_minutes' 'total_intl_calls' 'total_intl_charge' 'number_customer_service_calls'

c.Repeated cross-validation “repeatedcv” has nice bias-variance properties, so we’ll use 5 repeats of 10-fold cross-validation there are 50 resampled data sets being evaluated.


d.Using train() function we can specify the response, predictors, the modelling technique (in this case boosting), the metric for calculate sensitivity and specificity. In this case we have a binary outcomes and we models the probability that y="yes" for the churn dataset

e.Evaluate the performance using ROC curve.