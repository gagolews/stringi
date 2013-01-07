## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.



#' Wrap strings to paragraphs
#'
#' @description Wrap strings to paragraphs
#' @usage stri_wrap(s, width = 76, method = c("greedy", "dynamic"), spaces = "(\\p{Z}|\\n)+", spacecost = 1)
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
#' @export
stri_wrap <- function(s,width=76,method=c("greedy","dynamic"),spaces="(\\p{Z}|\\n)+",spacecost=1)
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


#'  documentation...
#'  
#' !we keep stri_wrap only to compare efficiency between R and C++ versions
#'  after that stri_wrapC will be stri_wrap and old stri_wrap will be del.
#'  TODO Also the default parameter spaces should be different - the current
#'  splits string only by space and omits line breaks - \n
#'  TODO add indent and exdent parameter (see strwrap)
#' @export
stri_wrapC <- function(s,width=76,method=c("greedy","dynamic"),spaces="(\\p{Z}|\\n)+",spacecost=1)
{
   if (!is.character(s))   
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
      space[where] <- "\n"
      space[length(where)] <- ""
      paste(words,space,sep="",collapse="")
   })
}

#'  documentation...
#'  
#'  this function uses stri_wrap_greedy implemented in C++
#'  
#'  TODO add indent and exdent parameter (see strwrap)
#' @export
stri_wrapC2 <- function(s,width=76,method=c("greedy","dynamic"),spaces="(\\p{Z}|\\n)+",spacecost=1)
{
	if (!is.character(s))   
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
							 dynamic = .Call("stri_wrap_dynamic",count,width,spacecost,PACKAGE="stringi"),
							 greedy = .Call("stri_wrap_greedy",count,width,spacecost,PACKAGE="stringi"))
		space <- rep(" ",length(where))
		space[where] <- "\n"
		space[length(where)] <- ""
		paste(words,space,sep="",collapse="")
	})
}

# (internal function)
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



# (internal function)
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


# (internal function)
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



# (internal function)
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


