# extracts all @references section
require('stringi')

# we are in the root dir of stringi
srcfiles <- dir('R', pattern='\\.R$', recursive=TRUE, ignore.case=TRUE, full.names=TRUE)

# sprintf("%x", unlist(stri_enc_toutf32(c(UTF8chars))))

for (f in srcfiles) {
   cf <- stri_flatten(readLines(f), "\n")
   whnasc <- stri_extract_all_regex(cf, "#'\\p{Z}*@reference(.|[\n])*?^(?=#'\\p{Z}+@\\p{L}+|[^#])", stri_opts_regex(multiline=TRUE))
   #    whnasc <- which(stri_detect_regex(cf, "^#'.*\\\\code\\{\\\\link"))
   #    whnasc <- which(stri_detect_regex(cf, "^#'.*\\\\link\\{\\\\code"))
   if (!is.na(whnasc[[1]][1])) {
      cat(stri_trim(sprintf('%-30s: %s', f, whnasc[[1]])), sep='\n\n')
      cat("\n")
   }
}
