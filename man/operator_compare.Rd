% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compare.R
\name{\%s<\%}
\alias{\%s<\%}
\alias{operator_compare}
\alias{oper_comparison}
\alias{oper_compare}
\alias{\%s<=\%}
\alias{\%s>\%}
\alias{\%s>=\%}
\alias{\%s==\%}
\alias{\%s!=\%}
\alias{\%s===\%}
\alias{\%s!==\%}
\alias{\%stri<\%}
\alias{\%stri<=\%}
\alias{\%stri>\%}
\alias{\%stri>=\%}
\alias{\%stri==\%}
\alias{\%stri!=\%}
\alias{\%stri===\%}
\alias{\%stri!==\%}
\title{Compare Strings with or without Collation}
\usage{
e1 \%s<\% e2

e1 \%s<=\% e2

e1 \%s>\% e2

e1 \%s>=\% e2

e1 \%s==\% e2

e1 \%s!=\% e2

e1 \%s===\% e2

e1 \%s!==\% e2

e1 \%stri<\% e2

e1 \%stri<=\% e2

e1 \%stri>\% e2

e1 \%stri>=\% e2

e1 \%stri==\% e2

e1 \%stri!=\% e2

e1 \%stri===\% e2

e1 \%stri!==\% e2
}
\arguments{
\item{e1, e2}{character vectors or objects coercible to character vectors}
}
\value{
All the functions return a logical vector
indicating the result of a pairwise comparison.
As usual, the elements of shorter vectors are recycled if necessary.
}
\description{
Relational operators for comparing corresponding strings in
two character vectors, with a typical R look-and-feel.
}
\details{
These functions call \code{\link{stri_cmp_le}} or its
friends, using the default collator options.
As a consequence, they are vectorized over \code{e1} and \code{e2}.

\code{\%stri==\%} tests for canonical equivalence of strings
(see \code{\link{stri_cmp_equiv}}) and is a locale-dependent operation.

\code{\%stri===\%} performs a locale-independent,
code point-based comparison.
}
\examples{
'a' \%stri<\% 'b'
c('a', 'b', 'c') \%stri>=\% 'b'

}
\seealso{
The official online manual of \pkg{stringi} at \url{https://stringi.gagolewski.com/}

Gagolewski M., \pkg{stringi}: Fast and portable character string processing in R, \emph{Journal of Statistical Software} 103(2), 2022, 1-59, \doi{10.18637/jss.v103.i02}

Other locale_sensitive: 
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
\code{\link{stri_unique}()},
\code{\link{stri_wrap}()}
}
\concept{locale_sensitive}
\author{
\href{https://www.gagolewski.com/}{Marek Gagolewski} and other contributors
}
