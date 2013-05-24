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
#'    \item \code{Lines} - number of lines (number of 
#'    not-\code{NA} strings in the vector)
#'    \item \code{LinesNEmpty} - number of lines with at least 
#'    one non-\code{WHITE_SPACE} character [WHITE_SPACE binary property....]
#'    \item \code{Chars} - number of Unicode code points 
#'    (total lengths of strings)
#'    \item \code{CharsNWhite} - number of Unicode code points 
#'    that are  not \code{WHITE_SPACE}s
#' }
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin
#'       nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel 
#'       lorem. Etiam pellentesque aliquet tellus."
#' stri_stats_general(s)
#' 
#' @family stats
#' @export
stri_stats_general <- function(str) {
   .Call("stri_stats_general", str, PACKAGE="stringi")
}


#' Statistics for a Character Vector Containing LaTeX Commands
#' 
#' We use a modified LaTeX Word Count algorithm taken from Kile 2.1.3,
#' see http://kile.sourceforge.net/team.php for original contributors
#' 
#' This function gives general statistics on the whole character vector.
#' Such input vector will often be a text file loaded via the
#' \code{\link{readLines}} function, where each text line
#' is represented by a separate string.
#' 
#' @param str character vector to aggregate
#' @return An integer vectors with the following named elements:
#' \enumerate{
#'    \item \code{CharsWord} - number of word characters
#'    \item \code{CharsCmdEnvir} - command and words characters
#'    \item \code{CharsWhite} - LaTeX white characters, including \{ and \} in some contexts
#'    \item \code{Words} - number of words
#'    \item \code{Cmds} - number of commands
#'    \item \code{Envirs} - number of environments
#' }
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin
#'       nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel 
#'       lorem. Etiam pellentesque aliquet tellus."
#' stri_stats_latex(s)
#' 
#' @family stats
#' @export
stri_stats_latex <- function(str) {
   .Call("stri_stats_latex", str, PACKAGE="stringi")
}

