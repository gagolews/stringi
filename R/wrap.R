#' Wrap strings to paragraphs
#'
#' @description Wrap strings to paragraphs
#' @usage stri_wrap(s, width = 76, method = c("greedy", "dynamic"), spaces = "\\p{Z}", spacecost = 1)
#' @param s character vector of strings to format into paragraphs
#' @param width positive integer giving the target column for wrapping lines
#' @param method indicates which method is used for wrapping. You can specify just the initial letter of the value. See 'Details' for description of possible methods.
#' @param spaces length one character vector or expression ?...
#' @param spacecost positive integer which determines the cost of one space (gap between each word)
#' @details Greedy algorithm is simple way of word wrapping and it always puts as many words on each line as possible. This method minimize the number of space left at the end of every line and always uses the minimum number of lines. Disadvantage of this method could be fact that the number of empty space at the end of lines may be various. Dynamic algorithm is more complex, but it returns text wrapped more aesthetic. This method minimize the squared number of space, so the text is arranged evenly.
#' 
#' @return character vector of reformatted strings
#' 
#' @examples 
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin
#'       nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel 
#'       lorem. Etiam pellentesque aliquet tellus."
#' stri_wrap(s,20,"d")
#' cat(stri_wrap(s,20,"d"))
#' 


stri_wrap_dynamic <- function(wordslist,width,spacecost){
   sapply(wordslist,function(words){
      n <- length(words)
      len <- nchar(words)
      costm <- matrix(Inf,nrow=n,ncol=n)
      for(i in 1:n){
         for(j in i:n){
            ct <- width-(j-i)*spacecost-sum(len[i:j])
            if(ct<0){
               break 
            }else
               costm[i,j]<-ct^2
         }
      }
      space <- matrix(" ",n,n)
      f <- rep(0,n)
      j <- 1
      while(j<=n && is.finite(costm[1,j])){
         f[j]<-costm[1,j]
         space[j,j] <- "\n"
         j<-j+1
      }
      if(j<=n){
         for(i in j:n){
            ct <- f[2:i-1]+costm[2:i,i]
            w <- which.min(ct)
            f[i]<-ct[w]
            space[i,] <- space[w,]
            space[i,i] <- "\n"
         }
      }
      paste(words, space[n,-n], sep="",collapse="")
   })
}

stri_wrap_greedy <- function(wordslist,width,spacecost){
   sapply(wordslist, function(words) {
      n <- length(words)
      space <- character(n)
      len <- nchar(words)
      cost <- len[1]
      if(n>1)
         for (i in 2:n) {
            if (cost + spacecost + len[i] > width) {
               space[i-1] <- "\n"
               cost <- len[i]
            } else {
               space[i-1] <- " "
               cost <- cost + spacecost + len[i]
            }
         }
      paste(words, space, sep="", collapse="")
   })
}

stri_wrap_g <- function(count,width,spacecost){
  n <- length(count)
  cost <- count[1]
  space <- rep(FALSE,n)
  #tutaj nie mozna wykonywac petli do n-1 bo moze sie okazac, ze nie zlamie
  #nam wtedy ostatniego wiersza odpowiednio i ostatni wyraz wyjdzie poza
  #ustalona szerokosc!
  if(n>1)
     for(i in 2:n){
       if(cost+spacecost+count[i]>width){
         space[i-1] <- TRUE
         cost <- count[i]
       }else
         cost <- cost + spacecost + count[i]
     }
  return(space)
}

stri_wrap_d <- function(count,width,spacecost){
  n <- length(count)
  costm <- matrix(Inf,nrow=n,ncol=n)
  for(i in 1:n){
    for(j in i:n){
      ct <- width-(j-i)*spacecost-sum(count[i:j])
      if(ct<0){
        break 
      }else
        costm[i,j]<-ct^2
    }
  }
  space <- matrix(FALSE,n,n)
  f <- rep(0,n)
  j <- 1
  while(j<=n && is.finite(costm[1,j])){
    f[j]<-costm[1,j]
    space[j,j] <- TRUE
    j<-j+1
  }
  if(j<=n){
    for(i in j:n){
      ct <- f[2:i-1]+costm[2:i,i]
      w <- which.min(ct)
      f[i]<-ct[w]
      space[i,] <- space[w,]
      space[i,i] <- TRUE
    }
  }
  return(space[n,])
}

stri_wrap <- function(s,width=76,method=c("greedy","dynamic"),spaces="\\p{Z}+",spacecost=1)
{
   s <- as.character(s)
   width <- as.integer(width)
   stopifnot(is.finite(width)&&width>0)
   spacecost <- as.integer(spacecost)
   stopifnot(is.finite(spacecost)&&spacecost>0)
   method <- match.arg(method)
   wordslist <- strsplit(enc2utf8(s), enc2utf8(spaces), perl=TRUE)
   switch(method, 
      dynamic = stri_wrap_dynamic(wordslist,width,spacecost),
      greedy = stri_wrap_greedy(wordslist,width,spacecost))
}

stri_wrapC <- function(s,width=76,method=c("greedy","dynamic"),spaces="\\p{Z}+",spacecost=1)
{
   s <- as.character(s)
   width <- as.integer(width)
   stopifnot(is.finite(width)&&width>0)
   spacecost <- as.integer(spacecost)
   stopifnot(is.finite(spacecost)&&spacecost>0)
   method <- match.arg(method)
   wordslist <- strsplit(enc2utf8(s), enc2utf8(spaces), perl=TRUE)
   sapply(wordslist,function(words){
      count <- nchar(words)
      where <- switch(method,
                      dynamic = stri_wrap_d(count,width,spacecost),
                      greedy = stri_wrap_g(count,width,spacecost))
      space <- rep(" ",length(where))
      space[length(where)] <- ""
      space[where] <- "\n"
      paste(words,space,sep="",collapse="")
   })
}

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
