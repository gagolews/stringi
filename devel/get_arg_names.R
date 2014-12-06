# detects non-ASCII chars in .R source files
require('stringi')

# we are in the root dir of stringi
srcfiles <- dir('R/', pattern='\\.(R)$', recursive=TRUE, ignore.case=TRUE, full.names = TRUE)

# sprintf("%x", unlist(stri_enc_toutf32(c(UTF8chars))))

allparams <- character(0)
for (f in srcfiles) {
   cf <- stri_read_lines(f)
   x <- stri_match_first_regex(cf, "^#'[ ]*@param[ ]*([^ ]+)", )[,2]
   x <- na.omit(x)
   x <- as.character(unlist(stri_split_fixed(x, ",")))
   allparams <- c(allparams, x)
}

print(sort(unique(allparams)))
