## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice,
## this list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
## this list of conditions and the following disclaimer in the documentation
## and/or other materials provided with the distribution.
##
## 3. Neither the name of the copyright holder nor the names of its
## contributors may be used to endorse or promote products derived from
## this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
## BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
## FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
## OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
## WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
## OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
## EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#' @title
#' Randomly Shuffle Code Points in Each String
#'
#' @description
#' Generates a (pseudo)random permutation of code points
#' in each string.
#'
#' @details
#' This operation may result in non-Unicode-normalized
#' strings and may give strange output for bidirectional strings.
#'
#' See also \code{\link{stri_reverse}} for a reverse permutation
#' of code points.
#'
#' @param str character vector
#'
#' @return Returns a character vector.
#'
#' @examples
#' stri_rand_shuffle(c("abcdefghi", "0123456789"))
#' # you can do better than this with stri_rand_strings:
#' stri_rand_shuffle(rep(stri_paste(letters, collapse=''), 10))
#'
#' @family random
#' @export
stri_rand_shuffle <- function(str) {
   .Call(C_stri_rand_shuffle, str)
}


#' @title
#' Generate Random Strings
#'
#' @description
#' Generates (pseudo)random strings of desired lengths.
#'
#' @details
#' Vectorized over \code{length} and \code{pattern}.
#' If length of \code{length} or \code{pattern} is greater than \code{n},
#' then redundant elements are ignored. Otherwise,
#' these vectors are recycled if necessary.
#'
#' This operation may result in non-Unicode-normalized
#' strings and may give strange output for bidirectional strings.
#'
#' Sampling of code points from the set specified by \code{pattern}
#' is always done with replacement and each code point appears with equal
#' probability.
#'
#' @param n single integer, number of observations
#' @param length integer vector, desired string lengths
#' @param pattern character vector specifying character classes to draw
#' elements from, see \link{stringi-search-charclass}
#'
#' @return Returns a character vector.
#'
#' @examples
#' stri_rand_strings(5, 10) # 5 strings of length 10
#' stri_rand_strings(5, sample(1:10, 5, replace=TRUE)) # 5 strings of random lengths
#' stri_rand_strings(10, 5, "[\\p{script=latin}&\\p{Ll}]") # small letters from the Latin script
#'
#' # generate n random passwords of length in [8, 14]
#' # consisting of at least one digit, small and big ASCII letter:
#' n <- 10
#' stri_rand_shuffle(stri_paste(
#'    stri_rand_strings(n, 1, '[0-9]'),
#'    stri_rand_strings(n, 1, '[a-z]'),
#'    stri_rand_strings(n, 1, '[A-Z]'),
#'    stri_rand_strings(n, sample(5:11, 5, replace=TRUE), '[a-zA-Z0-9]')
#' ))
#'
#' @family random
#' @export
stri_rand_strings <- function(n, length, pattern="[A-Za-z0-9]") {
   .Call(C_stri_rand_strings, n, length, pattern)
}


