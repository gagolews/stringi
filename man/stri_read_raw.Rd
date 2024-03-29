% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/files.R
\name{stri_read_raw}
\alias{stri_read_raw}
\title{Read Text File as Raw}
\usage{
stri_read_raw(con, fname = con)
}
\arguments{
\item{con}{name of the output file or a connection object
(opened in the binary mode)}

\item{fname}{[DEPRECATED] alias of \code{con}}
}
\value{
Returns a vector of type \code{raw}.
}
\description{
Reads a text file as-is, with no conversion or text line splitting.
}
\details{
Once a text file is read into memory,
encoding detection (see \code{\link{stri_enc_detect}}),
conversion (see \code{\link{stri_encode}}), and/or
splitting of text into lines (see \code{\link{stri_split_lines1}})
can be performed.
}
\seealso{
The official online manual of \pkg{stringi} at \url{https://stringi.gagolewski.com/}

Gagolewski M., \pkg{stringi}: Fast and portable character string processing in R, \emph{Journal of Statistical Software} 103(2), 2022, 1-59, \doi{10.18637/jss.v103.i02}

Other files: 
\code{\link{stri_read_lines}()},
\code{\link{stri_write_lines}()}
}
\concept{files}
\author{
\href{https://www.gagolewski.com/}{Marek Gagolewski} and other contributors
}
