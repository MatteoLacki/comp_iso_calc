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
path2output = '~/Projects/isospec/tests/envipat_res'
formulas = read_json(path2formulas, simplifyVector=T)

# ff = formulas[1:100]
# ff = formulas
# form = formulas[1]
test_envipat = function(form,
            						path2output,
            						thr=0.0001,
            						times=13,
            						t_unit='ns',
            						isotopes=isotopicData$IsoSpec){
    max_lprob = max(isospec(form, 0)[,"logProb"])
    abs_thr_from_rel = exp(log(thr) + max_lprob)
    
  	test_run = isopattern(
			isotopes=isotopes,
			chemforms=form,
			threshold=abs_thr_from_rel,
			rel_to=2,
			plotit=FALSE,
			charge=FALSE,
			algo=1,
			verbose=FALSE)[[1]]

	if(class(test_run) == 'character'){
		res = data.frame(formula=form, a1=NA, a2=NA)
	} else{
		med1 = try({	m1 = microbenchmark(
						pattern = isopattern(
						  isotopes=isotopes,
						  chemforms=form,
						  threshold=abs_thr_from_rel,
						  rel_to=2,
						  plotit=FALSE,
						  charge=FALSE,
						  algo=1,
						  verbose=FALSE),
						unit = t_unit,
						times = times)
					summary(m1)$median})
		med2 = try({	m2 = microbenchmark(
						pattern = isopattern(
						  isotopes=isotopes,
						  chemforms=form,
						  threshold=abs_thr_from_rel,
						  rel_to=2,
						  plotit=FALSE,
						  charge=FALSE,
						  algo=2,
						  verbose=FALSE),
						unit = t_unit,
						times = times)
					summary(m2)$median})
		res = data.frame(formula=form, a1=med1, a2=med2)
	}
	save(list=c('res'),
		 file=file.path(path2output, form))
	return(res)
}

# test_envipat(ff[1], path2output)
# med_times = lapply(	ff,
# 					test_envipat,
# 					path2output=path2output,
# 					times=1)

med_times = mclapply(	ff,
          						test_envipat,
          						path2output=path2output,
          						times=13L,
          						mc.cores = cores_no)

# med_times = do.call(rbind, med_times)
# save(med_times, file=path2output)
# test_envipat('C100000H200000S10000', '.', thr=0.0001)

# form = 'C4500H7530N1370O1210S80'
# microbenchmark(
# pattern = isopattern(
#   isotopes=isotopicData$IsoSpec,
#   chemforms=form,
#   threshold=.00001,
#   rel_to=0,
#   plotit=FALSE,
#   charge=FALSE,
#   algo=1,
#   verbose=FALSE)
# )
