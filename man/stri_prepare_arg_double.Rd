\name{stri_prepare_arg_double}
\alias{stri_prepare_arg_double}
\title{Prepare a Numeric Vector Argument [internal]}
\usage{
stri_prepare_arg_double(x)
}
\arguments{
  \item{x}{argument to be checked}
}
\value{
If \code{x} is a factor, \code{\link{as.character}} is
called, and the resulting character vector is coerced to
numeric. If it is a numeric vector, then it is returned
with no change. If atomic vector or a matrix is given, it
is coerced to a numeric vector. Otherwise the function
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
\code{\link{stri_prepare_arg_integer_1}};
\code{\link{stri_prepare_arg_integer}};
\code{\link{stri_prepare_arg_logical_1}};
\code{\link{stri_prepare_arg_logical}};
\code{\link{stri_prepare_arg_raw}};
\code{\link{stri_prepare_arg_string_1}};
\code{\link{stri_prepare_arg_string}};
\code{\link{stringi-arguments}}
}

