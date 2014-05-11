# Last update: 2014-05-11, MG
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
microbenchmark( stri_detect_fixed(x, "v"), grepl("v", x), grepl("v", x, fixed=TRUE), grepl("v", x, perl=TRUE) , stri_detect_regex(x, "v"))
# Unit: microseconds
#                         expr     min       lq   median       uq     max neval
#    stri_detect_fixed(x, "v")  44.478  46.7340  48.4110  49.8750  69.155   100  *BYTE SEARCH*
#                grepl("v", x) 131.480 135.5890 138.5085 142.1615 188.442   100
#  grepl("v", x, fixed = TRUE)  29.078  30.2795  31.3020  33.0705  80.791   100
#   grepl("v", x, perl = TRUE) 121.422 123.3890 125.2115 128.9780 140.846   100
#    stri_detect_regex(x, "v") 285.492 289.6530 292.1770 298.3195 360.656   100
#    stri_detect_fixed(x, "v")  46.823  48.9805  51.0840  52.5735 102.878   100  ** KMP **
#    stri_detect_fixed(x, "v")  45.578  47.6000  49.5305  51.1820  93.435   100  ** shortPat upgrade **

# a very long search string, match at first position
microbenchmark( stri_detect_fixed(y, "x"), grepl("x", y), grepl("x", y, fixed=TRUE), grepl("x", y, perl=TRUE) , stri_detect_regex(y, "x"))
# Unit: microseconds
#                         expr    min      lq  median      uq    max neval
#    stri_detect_fixed(y, "x")  2.816  3.5075  4.6715  5.1925 10.808   100  *BYTE SEARCH*
#                grepl("x", y)  4.986  6.4235  7.2660  9.3975 16.447   100
#  grepl("x", y, fixed = TRUE)  2.814  3.7455  4.2145  5.1805 18.086   100
#   grepl("x", y, perl = TRUE) 11.787 13.1915 14.5185 15.7490 31.494   100
#    stri_detect_regex(y, "x") 20.455 21.9270 22.7325 23.6635 95.352   100
#    stri_detect_fixed(y, "x")  2.776  3.5250   4.862  5.5325 12.269   100  ** KMP **
#    stri_detect_fixed(y, "x")  2.644  3.7515   4.771  5.4745 29.562   100  ** shortPat upgrade **

# a very long search string, pattern of length 1
microbenchmark( stri_detect_fixed(y, pat1), grepl(pat1, y), grepl(pat1, y, fixed=TRUE), grepl(pat1, y, perl=TRUE) , stri_detect_regex(y, pat1))
# Unit: microseconds
#                          expr     min       lq   median       uq     max neval
#    stri_detect_fixed(y, pat1)  19.715  21.0635  22.6080  25.0135  49.328   100  *BYTE SEARCH*
#                grepl(pat1, y) 195.340 196.9505 199.8910 202.6990 308.411   100
#  grepl(pat1, y, fixed = TRUE)  14.528  15.6405  16.5615  18.2635  34.302   100
#   grepl(pat1, y, perl = TRUE)  19.732  21.5165  23.7200  32.7990  40.794   100
#    stri_detect_regex(y, pat1)  40.269  42.1195  43.5625  47.3615 100.259   100
#    stri_detect_fixed(y, pat1)  51.691  54.8655  56.7155  57.3050  73.581   100  ** KMP **
#    stri_detect_fixed(y, pat1)  14.569  15.5630  16.9680  17.6720  25.599   100  ** shortPat upgrade **

# a very long search string, pattern of length 2
microbenchmark( stri_detect_fixed(y, pat2), grepl(pat2, y), grepl(pat2, y, fixed=TRUE), grepl(pat2, y, perl=TRUE) , stri_detect_regex(y, pat2))
# Unit: microseconds
#                          expr     min       lq   median       uq     max neval
#    stri_detect_fixed(y, pat2)  27.324  29.5970  30.3155  34.8600  46.424   100  *BYTE SEARCH*
#                grepl(pat2, y) 330.960 333.3750 336.1995 338.3595 368.736   100
#  grepl(pat2, y, fixed = TRUE)  94.248  95.2275  96.1135  98.0395 149.172   100
#   grepl(pat2, y, perl = TRUE) 424.791 427.8655 429.8805 431.5665 446.458   100
#    stri_detect_regex(y, pat2) 495.357 498.8975 502.1335 505.1120 739.877   100
#    stri_detect_fixed(y, pat2)  54.233  55.6425  56.9900  57.8660  79.242   100  ** KMP **
#    stri_detect_fixed(y, pat2)  14.742  15.9030  17.6715  18.2820  26.083   100  ** shortPat upgrade **

