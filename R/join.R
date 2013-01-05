#' Join two character vectors
#' 
#' This is ca. 1.5x faster than paste(e1, e2, sep="")
#' However, joining 3 vectors, e.g. e1 %+% e2 %+% e3
#' is slower than paste(e1, e2, e3, sep=""), 
#' because it creates a new result each time
#' 
#' @param e1 character vector
#' @param e2 character vector
#' @export
"%+%" <- function(e1, e2) {
   .Call("stri_join2", stri_prepare_arg_string(e1),
         stri_prepare_arg_string(e2), PACKAGE="stringi")
}



# TO DO: stri_join alias stri_c



#' Flatten a string
#' 
#' Joins each element of a character vector into one string;
#' this works like paste(str, collapse="", sep=""), but ca. 3x faster
#' 
#' @param str will be coerced to character
#' @export
stri_flatten <- function(str) {
   .Call("stri_flatten", stri_prepare_arg_string(str), PACKAGE="stringi")
}

