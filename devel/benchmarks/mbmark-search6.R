benchmark_description <- "does not find a long overlapping pattern in a string (Latin&Polish letters)"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   str <- enc2native(str_dup("ab\u0105", 4000))
   olap <- enc2native(str_join(str_dup("ab\u0105", 400), "c"))

   gc(reset=TRUE)
   microbenchmark2(
      stri_detect_regex(str, olap),
      stri_detect_regex(str, olap, list(literal=TRUE)),
      stri_detect_fixed(str, olap),
      stri_detect_coll(str, olap),
      grepl(olap, str),
      grepl(olap, str, perl=TRUE),
      grepl(olap, str, fixed=TRUE)
   )
}
