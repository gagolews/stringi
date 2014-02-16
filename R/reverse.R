## This file is part of the 'stringi' library.
##
## Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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


#' @title
#' Reverse Each String
#'
#' @description
#' Reverses characters in every string.
#'
#' @details
#' Note that this operation is not very intelligent -- it just reverses
#' the order of all Unicode code points.
#' It may result in non-Unicode-normalized
#' strings and may give strange output for bidirectional strings.
#'
#' @param str character vector
#'
#' @return Returns a character vector.
#'
#' @examples
#' stri_reverse(c("123", "abc d e f"))
#' stri_reverse("ZXY (\u0105\u0104123$^).")
#' \dontrun{
#' stri_reverse(stri_enc_nfd('\u0105')) == stri_enc_nfd('\u0105') # A, ogonek -> agonek, A
#' }
#' @export
stri_reverse <- function(str) {
   .Call("stri_reverse", str, PACKAGE="stringi")
}
