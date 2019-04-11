# install.packages('enviPat')
# install.packages('IsoSpecR') 
# install.packages('microbenchmark')
# install.packages('jsonlite')
library('microbenchmark')
library('IsoSpecR')
library('enviPat')
library('jsonlite')
library('parallel')

# source('formula_parsers.R')
# source('wrappers_iso_envi.R')
data(isotopicData)

cores_no = 4L
# cores_no = 60L
path2formulas = '~/Projects/isospec/tests/formulas.json'
path2output = '~/Projects/isospec/tests/isospecr_old_res'
formulas = read_json(path2formulas, simplifyVector=T)

ff = formulas[1:100]
# ff = formulas
form = formulas[100]
form = formulas[69]

isotopes = isotopicData$IsoSpec
thr=0.0001

max_lprob = max(isospec(form, 0)[,"logProb"])

# do both pieces of software return the same outcomes?
abs_thr_from_rel = exp(log(thr) + max_lprob)
envi = envipat(form, rel_to=2, thr = abs_thr_from_rel)
iso = isospec(form, algo=2, thr = abs_thr_from_rel)
recol = colnames(iso)
recol[1:2] = colnames(envi)[1:2]
envi = envi[,recol]
envi_sorted = envi[do.call(order, as.data.frame(envi)),]
iso_sorted = iso[do.call(order, as.data.frame(iso)),]
all(apply(envi_sorted[,-(1:2)] == iso_sorted[,-(1:2)], 1, all))
dim(iso)

microbenchmark(iso = isospec(form, algo=2, thr = abs_thr_from_rel))
microbenchmark(envi = envipat(form, rel_to=2, thr = abs_thr_from_rel))

# OK, so now, modify the bloody thing to calculate what we need.

