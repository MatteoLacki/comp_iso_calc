files = list.files('~/Projects/isospec/tests/envipat_res', full.names=TRUE)
get_res = function(f){load(f); return(res)}

X = list()
for(f in files){
	X[[f]] = get_res(f)
}
X = do.call(rbind, X)
rownames(X) = NULL
save(X, file='~/Projects/isospec/tests/envipat_runtimes.Rd')


plot(X$a1, X$a2, pch='.', asp=1)
abline(0,1,col='red')
