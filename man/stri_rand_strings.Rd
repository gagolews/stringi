\name{stri_rand_strings}
\alias{stri_rand_strings}
\title{Generate Random Strings}
\usage{
stri_rand_strings(n, length, pattern = "[A-Za-z0-9]")
}
\arguments{
  \item{n}{single integer, number of observations}

  \item{length}{integer vector, desired string lengths}

  \item{pattern}{single string with regex-like character
  class specifier, see below}
}
\value{
Returns a character vector.
}
\description{
Generates (pseudo)random strings of desired lengths.
}
\details{
This operation may result in non-Unicode-normalized strings
and may give strange output for bidirectional strings.

If length of \code{length} is greater than \code{n}, then
redundant elements are ignored. Otherwise, \code{length} is
recycled if necessary.

Patterns are a series of characters bounded by square
brackets that contain lists of characters and Unicode
property sets. These patterns follow a syntax similar to
that employed by version 8 regular expression character
classes, see References for more details.

Lists are a sequence of characters that may have ranges
indicated by a ``-'' between two characters, as in "a-z".
The sequence specifies the range of all characters from the
left to the right, in Unicode order. For example, \code{[a
c d-f m]} is equivalent to \code{[a c d e f m]}. Whitespace
can be freely used for clarity as [a c d-f m] means the
same as \code{[acd-fm]}.

On the other hand, Unicode property sets are specified by a
Unicode property, such as \code{[:Letter:]}. Perl-style
properties are also recognized, e.g. \code{\\p{L}}. Note
that any character may be preceded by a backslash in order
to remove any special meaning.

Sampling of code points from the set specified by
\code{pattern} is always with replacement and each code
point appears with equal probability.
}
\examples{
stri_rand_strings(5, 10) # 5 strings of length 10
stri_rand_strings(5, sample(1:10, 5, replace=TRUE)) # 5 strings of random lengths

# generate n random passwords of length in [8, 14]
# consisting of at least one digit, small and big ASCII letter:
n <- 10
stri_rand_shuffle(stri_paste(
   stri_rand_strings(n, 1, '[0-9]'),
   stri_rand_strings(n, 1, '[a-z]'),
   stri_rand_strings(n, 1, '[A-Z]'),
   stri_rand_strings(n, sample(5:11, 5, replace=TRUE), '[a-zA-Z0-9]')
))
}
\references{
\emph{UnicodeSet} -- ICU User Guide,
\url{http://userguide.icu-project.org/strings/unicodeset}
}
\seealso{
Other random: \code{\link{stri_rand_shuffle}}
}

