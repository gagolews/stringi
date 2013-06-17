require(microbenchmark)
require(stringr)

local({
   
   s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin 
      nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel 
   	lorem. Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac 
   	diam. Quisque semper justo at risus. Donec venenatis, turpis vel 
   	hendrerit interdum, dui ligula ultricies purus, sed posuere libero dui 
   	id orci. Nam congue, pede vitae dapibus aliquet, elit magna vulputate 
   	arcu, vel tempus metus leo non est. Etiam sit amet lectus quis est 
   	congue mollis. Phasellus congue lacus eget neque. Phasellus ornare, 
   	ante vitae consectetuer consequat, purus sapien ultricies dolor, et 
   	mollis pede metus eget nisi. Praesent sodales velit quis augue. Cras 
   	suscipit, urna at aliquam rhoncus, urna quam viverra nisi, in interdum 
   	massa nibh nec erat."
   
   #fixed
   print(microbenchmark(
      stri_count_fixed(s, "o", opts_collator=NA),
      stri_count_fixed(s, "o"),
      str_count(s, fixed("o"))
   ))
   
   print(microbenchmark(
      stri_count_fixed(s, ' '),
      stri_count_fixed(s, ' ', opts_collator=NA),
      str_count(s, fixed(' '))
   ))
   
   xxx <- stri_dup("\u0105b\u0105", 10000)
   print(microbenchmark(
      stri_count_fixed(xxx, ' '),
      stri_count_fixed(xxx, ' ', opts_collator=NA),
      str_count(xxx, fixed(' '))
   ))
   stopifnot(stri_count_fixed(xxx, ' ') == str_count(xxx, fixed(' ')))
   
   print(microbenchmark(
      stri_count_fixed(xxx, 'b\u0105\u0105b'),
      stri_count_fixed(xxx, 'b\u0105\u0105b', opts_collator=NA),
      str_count(xxx, fixed('b\u0105\u0105b'))
   ))
   stopifnot(stri_count_fixed(xxx, 'b\u0105\u0105b') == str_count(xxx, fixed('b\u0105\u0105b')))
   
   
   
   
   srep <- rep(s,10)
   print(microbenchmark(stri_count_fixed(srep,"o"),str_count(srep,fixed("o"))))
   print(microbenchmark(stri_count_fixed(srep,'a'),str_count(srep,fixed('a'))))
   print(microbenchmark(stri_count_fixed(s,"co"),str_count(s,fixed("co"))))

   srepdup <- stri_dup(srep,10)
   print(microbenchmark(stri_count_fixed(srepdup," "),str_count(srepdup,fixed(" "))))
   print(microbenchmark(stri_count_fixed(srepdup,"co"),str_count(srepdup,fixed("co"))))
})


local({
   s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin 
      nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel 
      lorem. Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac 
   	diam. Quisque semper justo at risus. Donec venenatis, turpis vel 
   	hendrerit interdum, dui ligula ultricies purus, sed posuere libero dui 
   	id orci. Nam congue, pede vitae dapibus aliquet, elit magna vulputate 
   	arcu, vel tempus metus leo non est. Etiam sit amet lectus quis est 
   	congue mollis. Phasellus congue lacus eget neque. Phasellus ornare, 
   	ante vitae consectetuer consequat, purus sapien ultricies dolor, et 
   	mollis pede metus eget nisi. Praesent sodales velit quis augue. Cras 
   	suscipit, urna at aliquam rhoncus, urna quam viverra nisi, in interdum 
   	massa nibh nec erat."
   srep <- rep(s,100)
   srepdup <- stri_dup(srep,10)
   
   #regex
   pat1 <- " [[a-z]]*\\. Phasellus (ph|or|co)"
   pat2 <- "(s|el|v)it"
   pat3 <- c(pat1, pat2, "ell?(e|u| )", "(L|l)orem .*? nisi .*? nisi","123")
   
   print(microbenchmark(stri_count_regex(s,pat1),str_count(s,pat1),str_count(s,perl(pat1))))
   print(microbenchmark(stri_count_regex(s,pat2),str_count(s,pat2),str_count(s,perl(pat2))))
   print(microbenchmark(stri_count_regex(s,pat3),str_count(s,pat3),str_count(s,perl(pat3))))
   
   print(microbenchmark(stri_count_regex(srep,pat1),str_count(srep,pat1),str_count(srep,perl(pat1))))
   print(microbenchmark(stri_count_regex(srep,pat2),str_count(srep,pat2),str_count(srep,perl(pat2))))
   print(microbenchmark(stri_count_regex(srep,pat3),str_count(srep,pat3),str_count(srep,perl(pat3))))
   
   print(microbenchmark(stri_count_regex(srepdup,pat1),str_count(srepdup,pat1),str_count(srepdup,perl(pat1))))
   print(microbenchmark(stri_count_regex(srepdup,pat2),str_count(srepdup,pat2),str_count(srepdup,perl(pat2))))
   print(microbenchmark(stri_count_regex(srepdup,pat3),str_count(srepdup,pat3),str_count(srepdup,perl(pat3))))
   
})

