benchmark_description <- "finds a word at the end of a long string (Latin&Polish letters)"

benchmark_do <- function() {
   library('stringi')
   library('stringr')

   str <- enc2native(str_join(str_dup("kaw\u0105", 100000), "law\u0105"))
   lastword <- enc2native("law\u0105")

   gc(reset=TRUE)
   microbenchmark2(
      stri_detect_regex(str, lastword),
      stri_detect_regex(str, lastword, list(literal=TRUE)),
      stri_detect_fixed(str, lastword),
      stri_detect_coll(str, lastword),
      grepl(lastword, str),
      grepl(lastword, str, perl=TRUE),
      grepl(lastword, str, fixed=TRUE)
   )
}
