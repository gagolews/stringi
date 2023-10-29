benchmark_description <- stri_c("joins two identical vectors consisting of words of ",
                         "different lengths, with a separator ",
                         "(ASCII + Polish letters, native encoding)")


benchmark_do <- function() {
   library('stringi')

   text <- enc2native(readLines('devel/benchmarks/pan_tadeusz_15.txt', encoding='UTF-8'))

   gc(reset=TRUE)
   benchmark2(
      tolower(text),
      toupper(text),
      stri_trans_tolower(text),
      stri_trans_toupper(text),
      replications=100L
   )
}
