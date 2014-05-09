require(testthat)

test_that("stri_replace_na", {
   s <- c("ala",NA,"kota")
   expect_identical(stri_replace_na(s,"brak"),c("ala","brak","kota"))
   expect_identical(stri_replace_na(s,""),c("ala","","kota"))
   expect_identical(stri_replace_na(s,NA),c("ala",NA,"kota"))
   expect_warning(stri_replace_na(s,character(3)))
   expect_error(stri_replace_na(s,character(0)))

   x <- stri_enc_tonative(stri_dup("\u0105", 1:100))
   x[sample(seq_along(x), 20)] <- NA_character_
   expect_equivalent(stri_replace_na(x, "???"), {
      x2 <- stri_enc_toutf8(x); x2[is.na(x2)] <- "???"; x2
   })
})
