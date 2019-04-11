library(dplyr)

collect_res = function(in_path, out_path){
  files = list.files(in_path, full.names=TRUE)
  get_res = function(f){load(f); return(res)}
  X = list()
  for(f in files){ X[[f]] = get_res(f) }
  X = do.call(rbind, X)
  rownames(X) = NULL
  save(X, file=out_path)
  X
}

envi = collect_res('~/Projects/isospec/tests/envipat_res',
                   '~/Projects/isospec/tests/envipat_runtimes.Rd')
plot(X$a1, X$a2, pch='.', asp=1)
abline(0,1,col='red')

iso = collect_res(
  '~/Projects/isospec/tests/isospecr_old_res',
  '~/Projects/isospec/tests/isospecr_old_runtime.Rd')
# C++ results
X = read.table('~/Projects/isospec/tests/C/res.txt')
X$V3 = NULL
X$V2 = 1000000 * X$V2
colnames(X) = c('formula', 'time')
save(X, file='~/Projects/isospec/tests/isospecpp_onetime_run.Rd')


#
runtimes = full_join(envi, iso, by='formula')
save(runtimes,
     file='~/Projects/isospec/tests/runtimes.Rd')

# R = runtimes[1:20,]
# plot(log(R$a1), log(R$t_med), asp=1, pch='.')
# abline(0,1, col='red')
# plot(log(R$a1), log(R$a1) - log(R$t_med), asp=1)

load('~/Projects/isospec/tests/envipat_runtimes.Rd')
envi = as_tibble(X)
load('~/Projects/isospec/tests/isospecr_old_runtime.Rd')
iso_old = as_tibble(X)
load('~/Projects/isospec/tests/isospecpp_onetime_run.Rd')
iso_new = as_tibble(X)

W = full_join(evni, iso_new, by='formula')
W = as_tibble(W)

plot(log(W$time), log(W$a1), pch='.', asp=1)
abline(0,1, col='red')

plot(log(W$time), log(W$a1/W$time), pch='.')
library(ggplot2)
ggplot(W, aes(x=time, y=a1/time)) + geom_point(size=.1) +
  scale_x_log10() +
  scale_y_log10()

sum(!complete.cases(W$time))
sum(!complete.cases(W$a1))
sum(!complete.cases(W$a2))

plot(Y$t_med, Y$t_med/ Y$time)


plot(log(Y$t_med), log(Y$time), asp=1)

