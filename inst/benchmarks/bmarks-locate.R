require(microbenchmark)
require(stringr)

local({
  
   x <- stri_dup('aba', 1000)
   stopifnot(stri_locate_all_regex(x, 'b')[[1]] == str_locate_all(x, 'b')[[1]])
   microbenchmark(
      stri_locate_all_regex(x, 'b'),
      str_locate_all(x, 'b'),
      str_locate_all(x, perl('b'))
   )
   

#    Unit: microseconds
#    expr        min          lq     median          uq        max neval
#    stri_locate_all_regex(x, "b") 228337.184 229810.3025 231045.666 233030.3165 269474.923   100
#    str_locate_all(x, "b")           480.892    507.6155    540.009    711.9705   2536.193   100
#    str_locate_all(x, perl("b"))     427.057    454.8265    477.464    646.4955   1690.127   100
   
   
#    Unit: microseconds
#    expr     min       lq   median       uq      max neval
#    stri_locate_all_regex(x, "b")  96.510 107.7960 111.2805 123.2370  185.160   100
#    str_locate_all(x, "b") 475.216 495.7040 506.4950 528.8160 2135.336   100
#    str_locate_all(x, perl("b")) 421.872 432.9785 445.8685 464.6195 2059.545   100
   
   x <- stri_dup('aba', 0:10)
   stopifnot(stri_locate_all_regex(x, 'b')[[1]] == str_locate_all(x, 'b')[[1]])
   microbenchmark(
      stri_locate_all_regex(x, 'b'),
      str_locate_all(x, 'b'),
      str_locate_all(x, perl('b'))
   )
#    
#    Unit: microseconds
#    expr     min       lq   median       uq      max neval
#    stri_locate_all_regex(x, "b")  52.250  58.1420  67.6635  70.5435  115.432   100
#    str_locate_all(x, "b")        148.852 155.8000 163.8400 172.8455  244.948   100
#    str_locate_all(x, perl("b"))  179.176 185.0675 192.1040 199.6590 1807.720   100
   
#    Unit: microseconds
#    expr     min       lq  median       uq     max neval
#    stri_locate_all_regex(x, "b")  13.109  16.0845  26.164  28.0230 115.614   100
#    str_locate_all(x, "b") 149.345 155.4425 161.089 165.3765 256.490   100
#    str_locate_all(x, perl("b")) 177.974 188.1760 194.279 203.7985 444.594   100
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
