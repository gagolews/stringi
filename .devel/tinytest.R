# This file is part of the 'stringi' project.
# Copyright (c) 2013-2024, Marek Gagolewski <https://www.gagolewski.com/>
# All rights reserved.

# Runs all unit tests for the package:

set.seed(123)
library("tinytest")
library("stringi")
library("methods")

#str(stringi::stri_info())
# options(encoding="UTF-8")  # e.g., on Windows
cat(stri_info(short=TRUE), "\n")
cat(Sys.getlocale(), "\n")

testWarnings <- TRUE

if (testWarnings) {
    oldOptions <- options(warn=1)
    t <- run_test_dir(".devel/tinytest/", verbose=TRUE)
    print(t, limit=25, nlong=25, sidefx=TRUE)
    do.call(options, oldOptions)
    rm(oldOptions)
} else {
    oldOptions <- options(warn=10)
    t <- run_test_dir(".devel/tinytest/")
    print(t)
    do.call(options, oldOptions)
    rm(oldOptions)
}

rm(testWarnings)
cat(stri_info(short=TRUE), "\n")
