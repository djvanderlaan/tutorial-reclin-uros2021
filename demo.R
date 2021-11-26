# Below the code I typed in during the online tutorial


library(reclin)

dta1 <- read.csv("data/example1.csv", stringsAsFactors = FALSE)
dta2 <- read.csv("data/example2.csv", stringsAsFactors = FALSE)

head(dta1)
head(dta2)

p <- pair_blocking(dta1, dta2)
head(p)

nrow(dta1)*nrow(dta2)

p <- pair_blocking(dta1, dta2, large = FALSE)
p
head(p)

p <- pair_blocking(dta1, dta2, large = FALSE, blocking_var = "dobyear")
p

p <- compare_pairs(p, by = c("firstname", "lastname", "sex", "dobday",
  "dobmon", "postcode"))
p

p <- score_simsum(p)
table(p$simsum)

p[p$simsum == 4, ]

dta1[22, ]
dta2[2131,]

p <- select_threshold(p, threshold = 3.9, 
  var = "selected", weight = "simsum")

p <- add_from_x(p, id_x = "id")
p <- add_from_y(p, id_y = "id")
p

p$true <- p$id_x == p$id_y

table(p$selected, p$true)

#13:20

tabulate_patterns(p)

m <- problink_em(p)
m
summary(m)

p <- score_problink(p, model = m, var = "em")

#p <- score_problink(p, model = m, var = "em", type = "all")

p <- select_threshold(p, threshold = 3.8, 
  weight = "em", var = "select_em")

table(p$selected, p$true)

table(p$select_em, p$true)


dta1[22, ]
dta2[2131,]
dta2[2132,]

?jaro_winkler
jw <- jaro_winkler()
jw(dta1$firstname[22], dta2$firstname[2131])
jw(dta1$firstname[22], dta2$firstname[2132])

jw <- jaro_winkler(0.85)
tmp <- jw(dta1$firstname[c(22,22)],
  dta2$firstname[c(2131,2132)])
jw(tmp)

jw <- jaro_winkler(0.85)
tmp <- jw(dta1$firstname[c(22,22,22)],
  c(dta2$firstname[c(2131,2132)], NA))
jw(tmp)

p <- compare_pairs(p, by = c("firstname", "lastname", "sex", "dobday",
  "dobmon", "postcode"), 
  comparators = list(
    firstname = jaro_winkler(0.85),
    lastname = jaro_winkler(0.9),
    sex = identical(),
    dobday = identical(),
    dobmon = identical(),
    postcode = lcs()
    ), overwrite = TRUE)


m <- problink_em(p)
m
summary(m)

p <- score_problink(p, model = m, var = "em")

#p <- score_problink(p, model = m, var = "em", type = "all")

p <- select_threshold(p, threshold = 4.2, 
  weight = "em", var = "select_em_stringdist")

table(p$select_em_stringdist, p$true)


m <- glm(true ~ firstname + lastname + 
    sex + dobday + dobmon + postcode, 
  family = binomial(), data = p)


p <- select_n_to_m(p, threshold = 3.8, 
  weight = "em", var = "select_n_to_m")


table(p$select_n_to_m, p$true)

result <- link(p, selection = "select_n_to_m",
  all_x = TRUE, all_y = TRUE)
head(result)


