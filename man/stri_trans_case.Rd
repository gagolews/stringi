\name{stri_trans_tolower}
\alias{stri_trans_tolower}
\alias{stri_trans_totitle}
\alias{stri_trans_toupper}
\title{Translate String with Case Mapping}
\usage{
stri_trans_tolower(str, locale = NULL)

stri_trans_toupper(str, locale = NULL)

stri_trans_totitle(str, locale = NULL)
}
\arguments{
  \item{str}{character vector}

  \item{locale}{\code{NULL} or \code{""} for case mapping
  following the conventions of the default locale, or a
  single string with locale identifier, see
  \link{stringi-locale}.}
}
\value{
Each function returns a character vector.
}
\description{
These functions translate strings either to lower case,
UPPER CASE, or to Title Case.
}
\details{
\pkg{ICU} implements full Unicode string case mappings. In
general, \itemize{ \item case mapping can change the number
of code points and/or code units of a string, \item is
language-sensitive (results may differ depending on
locale), and \item is context-sensitive (a character in the
input string may map differently depending on surrounding
characters). }
}
\examples{
\dontrun{
stri_trans_toupper("\\u00DF", "de_DE") # small German double s
stri_trans_toupper("i", "en_US") != stri_trans_toupper("i", "tr_TR")
stri_trans_toupper(c('abc','123','\\u0105\\u0104'))

stri_trans_tolower(c('AbC','123','\\u0105\\u0104'))

stri_trans_totitle(c('AbC','123','\\u0105\\u0104'))
stri_trans_totitle("aLA mA kOTA")

stri_trans_totitle('taming of the shrew', locale='en_US') # TODO: we are working on this
}
}
\references{
\emph{Case Mappings} -- ICU User Guide,
\url{http://userguide.icu-project.org/transforms/casemappings}
}
\seealso{
Other locale_sensitive: \code{\link{stri_cmp}},
\code{\link{stri_compare}}; \code{\link{stri_count_fixed}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_enc_detect2}};
\code{\link{stri_locate_all_fixed}},
\code{\link{stri_locate_all_fixed,}},
\code{\link{stri_locate_first_fixed}},
\code{\link{stri_locate_first_fixed,}},
\code{\link{stri_locate_last_fixed}},
\code{\link{stri_locate_last_fixed}};
\code{\link{stri_opts_collator}}; \code{\link{stri_order}},
\code{\link{stri_sort}};
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stringi-locale}};
\code{\link{stringi-search-fixed}}
}

