# extracts all \links that are \code{\link in Roxygen documentation of functions
require('stringi')

# we are in the root dir of stringi
srcfiles <- dir('R', pattern='\\.R$', recursive=TRUE, ignore.case=TRUE, full.names=TRUE)

# sprintf("%x", unlist(stri_enc_toutf32(c(UTF8chars))))

for (f in srcfiles) {
   cf <- readLines(f)
   whnasc <- which(stri_detect_regex(cf, "^#'.*(?<!\\\\code\\{)\\\\link"))
#    whnasc <- which(stri_detect_regex(cf, "^#'.*\\\\code\\{\\\\link"))
#    whnasc <- which(stri_detect_regex(cf, "^#'.*\\\\link\\{\\\\code"))
   if (length(whnasc) != 0) {
      cat(stri_trim(sprintf('%-30s: %5d: %s', f, whnasc, cf[whnasc])), sep='\n')
   }
}
