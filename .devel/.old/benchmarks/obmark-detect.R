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
      stri_detect_fixed(sjoin, "Nam", opts_collator=NA),
      stri_detect_fixed(sjoin, "Nam", opts_collator=list()),
      str_detect(sjoin, fixed("Nam"))
   ))

   print(microbenchmark(
      stri_detect_fixed(s, "Nam", opts_collator=NA),
      stri_detect_fixed(s, "Nam", opts_collator=list()),
      str_detect(s, fixed("Nam"))
   ))

   print(microbenchmark(
      stri_detect_fixed(sjoindup, "Nam", opts_collator=NA),
      stri_detect_fixed(sjoindup, "Nam", opts_collator=list()),
      str_detect(sjoindup, fixed("Nam"))
   ))

   print(microbenchmark(
      stri_detect_fixed(sjoin, "Bam", opts_collator=NA),
      stri_detect_fixed(sjoin, "Bam", opts_collator=list()),
      str_detect(sjoin, fixed("Bam"))
   ))

   print(microbenchmark(
      stri_detect_fixed(s, "Bam", opts_collator=NA),
      stri_detect_fixed(s, "Bam", opts_collator=list()),
      str_detect(s, fixed("Bam"))
   ))

   print(microbenchmark(
      stri_detect_fixed(sjoindup, "Bam", opts_collator=NA),
      stri_detect_fixed(sjoindup, "Bam", opts_collator=list()),
      str_detect(sjoindup, fixed("Bam"))
   ))

})


longtext <- rawToChar(as.raw(sample(65:90, 10000000, replace=TRUE)))
pattern <- c("ABC", "DSHFUD", "A", "GDSUI", "XVCXGUIE", "DGUHERE", rawToChar(as.raw(sample(65:90, 200, replace=TRUE))))
print(system.time(stri_detect_fixed(longtext, pattern, opts_collator=NA)))
print(system.time(stri_detect_fixed(longtext, pattern, opts_collator=list())))
print(system.time(stri_detect_fixed(longtext, pattern, opts_collator=list(strength=1))))
print(system.time(str_detect(longtext, fixed(pattern))))

longtext1 <- rawToChar(as.raw(sample(65:90, 10000000, replace=TRUE)))
longtext2 <- stri_flatten(stri_dup("A", 10000000), stri_dup("B", 10000000))
longtext3 <- rawToChar(as.raw(sample(65:90, 10000000, replace=TRUE)))
longtext <- c(longtext1, longtext2, longtext3)
pattern <- stri_flatten(stri_dup("A", 5000000), stri_dup("B", 5000000))
print(system.time(stri_detect_fixed(longtext, pattern, opts_collator=NA)))
print(system.time(stri_detect_fixed(longtext, pattern, opts_collator=list())))
print(system.time(stri_detect_fixed(longtext, pattern, opts_collator=list(strength=1))))
print(system.time(str_detect(longtext, fixed(pattern))))

longtext <- longtext[1]
pattern <- pattern[1:3]
print(system.time(stri_detect_fixed(longtext, pattern, opts_collator=list())))
print(system.time(str_detect(longtext, fixed(pattern))))
print(system.time({stringi:::stri_test_UnicodeContainer16(longtext);
                   stringi:::stri_test_UnicodeContainer16(pattern)})) # this is not THE critical part


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


