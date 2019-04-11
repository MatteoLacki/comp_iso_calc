library(dplyr)
library(ggplot2)

load(file='~/Projects/isospec/tests/envipat_runtimes.Rd')
str(X)
X = tibble(formula=X$formula, a1=X$a1, a2=X$a2)

plot(X$a1, X$a2, pch='.', asp=1)
abline(a=0, b=1, col='red')
