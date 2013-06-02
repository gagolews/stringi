require(microbenchmark)

local({
   
   require('compiler')
   stri_test_returnasis_compiled <- cmpfun(stringi:::stri_test_returnasis)
   s <- ""
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
     identity(s),
     stri_test_returnasis_compiled(s),
     stringi:::stri_test_returnasis(s),          # !!!!!!!!   O_O
     stringi:::stri_prepare_arg_string(s), 
     stringi:::stri_test_UnicodeContainer8(s),
     stringi:::stri_test_UnicodeContainer16(s)
   ))
   
   

})


# Measurement #1 (2013-05-19, MG)
#    Unit: nanoseconds
#    expr   min      lq  median      uq   max neval
#    identity(s)   440   645.0   766.0   914.5 11564   100
#    stri_test_returnasis_compiled(s)  1590  1864.5  2018.5  2215.5  5872   100
#    stringi:::stri_test_returnasis(s)  9620 10641.0 11006.5 11741.5 42436   100
#    stringi:::stri_prepare_arg_string(s)  9552 10329.5 10799.0 11795.5 88299   100
#    stringi:::stri_test_UnicodeContainer8(s) 10003 10997.0 11367.5 12459.5 25446   100
#    stringi:::stri_test_UnicodeContainer16(s) 10504 11128.5 11785.0 12573.5 25176   100




local({
   
   s <- stri_dup(stri_flatten(stri_dup(c("aa", "bb"), 1000), " "), 1:10)
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
      stringi:::stri_prepare_arg_string(s), 
      stringi:::stri_test_UnicodeContainer8(s),
      stringi:::stri_test_UnicodeContainer16(s)
   ))

})


# Measurement #1 (2013-05-19, MG)
# Unit: microseconds
# expr     min       lq   median       uq     max neval
# stringi:::stri_prepare_arg_string(s)   9.974  11.9055  13.1745  19.1200  28.835   100
# stringi:::stri_test_UnicodeContainer8(s)  11.371  12.8830  14.0140  21.1885  86.676   100
# stringi:::stri_test_UnicodeContainer16(s) 164.490 166.0250 167.8360 173.9060 306.561   100


local({
   
   s <- stri_dup(stri_flatten(stri_dup(c("\u0105", "\u0104"), 1000), " "), 1:10)
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
      stringi:::stri_prepare_arg_string(s), 
      stringi:::stri_test_UnicodeContainer8(s),
      stringi:::stri_test_UnicodeContainer16(s)
   ))
   
})

# Measurement #1 (2013-05-19, MG)
# Unit: microseconds
# expr     min       lq   median       uq      max neval
# stringi:::stri_prepare_arg_string(s)  10.067  11.0425  11.8515  18.7260   51.464   100
# stringi:::stri_test_UnicodeContainer8(s)  11.115  12.4325  13.5465  21.0015   37.968   100
# stringi:::stri_test_UnicodeContainer16(s) 386.544 389.9070 395.3860 401.0670 2105.723   100



local({
   
   oldenc <- stri_enc_set("latin2")
   s <- stri_dup(stri_flatten(stri_dup(c("\u0105", "\u0104"), 1000), " "), 1:10)
   s <- stri_encode(s, "", "latin2")
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
      stringi:::stri_prepare_arg_string(s), 
      stringi:::stri_test_UnicodeContainer8(s),
      stringi:::stri_test_UnicodeContainer16(s),
      iconv(s, "latin2", "utf-8")
   ))
   stri_enc_set(oldenc)
})

# Measurement #1 (2013-05-19, MG)
#    Unit: microseconds
#    expr      min        lq    median        uq       max neval
#    stringi:::stri_prepare_arg_string(s)   10.868   19.8425   22.4715   35.1675    76.684   100
#    stringi:::stri_test_UnicodeContainer8(s) 1215.251 1241.1820 1260.1905 1295.7425  1945.011   100
#    stringi:::stri_test_UnicodeContainer16(s)  257.947  267.8210  277.5655  297.4815   768.980   100
#    iconv(s, "latin2", "utf-8") 3321.250 3368.4820 3390.2320 3415.2325 26885.133   100
