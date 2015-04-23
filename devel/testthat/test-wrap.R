require(testthat)
require(stringr)
context("test-wrap.R")

test_that("stri_wrap", {
   expect_error(stri_wrap("what\never", normalize=FALSE))
   expect_identical(stri_wrap(c("", "singleword", NA), cost=0.0), c("", "singleword", NA))
   expect_identical(stri_wrap("a12345     b123456 c1234567", 5, 0.0), c("a12345", "b123456", "c1234567"))
   expect_identical(stri_wrap("a12345     b123456 c1234567", 5, 1.0), c("a12345", "b123456", "c1234567"))
   expect_identical(stri_wrap("a12345     b123456 c1234567", 5, 2.0), c("a12345", "b123456", "c1234567"))
   expect_identical(stri_wrap("a12345     b123456 c1234567", 5, 3.0), c("a12345", "b123456", "c1234567"))
   expect_identical(stri_wrap("a12345     b123456 c1234567", -100, 2.0), c("a12345", "b123456", "c1234567"))
   expect_identical(stri_wrap("a b c", -100), c("a", "b", "c"))
   expect_identical(stri_wrap("test-all", 0), c("test-", "all"))
   expect_identical(stri_wrap("test-all", 0, whitespace_only = TRUE), c("test-all"))

   expect_identical(stri_wrap("test      all", 0), c("test", "all"))
   expect_identical(stri_wrap("test      all", 0, normalize=FALSE), c("test     ", "all"))

   expect_identical(stri_wrap("\ud6c8\ud6c8 \ud6c8\ud6c8 abcd", 5, 2.0), c("\ud6c8\ud6c8", "\ud6c8\ud6c8", "abcd"))
   expect_identical(stri_wrap("\ud6c8\ud6c8 \ud6c8\ud6c8 abcd", 5, 2.0, use_length=TRUE), c("\ud6c8\ud6c8 \ud6c8\ud6c8", "abcd"))
   expect_identical(stri_wrap("\ud6c8 a", 5, 2.0, prefix="\ud6c8"), c("\ud6c8\ud6c8", "\ud6c8a"))
   expect_identical(stri_wrap("\ud6c8 a", 5, 2.0, prefix="\ud6c8", use_length=TRUE), c("\ud6c8\ud6c8 a"))


   #non breaking spaces....
   expect_equivalent(stri_wrap("abc def", 5), c("abc", "def"))
   expect_equivalent(stri_wrap("abc\u00a0def", 5), "abc\u00a0def")
   expect_equivalent(stri_wrap("abc\u2007def", 5), "abc\u2007def")
   expect_equivalent(stri_wrap("abc\u202fdef", 5), "abc\u202fdef")
   expect_equivalent(stri_wrap("abc\u2060def", 5), "abc\u2060def")

   expect_equivalent(stri_wrap("ab\u00adde abc\u00addef", 5), c("ab\u00adde", "abc\u00ad", "def"))

   #soft hyphens....

   expect_identical(stri_wrap(stri_paste(rep("\u0105\u0105\u0105\u0105\u0105", 5), collapse=" "), 12),
      c("\u0105\u0105\u0105\u0105\u0105 \u0105\u0105\u0105\u0105\u0105",
         "\u0105\u0105\u0105\u0105\u0105 \u0105\u0105\u0105\u0105\u0105",
         "\u0105\u0105\u0105\u0105\u0105"))
   expect_identical(stri_wrap(stri_paste(rep("\u0105\u0105\u0105\u0105\u0105", 5), collapse=" "), 12, cost=-1),
      c("\u0105\u0105\u0105\u0105\u0105 \u0105\u0105\u0105\u0105\u0105",
         "\u0105\u0105\u0105\u0105\u0105 \u0105\u0105\u0105\u0105\u0105",
         "\u0105\u0105\u0105\u0105\u0105"))

   expect_identical(stri_wrap("aaa bb cc ddddd", 6, cost=2), c("aaa", "bb cc", "ddddd")) # wikipedia
   expect_identical(stri_wrap("aaa bb cc ddddd", 6, cost=0), c("aaa bb", "cc", "ddddd")) # wikipedia


   expect_identical(stri_wrap(stri_paste(stri_dup(LETTERS[1:4], 3), collapse=" "), exdent=1, indent=2, cost=-1, width=6),
      c("  AAA", " BBB", " CCC", " DDD"))

   expect_identical(stri_wrap(stri_paste(stri_dup(LETTERS[1:4], 3), collapse=" "), exdent=1, indent=2, initial=">", prefix="!", cost=-1, width=6),
      c(">  AAA", "! BBB", "! CCC", "! DDD"))

   expect_identical(stri_wrap(c("AAA BBB", "CCC DDD"), exdent=1, indent=2, initial=">", prefix="!", cost=-1, width=6),
      c(">  AAA", "! BBB", "!  CCC", "! DDD"))

   expect_identical(stri_wrap(stri_paste(stri_dup(LETTERS[1:4], 3), collapse=" "), exdent=1, indent=2, cost=2, width=6),
      c("  AAA", " BBB", " CCC", " DDD"))

   expect_identical(stri_wrap(stri_paste(stri_dup(LETTERS[1:4], 3), collapse=" "), exdent=1, indent=2, initial=">", prefix="!", cost=2, width=6),
      c(">  AAA", "! BBB", "! CCC", "! DDD"))

   expect_identical(stri_wrap(c("AAA BBB", "CCC DDD"), exdent=1, indent=2, initial=">", prefix="!", cost=2, width=6),
      c(">  AAA", "! BBB", "!  CCC", "! DDD"))


   strings <- list(
      stri_paste("ala ma \u0105 \u00F1 kota i kotek ma alicje oraz dwie gruszeczki oraz ",
         "gruby czarny pies ma kotka ale nie ma alibaby"),
      stri_c(stri_rand_strings(1000, runif(1000, 2, 12), "[\\p{script=latin}&\\p{Ll}]"),
          stri_dup(" ", runif(1000, 1, 5)), sep="", collapse=""), stri_paste(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id ",
         "ligula pulvinar, posuere orci eu, pellentesque orci. Nullam eget ",
         "augue mattis, rhoncus velit a, tempus diam. Proin aliquet mauris ",
         "eu leo vestibulum bibendum ut at orci. Vestibulum et felis velit. ",
         "Etiam feugiat massa quis tortor sagittis accumsan. Proin eleifend ",
         "mattis enim, eget cursus lorem scelerisque quis. Sed libero libero, ",
         "consectetur a purus et, aliquet venenatis sapien. Phasellus ut ",
         "iaculis mi, at accumsan nulla. Quisque laoreet eros eget diam ",
         "luctus dignissim. Vivamus ullamcorper volutpat tortor sit amet ",
         "bibendum. Praesent scelerisque dui a nisl sollicitudin gravida. ",
         "Nunc blandit congue neque, at elementum eros condimentum sed. ",
         "Curabitur sit amet nulla vitae sem dapibus porta. Phasellus posuere ",
         "quam eu sapien feugiat, nec condimentum elit iaculis. Nam consequat, ",
         "tortor vel facilisis commodo, mauris lectus semper tortor, sit amet ",
         "malesuada augue nisl id justo. Pellentesque risus purus, viverra at ",
         "ipsum nec, fermentum rutrum mauris. Mauris molestie dui et velit ",
         "dapibus mattis. Duis et nulla eu libero tincidunt accumsan et nec ",
         "elit. In imperdiet ut ante quis varius. Aenean placerat, magna a ",
         "vulputate scelerisque, nibh quam pretium elit, ut blandit velit ",
         "ipsum nec nunc. Nam convallis justo ligula, sed cursus orci ",
         "suscipit fringilla. Suspendisse in erat ac ligula congue tincidunt ",
         "et at arcu. Suspendisse vitae orci scelerisque, tristique est et, ",
         "ullamcorper ligula. Duis imperdiet libero erat, posuere laoreet ",
         "lorem fringilla in. Proin eros mi, convallis vitae sem vitae, ",
         "rutrum mattis velit. Mauris a pulvinar nunc, tincidunt posuere ",
         "tellus. Nam laoreet, mauris eget faucibus imperdiet, diam mauris ",
         "imperdiet ante, ut eleifend erat dui quis libero. Donec odio nulla, ",
         "ornare quis eleifend ac, vehicula eu tortor. Aenean sapien orci, ",
         "pellentesque quis enim sed, adipiscing posuere massa. Praesent ",
         "quis augue ut massa pellentesque tincidunt. In sed pretium eros.")
   )

#    for (s in strings) { # to do: cost of the last line is zero since stringi_0.4-1
#       for (i in c(12,20,30,40)) {
#          exponents <- c(0, 1, 2, 3)
#          res <- vector('list', length(exponents))
#          for (j in seq_along(exponents))
#             res[[j]] <- stri_wrap(s, i, cost_exponent=exponents[j])
#
#          for (j in seq_along(exponents))
#             expect_true(all(stri_length(res[[j]]) <= i))
#
#          for (j in seq_along(exponents)[-1]) {
#             cost_greedy <- sum((i-stri_length(res[[1]]))^exponents[j])
#             cost_dynamic <- sum((i-stri_length(res[[j]]))^exponents[j])
#             expect_true(cost_greedy >= cost_dynamic)
#          }
#       }
#    }
})


