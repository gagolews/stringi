require("microbenchmark")
require("stringr")

local({
   s <- c("Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipisicing", 
     "elit", "Proin", "nibh", "augue", "suscipit", "a", "scelerisque", 
     "sed", "lacinia", "in", "mi", "Cras", "vel", "lorem", "Etiam", 
     "pellentesque", "aliquet", "tellus", "Phasellus", "pharetra", 
     "nulla", "ac", "diam", "Quisque", "semper", "justo", "at", "risus", 
     "Donec", "venenatis", "turpis", "vel", "hendrerit", "interdum", 
     "dui", "ligula", "ultricies", "purus", "sed", "posuere", "libero", 
     "dui", "id", "orci", "Nam", "congue", "pede", "vitae", "dapibus", 
     "aliquet", "elit", "magna", "vulputate", "arcu", "vel", "tempus", 
     "metus", "leo", "non", "est", "Etiam", "sit", "amet", "lectus", 
     "quis", "est", "congue", "mollis", "Phasellus", "congue", "lacus", 
     "eget", "neque")
   srep  <- rep(s, 100)
   srep2 <- stri_dup(s, 1000)
   
   stopifnot(stri_detect_regex(s, "^[A-Z]") == str_detect(s, "^[A-Z]"))
   stopifnot(stri_detect_regex(srep, "^[A-Z]") == str_detect(srep, "^[A-Z]"))
   
   print(microbenchmark(stri_detect_regex(s, "^[A-Z]"), str_detect(s, "^[A-Z]"), str_detect(s, perl("^[A-Z]"))))
   print(microbenchmark(stri_detect_regex(srep, "^[A-Z]"), str_detect(srep, "^[A-Z]"), str_detect(srep, perl("^[A-Z]"))))
   print(microbenchmark(stri_detect_regex(srep, "[a-z]$"), str_detect(srep, "[a-z]$"), str_detect(srep, perl("[a-z]$"))))
   print(microbenchmark(stri_detect_regex(srep, "^[a-z]+$"), str_detect(srep, "^[a-z]+$"), str_detect(srep, perl("^[a-z]+$"))))
   print(microbenchmark(stri_detect_regex(srep2, "^[A-Z]"), str_detect(srep2, "^[A-Z]"), str_detect(srep2, perl("^[A-Z]"))))
   print(microbenchmark(stri_detect_regex(srep2, "[a-z]$"), str_detect(srep2, "[a-z]$"), str_detect(srep2, perl("[a-z]$"))))
   print(microbenchmark(stri_detect_regex(srep2, "^[a-z]+$"), str_detect(srep2, "^[a-z]+$"), str_detect(srep2, perl("^[a-z]+$"))))
   
   print(microbenchmark(grepl("^[A-Z]", s), stri_detect_regex(s, "^[A-Z]")))
   print(microbenchmark(grepl("^[A-Z]", srep), stri_detect_regex(srep, "^[A-Z]")))
   
   p <- c("^[A-Z]", ".{3}", ".{4}", "[^a]+")
   srep2 <- rep(s, 10)
   prep <- rep(p, 60)
   
   stopifnot(stri_detect_regex(s, p) == str_detect(s, p))
   print(microbenchmark(stri_detect_regex(s, p), str_detect(s, p), str_detect(s, perl(p))))
   
   stopifnot(stri_detect_regex(srep2, p) == str_detect(srep2, p))
   print(microbenchmark(stri_detect_regex(srep2, p), str_detect(srep2, p), str_detect(srep2, perl(p))))
   
   stopifnot(stri_detect_regex(s, prep) == str_detect(s, prep))
   print(microbenchmark(stri_detect_regex(s, prep), str_detect(s, prep), str_detect(s, perl(prep))))
   
})