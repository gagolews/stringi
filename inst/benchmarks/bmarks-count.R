require(microbenchmark)

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
   
   print(microbenchmark(stri_count(s,"o"),str_count(s,"o")))
   print(microbenchmark(stri_count(s,' '),str_count(s,' ')))
   
   srep <- rep(s,10)
   print(microbenchmark(stri_count(srep,"o"),str_count(srep,"o")))
   print(microbenchmark(stri_count(srep,'a'),str_count(srep,'a')))
   print(microbenchmark(stri_count(s,"co"),str_count(s,"co")))

   srepdup <- stri_dup(srep,10)
   print(microbenchmark(stri_count(srepdup," "),str_count(srepdup," ")))
   print(microbenchmark(stri_count(srepdup,"co"),str_count(srepdup,"co")))
   
})
