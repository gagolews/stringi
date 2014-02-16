\name{stri_count_regex}
\alias{stri_count_regex}
\title{Count the Number of Regex Pattern Matches}
\usage{
stri_count_regex(str, pattern, opts_regex = list())
}
\arguments{
  \item{str}{character vector of strings to search in}

  \item{pattern}{character vector of regular expressions}

  \item{opts_regex}{a named list as generated with
  \code{\link{stri_opts_regex}}}
}
\value{
Returns an integer vector.
}
\description{
This function counts the number of occurrences of matches
to a regex pattern.
}
\details{
Vectorized over \code{str} and \code{pattern}.

If \code{pattern} is empty, then the result is \code{NA}
and a warning is generated.
}
\examples{
\dontrun{
s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
stri_count_regex(s,"(s|el)it")
stri_count_regex(s,"i.i")
stri_count_regex(s,".it")
stri_count_regex("bab baab baaab",c("b.*?b","b.b"))
stri_count_regex(c("stringi w R","REXAMINE","123"), '( R|RE)')
stri_count_regex(c("stringi w R","REXAMINE","123"), '(i|I|1)')
}
}
\seealso{
Other search_count: \code{\link{stri_count_charclass}};
\code{\link{stri_count_fixed}}; \code{\link{stri_count}};
\code{\link{stringi-search}}

Other search_regex: \code{\link{stri_detect_regex}};
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_all_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_first_regex}},
\code{\link{stri_extract_last_regex}},
\code{\link{stri_extract_last_regex}};
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_all_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_first_regex}},
\code{\link{stri_locate_last_regex}},
\code{\link{stri_locate_last_regex}};
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_all_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_first_regex}},
\code{\link{stri_match_last_regex}},
\code{\link{stri_match_last_regex}};
\code{\link{stri_opts_regex}};
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_all_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_first_regex}},
\code{\link{stri_replace_last_regex}},
\code{\link{stri_replace_last_regex}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}};
\code{\link{stringi-search-regex}};
\code{\link{stringi-search}}
}

