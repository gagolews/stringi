require("microbenchmark")

local({
   
   .polish_chars_cp1250  <-
      rawToChar(as.raw(c(165, 198, 202, 163, 209,
          211, 140, 143, 175, 185, 230, 234, 179, 241, 243, 156, 159, 191)))  
   Encoding(.polish_chars_cp1250) <- "bytes"
   
   
   print(microbenchmark(
      stri_ucnv_encode(.polish_chars_cp1250, "cp1250", "utf8"),  
      iconv(.polish_chars_cp1250, "cp1250", "utf8")
   ))
   
   print(microbenchmark(
      stri_ucnv_encode(.polish_chars_cp1250, "cp1250", "latin2"),  
      iconv(.polish_chars_cp1250, "cp1250", "latin2")
   ))
   
   print(microbenchmark(
      stri_ucnv_encode(rep(.polish_chars_cp1250, 25), "cp1250", "utf8"),
      iconv(rep(.polish_chars_cp1250, 25), "cp1250", "utf8")
   ))
   
   print(microbenchmark(
      stri_ucnv_encode(rep(.polish_chars_cp1250, 25), "cp1250", "latin2"),
      iconv(rep(.polish_chars_cp1250, 25), "cp1250", "latin2")
   ))
   
   x <- stri_dup(.polish_chars_cp1250, 1:250)
   print(microbenchmark(
      stri_ucnv_encode(x, "cp1250", "utf8"),
      iconv(x, "cp1250", "utf8")
   ))
   
   print(microbenchmark(
      stri_ucnv_encode(x, "cp1250", "latin2"),
      iconv(x, "cp1250", "latin2")
   ))
   

# #   ERROR????????????????????????????????????????????????
#    print(microbenchmark(
#       stri_ucnv_encode(stri_dup(.polish_chars_cp1250, 1), "cp1250", "latin2"),
#       iconv(stri_dup(.polish_chars_cp1250, 1), "cp1250", "latin2")
#    , times=1, control=list(warmup=1)))

})
