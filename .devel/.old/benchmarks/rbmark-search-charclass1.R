benchmark_description <- "counts the number of whitespaces"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   set.seed(123)
   x <- stri_rand_strings(10, runif(10, 100, 10000), "[a-zA-Z0-9\\u0020\\u0105\\u0107\\u0119\\u0142\\u0144\\u00f3\\u015b\\u017a\\u017c]")
   x <- enc2native(stri_rand_shuffle(x))



   gc(reset=TRUE)
   benchmark2(
      stri_count_charclass(x, "\\p{Wspace}"),
      stri_count_charclass(x, "\\p{Z}"),
      stri_count_regex(x, "\\p{Z}"),
      stri_count_regex(x, "[ ]"),
      replications=1000L
   )
}
