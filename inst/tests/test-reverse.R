require(testthat)

test_that("stri_reverse", {
   expect_identical(stri_reverse(character(0)), character(0))
   expect_identical(stri_reverse(NA), NA_character_)
	expect_identical(stri_reverse("ala ma \u0105 \u00F1 ą kota"), "atok ą \u00F1 \u0105 am ala")
	expect_identical(stri_reverse(c("abc", 1:3, "123")), c("cba", 1:3, "321"))
   expect_identical(stri_reverse(letters), letters)
   expect_identical(stri_reverse(stri_flatten(letters)), stri_flatten(letters[26:1]))
   
})
