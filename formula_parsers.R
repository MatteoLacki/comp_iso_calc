library('stringr')

formula_str2vec = function(form){
  out = as.integer(str_extract_all(form, "[:digit:]+", simplify = T))
  names(out) = str_extract_all(form, "[:alpha:]+", simplify = T)
  return(out)
}

formula_vec2str = function(form) paste(names(form), form, sep="", collapse="")
