# Runs all tests for the package:

library("testthat")
library("stringi")
library("stringr")
library("methods")
cat(stri_info(short=TRUE), "\n")
test_dir("devel/testthat/")
