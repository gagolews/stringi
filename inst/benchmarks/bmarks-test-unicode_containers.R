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
   
   s <- LETTERS
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
      stringi:::stri_prepare_arg_string(s), 
      stringi:::stri_test_UnicodeContainer8(s),
      stringi:::stri_test_UnicodeContainer16(s)
   ))
   
# Measurement #1 (2013-05-19, MG)
#    Unit: microseconds
#    expr    min      lq  median      uq    max neval
#    stringi:::stri_prepare_arg_string(s)  9.872 10.7135 11.2230 11.8865 25.889   100
#    stringi:::stri_test_UnicodeContainer8(s) 11.820 12.8505 13.4395 14.1160 29.648   100
#    stringi:::stri_test_UnicodeContainer16(s) 14.034 14.7510 15.3555 16.1440 90.433   100
})




local({
   
   s <- stri_dup(stri_flatten(stri_dup(c("aa", "bb"), 100), " "), 1:10)
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
      stringi:::stri_prepare_arg_string(s), 
      stringi:::stri_test_UnicodeContainer8(s),
      stringi:::stri_test_UnicodeContainer16(s)
   ))

})


# Measurement #1 (2013-05-19, MG)
#    Unit: microseconds
#    expr    min      lq  median      uq     max neval
#    stringi:::stri_prepare_arg_string(s)  9.672 11.0385 11.7550 13.7835  38.844   100
#    stringi:::stri_test_UnicodeContainer8(s) 10.905 12.1820 13.1995 15.2210  57.305   100
#    stringi:::stri_test_UnicodeContainer16(s) 44.819 45.9320 46.6670 48.0230 360.264   100

# Improved ASCII performance for UTF16
#    Unit: microseconds
#    expr    min      lq  median      uq     max neval
#    stringi:::stri_prepare_arg_string(s)  9.561 10.9010 11.3885 13.9725  43.902   100
#    stringi:::stri_test_UnicodeContainer8(s) 10.958 11.8655 12.9865 15.4225 108.738   100
#    stringi:::stri_test_UnicodeContainer16(s) 31.290 32.1465 32.8440 34.6435  99.538   100


local({
   
   s <- stri_dup(stri_flatten(stri_dup(c("\u0105", "\u0104"), 100), " "), 1:10)
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
      stringi:::stri_prepare_arg_string(s), 
      stringi:::stri_test_UnicodeContainer8(s),
      stringi:::stri_test_UnicodeContainer16(s)
   ))
   
})

# Measurement #1 (2013-05-19, MG)
#    Unit: microseconds
#    expr    min      lq  median      uq      max neval
#    stringi:::stri_prepare_arg_string(s)  9.664 10.7785 11.5585 12.6710   76.666   100
#    stringi:::stri_test_UnicodeContainer8(s) 10.899 12.2120 12.8875 14.7425 1549.652   100
#    stringi:::stri_test_UnicodeContainer16(s) 52.557 53.9540 54.6785 55.6770   87.539   100



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
