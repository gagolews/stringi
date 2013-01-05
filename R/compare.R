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



#' Compare two character vectors case-insensitively
#' 
#' This uses full Unicode character folding.
#' 
#' @param e1 character vector
#' @param e2 character vector
#' @export
"%==%" <- function(e1, e2) {
   stop("not yet implemented")
#    .Call("stri_casecompare", 
#          stri_prepare_arg_string(e1), stri_prepare_arg_string(e2), PACKAGE="stringi")
}

# COLLATION OPTIONS
# TO DO %<%
# TO DO %<=%
# TO DO %>=%
# TO DO %>%
# TO DO %==%
# TO DO %!=%
# TO DO stri_order (STL? + ICU COLLATE)
# TO DO stri_sort on stri_order??
# TO DO stri_rank on stri_order??
