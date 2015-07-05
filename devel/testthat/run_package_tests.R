# Runs all tests for the package:

library("testthat")
library("stringi")
library("stringr")
library("methods")
cat(stri_info(short=TRUE), "\n")
oldOptions <- options(warn=2)
test_dir("devel/testthat/", reporter="summary")
do.call(options, oldOptions)
rm(oldOptions)

