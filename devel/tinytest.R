# This file is part of the 'stringi' package for R.
# Copyright (c) 2013-2020, Marek Gagolewski and other contributors.
# All rights reserved.

# Runs all unit tests for the package:

set.seed(123)
library("tinytest")
library("stringi")
library("stringr")
library("methods")

cat(stri_info(short=TRUE), "\n")
testWarnings <- TRUE

if (testWarnings) {
    t <- run_test_dir("devel/tinytest/", verbose=TRUE)
    print(t, limit=25, nlong=25)
} else {
    oldOptions <- options(warn=10)
    t <- run_test_dir("devel/tinytest/")
    print(t)
    do.call(options, oldOptions)
    rm(oldOptions)
}

rm(testWarnings)
