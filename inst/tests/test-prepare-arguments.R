
ICU:::stri_prepare_arg_string(LETTERS)
ICU:::stri_prepare_arg_string(c(TRUE, FALSE, TRUE))
ICU:::stri_prepare_arg_string(seq(0,1,0.1))
ICU:::stri_prepare_arg_string(c(1+1i, 2+2i))
ICU:::stri_prepare_arg_string(as.name("name"))
ICU:::stri_prepare_arg_string(matrix(1:10, nrow=2))
ICU:::stri_prepare_arg_string(matrix(letters[1:10], nrow=2))
ICU:::stri_prepare_arg_string(ts(1:10))
ICU:::stri_prepare_arg_string(as.factor(letters[c(1,1,1,2,1,1,1)]))
ICU:::stri_prepare_arg_string(numeric(0))
ICU:::stri_prepare_arg_string(NULL) # error
ICU:::stri_prepare_arg_string(list(1, 2, 3)) # error
ICU:::stri_prepare_arg_string(data.frame(1, 2, 3)) # error


require("microbenchmark")
require("testthat")
require("stringr")

microbenchmark(ICU:::stri_prepare_arg_string(LETTERS),
               stringr:::check_string(LETTERS), times=10000)

microbenchmark(ICU:::stri_prepare_arg_string(c(1+1i, 2+2i)),
               stringr:::check_string(c(1+1i, 2+2i)), times=10000)

