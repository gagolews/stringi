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


#' General statistics for a Character Vector
#' 
#' This function gives general statistics on the whole character vector.
#' Such input vector will often be a text file loaded via the
#' \code{\link{readLines}} function, where each text line
#' is represented by a separate string.
#' 
#' 
#' @param str character vector to aggregate
#' @return An integer vectors with the following named elements:
#' \enumerate{
#'    \item ...
#' }
#' @family stats
#' @export
stri_stats_general <- function(str) {
   # prepare_arg done internally
   .Call("stri_stats_general", str, class, PACKAGE="stringi")
}


#' Statistics for a Character Vector Containing LaTeX Commands
#' 
#' We use Kile 2.1.3 LaTeX Word Count algorithm,
#' see http://kile.sourceforge.net/team.php
#' 
#' This function gives general statistics on the whole character vector.
#' Such input vector will often be a text file loaded via the
#' \code{\link{readLines}} function, where each text line
#' is represented by a separate string.
#' 
#' @param str character vector to aggregate
#' @return An integer vectors with the following named elements:
#' \enumerate{
#'    \item ...
#' }
#' @family stats
#' @export
stri_stats_latex <- function(str) {
   # prepare_arg done internally
   .Call("stri_stats_latex", str, class, PACKAGE="stringi")
}

