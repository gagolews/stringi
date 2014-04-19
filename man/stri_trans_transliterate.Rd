\name{stri_trans_transliterate}
\alias{stri_trans_transliterate}
\title{Transform Text, Including Transliteration}
\usage{
stri_trans_transliterate(str, id)
}
\arguments{
  \item{str}{character vector}

  \item{id}{a single string with transform identifier, see
  \code{\link{stri_trans_list}}}
}
\value{
Returns a character vector.
}
\description{
\pkg{ICU} General transforms provide a general-purpose
package for processing Unicode text. They are a powerful
and flexible mechanism for handling a variety of different
tasks, including: \itemize{ \item Uppercase, Lowercase,
Titlecase, Full/Halfwidth conversions, \item Normalization,
\item Hex and Character Name conversions, \item Script to
Script conversion/transliteration. }
}
\details{
To get the list of available transforms, call
\code{\link{stri_trans_list}}.

\pkg{ICU} Transforms were mainly designed to transliterate
characters from one script to another (for example, from
Greek to Latin, or Japanese Katakana to Latin). However,
the services performed here represent a much more general
mechanism capable of handling a much broader range of
tasks. In particular, the Transforms include pre-built
transformations for case conversions, for normalization
conversions, for the removal of given characters, and also
for a variety of language and script transliterations.
Transforms can be chained together to perform a series of
operations and each step of the process can use a
UnicodeSet to restrict the characters that are affected.
}
\examples{
\dontrun{

}
}
\references{
\emph{General Transforms} -- ICU User Guide,
\url{http://userguide.icu-project.org/transforms/general}
}
\seealso{
Other transform: \code{\link{stri_trans_list}};
\code{\link{stri_trans_tolower}},
\code{\link{stri_trans_totitle}},
\code{\link{stri_trans_toupper}}
}

