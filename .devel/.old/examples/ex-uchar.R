require("stringi")

local({

   cat("Polish characters:\n")
   # get character categories for each Polish (UTF-8 encoded) character
   ogonki <- sapply(c(260, 262, 280, 321, 323, 211, 346, 377, 379, 261,
                      263, 281, 322, 324, 243, 347, 378, 380), intToUtf8)
   ogonki_ct <- simplify2array(stri_chartype(ogonki))
   names(ogonki_ct) <- ogonki
   print(ogonki_ct)

   cat("\n")
   cat("ASCII characters:\n")
   # get character categories for each ASCII character
   ascii <- sapply(1:127, intToUtf8)
   ascii_ct <- simplify2array(stri_chartype(ascii))
   categories <- stri_charcategories()

   ascii_dt <- data.frame(char=ascii, cat_id=ascii_ct,
                          cat=categories$Category[ascii_ct],
                          cat_desc=rownames(categories)[ascii_ct])
   print(ascii_dt)
})
