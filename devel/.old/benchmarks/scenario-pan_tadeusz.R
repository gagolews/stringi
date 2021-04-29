data <- enc2native(readLines('devel/benchmarks/pan_tadeusz_15.txt', encoding="UTF-8"))

require('stringi')
require('stringr')

system.time({
   words <- stri_split_charclass(data, "^L", omit_empty=TRUE)
   words <- unlist(words)
   words <- words[stri_length(words) > 0]
   words <- stri_sort(words)
})

system.time({
   words <- stri_split_regex(data, "\\P{L}")
   words <- unlist(words)
   words <- words[stri_length(words) > 0]
   words <- sort(words)
})


system.time({
   words <- str_split(data, perl("\\P{L}"))
   words <- unlist(words)
   words <- words[stri_length(words) > 0]
   words <- sort(words)
})



x <- enc2native(str_join(str_dup("kawa", 100000), "lawa"))
whatbegin <- enc2native("kawa")
whatend   <- enc2native("lawa")
microbenchmark(
   stri_detect_fixed(x, whatbegin),
   stri_detect_regex(x, whatbegin),
   stri_detect_fixed(x, whatbegin, NA),
   stri_detect_regex(x, whatbegin, list(literal=TRUE)),
   grepl(whatbegin, x),
   grepl(whatbegin, x, fixed=TRUE),
   grepl(whatbegin, x, perl=TRUE)
)
