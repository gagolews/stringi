# Last update: 2014-07-25, BT
set.seed(1L)
x <- "v" %stri+% 1:1000
y <- stri_c(stri_dup("x", 10000), stri_dup("y", 100))
pat <- stri_c(stri_dup("x", 1000), "y")
pat1 <- "y"
pat2 <- "xy"
pat3 <- "xxy"
pat4 <- "xxxy"

library(microbenchmark)
# short search strings, match at first position
microbenchmark(x[stri_detect_fixed(x, "v")], stri_subset_fixed(x, "v"))
# Unit: microseconds
# 									expr    min      lq median      uq     max neval
# 	x[stri_detect_fixed(x, "v")] 78.362 80.1790 84.195 89.3975 103.506   100
# 		stri_subset_fixed(x, "v") 51.055 52.2075 54.652 60.2740 137.518   100 * faster :)

# a very long search string, match at first position
microbenchmark( y[stri_detect_fixed(y, "x")], stri_subset_fixed(y, "x"))
# Unit: microseconds
# 									expr  min     lq median    uq    max neval
# 	y[stri_detect_fixed(y, "x")] 4.61 4.9245  5.099 5.169 55.036   100
# 		stri_subset_fixed(y, "x") 4.54 4.8900  5.030 5.169 14.667   100 * only slightly faster

# a very long search string, pattern of length 1
microbenchmark( y[stri_detect_fixed(y, pat1)], stri_subset_fixed(y, pat1))
# Unit: microseconds
#									 expr    min      lq median    uq    max neval
# 	y[stri_detect_fixed(y, pat1)] 16.832 17.1465 17.322 18.09 38.414   100
# 		stri_subset_fixed(y, pat1) 16.693 17.0775 17.391 18.09 65.372   100

# a very long search string, pattern of length 2
microbenchmark( y[stri_detect_fixed(y, pat2)], stri_subset_fixed(y, pat2))


# a very long search string, pattern of length 3
microbenchmark( y[stri_detect_fixed(y, pat3)], stri_subset_fixed(y, pat3))


# a very long search string, pattern of length 4
microbenchmark( y[stri_detect_fixed(y, pat4)], stri_subset_fixed(y, pat4))


# a very long search string, a very long pattern
microbenchmark( y[stri_detect_fixed(y, pat)], stri_subset_fixed(y, pat))
