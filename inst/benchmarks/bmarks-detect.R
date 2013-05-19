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
   sjoin <- stri_flatten(s, collapse=" ")
   sjoindup <- stri_dup(sjoin, 1:100)
   
   print(microbenchmark(
      stri_detect_fixed(sjoin, "Nam"),
      str_detect(sjoin, fixed("Nam"))
   ))
   
   print(microbenchmark(
      stri_detect_fixed(s, "Nam"),
      str_detect(s, fixed("Nam"))
   ))
   
   print(microbenchmark(
      stri_detect_fixed(sjoindup, "Nam"),
      str_detect(sjoindup, fixed("Nam"))
   ))
   
   print(microbenchmark(
      stri_detect_fixed(sjoin, "Bam"),
      str_detect(sjoin, fixed("Bam"))
   ))
   
   print(microbenchmark(
      stri_detect_fixed(s, "Bam"),
      str_detect(s, fixed("Bam"))
   ))
   
   print(microbenchmark(
      stri_detect_fixed(sjoindup, "Bam"),
      str_detect(sjoindup, fixed("Bam"))
   ))
   
})


# Original version (v0.1) - measured by MG
# Unit: microseconds
# expr     min      lq  median       uq     max neval
# stri_detect_fixed(sjoin, "Nam")   2.334   2.957   4.804   6.6325  44.137   100
# str_detect(sjoin, fixed("Nam")) 148.894 151.957 154.299 160.7850 448.921   100
# Unit: microseconds
# expr     min       lq   median      uq     max neval
# stri_detect_fixed(s, "Nam")   4.209   5.1075   8.0835   8.730  22.807   100
# str_detect(s, fixed("Nam")) 154.888 159.2970 160.9325 163.973 379.295   100
# Unit: microseconds
# expr     min      lq   median       uq      max neval
# stri_detect_fixed(sjoindup, "Nam")  44.745  45.683  57.9065  72.3080  110.712   100
# str_detect(sjoindup, fixed("Nam")) 890.437 935.000 959.8540 986.0135 1181.112   100
# Unit: microseconds
# expr     min       lq   median       uq     max neval
# stri_detect_fixed(sjoin, "Bam")   2.497   3.3190   3.8835   6.7605  20.540   100
# str_detect(sjoin, fixed("Bam")) 148.713 154.1205 155.8410 160.7815 387.266   100
# Unit: microseconds
# expr     min       lq   median       uq     max neval
# stri_detect_fixed(s, "Bam")   4.195   5.2660   8.2790   8.6410  41.199   100
# str_detect(s, fixed("Bam")) 155.106 158.6975 160.6515 163.1345 310.525   100
# Unit: milliseconds
# expr       min        lq    median        uq       max neval
# stri_detect_fixed(sjoindup, "Bam")  3.093148  3.135406  3.158489  3.179832  3.963646   100
# str_detect(sjoindup, fixed("Bam")) 23.252359 23.538131 23.593086 23.660623 24.452321   100


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
   print(microbenchmark(stri_detect_regex(srep2, "^[a-z]+$"), str_detect(srep2, "^[a-z]+$"), str_detect(srep2, perl("^[a-z]+$"))))
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