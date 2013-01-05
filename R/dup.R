#' Duplicate strings
#'
#' @param str will be coerced to character
#' @param count will be coerced to integer
#' @export
stri_dup <- function(str, count) {
   .Call("stri_dup", stri_prepare_arg_string(str),
         as.integer(count), PACKAGE="stringi")
}

