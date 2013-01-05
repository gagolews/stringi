
#' Translate to lower case
#' 
#' Performance: similar to tolower() 
#' @param str will be coerced to character
#' @export
stri_tolower <- function(str) {
   .Call("stri_casefold", as.character(str), 1L, PACKAGE="stringi")
}

#' Translate to upper case
#' 
#' Performance: similar to toupper() 
#' @param str will be coerced to character
#' @export
stri_toupper <- function(str) {
   .Call("stri_casefold", as.character(str), 2L, PACKAGE="stringi")
}
