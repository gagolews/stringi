benchmark_description <- "detects occurences of *sie* in verses from *Pan Tadeusz* (Chap. 1-5)"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   pan_tadeusz <- enc2native(readLines('devel/benchmarks/pan_tadeusz_15.txt', encoding="UTF-8"))
   sie <- enc2native("si\u0119")

   gc(reset=TRUE)
   microbenchmark2(
      stri_detect_regex(pan_tadeusz, sie),
      stri_detect_regex(pan_tadeusz, sie, list(literal=TRUE)),
      stri_detect_coll(pan_tadeusz, sie),
      stri_detect_fixed(pan_tadeusz, sie),
      grepl(sie, pan_tadeusz),
      grepl(sie, pan_tadeusz, perl=TRUE),
      grepl(sie, pan_tadeusz, fixed=TRUE)
   )
}