# Unit: microseconds
# expr     min       lq   median       uq     max neval
# stri_detect_regex(s, "^[A-Z]")  36.612  41.2355  50.6875  54.3310  99.898   100
# str_detect(s, "^[A-Z]") 150.027 155.1855 162.5340 168.4970 542.166   100
# str_detect(s, perl("^[A-Z]")) 177.492 181.2740 190.9660 194.7795 383.178   100
# Unit: milliseconds
# expr      min       lq   median       uq      max neval
# stri_detect_regex(srep, "^[A-Z]") 2.330613 2.432441 2.505707 2.726349 4.064337   100
# str_detect(srep, "^[A-Z]") 1.925887 1.973954 2.031168 2.127632 4.048808   100
# str_detect(srep, perl("^[A-Z]")) 1.204826 1.248119 1.320212 1.442252 3.157981   100
# Unit: milliseconds
# expr      min       lq   median       uq       max neval
# stri_detect_regex(srep, "[a-z]$") 4.302552 4.408041 4.510706 4.669081  5.966780   100
# str_detect(srep, "[a-z]$") 2.350569 2.390493 2.432893 2.535776 45.253126   100
# str_detect(srep, perl("[a-z]$")) 2.686539 2.751870 2.819980 2.924716  4.433458   100
# Unit: milliseconds
# expr      min       lq   median       uq      max neval
# stri_detect_regex(srep, "^[a-z]+$") 2.616492 2.693922 2.769459 2.859256 4.478514   100
# str_detect(srep, "^[a-z]+$") 2.442615 2.484303 2.532267 2.645340 5.215509   100
# str_detect(srep, perl("^[a-z]+$")) 1.562145 1.603903 1.645096 1.763850 3.261454   100
# Unit: microseconds
# expr      min       lq    median       uq       max neval
# stri_detect_regex(srep2, "^[a-z]+$") 1543.555 1584.260 1621.0535 1646.991  1923.114   100
# str_detect(srep2, "^[a-z]+$") 9572.433 9684.959 9765.2175 9923.465 10511.253   100
# str_detect(srep2, perl("^[a-z]+$"))  791.373  820.875  870.2375  933.303  1290.456   100
# Unit: microseconds
# expr      min        lq   median       uq      max neval
# stri_detect_regex(srep2, "^[A-Z]")  635.833  656.8965  675.312  698.154  965.517   100
# str_detect(srep2, "^[A-Z]") 5132.751 5177.8490 5208.408 5265.812 5641.593   100
# str_detect(srep2, perl("^[A-Z]"))  211.725  220.0365  250.446  272.877  407.115   100
# Unit: milliseconds
# expr       min        lq    median        uq      max neval
# stri_detect_regex(srep2, "[a-z]$") 22.168928 22.643502 22.789515 23.064929 26.89349   100
# str_detect(srep2, "[a-z]$")  9.640041  9.746156  9.850829  9.969993 11.76579   100
# str_detect(srep2, perl("[a-z]$")) 16.306815 16.479792 16.597537 16.732975 17.51770   100
# Unit: microseconds
# expr      min       lq   median       uq       max neval
# stri_detect_regex(srep2, "^[a-z]+$") 1537.432 1598.646 1630.426 1665.660  1926.074   100
# str_detect(srep2, "^[a-z]+$") 9682.993 9773.938 9854.593 9958.672 11420.445   100
# str_detect(srep2, perl("^[a-z]+$"))  794.174  841.267  887.335  946.419  1201.039   100
# Unit: microseconds
# expr    min     lq median      uq     max neval
# grepl("^[A-Z]", s) 22.290 23.371 28.260 30.0005  70.220   100
# stri_detect_regex(s, "^[A-Z]") 36.094 37.484 40.105 40.9905 132.174   100
# Unit: milliseconds
# expr      min       lq   median       uq      max neval
# grepl("^[A-Z]", srep) 1.537374 1.562241 1.582422 1.598145 1.768441   100
# stri_detect_regex(srep, "^[A-Z]") 2.305724 2.330019 2.352647 2.377387 4.065180   100
# Unit: microseconds
# expr     min       lq    median        uq      max neval
# stri_detect_regex(s, p)  61.122  69.2055   80.5025   96.9525  191.620   100
# str_detect(s, p) 897.817 939.8195  965.0835  993.9815 2547.837   100
# str_detect(s, perl(p)) 935.881 978.8880 1004.0225 1024.9640 2574.730   100
# Unit: microseconds
# expr      min        lq   median        uq       max neval
# stri_detect_regex(srep2, p)  293.463  340.5615  374.274  390.5745   518.832   100
# str_detect(srep2, p) 7635.304 8134.9815 8266.629 8476.4670 12892.942   100
# str_detect(srep2, perl(p)) 7838.578 8276.7985 8455.849 9555.6305 12240.126   100
# Unit: milliseconds
# expr      min       lq   median       uq      max neval
# stri_detect_regex(s, prep) 1.883137 1.922927 1.960843 1.981460 3.288288   100
# str_detect(s, prep) 2.419711 2.533349 2.591525 2.720442 4.161303   100
# str_detect(s, perl(prep)) 2.472743 2.591743 2.671343 2.824117 6.448065   100
