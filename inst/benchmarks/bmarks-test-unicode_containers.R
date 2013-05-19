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
   
   
# Measurement #1 (2013-05-19, MG)
#    Unit: nanoseconds
#    expr   min      lq  median      uq   max neval
#    identity(s)   440   645.0   766.0   914.5 11564   100
#    stri_test_returnasis_compiled(s)  1590  1864.5  2018.5  2215.5  5872   100
#    stringi:::stri_test_returnasis(s)  9620 10641.0 11006.5 11741.5 42436   100
#    stringi:::stri_prepare_arg_string(s)  9552 10329.5 10799.0 11795.5 88299   100
#    stringi:::stri_test_UnicodeContainer8(s) 10003 10997.0 11367.5 12459.5 25446   100
#    stringi:::stri_test_UnicodeContainer16(s) 10504 11128.5 11785.0 12573.5 25176   100
})




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
   
   s <- stri_dup(stri_flatten(stri_dup(letters, 100), " "), 1:10)
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
      stringi:::stri_prepare_arg_string(s), 
      stringi:::stri_test_UnicodeContainer8(s),
      stringi:::stri_test_UnicodeContainer16(s)
   ))
   
# Measurement #1 (2013-05-19, MG)
#    Unit: microseconds
#    expr     min       lq   median      uq      max neval
#    stringi:::stri_prepare_arg_string(s)   9.871  11.1310  11.9785  17.995   32.542   100
#    stringi:::stri_test_UnicodeContainer8(s)  10.951  12.2285  13.2900  20.160   37.361   100
#    stringi:::stri_test_UnicodeContainer16(s) 202.550 204.8495 210.5625 217.007 1741.181   100
})



local({
   
   s <- stri_dup(stri_flatten(stri_dup(c("\u0105", "\u0104"), 100), " "), 1:10)
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
      stringi:::stri_prepare_arg_string(s), 
      stringi:::stri_test_UnicodeContainer8(s),
      stringi:::stri_test_UnicodeContainer16(s)
   ))
   
   
# Measurement #1 (2013-05-19, MG)
#    Unit: microseconds
#    expr    min      lq  median      uq      max neval
#    stringi:::stri_prepare_arg_string(s)  9.664 10.7785 11.5585 12.6710   76.666   100
#    stringi:::stri_test_UnicodeContainer8(s) 10.899 12.2120 12.8875 14.7425 1549.652   100
#    stringi:::stri_test_UnicodeContainer16(s) 52.557 53.9540 54.6785 55.6770   87.539   100
})



local({
   
   oldenc <- stri_enc_set("latin2")
   s <- stri_dup(stri_flatten(stri_dup(c("\u0105", "\u0104"), 100), " "), 1:10)
   s <- stri_encode(s, "", "latin2")
   stringi:::stri_test_Rmark(s)
   print(microbenchmark(
      stringi:::stri_prepare_arg_string(s), 
      stringi:::stri_test_UnicodeContainer8(s),
      stringi:::stri_test_UnicodeContainer16(s)
   ))
   stri_enc_set(oldenc)
   
   
# Measurement #1 (2013-05-19, MG)
#    Unit: microseconds
#    expr     min       lq   median       uq     max neval
#    stringi:::stri_prepare_arg_string(s)  20.755  24.6040  29.5180  30.4275 109.448   100
#    stringi:::stri_test_UnicodeContainer8(s) 246.106 261.5035 266.2845 270.3125 614.057   100
#    stringi:::stri_test_UnicodeContainer16(s)  75.999  82.0085  83.9125  87.3870 150.798   100
})
