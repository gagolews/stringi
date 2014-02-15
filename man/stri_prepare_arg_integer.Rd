\name{stri_prepare_arg_integer}
\alias{stri_prepare_arg_integer}
\title{Prepare an Integer Vector Argument [internal]}
\usage{
stri_prepare_arg_integer(x)
}
\arguments{
  \item{x}{argument to be checked}
}
\value{
If \code{x} is a factor, \code{\link{as.character}} is
called, and the resulting character vector is coerced to
integer. If it is an integer vector, then it is returned
with no change. If an atomic vector or a matrix is given,
it is coerced to an integer vector. Otherwise the function
throws an error.
}
\description{
This is an internal function. However, the interested user
may play with it in order to get more insight on how
\pkg{stringi} deals with its functions' arguments. See
`Value' section for details.
}
\seealso{
Other prepare_arg: \code{\link{stri_prepare_arg_double_1}};
\code{\link{stri_prepare_arg_double}};
\code{\link{stri_prepare_arg_integer_1}};
\code{\link{stri_prepare_arg_logical_1}};
\code{\link{stri_prepare_arg_logical}};
\code{\link{stri_prepare_arg_raw}};
\code{\link{stri_prepare_arg_string_1}};
\code{\link{stri_prepare_arg_string}};
\code{\link{stringi-arguments}}
}

