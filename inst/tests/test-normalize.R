require(testthat)

# TO DO....

test_that("stri_tolower", {
   
   x1 <- c("\u0105", "\u0104", "\u00F1")
   x2 <- c("\u0061\u0328", "\u0041\u0328", "\u006E\u0303")
   expect_that(stri_nfc(x2), is_equivalent_to(x1))

#    # temp:
#    print(stri_nfc(x1))
#    print(stri_nfd(x1))
#    print(stri_nfkc(x1))
#    print(stri_nfkd(x1))
#    print(stri_nfkc_casefold(x1))
#    print(stri_nfkc_casefold("АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ"))
})