\name{stringi-arguments}
\alias{stringi-arguments}
\title{Passing Arguments to Functions in \pkg{stringi}}
\description{
Below we explain how \pkg{stringi} deals (in almost all
cases) with its functions' arguments.
}
\section{Coercion of Arguments}{
  When a character vector argument is expected, factors and
  other vectors coercible to characters vectors are
  silently converted with \code{\link{as.character}},
  otherwise an error is generated.

  When a logical, numeric or integer vector argument is
  expected, factors are converted with
  \code{as.*(\link{as.character}(...))}, and other
  coercible vectors are converted with \code{as.*},
  otherwise an error is generated.

  See the links below for the description of internal
  methods used in all functions from the \pkg{stringi}
  package (just to get more insight, in case you are
  interested in technical details). Anyway, we hope that
  everything works as you intuitively expect.
}

\section{Vectorization}{
  Almost all functions are vectorized with respect to all
  their arguments; This may sometimes lead to strange
  results - we assume you know what you are doing. However,
  thanks to this property you may e.g. search for one
  pattern in each given string, or search for each pattern
  in one given string.

  We of course took great care of performance issues: e.g.
  in regular expression searching, regex matchers are
  reused from iteration to iteration, as long it is
  possible.

  Functions with some non-vectorized arguments are rare:
  e.g. regular expression matcher's settings are
  established once per each call.

  Some functions assume that a vector with one element is
  given as an argument (like \code{collapse} in
  \code{\link{stri_join}}). In such cases, if an empty
  vector is given you will get an error and for vectors
  with more than 1 elements - a warning will be generator
  (only the first element will be used).

  You may find details on vectorization behavior in the man
  pages on each particular function of your interest.
}

\section{Handling Missing Values (\code{NA}s)}{
  \pkg{stringi} handles missing values consistently. For
  any vectorized operation, if at least one vector element
  is missing, then the corresponding resulting value is
  also set to \code{NA}.
}

\section{Preserving Input Objects' Attributes}{
  Generally, all our functions drop input objects'
  attributes (e.g. \code{\link{names}}, \code{\link{dim}},
  etc.). This is generally because of advanced
  vectorization and for efficiency reasons. Currently,
  there is only one exception to this rule: the
  \code{\link{stri_sort}} function. Thus, if this is
  needed, please remember to copy important attributes
  manually or use e.g. the subsetting operation like
  \code{x[] <- stri_...(x, ...)}.
}
\seealso{
Other prepare_arg: \code{\link{stri_prepare_arg_double_1}};
\code{\link{stri_prepare_arg_double}};
\code{\link{stri_prepare_arg_integer_1}};
\code{\link{stri_prepare_arg_integer}};
\code{\link{stri_prepare_arg_logical_1}};
\code{\link{stri_prepare_arg_logical}};
\code{\link{stri_prepare_arg_raw}};
\code{\link{stri_prepare_arg_string_1}};
\code{\link{stri_prepare_arg_string}}

Other stringi_general_topics:
\code{\link{stringi-encoding}};
\code{\link{stringi-locale}};
\code{\link{stringi-package}};
\code{\link{stringi-search-charclass}};
\code{\link{stringi-search-fixed}};
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}
}

