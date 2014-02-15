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
#' General Statistics for a Character Vector
#'
#' @description
#' This function gives general statistics for a character vector,
#' e.g. obtained by loading a text file with the
#' \code{\link{readLines}} or \code{\link{stri_read_lines}} function,
#' where each text line' is represented by a separate string.
#'
#' @details
#' Any of the strings must not contain \code{\\r} or \code{\\n} characters,
#' otherwise you will get at error.
#'
#' Below by `white space` we mean the Unicode binary property
#' \code{WHITE_SPACE}, see \code{stringi-search-charclass}.
#'
#' @param str character vector to be aggregated
#' @return Returns an integer vector with the following named elements:
#' \enumerate{
#'    \item \code{Lines} - number of lines (number of
#'    non-missing strings in the vector);
#'    \item \code{LinesNEmpty} - number of lines with at least
#'    one non-\code{WHITE_SPACE} character;
#'    \item \code{Chars} - total number of Unicode code points detected;
#'    \item \code{CharsNWhite} - number of Unicode code points
#'    that are not \code{WHITE_SPACE}s;
#'    \item ... (Other stuff that may appear in future releases of \pkg{stringi}).
#' }
#' @examples
#' s <- c("Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
#'        "nibh augue, suscipit a, scelerisque sed, lacinia in, mi.",
#'        "Cras vel lorem. Etiam pellentesque aliquet tellus.",
#'        "")
#' stri_stats_general(s)
#'
#' @family stats
#' @export
stri_stats_general <- function(str) {
   .Call("stri_stats_general", str, PACKAGE="stringi")
}


#' @title
#' Statistics for a Character Vector Containing LaTeX Commands
#'
#' @description
#' This function gives LaTeX-oriented statistics for a character vector,
#' e.g. obtained by loading a text file with the
#' \code{\link{readLines}} function, where each text line
#' is represented by a separate string.
#'
#' @details
#' We use a slightly modified LaTeX Word Count algorithm taken from Kile 2.1.3,
#' see \url{http://kile.sourceforge.net/team.php} for original contributors.
#'
#'
#'
#' @param str character vector to be aggregated
#' @return Returns an integer vector with the following named elements:
#' \enumerate{
#'    \item \code{CharsWord} - number of word characters;
#'    \item \code{CharsCmdEnvir} - command and words characters;
#'    \item \code{CharsWhite} - LaTeX white spaces, including \{ and \} in some contexts;
#'    \item \code{Words} - number of words;
#'    \item \code{Cmds} - number of commands;
#'    \item \code{Envirs} - number of environments;
#'    \item ... (Other stuff that may appear in future releases of \pkg{stringi}).
#' }
#' @examples
#' s <- c("Lorem \\textbf{ipsum} dolor sit \\textit{amet}, consectetur adipisicing elit.",
#'        "\\begin{small}Proin nibh augue,\\end{small} suscipit a, scelerisque sed, lacinia in, mi.",
#'        "")
#' stri_stats_latex(s)
#' \dontrun{
#' # Stats for the preprint version of M. Gagolewski's book
#' # "Programowanie w jezyku R", Wydawnictwo Naukowe PWN, 2014.
#' # see http://rksiazka.rexamine.com
#' apply(
#'    sapply(
#'       lapply(
#'          list.files(path="~/Publikacje/ProgramowanieR/rozdzialy/",
#'             pattern="*.tex$", recursive=TRUE, full.names=TRUE),
#'          readLines),
#'       stri_stats_latex),
#'    1, sum)
#'
#' CharsWord CharsCmdEnvir    CharsWhite         Words          Cmds        Envirs
#'    718755        458403        281989        120202         37055          6119
#' }
#'
#' @family stats
#' @export
stri_stats_latex <- function(str) {
   .Call("stri_stats_latex", str, PACKAGE="stringi")
}
