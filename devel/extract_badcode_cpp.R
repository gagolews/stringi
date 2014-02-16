# extracts all bad words from documentation
require('stringi')

# we are in the root dir of stringi
srcfiles <- dir('src', pattern='^stri_.*(\\.cpp|\\.h)$', recursive=TRUE, ignore.case=TRUE, full.names=TRUE)

# sprintf("%x", unlist(stri_enc_toutf32(c(UTF8chars))))

for (f in srcfiles) {
   cf <- readLines(f)
   whnasc <- which(stri_detect_regex(cf, "<<|>>|[^s]printf|scanf|[^/]//<", stri_opts_regex(case_insensitive=TRUE)))
   if (length(whnasc) != 0) {
      cat(stri_trim(sprintf('%-30s: %5d: %s', f, whnasc, cf[whnasc])), sep='\n')
   }
}
