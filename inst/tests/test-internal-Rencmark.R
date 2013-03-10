require('testthat')


# some internal encoding tests....



stringi:::stri_enc_Rmark(c('a', '\uc9', '\xc9'))
stringi:::stri_enc_Rmark(eval(parse(text="c('a', '\uc9')")))
stringi:::stri_enc_Rmark(intToUtf8(220))
test_that("test", {
   # something strange happens here - calling source() on this file
   # causes R not to mark the UTF-8 string (getOption('encoding')=="native.enc");
   # calling the following expression manually gives correct encmark
expect_that(stringi:::stri_enc_Rmark(c('abc', 'ąśćź', '\uc9')), is_equivalent_to(NULL))
})
