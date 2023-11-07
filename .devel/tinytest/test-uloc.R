library("tinytest")
library("stringi")


expect_true(length(stri_locale_list()) > 0)

suppressMessages(old_loc <- stri_locale_set("XX_YY"))
suppressMessages(expect_true(stri_locale_set("pl_PL") == "xx_YY"))
suppressMessages(expect_true(stri_locale_set("C") == "pl_PL"))
suppressMessages(expect_true(stri_locale_set(old_loc) == "en_US_POSIX"))
