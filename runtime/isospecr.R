# install.packages('enviPat')
# install.packages('IsoSpecR') 
# install.packages('microbenchmark')
# install.packages('jsonlite')
# install.packages('stringr')
library('enviPat')
library('microbenchmark')
library('IsoSpecR')
library('jsonlite')
library('parallel')

source('wrappers_iso_envi.R')

data(isotopicData)

# cores_no = 4L
# cores_no = 24L
# cores_no = 60L
path2formulas = '~/Projects/isospec/tests/formulas.json'
path2output = '~/Projects/isospec/tests/isospecr_old_res'
formulas = read_json(path2formulas, simplifyVector=T)

# ff = formulas[1:100]
# ff = formulas
# form = formulas[1]
test_isospec = function(form,
                        path2output,
                        thr=0.0001,
                        times=13,
                        t_unit='ns',
                        isotopes=isotopicData$IsoSpec){
  max_lprob = max(isospec(form, 0)[,"logProb"])
  abs_thr_from_rel = exp(log(thr) + max_lprob)
  vec_form = formula_str2vec(form)
  isotopes = isotopicData$IsoSpec
  m = microbenchmark(
    pattern = IsoSpecify( molecule = vec_form,
                          isotopes = isotopes,
                          stopCondition = abs_thr_from_rel,
                          showCounts = TRUE,
                          algo = 2),
  unit = t_unit,
  times = times)
  res = data.frame(formula=form, t_med=summary(m)$median)
  save(list=c('res'),
       file=file.path(path2output, form))
  return(res)
}

# test_envipat(ff[2], path2output)
med_times = mclapply(	ff,
                      test_isospec,
                      path2output=path2output,
                      times=13L,
                      mc.cores = cores_no)
