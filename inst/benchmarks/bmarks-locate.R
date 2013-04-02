require(microbenchmark)
require(stringr)

local({
   
   x <- stri_dup('aba', c(100, 1000, 10000))
   stopifnot(stri_locate_all_regex(x, 'b')[[1]] == str_locate_all(x, 'b')[[1]])
   microbenchmark(
      stri_locate_all_regex(x, 'b'),
      str_locate_all(x, 'b'),
      str_locate_all(x, perl('b'))
   )
   
   x <- stri_dup('aba', 0:10)
   stopifnot(stri_locate_all_regex(x, 'b')[[1]] == str_locate_all(x, 'b')[[1]])
   microbenchmark(
      stri_locate_all_regex(x, 'b'),
      str_locate_all(x, 'b'),
      str_locate_all(x, perl('b'))
   )
   
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
   
   print(microbenchmark(stri_locate_all_fixed(s," "),str_locate_all(s,fixed(" "))))
   print(microbenchmark(stri_locate_all_fixed(s,'a'),str_locate_all(s,fixed('a'))))
   print(microbenchmark(stri_locate_all_fixed(s,letters),str_locate_all(s,fixed(letters))))
   
   srep <- rep(s,10)
   print(microbenchmark(stri_locate_all_fixed(srep," "),str_locate_all(srep,fixed(" "))))
   print(microbenchmark(stri_locate_all_fixed(s,'a'),str_locate_all(s,fixed('a'))))
   print(microbenchmark(stri_locate_all_fixed(s,letters),str_locate_all(s,fixed(letters))))

   srepdup <- stri_dup(srep,26)
   print(microbenchmark(stri_locate_all_fixed(srepdup," "),str_locate_all(srepdup,fixed(" "))))
   print(microbenchmark(stri_locate_all_fixed(srepdup,"Lorem"),str_locate_all(srepdup,fixed("Lorem"))))
   
   #compare different variants of stri_locate_*_fixed
   print(microbenchmark(stri_locate_all_fixed(s,"a"),
                        stri_locate_first_fixed(s,"a"),
                        stri_locate_last_fixed(s,"a")))
   
   print(microbenchmark(stri_locate_all_fixed(srep,"a"),
                        stri_locate_first_fixed(srep,"a"),
                        stri_locate_last_fixed(srep,"a")))
   
   print(microbenchmark(stri_locate_all_fixed(srepdup,"a"),
                        stri_locate_first_fixed(srepdup,"a"),
                        stri_locate_last_fixed(srepdup,"a")))
   
   one <- stri_flatten(c(stri_dup(1,10000),2))
   pat <- stri_flatten(c(stri_dup(1,1000),2))
   print(microbenchmark(stri_locate_all_fixed(one,pat),str_locate_all(one,fixed(pat))))
   print(microbenchmark(stri_locate_first_fixed(one,pat),str_locate(one,fixed(pat))))
   
   print(microbenchmark(stri_locate_first_fixed(one,one),stri_locate_all_fixed(one,one)))
   
})
