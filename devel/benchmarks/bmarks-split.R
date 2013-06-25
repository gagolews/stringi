require(microbenchmark)
require(stringr)
local({
   
   sorig <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin 
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
   
   s <- sorig
   print(microbenchmark(
      stri_split_fixed(s, " "),
      stri_split_fixed(s, " ", opts_collator=NA),
      stri_split_charclass(s, "WHITE_SPACE"),
      stri_split_charclass(s, "Z"),
      stri_split_regex(s, " "),
      stri_split_regex(s, " ", opts_regex=stri_opts_regex(literal=TRUE)),
      strsplit(s,' ',fixed=TRUE),
      strsplit(s,' '),
      str_split(s, ' '),
      str_split(s, fixed(' '))))

   
   s <- rep(sorig,10)
   print(microbenchmark(
      stri_split_fixed(s, " "),
      stri_split_fixed(s, " ", opts_collator=NA),
      stri_split_charclass(s, "WHITE_SPACE"),
      stri_split_charclass(s, "Z"),
      stri_split_regex(s, " "),
      stri_split_regex(s, " ", opts_regex=stri_opts_regex(literal=TRUE)),
      strsplit(s,' ',fixed=TRUE),
      strsplit(s,' '),
      str_split(s, ' '),
      str_split(s, fixed(' '))))

   s <- stri_dup(rep(sorig,10),10)
   print(microbenchmark(
      stri_split_fixed(s, " "),
      stri_split_fixed(s, " ", opts_collator=NA),
      stri_split_charclass(s, "WHITE_SPACE"),
      stri_split_charclass(s, "Z"),
      stri_split_regex(s, " "),
      stri_split_regex(s, " ", opts_regex=stri_opts_regex(literal=TRUE)),
      strsplit(s,' ',fixed=TRUE),
      strsplit(s,' '),
      str_split(s, ' '),
      str_split(s, fixed(' '))))
   

})
