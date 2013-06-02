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
   
   print(microbenchmark(stri_split(s),strsplit(s,'\n',fixed=TRUE)))
   print(microbenchmark(stri_split(s,' '),strsplit(s,' ',TRUE)))
   
   srep <- rep(s,10)
   print(microbenchmark(stri_split(srep),strsplit(srep,'\n',fixed=TRUE)))
   print(microbenchmark(stri_split(s,'a'),strsplit(s,'a',TRUE)))
   print(microbenchmark(stri_split(s,"co"),strsplit(s,"co",TRUE)))

   srepdup <- stri_dup(srep,10)
   print(microbenchmark(stri_split(srepdup),strsplit(srepdup,'\n',fixed=TRUE)))
   print(microbenchmark(stri_split(srepdup,"co"),strsplit(srepdup,"co",fixed=TRUE)))
   
   #stri_split_pos vs stri_sub
   print(microbenchmark(stri_split_pos(s,c(1,15),c(10,25)),stri_sub(s,c(1,15),c(10,25))))
   print(microbenchmark(stri_split_pos(s,c(1,4,19),c(3,20,45)),stri_sub(s,c(1,4,19),c(3,20,45)),times=10))
   
   print(microbenchmark(stri_split_pos(srep,c(1,21),c(20,45)),stri_sub(srep,c(1,21),c(20,45)),times=10))
   print(microbenchmark(stri_split_pos(srepdup,c(1,21),c(20,45)),stri_sub(srepdup,c(1,21),c(20,45)),times=10))
   
})
