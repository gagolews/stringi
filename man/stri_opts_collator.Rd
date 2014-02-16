\name{stri_opts_collator}
\alias{stri_opts_collator}
\title{Generate a List with Collator Options}
\usage{
stri_opts_collator(locale = NULL, strength = 3L,
  alternate_shifted = FALSE, french = FALSE, uppercase_first = NA,
  case_level = FALSE, normalization = FALSE, numeric = FALSE)
}
\arguments{
  \item{locale}{single string, \code{NULL} or \code{""} for
  default locale}

  \item{strength}{single integer in \{1,2,3,4\}, which
  defines collation strength; \code{1} for the most
  permissive collation rules, \code{4} for the most strict
  ones}

  \item{alternate_shifted}{single logical value;
  \code{FALSE} treats all the code points with
  non-ignorable primary weights in the same way,
  \code{TRUE} causes code points with primary weights that
  are equal or below the variable top value to be ignored
  on primary level and moved to the quaternary level}

  \item{french}{single logical value; used in Canadian
  French; \code{TRUE} results in secondary weights being
  considered backwards}

  \item{uppercase_first}{single logical value; \code{NA}
  orders upper and lower case letters in accordance to
  their tertiary weights, \code{TRUE} forces upper case
  letters to sort before lower case letters, \code{FALSE}
  does the opposite}

  \item{case_level}{single logical value; controls whether
  an extra case level (positioned before the third level)
  is generated or not}

  \item{normalization}{single logical value; if
  \code{TRUE}, then incremental check is performed to see
  whether the input data is in the FCD form. If the data is
  not in the FCD form, incremental NFD normalization is
  performed}

  \item{numeric}{single logical value; when turned on, this
  attribute generates a collation key for the numeric value
  of substrings of digits; This is a way to get '100' to
  sort AFTER '2'.}
}
\value{
Returns a named list object; missing options are left with
default values.
}
\description{
A convenience function to tune the Collator's behavior,
e.g. in \code{\link{stri_compare}},
\code{\link{stri_order}}, \code{\link{stri_detect_fixed}},
and other \link{stringi-search-fixed} functions.
}
\details{
\pkg{ICU}'s \emph{collator} performs a locale-aware,
natural-language alike string comparison. This is a more
reliable way of establishing relationships between string
than that provided by base \R, and definitely one that is
more complex than ordinary byte-comparison.

A note on collation \code{strength}: generally,
\code{strength} set to 4 is the least permissive. Set to 2
to ignore case differences. Set to 1 to also ignore
diacritical differences.

The strings are Unicode-normalized before the comparison.
}
\examples{
\dontrun{
stri_cmp("zupa100", "zupa2") != stri_cmp("zupa100", "zupa2", stri_opts_collator(numeric=TRUE))
stri_cmp("above mentioned", "above-mentioned")
stri_cmp("above mentioned", "above-mentioned", stri_opts_collator(alternate_shifted=TRUE))
}
}
\references{
\emph{Collation} -- ICU User Guide,
\url{http://userguide.icu-project.org/collation}

\emph{ICU Collation Service Architecture} -- ICU User
Guide,
\url{http://userguide.icu-project.org/collation/architecture}

\emph{\code{icu::Collator} Class Reference} -- ICU4C API
Documentation,
\url{http://www.icu-project.org/apiref/icu4c/classicu_1_1Collator.html}
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
\code{\link{stri_order}}, \code{\link{stri_sort}};
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_trans_tolower}},
\code{\link{stri_trans_totitle}},
\code{\link{stri_trans_toupper}};
\code{\link{stringi-locale}};
\code{\link{stringi-search-fixed}}

Other search_fixed: \code{\link{stri_count_fixed}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_extract_all_fixed}},
\code{\link{stri_extract_all_fixed,}},
\code{\link{stri_extract_first_fixed}},
\code{\link{stri_extract_first_fixed,}},
\code{\link{stri_extract_last_fixed}},
\code{\link{stri_extract_last_fixed}};
\code{\link{stri_locate_all_fixed}},
\code{\link{stri_locate_all_fixed,}},
\code{\link{stri_locate_first_fixed}},
\code{\link{stri_locate_first_fixed,}},
\code{\link{stri_locate_last_fixed}},
\code{\link{stri_locate_last_fixed}};
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stringi-search-fixed}};
\code{\link{stringi-search}}
}

