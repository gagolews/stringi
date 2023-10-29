benchmark_description <- "detect a fixed pattern in ASCII text (144k strings)"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   if (!file.exists('devel/benchmarks/test1.csv.gz')) {
   # don't change the URL!
   download.file('http://cran-logs.rstudio.com/2014/2014-03-18.csv.gz',
      'devel/benchmarks/test1.csv.gz')
}

   f <- gzfile('devel/benchmarks/test1.csv.gz')
   data <- enc2native(readLines(f, encoding="ASCII"))
   close(f)

   gc(reset=TRUE)
   microbenchmark2(
      stri_detect_regex(data, ',\\"stringi\\",'),
      stri_detect_coll(data, ',\\"stringi\\",'),
      stri_detect_fixed(data, ',\\"stringi\\",'),
      str_detect(data, ',\\"stringi\\",'),
      str_detect(data, perl(',\\"stringi\\",')),
      str_detect(data, fixed(',\\"stringi\\",')),
      grepl(',\\"stringi\\",', data),
      grepl(',\\"stringi\\",', data, perl=TRUE),
      grepl(',\\"stringi\\",', data, fixed=TRUE),
      times=10L, control=list(order='inorder', warmup=3L)
   )
}
