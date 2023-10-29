
s <- c("ala ma \u0105 \u00F1 kota i kotek ma alicje oraz dwie gruszeczki oraz gruby czarny pies ma kotka ale nie ma alibaby")
s <- c(s,"ala ma kota, psa i dwa kanarki","lorem ipsum cos tam dalej","do ciebie aniu szlem")
h <- 20
cat(paste(c("|",rep("-",h-2),"|\n"),collapse=""),stri_wrap(s,h,"g",spacecost=3),sep="")
cat(paste(c("|",rep("-",h-2),"|\n"),collapse=""),stri_wrap(s,h,"d",spacecost=3),sep="")
s <- c("ala",paste("???",1:6,sep=" nr ",collapse=" "))
h <- 23
cat(stri_wrap(s,h,"g",spacecost=1),sep=paste(c("\n|",rep("-",h-2),"|\n"),collapse=""))
cat(stri_wrap(s,h,"d",spacecost=1),sep=paste(c("\n|",rep("-",h-2),"|\n"),collapse=""))

s <- c("ala ma \u0105 \u00F1 kota i kotek ma alicje oraz dwie gruszeczki oraz gruby czarny pies ma kotka ale nie ma alibaby")
s <- c(s,"ala ma kota, psa i dwa kanarki","lorem ipsum cos tam dalej","do ciebie aniu szlem")
s <- rep(s,10)
system.time(stri_wrap(s,h,"d"))
system.time(stri_wrap(s,h,"d"))

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

s <- rep(s,2)
h <- 70
cat(stri_wrap(s,h,c("g","d")),sep=paste(c("\n|",rep("-",h-2),"|\n"),collapse=""))
s <- c("Lorem ipsum dolor sit amet, consectetur adipisicing elit.","Nie ma zatem takiego czlowieka, ktory kocha cierpienie samo w sobie")
s <- rep(s,3)
h <- 20
cat(stri_wrap(s,h,c("d","g","g")),sep=paste(c("\n|",rep("-",h-2),"|\n"),collapse=""))
stri_wrap(s,h,"d")
