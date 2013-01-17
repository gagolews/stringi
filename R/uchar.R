## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.



#' Get character types (general character category identifier)
#'
#' Returns the general category value for each *code point* in each string
#' Same as java.lang.Character.getType()
#' @param s character vector
#' @return list of numeric vectors
#' @seealso \code{\link{stri_charcategories}}
#' @export
stri_chartype <- function(s) {
   .Call("stri_chartype", s, PACKAGE="stringi")
}

#' Get general character categories
#'
#' Returns the "modern" names of each Unicode character category
#' Based on ICU4C/uchar.h
#' U_UNASSIGNED (id=0) is omitted
#' @return data frame with 2 columns...
#' @seealso \code{\link{stri_chartype}}
#' @export
stri_charcategories <- function() {
   categories <- as.data.frame(.Call("stri_charcategories", PACKAGE="stringi"),
      stringsAsFactors=FALSE)
   rownames(categories) <- categories[,2]
   categories[,-2]
}


#' Get Unicode character General Category Mask
#' @param name One- or two-letter category name
#' @return internal code
#' @export
stri_char_getcategoryid <- function(name)
{
   .Call("stri_char_getcategoryid", name, PACKAGE="stringi")  
}



#' Get Unicode character binary property identifier
#' @param name Property name
#' @return internal code
#' @export
stri_char_getpropertyid <- function(name)
{
   .Call("stri_char_getpropertyid", name, PACKAGE="stringi")  
}


# UCHAR_GENERAL_CATEGORY_Cn <- stri_char_getcategorymask("Cn")
# UCHAR_GENERAL_CATEGORY_Lu <- .Call("stri_char_getcategorymask", "Lu", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Ll <- .Call("stri_char_getcategorymask", "Ll", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Lt <- .Call("stri_char_getcategorymask", "Lt", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Lm <- .Call("stri_char_getcategorymask", "Lm", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Lo <- .Call("stri_char_getcategorymask", "Lo", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Mn <- .Call("stri_char_getcategorymask", "Mn", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Me <- .Call("stri_char_getcategorymask", "Me", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Mc <- .Call("stri_char_getcategorymask", "Mc", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Nd <- .Call("stri_char_getcategorymask", "Nd", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Nl <- .Call("stri_char_getcategorymask", "Nl", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_No <- .Call("stri_char_getcategorymask", "No", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Zs <- .Call("stri_char_getcategorymask", "Zs", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Zl <- .Call("stri_char_getcategorymask", "Zl", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Zp <- .Call("stri_char_getcategorymask", "Zp", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Cc <- .Call("stri_char_getcategorymask", "Cc", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Cf <- .Call("stri_char_getcategorymask", "Cf", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Co <- .Call("stri_char_getcategorymask", "Co", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Cs <- .Call("stri_char_getcategorymask", "Cs", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Pd <- .Call("stri_char_getcategorymask", "Pd", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Ps <- .Call("stri_char_getcategorymask", "Ps", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Pe <- .Call("stri_char_getcategorymask", "Pe", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Pc <- .Call("stri_char_getcategorymask", "Pc", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Po <- .Call("stri_char_getcategorymask", "Po", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Sm <- .Call("stri_char_getcategorymask", "Sm", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Sc <- .Call("stri_char_getcategorymask", "Sc", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Sk <- .Call("stri_char_getcategorymask", "Sk", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_So <- .Call("stri_char_getcategorymask", "So", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Pi <- .Call("stri_char_getcategorymask", "Pi", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Pf <- .Call("stri_char_getcategorymask", "Pf", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_L  <- .Call("stri_char_getcategorymask", "L",  PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Lc <- .Call("stri_char_getcategorymask", "Lc", PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_M  <- .Call("stri_char_getcategorymask", "M",  PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_N  <- .Call("stri_char_getcategorymask", "N",  PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_Z  <- .Call("stri_char_getcategorymask", "Z",  PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_C  <- .Call("stri_char_getcategorymask", "C",  PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_P  <- .Call("stri_char_getcategorymask", "P",  PACKAGE="stringi")
# UCHAR_GENERAL_CATEGORY_S  <- .Call("stri_char_getcategorymask", "S",  PACKAGE="stringi")


