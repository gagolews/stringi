# This file is part of the 'stringi' package for R.
# Copyright (c) 2013-2019, Marek Gagolewski and other contributors.
# All rights reserved.

# Runs all unit tests for the package:

library("testthat")
library("stringi")
library("stringr")
library("methods")

cat(stri_info(short=TRUE), "\n")
testWarnings <- TRUE

if (testWarnings) {
   test_dir("devel/testthat/")#, reporter="summary")
} else {
   oldOptions <- options(warn=10)
   test_that <- function(x, e) {
      eval(e)
   }
   test_dir("devel/testthat/", reporter="summary")
   do.call(options, oldOptions)
   rm(oldOptions)
   rm(test_that)
}

rm(testWarnings)
