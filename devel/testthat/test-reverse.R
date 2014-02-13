require(testthat)

test_that("stri_reverse", {
   expect_identical(stri_reverse(character(0)), character(0))
   expect_identical(stri_reverse(NA), NA_character_)
   expect_identical(stri_reverse("ala ma \u0105 \u00F1 kota"), "atok \u00F1 \u0105 am ala")
   expect_identical(stri_reverse("\U0010FFFF\U0010FFFE"), "\U0010FFFE\U0010FFFF")
   expect_identical(stri_reverse(c("abc", 1:3, "123")), c("cba", 1:3, "321"))
   expect_identical(stri_reverse(c(1:3, 12, 33:35)), as.character(c(1:3, 21, 33, 43, 53)))
   expect_identical(stri_reverse(letters), letters)
   expect_identical(stri_reverse(stri_flatten(letters)), stri_flatten(letters[26:1]))
   expect_identical(stri_reverse(stri_flatten(letters)), stri_flatten(letters[26:1]))
   expect_identical(stri_reverse(stri_flatten(9:1)), stri_flatten(1:9))
})
