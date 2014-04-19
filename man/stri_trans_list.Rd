\name{stri_trans_list}
\alias{stri_trans_list}
\title{List Available Transforms}
\usage{
stri_trans_list()
}
\value{
Returns a character vector.
}
\description{
Returns a list of available text transform identifiers.
Each of them may be used in
\code{\link{stri_trans_general}} tasks.
}
\references{
\emph{General Transforms} -- ICU User Guide,
\url{http://userguide.icu-project.org/transforms/general}
}
\seealso{
Other transform: \code{\link{stri_trans_general}};
\code{\link{stri_trans_tolower}},
\code{\link{stri_trans_totitle}},
\code{\link{stri_trans_toupper}}
}

