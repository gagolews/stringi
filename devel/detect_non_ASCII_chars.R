# detects non-ASCII chars in .R source files
require('stringi')

# we are in the root dir of stringi
srcfiles <- dir('.', pattern='\\.(R|cpp|h)$', recursive=TRUE, ignore.case=TRUE)

# sprintf("%x", unlist(stri_enc_toutf32(c(UTF8chars))))

for (f in srcfiles) {
   cf <- readLines(f)
   whnasc <- which(!stri_enc_isascii(cf))
   if (length(whnasc) != 0) {
      cat(sprintf('%s: %d\n', f, whnasc))
   }
}
