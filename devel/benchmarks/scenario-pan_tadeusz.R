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