Unit: microseconds
expr     min       lq   median       uq     max neval
stri_count_regex(s, pat1)  60.886  66.1995  75.5150  82.2640 143.019   100
str_count(s, pat1) 187.951 195.2355 202.6550 214.2305 332.878   100
str_count(s, perl(pat1)) 183.493 193.8730 203.0115 213.4965 508.038   100
Unit: microseconds
expr     min       lq   median       uq     max neval
stri_count_regex(s, pat2)  48.630  54.6060  62.7115  68.0935 153.101   100
str_count(s, pat2) 204.329 208.0605 212.5235 221.7090 399.158   100
str_count(s, perl(pat2)) 235.766 246.9415 253.1870 258.8550 341.334   100
Unit: microseconds
expr     min       lq   median       uq      max neval
stri_count_regex(s, pat3) 146.182 152.7390 167.3890 187.5090  273.426   100
str_count(s, pat3) 519.900 528.6225 543.3535 568.9780 2629.003   100
str_count(s, perl(pat3)) 552.096 567.8790 579.0150 602.1275  827.976   100
Unit: milliseconds
expr      min       lq   median       uq       max neval
stri_count_regex(srep, pat1) 3.518195 3.566394 3.607587 3.650450  3.882239   100
str_count(srep, pat1) 3.913211 4.011245 4.057915 4.157472  6.882773   100
str_count(srep, perl(pat1)) 2.327363 2.411910 2.470751 2.604372 46.090191   100
Unit: milliseconds
expr      min       lq   median       uq       max neval
stri_count_regex(srep, pat2) 3.160353 3.231532 3.255483 3.289424  3.610746   100
str_count(srep, pat2) 7.197776 7.323842 7.380501 7.467190 10.049030   100
str_count(srep, perl(pat2)) 3.151256 3.237266 3.315058 4.935655  6.742733   100
Unit: milliseconds
expr      min       lq   median       uq       max neval
stri_count_regex(srep, pat3) 1.882057 1.922520 1.962747 1.994749  2.229919   100
str_count(srep, pat3) 7.987920 8.075704 8.160106 8.288908 10.592755   100
str_count(srep, perl(pat3)) 7.986615 8.147054 8.231116 8.422896 11.375169   100
Unit: milliseconds
expr      min       lq   median       uq      max neval
stri_count_regex(srepdup, pat1) 35.00213 35.29688 35.55134 36.04959 42.10591   100
str_count(srepdup, pat1) 31.06004 31.33528 31.55407 32.39411 37.88946   100
str_count(srepdup, perl(pat1)) 11.33766 11.46099 11.61264 13.05671 15.20922   100
Unit: milliseconds
expr      min       lq   median       uq       max neval
stri_count_regex(srepdup, pat2) 31.16113 31.41963 31.62862 32.14316  36.70156   100
str_count(srepdup, pat2) 67.30138 67.95070 68.59426 70.25670 148.06244   100
str_count(srepdup, perl(pat2)) 24.14974 24.44134 24.77787 26.43748  68.87563   100
Unit: milliseconds
expr      min       lq   median       uq      max neval
stri_count_regex(srepdup, pat3) 17.98243 18.28373 18.38711 18.48461 19.86165   100
str_count(srepdup, pat3) 50.16880 50.50590 50.93765 51.71819 54.63098   100
str_count(srepdup, perl(pat3)) 50.16172 50.59285 50.81038 51.28169 54.75250   100
