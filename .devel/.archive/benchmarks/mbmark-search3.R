benchmark_description <- "counts occurences of *sie* in verses from *Pan Tadeusz* (Chap. 1-5)"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   pan_tadeusz <- enc2native(readLines('devel/benchmarks/pan_tadeusz_15.txt', encoding="UTF-8"))
   sie <- enc2native("si\u0119")

   gc(reset=TRUE)
   microbenchmark2(
      stri_count_regex(pan_tadeusz, sie),
      stri_count_regex(pan_tadeusz, sie, list(literal=TRUE)),
      stri_count_fixed(pan_tadeusz, sie),
      stri_count_coll(pan_tadeusz, sie),
      str_count(pan_tadeusz, sie),
      str_count(pan_tadeusz, fixed(sie)),
      str_count(pan_tadeusz, perl(sie))
   )
}
