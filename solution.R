library(reclin)

# Read the exercise data. We assume that the data is stored in a folder `data`
# in the current working directory. Change path to data if necessary.
cis <- read.csv("data/cis.csv", stringsAsFactors = FALSE)
census <- read.csv("data/census.csv", stringsAsFactors = FALSE)




# Exercise 1 ---------------------------------------------------------------

# a 
p <- pair_blocking(census, cis, blocking_var = "enumcap", large = FALSE)

nrow(census)*nrow(cis)


# b 
p <- compare_pairs(p, by = c("pername1", "pername2", "dob_day", "dob_mon",
  "dob_year"))

# c 
p <- score_simsum(p)


# d
table(p$simsum)
p[p$simsum == 3,]
census[19, ]
cis[13589,]

p[p$simsum == 2,]
census[3, ]
cis[19868,]

# We have an id for some records:
p <- add_from_x(p, id_x = "person_id")
p <- add_from_y(p, id_y = "person_id")
p$true <- p$id_x == p$id_y

prop.table(table(p$simsum, p$true),1)
# In case of simsum == 3 we still only make 3% errors; below that the fraction
# of errors increases strongly

# e 
p <- select_threshold(p, threshold = 2.9, var = "select")
table(p$select, p$true)



# Exercise 2 --------------------------------------------------------------

# a
m <- problink_em(p)
m
summary(m)

m$p


# b
p <- score_problink(p, model = m, var = "em")

# c
# We can use small set for which we know the true match status to tabulate the
# number of error for decreasing threshold:
tab <- table(p$em, p$true)
tab[,1] <- rev(cumsum(rev(tab[,1])))
tab[,2] <- rev(cumsum(rev(tab[,2])))
prop.table(tab, 1)
# With a threshold of 0 we have 5% of errors: is that ok? 
# A more extensive analyses would compare the number of missed links and the 
# number of false links. Here we now only look at the false links. 

# d
p <- select_n_to_m(p, threshold = 0, weight = "em", var = "select_em")
table(p$select_em, p$true)




# Exercise 3 --------------------------------------------------------------

# a
p <- compare_pairs(p, by = c("pername1", "pername2", "dob_day", "dob_mon",
  "dob_year"), comparators = list(pername1 = jaro_winkler(0.85), 
    pername2 = jaro_winkler(0.85)), overwrite = TRUE)


#b 
m <- problink_em(p)
p <- score_problink(p, model = m, var = "em_stringdist")

p <- select_n_to_m(p, threshold = 2.9, var = "select_stringdist", 
  weight = "em_stringdist")
table(p$select_stringdist, p$true)
# Similar number of errors as before

# We could probably lower the threshold to get better performance:
p <- select_n_to_m(p, threshold = 0, var = "select_stringdist", 
  weight = "em_stringdist")
table(p$select_stringdist, p$true)




# Exercise 4 --------------------------------------------------------------



mglm <- glm(true ~ pername1 + pername2 + dob_day + dob_mon + dob_year,
  data = p, family = binomial())
p$pglm <- predict(mglm, newdata = p, type = "response")
p <- select_n_to_m(p, threshold = 0.5, var = "select_glm", 
  weight = "pglm")
# This gives an error because we have missing values in some of the predictors
# this in turn results in missing values in the predicted scores which 
# select_n_to_m does not like. 
summary(p)
# We have missing values in the dob fields -> impute
p$dob_day2 <- ifelse(is.na(p$dob_day), FALSE, p$dob_day)
p$dob_mon2 <- ifelse(is.na(p$dob_mon), FALSE, p$dob_mon)
p$dob_year2 <- ifelse(is.na(p$dob_year), FALSE, p$dob_year)

mglm <- glm(true ~ pername1 + pername2 + dob_day2 + dob_mon2 + dob_year2,
  data = p, family = binomial())
p$pglm <- predict(mglm, newdata = p, type = "response")
p <- select_n_to_m(p, threshold = 0.5, var = "select_glm", 
  weight = "pglm")

table(p$select_glm, p$true)
# Probably a lower threshold would help


