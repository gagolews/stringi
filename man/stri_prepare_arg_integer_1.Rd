\name{stri_prepare_arg_integer_1}
\alias{stri_prepare_arg_integer_1}
\title{Prepare an Integer Vector Argument [Single Value]  [internal]}
\usage{
stri_prepare_arg_integer_1(x)
}
\arguments{
  \item{x}{argument to be checked}
}
\value{
In the first place, \code{\link{stri_prepare_arg_integer}}
is called. On ab empty vector, an error is generated. If
there are more than 1 elements, a warning is generated. A
vector with one element (the first in \code{x}) is
returned.
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
\code{\link{stri_prepare_arg_integer}};
\code{\link{stri_prepare_arg_logical_1}};
\code{\link{stri_prepare_arg_logical}};
\code{\link{stri_prepare_arg_raw}};
\code{\link{stri_prepare_arg_string_1}};
\code{\link{stri_prepare_arg_string}};
\code{\link{stringi-arguments}}
}

