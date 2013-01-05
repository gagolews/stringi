
#' Perform Unicode normalization (NFC)
#' 
#' @param str will be coerced to character
#' @export
stri_nfc <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 10L, PACKAGE="stringi")
}

#' Perform Unicode normalization (NFD)
#' 
#' @param str will be coerced to character
#' @export
stri_nfd <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 20L, PACKAGE="stringi")
}


#' Perform Unicode normalization (NFKD)
#' 
#' @param str will be coerced to character
#' @export
stri_nfkd <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 21L, PACKAGE="stringi")
}


#' Perform Unicode normalization (NFKC)
#' 
#' @param str will be coerced to character
#' @export
stri_nfkc <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 11L, PACKAGE="stringi")
}


#' Perform Unicode normalization (NFKC_Casefild)
#' 
#' @param str will be coerced to character
#' @export
stri_nfkc_casefold <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 12L, PACKAGE="stringi")
}