#' @title
#' A Lorem Ipsum Generator
#'
#' @description
#' Generates (pseudo)random \emph{lorem ipsum} text consisting
#' of a given number of text paragraphs.
#'
#' @details
#' \emph{Lorem ipsum} is a dummy text often used as a source
#' of data for string processing and displaying/layouting exercises.
#'
#' Current implementation is very simple:
#' words are selected randomly from a Zipf distribution
#' (we base on a set of ca. 190 predefined Latin words).
#' Number of words per sentence and sentences per paragraph
#' follows a discretized, truncated normal distribution.
#' No Markov chain modeling, just i.i.d. word selection.
#'
#' @param nparagraphs single integer, number of paragraphs to generate
#' @param start_lipsum single logical value; should the resulting
#' text start with \emph{Lorem ipsum dolor sit amet}?
#'
#' @return Returns a character vector of length \code{nparagraphs}.
#'
#' @examples
#' cat(sapply(
#'    stri_wrap(stri_rand_lipsum(10), 80, simplify=FALSE),
#'    stri_flatten, collapse="\n"), sep="\n\n")
#' cat(stri_rand_lipsum(10), sep="\n\n")
#'
#' @family random
#' @export
stri_rand_lipsum <- function(nparagraphs, start_lipsum=TRUE) {
   # Whoa! A pure R function in stringi :)
   # Version 0.3-1 (Marek Gagolewski, 2014-10-16)

   nparagraphs <- as.integer(nparagraphs)
   stopifnot(is.finite(nparagraphs), nparagraphs >= 1)
   start_lipsum <- identical(start_lipsum, TRUE)

   rwords <- function(n) { # generate n random words
      words <- c("SED", "IN", "UT", "ET", "AC", "EU", "NON", "NEC", "AMET",
         "SIT", "VEL", "AT", "MAURIS", "A", "VITAE", "EGET", "QUIS", "NUNC",
         "NULLA", "ID", "VESTIBULUM", "PELLENTESQUE", "TINCIDUNT", "ALIQUAM",
         "IPSUM", "DONEC", "TURPIS", "LIGULA", "EGESTAS", "NIBH", "SAPIEN",
         "ANTE", "NISL", "VELIT", "ERAT", "EROS", "LEO", "MAGNA", "JUSTO",
         "ENIM", "MI", "PURUS", "EST", "LACUS", "LOREM", "QUAM", "DIAM",
         "RISUS", "DOLOR", "SEM", "AUGUE", "NEQUE", "TEMPOR", "DUI", "ARCU",
         "METUS", "TORTOR", "URNA", "LIBERO", "PHARETRA", "TEMPUS", "FAUCIBUS",
         "LECTUS", "SUSPENDISSE", "FELIS", "ODIO", "ORCI", "VARIUS", "MASSA",
         "TELLUS", "VOLUTPAT", "BLANDIT", "INTERDUM", "LOBORTIS", "MAXIMUS",
         "NISI", "LUCTUS", "PORTTITOR", "AUCTOR", "ELEMENTUM", "EX", "MAECENAS",
         "MALESUADA", "TRISTIQUE", "ULLAMCORPER", "ULTRICES", "NULLAM",
         "CONSEQUAT", "LACINIA", "PHASELLUS", "ACCUMSAN", "DAPIBUS", "ELEIFEND",
         "COMMODO", "DUIS", "EFFICITUR", "ELIT", "IMPERDIET", "AENEAN",  "IACULIS",
         "NAM", "CONSECTETUR", "FERMENTUM", "PORTA", "SCELERISQUE",  "SODALES",
         "FEUGIAT", "LAOREET", "VULPUTATE", "DICTUM", "QUISQUE",  "FACILISIS",
         "FINIBUS", "ORNARE", "PULVINAR", "RHONCUS", "CONDIMENTUM",  "MOLLIS",
         "PRETIUM", "ALIQUET", "CONGUE", "POSUERE", "SUSCIPIT",  "ULTRICIES",
         "CURABITUR", "GRAVIDA", "MATTIS", "VIVERRA", "CURSUS",  "EUISMOD",
         "RUTRUM", "VENENATIS", "CONVALLIS", "PROIN", "VEHICULA",  "PLACERAT",
         "SAGITTIS", "CRAS", "INTEGER", "MORBI", "VIVAMUS",  "PRAESENT",
         "BIBENDUM", "MOLESTIE", "SEMPER", "FRINGILLA", "FUSCE",  "DIGNISSIM",
         "ETIAM", "HENDRERIT", "SOLLICITUDIN", "PER", "FAMES",  "POTENTI", "AD",
         "APTENT", "CLASS", "CONUBIA", "HIMENAEOS", "INCEPTOS",  "LITORA",
         "NOSTRA", "SOCIOSQU", "TACITI", "TORQUENT", "HABITANT",  "NETUS",
         "SENECTUS", "PRIMIS", "CUM", "DIS", "MAGNIS", "MONTES",  "MUS",
         "NASCETUR", "NATOQUE", "PARTURIENT", "PENATIBUS", "RIDICULUS",
         "SOCIIS", "ADIPISCING", "FACILISI", "CUBILIA", "CURAE", "DICTUMST",
         "HABITASSE", "HAC", "PLATEA")

      # Zipf distribution
      dzipf <- function(k, N, s) 1/k^s/sum(1/(1:N)^s)
      pzipf.y <- c(0, cumsum(dzipf(1:length(words), length(words), 0.5)))
      robs <- findInterval(runif(n), pzipf.y)
      words[robs]
   }


   rtruncnorm <- function(n, a, b, mu, sd) {
      # truncated discretized normal distribution
      x <- round(rnorm(n, mu, sd))
      while(any(x < a | x > b))
         x[x < a | x > b] <- round(rnorm(sum(x < a | x > b), mu, sd))
      x
   }

   sent_para <- rtruncnorm(nparagraphs, 7, 20, 11, 3)
   word_sent <- lapply(sent_para, function(numsent)
      rtruncnorm(numsent, 2, Inf, 8, 3))

   totwords <- sum(unlist(word_sent))
   words <- rwords(totwords)
   seps <- sample(c(" ", ", "), replace=TRUE, size=totwords, prob=c(0.9, 0.1))
   seps[cumsum(unlist(word_sent))] <- sample(c(". ", "? ", "! "),
      size=length(unlist(word_sent)), replace=TRUE, prob=c(0.95, 0.025, 0.025)) # end of sentence
   seps[cumsum(sapply(word_sent, sum))] <- ".\n" # end of para
   seps[totwords] <- "." # very last sentence in very last para

   if (start_lipsum) {
      words <- c("LOREM", "IPSUM", "DOLOR", "SIT", "AMET", words)
      seps  <- c(" ",     " ",     " ",     " ",   ", ", seps)
   }

   ret <- stri_split_charclass(stri_paste(words, seps, collapse=""), "[\\n]")[[1]]
   ret <- stri_trans_totitle(ret, opts_brkiter=stri_opts_brkiter(type="sentence"))
   ret
}
