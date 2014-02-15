\name{stri_split_lines}
\alias{stri_split_lines}
\alias{stri_split_lines1}
\title{Split a String into Text Lines}
\usage{
stri_split_lines(str, n_max = -1L, omit_empty = FALSE)

stri_split_lines1(str)
}
\arguments{
  \item{str}{character vector}

  \item{n_max}{integer vector, maximal number of pieces to
  return}

  \item{omit_empty}{logical vector; determines whether
  empty strings should be removed from the result}
}
\value{
\code{stri_split_lines} returns a list of character
vectors. If any input string is \code{NA}, then the
corresponding list element is a \code{NA} string.

\code{stri_split_lines1(str)} is like
\code{stri_split_lines(str[1])[[1]]} (with default
parameters), thus it returns a character vector. Moreover,
if the input string ends at a newline sequence, the last
empty string is omitted from the result. Therefore, this
function is convenient for splitting a loaded text file
into lines.
}
\description{
These functions split each character string into text
lines.
}
\details{
Vectorized over \code{str}, \code{pattern}, \code{n_max},
and \code{omit_empty}.

If \code{n_max} is negative (default), then all pieces are
extracted.

\code{omit_empty} is applied during splitting: if set to
\code{TRUE}, then empty strings will never appear in the
resulting vector.

Newlines are represented on different platforms e.g. by
carriage return (CR, 0x0D), line feed (LF, 0x0A), CRLF, or
next line (NEL, 0x85). Moreover, the Unicode Standard
defines two unambiguous separator characters, Paragraph
Separator (PS, 0x2029) and Line Separator (LS, 0x2028).
Sometimes also vertical tab (VT, 0x0B) and form feed (FF,
0x0C) are used.

This function follows UTR#18 rules, where a newline
sequence corresponds to the following regular expression:
\code{(?:\\u\{D A\}|(?!\\u\{D
A\})[\\u\{A\}-\\u\{D\}\\u\{85\}\\u\{2028\}\\u\{2029\}]}.
Each match is used to split a text line. Of course, the
search is not performed via regexes here, for efficiency
reasons.
}
\references{
\emph{Unicode Newline Guidelines} -- Unicode Technical
Report #13,
\url{http://www.unicode.org/standard/reports/tr13/tr13-5.html}

\emph{Unicode Regular Expressions} -- Unicode Technical
Standard #18, \url{http://www.unicode.org/reports/tr18/}
}
\seealso{
Other search_split: \code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}}; \code{\link{stri_split}};
\code{\link{stringi-search}}
}

