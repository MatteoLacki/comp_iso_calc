library('IsoSpecR')
library('enviPat')

source('formula_parsers.R')

data(isotopicData)

isospec = function(form, algo, thr=0.0001)
  IsoSpecify( molecule = formula_str2vec(form),
              isotopes = isotopicData$IsoSpec,
              stopCondition = thr,
              showCounts = TRUE,
              algo = algo)

envipat = function(form, algo=1, rel_to=0, thr=0.0001)
  isopattern( isotopes=isotopes,
              chemforms=form,
              threshold=thr,
              rel_to=rel_to,
              plotit=FALSE,
              charge=FALSE,
              algo=algo,
              verbose=FALSE)[[1]]