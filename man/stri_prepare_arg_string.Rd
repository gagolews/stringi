\name{stri_prepare_arg_string}
\alias{stri_prepare_arg_string}
\title{Prepare a String Vector Argument [internal]}
\usage{
stri_prepare_arg_string(x)
}
\arguments{
  \item{x}{argument to be checked}
}
\value{
If \code{x} is a string, it is returned with no change. If
it is a factor, then \code{\link{as.character}} is called.
If an atomic vector or a matrix is given, it is coerced to
a character vector. If it is a \code{name} object, a
character vector of length 1 is generated. Otherwise the
function throws an error.
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
\code{\link{stri_prepare_arg_integer}};
\code{\link{stri_prepare_arg_logical_1}};
\code{\link{stri_prepare_arg_logical}};
\code{\link{stri_prepare_arg_raw}};
\code{\link{stri_prepare_arg_string_1}};
\code{\link{stringi-arguments}}
}

