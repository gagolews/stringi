
#' Trim whitespaces from strings
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_trim <- function(str) {
   .Call("stri_trim", stri_prepare_arg_string(str), PACKAGE="ICU")
}


# TO DO: stri_rtrim

# TO DO: stri_ltrim
