# trims whitespaces from source files
require('stringi')

# we are in the root dir of stringi
srcfiles <- dir('.', pattern='\\.(R|cpp|h)$', recursive=TRUE, ignore.case=TRUE)

# sprintf("%x", unlist(stri_enc_toutf32(c(UTF8chars))))

for (f in srcfiles) {
   cf <- readLines(f)
   if (!all(stri_enc_isascii(cf))) next;
   cf <- stri_trim_right(cf)
   cf <- stri_replace_first_regex(cf, "^\\t", "   ")
   while (stri_numbytes(cf[length(cf)]) == 0)
      cf <- cf[-length(cf)]
   writeLines(cf, f)
}
