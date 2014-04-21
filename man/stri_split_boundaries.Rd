\name{stri_split_boundaries}
\alias{stri_split_boundaries}
\title{Split Strings at Specific Text Boundaries}
\usage{
stri_split_boundaries(str, boundary = "word")
}
\arguments{
  \item{str}{character vector or an object coercible to}

  \item{boundary}{single string, one of \code{character},
  \code{line-break}, \code{sentence}, or \code{word},}
}
\value{
Returns a list of character vectors.
}
\description{
This function locates specific text boundaries (like
character, word, line, or sentence boundaries) and splits
strings at the indicated positions.
}
\details{
Text boundary analysis is the process of locating
linguistic boundaries while formatting and handling text.
Examples of this process include:

\itemize{ \item Locating appropriate points to word-wrap
text to fit within specific margins while displaying or
printing. \item Counting characters, words, sentences, or
paragraphs. \item Making a list of the unique words in a
document. \item Capitalizing the first letter of each word.
\item Locating a particular unit of the text (For example,
finding the third word in the document). }

This function uses \pkg{ICU}'s \code{BreakIterator} to
split given strings at specific boundaries. The
\code{character} boundary iterator tries to match what a
user would think of as a ``character'' -- a basic unit of a
writing system for a language -- which may be more than
just a single Unicode code point. The \code{word} boundary
iterator locates the boundaries of words, for purposes such
as ``Find whole words'' operations. The \code{line-break}
iterator locates positions that would be appropriate points
to wrap lines when displaying the text. On the other hand,
a \code{sentence}-break iterator locates sentence
boundaries.

For more details on different classes of text boundaries
refer to the \pkg{ICU} User Guide, see below.
}
\references{
\emph{Boundary Analysis} -- ICU User Guide,
http://userguide.icu-project.org/boundaryanalysis}
}
\seealso{
Other search_split: \code{\link{stri_split_charclass}},
\code{\link{stri_split_charclass}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines}},
\code{\link{stri_split_lines1}},
\code{\link{stri_split_lines1}};
\code{\link{stri_split_regex}},
\code{\link{stri_split_regex}}; \code{\link{stri_split}};
\code{\link{stringi-search}}
}

