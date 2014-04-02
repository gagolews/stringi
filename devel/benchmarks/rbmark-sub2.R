benchmark_description <- "Extract substrings at positions from 20 in "%+%
                         "verses of Pan Tadeusz"


benchmark_do <- function() {
   library('stringi')
   library('stringr')

   text <- enc2native(readLines('devel/benchmarks/pan_tadeusz_15.txt', encoding='UTF-8'))
   
   gc(reset=TRUE)
   benchmark2(
      substring(text, 20L),
      str_sub(text, 20L),
      stri_sub(text, 20L),
      replications=250L
   )
}