# a very long search string, pattern of length 3
microbenchmark( stri_detect_fixed(y, pat3), grepl(pat3, y), grepl(pat3, y, fixed=TRUE), grepl(pat3, y, perl=TRUE) , stri_detect_regex(y, pat3))
# Unit: microseconds
#                          expr     min       lq   median       uq      max neval
#    stri_detect_fixed(y, pat3)  34.913  43.0675  44.9425  45.8595   64.803   100  *BYTE SEARCH*
#                grepl(pat3, y) 458.535 461.2095 463.0620 467.3015  578.548   100
#  grepl(pat3, y, fixed = TRUE)  94.427  95.8575  96.7820  98.4870  159.665   100
#   grepl(pat3, y, perl = TRUE) 465.463 468.8180 470.6595 473.8085  707.795   100
#    stri_detect_regex(y, pat3) 505.392 510.6205 513.5305 517.6755 1841.009   100
#    stri_detect_fixed(y, pat3)  53.166  55.4555  57.0975  57.9300   86.073   100  ** KMP **
#    stri_detect_fixed(y, pat3)  22.661  24.0475  25.5230  26.1990   46.480   100  ** shortPat upgrade **

# a very long search string, pattern of length 4
microbenchmark( stri_detect_fixed(y, pat4), grepl(pat4, y), grepl(pat4, y, fixed=TRUE), grepl(pat4, y, perl=TRUE) , stri_detect_regex(y, pat4))
# Unit: microseconds
#                          expr     min       lq  median       uq      max neval
#    stri_detect_fixed(y, pat4)  72.692  75.6145  77.346  79.8190  126.660   100  ** BYTE SEARCH **
#                grepl(pat4, y) 589.747 592.6790 594.037 596.2630 1812.444   100
#  grepl(pat4, y, fixed = TRUE)  95.056  96.5010  97.524  99.1890  146.050   100
#   grepl(pat4, y, perl = TRUE) 505.014 507.6075 509.685 513.5365  771.097   100
#    stri_detect_regex(y, pat4) 550.657 555.6510 559.501 563.7855  690.755   100
#    stri_detect_fixed(y, pat4)  53.850  55.7635  57.374  57.9660   62.653   100  ** KMP **
#    stri_detect_fixed(y, pat4)  14.687  15.5405  17.603  18.6250   31.989   100  ** shortPat upgrade **

# a very long search string, a very long pattern
microbenchmark( stri_detect_fixed(y, pat), grepl(pat, y), grepl(pat, y, fixed=TRUE), grepl(pat, y, perl=TRUE), stri_detect_regex(y, pat), unit="ms")
# Unit: milliseconds
#                         expr        min          lq     median         uq        max neval
#    stri_detect_fixed(y, pat)   10.91158   10.923044  10.935109   10.95073  11.172243   100 ** BYTE SEARCH **
#                grepl(pat, y) 133.476346 133.5998070 133.658967 133.831827 137.381119   100
#  grepl(pat, y, fixed = TRUE)   1.560229   1.5738575   1.582063   1.590295   1.847035   100
#   grepl(pat, y, perl = TRUE)  39.195742  39.2114195  39.224532  39.311148  40.567287   100
#    stri_detect_regex(y, pat)  11.385428  11.4221775  11.449490  11.481821  11.844836   100
#    stri_detect_fixed(y, pat)   0.054129   0.0587745   0.066106   0.077829   0.104892   100  ** KMP **
#    stri_detect_fixed(y, pat)   0.054574   0.058524    0.06579    0.074838   0.103932   100  ** shortPat upgrade **
