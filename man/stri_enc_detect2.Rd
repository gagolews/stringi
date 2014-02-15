\name{stri_enc_detect2}
\alias{stri_enc_detect2}
\title{[DRAFT API] Detect Locale-Sensitive Character Encoding}
\usage{
stri_enc_detect2(str, locale = NULL)
}
\arguments{
  \item{str}{character vector, a raw vector, or a list of
  \code{raw} vectors}

  \item{locale}{\code{NULL} or \code{""} for default
  locale, \code{NA} for just checking the UTF-* family, or
  a single string with locale identifier.}
}
\value{
Just like \code{\link{stri_enc_detect}}, this function
returns a list of length equal to the length of \code{str}.
Each list element is a list with the following three named
components: \itemize{ \item \code{Encoding} -- string;
guessed encodings; \code{NA} on failure (iff
\code{encodings} is empty), \item \code{Language} -- always
\code{NA}, \item \code{Confidence} -- numeric in [0,1]; the
higher the value, the more confidence there is in the
match; \code{NA} on failure. } The guesses are ordered
w.r.t. nonincreasing confidence.
}
\description{
This function tries to detect character encoding in case
the language of text is known.

\bold{[THIS IS AN EXPERIMENTAL FUNCTION]}
}
\details{
Vectorized over \code{str}.

First, the text is checked whether it is valid UTF-32BE,
UTF-32LE, UTF-16BE, UTF-16LE, UTF-8 (as in
\code{\link{stri_enc_detect}}, this slightly bases on ICU's
\code{i18n/csrucode.cpp}, but we do it in our own way,
however) or ASCII.

If \code{locale} is not \code{NA} and the above fails, the
text is checked for the number of occurrences of
language-specific code points (data provided by the ICU
library) converted to all possible 8-bit encodings that
fully cover the indicated language. The encoding is
selected basing on the greatest number of total byte hits.

The guess is of course imprecise [\bold{This is DRAFT API -
still does not work as expected}], as it is obtained using
statistics. Because of this, detection works best if you
supply at least a few hundred bytes of character data
that's in a single language.

If you have no initial guess on language and encoding, try
with \code{\link{stri_enc_detect}} (uses ICU facilities).
However, it turns out that (empirically)
\code{stri_enc_detect2} works better than the ICU-based one
if UTF-* text is provided. Test yourself.
}
\seealso{
Other encoding_detection: \code{\link{stri_enc_detect}};
\code{\link{stri_enc_isascii}};
\code{\link{stri_enc_isutf16be}},
\code{\link{stri_enc_isutf16le}},
\code{\link{stri_enc_isutf32be}},
\code{\link{stri_enc_isutf32le}};
\code{\link{stri_enc_isutf8}};
\code{\link{stringi-encoding}}

Other locale_sensitive: \code{\link{stri_cmp}},
\code{\link{stri_compare}}; \code{\link{stri_count_fixed}};
\code{\link{stri_detect_fixed}};
\code{\link{stri_locate_all_fixed}},
\code{\link{stri_locate_all_fixed,}},
\code{\link{stri_locate_first_fixed}},
\code{\link{stri_locate_first_fixed,}},
\code{\link{stri_locate_last_fixed}},
\code{\link{stri_locate_last_fixed}};
\code{\link{stri_opts_collator}}; \code{\link{stri_order}},
\code{\link{stri_sort}};
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_all_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_first_fixed}},
\code{\link{stri_replace_last_fixed}},
\code{\link{stri_replace_last_fixed}};
\code{\link{stri_split_fixed}},
\code{\link{stri_split_fixed}};
\code{\link{stri_trans_tolower}},
\code{\link{stri_trans_totitle}},
\code{\link{stri_trans_toupper}};
\code{\link{stringi-locale}};
\code{\link{stringi-search-fixed}}
}

