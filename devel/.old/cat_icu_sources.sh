#!/usr/bin/Rscript --vanilla

# must be called from within src/

prefix <- 'icu55_'

catsrc <- function(dir, ext) {
   lst <- dir(paste0('icu55/', dir), glob2rx(paste0("*.", ext)), full.names=TRUE)
   cat(lst, sep=' \\\n', file=paste0(prefix, dir, "_", ext, ".txt"))
}

catsrc('i18n', 'c')
catsrc('i18n', 'cpp')
catsrc('common', 'c')
catsrc('common', 'cpp')
catsrc('stubdata', 'c')
catsrc('stubdata', 'cpp')

lst <- dir('.', glob2rx(paste0("*.cpp")))
cat(lst, sep=' \\\n', file=paste0("stri_cpp.txt"))
