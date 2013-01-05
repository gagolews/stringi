
s <- c("ala ma \u0105 \u00F1 kota i kotek ma alicje oraz dwie gruszeczki oraz gruby czarny pies ma kotka ale nie ma alibaby")
s <- c(s,"ala ma kota, psa i dwa kanarki","lorem ipsum cos tam dalej","do ciebie aniu szlem")
h <- 20
cat(paste(c("|",rep("-",h-2),"|\n"),collapse=""),stri_wrapC(s,h,"g",spacecost=3),sep="")
cat(paste(c("|",rep("-",h-2),"|\n"),collapse=""),stri_wrapC(s,h,"d",spacecost=3),sep="")
s <- c("ala",paste("???",1:6,sep=" nr ",collapse=" "))
h <- 23
cat(stri_wrapC(s,h,"g",spacecost=1),sep=paste(c("\n|",rep("-",h-2),"|\n"),collapse=""))
cat(stri_wrapC(s,h,"d",spacecost=1),sep=paste(c("\n|",rep("-",h-2),"|\n"),collapse=""))

s <- c("ala ma \u0105 \u00F1 kota i kotek ma alicje oraz dwie gruszeczki oraz gruby czarny pies ma kotka ale nie ma alibaby")
s <- c(s,"ala ma kota, psa i dwa kanarki","lorem ipsum cos tam dalej","do ciebie aniu szlem")
s <- rep(s,10)
system.time(stri_wrap(s,h,"d"))
system.time(stri_wrapC(s,h,"d"))
