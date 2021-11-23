
library(reclin)

# Read the exercise data. We assume that the data is stored in a folder `data`
# in the current working directory. Change path to data if necessary.
cis <- read.csv("data/cis.csv", stringsAsFactors = FALSE)
census <- read.csv("data/census.csv", stringsAsFactors = FALSE)



# Datasets are from ESSnet on Data Integration:
# https://ec.europa.eu/eurostat/cros/content/essnet-di-fictitious-data-ons-job-training-record-linkage_en
#
# These totally fictional data sets are supposed to have captured details of
# persons up to the date 31 December 2011.  Any years of birth captured as 2012
# are therefore in error.  Note that in the fictional Census data set, dates of
# birth between 27 March 2011 and 31 December 2011 are not necessarily in error.
#
# Census: A fictional data set to represent some observations from a
#         decennial Census
# CIS: Fictional observations from Customer Information System, which is
#         combined administrative data from the tax and benefit systems
# 
#
# In the dataset census all records contain a person_id. For some of the records
# in cis the person_id is also available. This information can be used to
# evaluate the linkage (assuming these records from the cis are representable 
# all records in the cis). 



# Exercise 1 --------------------------------------------------------------

# Link the two datasets:
#
# a. block on enumpc
# How many pairs would be generated without blocking? 
#
# b. compare on pername1, pername2, sex, dob_*
# 
# c. score the pairs using the total comparison score (simsum)
#
# Optional:
# 
# d. determine an appropriate threshold
# 
# e. evaluate the linkage


# To help you get started: below are the functions used in the demo with their 
# most important argument:
# 
# pair_blocking(., ., blocking_var = ., large = FALSE)
# compare_pairs(., by = .)
# score_simsum(.)
# select_threshold(., threshold = ., var = .)
# add_from_x(., . = .)
# add_from_y(., . = .)





# Exercise 2 --------------------------------------------------------------

# Use the pairs from the previous exercise. 
#
# a. Estimate the EM-model
# According to the model, which percentage of the pairs are matches? 
# Which variable contains the least amount of errors according to the model?
#
# b. Calculate the weighs for each pair
#
# c. determine an appropriate threshold
# 
# d. evaluate the linkage




# To help you get started: below are the functions used in the demo with their 
# most important argument:
# 
# tabulate_patterns(.)
# problink_em(.)
# score_problink(., model = ., var = .)
# select_n_to_m(., threshold = ., weight = ., var = .)





# Exercise 3 --------------------------------------------------------------

# Use the pairs from the previous exercise. 
#
# a. Compare the text fields (pername1, pername2) using a string similarity 
# function. Use Jaro-Winkler with a threshold of 0.85
#
# b. Run the EM-algorithm, use the same threshold as in the previous exercise
# and evaluate the linkage.


# To help you get started: below are the functions used in the demo with their 
# most important argument:
# 
# compare_pairs(., by = ., comparators = list(.))
# jaro_winkler(.)





# Exercise 4 --------------------------------------------------------------

# Continue with the data from the previous exercise

# Use a machine learning (regression) model to classifiy the pairs into 
# matches and non-matches. You can use glm like in the demo, or you can use 
# another classification method. 
#
# Evaluate the performance





# Warning: there are some missing values in some of the dob variables. 
# For some regression/ML methods this will result in predicted missing values
# which select_n_to_m does not like. You can derive new variables without 
# missing values. Remember: the pairs object is just a regular data.frame. 
# For example:
# p$dob_day2 <- ifelse(is.na(p$dob_day), FALSE, p$dob_day)
# p$dob_mon2 <- ifelse(is.na(p$dob_mon), FALSE, p$dob_mon)
# p$dob_year2 <- ifelse(is.na(p$dob_year), FALSE, p$dob_year)













