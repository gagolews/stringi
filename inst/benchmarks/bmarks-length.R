require('microbenchmark')
require('stringr')


x <- str_dup('a', 0:100)
y <- str_dup('ą', 0:100)

microbenchmark(
   nchar(x), stri_length(x), str_length(x),
   nchar(y), stri_length(y), str_length(y),
   times=1000
)

microbenchmark(
   nzchar(x), stri_isempty(x), times=1000 
)
