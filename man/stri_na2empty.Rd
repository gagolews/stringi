% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{stri_na2empty}
\alias{stri_na2empty}
\title{Replace NAs with empty strings}
\usage{
stri_na2empty(x)
}
\arguments{
\item{x}{a character vector}
}
\value{
Always returns a character vector.
}
\description{
This function replaces all missing values with empty strings
}
\examples{
stri_na2empty(c("a", NA, "", "b"))

}
\seealso{
Other utils: \code{\link{stri_list2matrix}},
  \code{\link{stri_remove_empty}}
}