# 	#expect_identical(stri_wrap(s, h,"d"), stri_wrap(s,h,"d"))
# 	#expect_identical(stri_wrap(s, h,"d"), stri_wrap(s,h,"d"))
#    #vectorized over string, method, width and spacecost
# 	expect_identical(stri_wrap(s, h,c("g","d")),
#                     c(stri_wrap(s,h,"g"),stri_wrap(s,h,"d")))
#    expect_identical(stri_wrap(c(s,s)),c(stri_wrap(s),stri_wrap(s)))
# 	expect_identical(stri_wrap(s,1:3*h),
#                     c(stri_wrap(s,h),stri_wrap(s,2*h),stri_wrap(s,3*h)))
# 	expect_identical(stri_wrap(s,spacec=1:2),
#                     c(stri_wrap(s,spacec=1),stri_wrap(s,spacec=2)))
#
# 	s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin
# 	nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel
# 	lorem. Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac
# 	diam. Quisque semper justo at risus. Donec venenatis, turpis vel
# 	hendrerit interdum, dui ligula ultricies purus, sed posuere libero dui
# 	id orci. Nam congue, pede vitae dapibus aliquet, elit magna vulputate
# 	arcu, vel tempus metus leo non est. Etiam sit amet lectus quis est
# 	congue mollis. Phasellus congue lacus eget neque. Phasellus ornare,
# 	ante vitae consectetuer consequat, purus sapien ultricies dolor, et
# 	mollis pede metus eget nisi. Praesent sodales velit quis augue. Cras
# 	suscipit, urna at aliquam rhoncus, urna quam viverra nisi, in interdum
# 	massa nibh nec erat."
# 	h <- "25"
# 	expect_identical(stri_wrap(s, h,"g"), str_wrap(s,h))
#
#    expect_warning(stri_wrap(rep(s,2),10,c("g","d","g")))
# })
