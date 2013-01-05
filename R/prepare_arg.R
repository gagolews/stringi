#' Prepare a string argument (Internal method)
#' 
#' @param x argument to be checked
#' @return if x is a string, it is returned with no change.
#' if factor, as.character is called.
#' if atomic vector (also a matrix), it is coerced to character vector.
#' if name, a single string is generated.
#' otherwise the function throws an error.
stri_prepare_arg_string <- function(x) {
   .Call("stri_prepare_arg_string", x, PACKAGE="ICU")  
}
