# trims whitespaces from source files
require('stringi')

# we are in the root dir of stringi
srcfiles <- dir('.', pattern='\\.(R|cpp|h)$', recursive=TRUE, ignore.case=TRUE)

# sprintf("%x", unlist(stri_enc_toutf32(c(UTF8chars))))

for (f in srcfiles) {
   cf <- readLines(f)
   if (!all(stri_enc_isascii(cf))) next;
   cf <- stri_trim_right(cf)
   cf <- stri_replace_first_regex(cf, "^\\t",             "   ")
   cf <- stri_replace_first_regex(cf, "^\\t\\t",          "      ")
   cf <- stri_replace_first_regex(cf, "^\\t\\t\\t",       "         ")
   cf <- stri_replace_first_regex(cf, "^\\t\\t\\t\\t",    "            ")
   cf <- stri_replace_first_regex(cf, "^\\t\\t\\t\\t\\t", "               ")

   # newlines at end:
   while (stri_numbytes(cf[length(cf)]) == 0)
      cf <- cf[-length(cf)]

   # more than 2 new lines
   if (stri_detect_regex(f, "^(src/|R/)[^/]+$")) {
      whichempty <- which(stri_isempty(cf))
      x <- intersect(intersect(whichempty+2, whichempty), intersect(whichempty+1, whichempty))
      if (length(x) > 0)
         cf <- cf[-x]
   }

   writeLines(cf, f)
}
