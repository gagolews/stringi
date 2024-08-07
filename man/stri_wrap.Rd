% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wrap.R
\name{stri_wrap}
\alias{stri_wrap}
\title{Word Wrap Text to Format Paragraphs}
\usage{
stri_wrap(
  str,
  width = floor(0.9 * getOption("width")),
  cost_exponent = 2,
  simplify = TRUE,
  normalize = TRUE,
  normalise = normalize,
  indent = 0,
  exdent = 0,
  prefix = "",
  initial = prefix,
  whitespace_only = FALSE,
  use_length = FALSE,
  locale = NULL
)
}
\arguments{
\item{str}{character vector of strings to reformat}

\item{width}{single integer giving the suggested
maximal total width/number of code points per line}

\item{cost_exponent}{single numeric value, values not greater than zero
will select a greedy word-wrapping algorithm; otherwise
this value denotes the exponent in the cost function
of a (more aesthetic) dynamic programming-based algorithm
(values in [2, 3] are recommended)}

\item{simplify}{single logical value, see Value}

\item{normalize}{single logical value, see Details}

\item{normalise}{alias of \code{normalize}}

\item{indent}{single non-negative integer; gives the indentation of the
first line in each paragraph}

\item{exdent}{single non-negative integer; specifies the indentation
of subsequent lines in paragraphs}

\item{prefix, initial}{single strings; \code{prefix} is used as prefix for each
line except the first, for which \code{initial} is utilized}

\item{whitespace_only}{single logical value; allow breaks only at white-spaces?
if \code{FALSE}, \pkg{ICU}'s line break iterator is used to split text
into words, which is suitable for natural language processing}

\item{use_length}{single logical value; should the number of code
points be used instead of the total code point width (see \code{\link{stri_width}})?}

\item{locale}{\code{NULL} or \code{''} for text boundary analysis following
the conventions of the default locale, or a single string with
locale identifier, see \link{stringi-locale}}
}
\value{
If \code{simplify} is \code{TRUE}, then a character vector is returned.
Otherwise, you will get a list of \code{length(str)} character vectors.
}
\description{
This function breaks text paragraphs into lines,
of total width (if it is possible) at most given \code{width}.
}
\details{
Vectorized over \code{str}.

If \code{whitespace_only} is \code{FALSE},
then \pkg{ICU}'s line-\code{BreakIterator} is used to determine
text boundaries where a line break is possible.
This is a locale-dependent operation.
Otherwise, the breaks are only at white-spaces.

Note that Unicode code points may have various widths when
printed on the console and that this function, by default, takes that
into account. By changing the state of the \code{use_length}
argument, this function starts to act as if each code point
was of width 1.

If \code{normalize} is \code{FALSE},
then multiple white spaces between the word boundaries are
preserved within each wrapped line.
In such a case, none of the strings can contain \code{\\r}, \code{\\n},
or other new line characters, otherwise you will get an error.
You should split the input text into lines
or, for example, substitute line breaks with spaces
before applying this function.

If \code{normalize} is \code{TRUE}, then
all consecutive white space (ASCII space, horizontal TAB, CR, LF)
sequences are replaced with single ASCII spaces
before actual string wrapping. Moreover, \code{\link{stri_split_lines}}
and \code{\link{stri_trans_nfc}} is called on the input character vector.
This is for compatibility with \code{\link{strwrap}}.

The greedy algorithm (for \code{cost_exponent} being non-positive)
provides a very simple way for word wrapping.
It always puts as many words in each line as possible.
This method -- contrary to the dynamic algorithm -- does not minimize
the number of space left at the end of every line.
The dynamic algorithm (a.k.a. Knuth's word wrapping algorithm)
is more complex, but it returns text wrapped
in a more aesthetic way. This method minimizes the squared
(by default, see \code{cost_exponent}) number of spaces  (raggedness)
at the end of each line, so the text is mode arranged evenly.
Note that the cost of printing the last line is always zero.
}
\examples{
s <- stri_paste(
   'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin ',
   'nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel ',
   'lorem. Etiam pellentesque aliquet tellus.')
cat(stri_wrap(s, 20, 0.0), sep='\n') # greedy
cat(stri_wrap(s, 20, 2.0), sep='\n') # dynamic
cat(stri_pad(stri_wrap(s), side='both'), sep='\n')

}
\references{
D.E. Knuth, M.F. Plass,
Breaking paragraphs into lines, \emph{Software: Practice and Experience} 11(11),
1981, pp. 1119--1184.
}
\seealso{
The official online manual of \pkg{stringi} at \url{https://stringi.gagolewski.com/}

Gagolewski M., \pkg{stringi}: Fast and portable character string processing in R, \emph{Journal of Statistical Software} 103(2), 2022, 1-59, \doi{10.18637/jss.v103.i02}

Other locale_sensitive: 
\code{\link{\%s<\%}()},
\code{\link{about_locale}},
\code{\link{about_search_boundaries}},
\code{\link{about_search_coll}},
\code{\link{stri_compare}()},
\code{\link{stri_count_boundaries}()},
\code{\link{stri_duplicated}()},
\code{\link{stri_enc_detect2}()},
\code{\link{stri_extract_all_boundaries}()},
\code{\link{stri_locate_all_boundaries}()},
\code{\link{stri_opts_collator}()},
\code{\link{stri_order}()},
\code{\link{stri_rank}()},
\code{\link{stri_sort}()},
\code{\link{stri_sort_key}()},
\code{\link{stri_split_boundaries}()},
\code{\link{stri_trans_tolower}()},
\code{\link{stri_unique}()}

Other text_boundaries: 
\code{\link{about_search}},
\code{\link{about_search_boundaries}},
\code{\link{stri_count_boundaries}()},
\code{\link{stri_extract_all_boundaries}()},
\code{\link{stri_locate_all_boundaries}()},
\code{\link{stri_opts_brkiter}()},
\code{\link{stri_split_boundaries}()},
\code{\link{stri_split_lines}()},
\code{\link{stri_trans_tolower}()}
}
\concept{locale_sensitive}
\concept{text_boundaries}
\author{
\href{https://www.gagolewski.com/}{Marek Gagolewski} and other contributors
}
