benchmark_description <- "Extract first code points in "%+%
                         "verses of Pan Tadeusz"


benchmark_do <- function() {
   library('stringi')
   library('stringr')

   text <- enc2native(readLines('devel/benchmarks/pan_tadeusz_15.txt', encoding='UTF-8'))

   gc(reset=TRUE)
   benchmark2(
      substring(text, 1L, 1L),
      str_sub(text, 1L, 1L),
      stri_sub(text, 1L, 1L),
      replications=1000L
   )
}
