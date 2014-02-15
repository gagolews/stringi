# Runs all tests for the package:

library("testthat")
library("stringi")
cat(stri_info(short=TRUE), "\n")
test_dir("devel/testthat/")
