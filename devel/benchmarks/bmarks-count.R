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
   
   print(microbenchmark(stri_count_regex(srepdup,pat1),str_count(srepdup,pat1)))
   print(microbenchmark(stri_count_regex(srepdup,pat2),str_count(srepdup,pat2)))
   print(microbenchmark(stri_count_regex(srepdup,pat3),str_count(srepdup,pat3)))
   
})
