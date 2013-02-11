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
   to <- stri_length(s)
   print(microbenchmark(stri_sub(s),substr(s,1,to)))
   print(microbenchmark(stri_sub(s,1:10,11:20),str_sub(s,1:10,11:20)))
   
   srep <- rep(s,10)
   print(microbenchmark(stri_sub(srep,10,20),substr(srep,10,20)))
   print(microbenchmark(stri_sub(s,1:100,-(1:100)),str_sub(s,1:100,-(1:100))))
   #print(microbenchmark(stri_sub(s,"co"),substr(s,"co",TRUE)))

   srepdup <- stri_dup(srep,10)
   print(microbenchmark(stri_sub(srepdup,1:100,1:100),str_sub(srepdup,1:100,1:100)))
   print(microbenchmark(stri_sub(srepdup,1:100),str_sub(srepdup,1:100)))
   
})
