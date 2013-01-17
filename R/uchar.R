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
#' @seealso \code{\link{stri_charcategories}}, \code{\link{stri_char_getcategoryid}}
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
#' @seealso \code{\link{stri_chartype}}, \code{\link{stri_char_getcategoryid}}
#' @export
stri_charcategories <- function() {
   categories <- as.data.frame(.Call("stri_charcategories", PACKAGE="stringi"),
      stringsAsFactors=FALSE)
   rownames(categories) <- categories[,2]
   categories[,-2]
}


#' Get Unicode character General Category Mask
#' 
#' The following may also be preceeded with '^' (complement):
#' \code{Lu}: UPPERCASE_LETTER
#' \code{Ll}: LOWERCASE_LETTER
#' \code{Lt}: TITLECASE_LETTER
#' \code{Lm}: MODIFIER_LETTER
#' \code{Lo}: OTHER_LETTER
#' \code{Mn}: NON_SPACING_MARK
#' \code{Me}: ENCLOSING_MARK
#' \code{Mc}: COMBINING_SPACING_MARK
#' \code{Nd}: DECIMAL_DIGIT_NUMBER
#' \code{Nl}: LETTER_NUMBER
#' \code{No}: OTHER_NUMBER
#' \code{Zs}: SPACE_SEPARATOR
#' \code{Zl}: LINE_SEPARATOR
#' \code{Zp}: PARAGRAPH_SEPARATOR
#' \code{Cc}: CONTROL_CHAR
#' \code{Cf}: FORMAT_CHAR
#' \code{Co}: PRIVATE_USE_CHAR
#' \code{Cs}: SURROGATE
#' \code{Pd}: DASH_PUNCTUATION
#' \code{Ps}: START_PUNCTUATION
#' \code{Pe}: END_PUNCTUATION
#' \code{Pc}: CONNECTOR_PUNCTUATION
#' \code{Po}: OTHER_PUNCTUATION
#' \code{Sm}: MATH_SYMBOL
#' \code{Sc}: CURRENCY_SYMBOL
#' \code{Sk}: MODIFIER_SYMBOL
#' \code{So}: OTHER_SYMBOL
#' \code{Pi}: INITIAL_PUNCTUATION
#' \code{Pf}: FINAL_PUNCTUATION
#' \code{L}: ...
#' \code{Z}: ...
#' \code{C}: ...
#' \code{M}: ...
#' \code{N}: ...
#' \code{P}: ...
#' \code{S}: ...
#' 
#' @param name One- or two-letter category name
#' @return Internal Unicode character General Category identifier
#' @seealso \code{\link{stri_charcategories}}
#' @export
stri_char_getcategoryid <- function(name)
{
   .Call("stri_char_getcategoryid", name, PACKAGE="stringi")  
}



#' Get Unicode character binary property identifier
#' 
#' The following may also be preceeded with '^' (complement):
#' \code{ALPHABETIC}
#' \code{ASCII_HEX_DIGIT}
#' \code{BIDI_CONTROL}
#' \code{BIDI_MIRRORED}
#' \code{DASH}
#' \code{DEFAULT_IGNORABLE_CODE_POINT}
#' \code{DEPRECATED}
#' \code{DIACRITIC}
#' \code{EXTENDER}
#' \code{FULL_COMPOSITION_EXCLUSION}
#' \code{GRAPHEME_BASE}
#' \code{GRAPHEME_EXTEND}
#' \code{GRAPHEME_LINK}
#' \code{HEX_DIGIT}
#' \code{HYPHEN}
#' \code{ID_CONTINUE}
#' \code{ID_START}
#' \code{IDEOGRAPHIC}
#' \code{IDS_BINARY_OPERATOR}
#' \code{IDS_TRINARY_OPERATOR}
#' \code{JOIN_CONTROL}
#' \code{LOGICAL_ORDER_EXCEPTION}
#' \code{LOWERCASE}
#' \code{MATH}
#' \code{NONCHARACTER_CODE_POINT}
#' \code{QUOTATION_MARK}
#' \code{RADICAL}
#' \code{SOFT_DOTTED}
#' \code{TERMINAL_PUNCTUATION}
#' \code{UNIFIED_IDEOGRAPH}
#' \code{UPPERCASE}
#' \code{WHITE_SPACE}
#' \code{XID_CONTINUE}
#' \code{XID_START}
#' \code{CASE_SENSITIVE}
#' \code{S_TERM}
#' \code{VARIATION_SELECTOR}
#' \code{NFD_INERT}
#' \code{NFKD_INERT}
#' \code{NFC_INERT}
#' \code{NFKC_INERT}
#' \code{SEGMENT_STARTER}
#' \code{PATTERN_SYNTAX}
#' \code{PATTERN_WHITE_SPACE}
#' \code{POSIX_ALNUM}
#' \code{POSIX_BLANK}
#' \code{POSIX_GRAPH}
#' \code{POSIX_PRINT}
#' \code{POSIX_XDIGIT}
#' \code{CASED}
#' \code{CASE_IGNORABLE}
#' \code{CHANGES_WHEN_LOWERCASED}
#' \code{CHANGES_WHEN_UPPERCASED}
#' \code{CHANGES_WHEN_TITLECASED}
#' \code{CHANGES_WHEN_CASEFOLDED}
#' \code{CHANGES_WHEN_CASEMAPPED}
#' \code{CHANGES_WHEN_NFKC_CASEFOLDED}
#'
#' @param name Property name
#' @return Internal Unicode character Binary Property identifier
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


