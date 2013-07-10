require("microbenchmark")

local({

   .polish_chars_cp1250_raw <- as.raw(c(165, 198, 202, 163, 209,
            211, 140, 143, 175, 185, 230, 234, 179, 241, 243, 156, 159, 191))
   .polish_chars_cp1250  <- rawToChar(.polish_chars_cp1250_raw)
   Encoding(.polish_chars_cp1250) <- "bytes"


   print(microbenchmark(
      stri_encode(.polish_chars_cp1250, "cp1250", "utf8"),
      iconv(.polish_chars_cp1250, "cp1250", "utf8")
   ))

   print(microbenchmark(
      stri_encode(.polish_chars_cp1250, "cp1250", "latin2"),
      iconv(.polish_chars_cp1250, "cp1250", "latin2")
   ))

   print(microbenchmark(
      stri_encode(rep(.polish_chars_cp1250, 25), "cp1250", "utf8"),
      iconv(rep(.polish_chars_cp1250, 25), "cp1250", "utf8")
   ))

   print(microbenchmark(
      stri_encode(rep(.polish_chars_cp1250, 25), "cp1250", "latin2"),
      iconv(rep(.polish_chars_cp1250, 25), "cp1250", "latin2")
   ))

   x <- sapply(1:250, function(i) rawToChar(rep(.polish_chars_cp1250_raw, i)))
   print(microbenchmark(
      stri_encode(x, "cp1250", "utf8"),
      iconv(x, "cp1250", "utf8")
   ))

   print(microbenchmark(
      stri_encode(x, "cp1250", "latin2"),
      iconv(x, "cp1250", "latin2")
   ))


# #   ERROR????????????????????????????????????????????????
#    print(microbenchmark(
#       stri_encode(stri_dup(.polish_chars_cp1250, 1), "cp1250", "latin2"),
#       iconv(stri_dup(.polish_chars_cp1250, 1), "cp1250", "latin2")
#    , times=1, control=list(warmup=1)))

})
