library("tinytest")
library("stringi")

expect_identical(stri_sprintf(character(0), 1:10), character(0))
expect_identical(stri_sprintf("%s", NULL), character(0))
expect_identical(stri_sprintf("%s", 1:10, character(0)), character(0))
expect_identical(stri_sprintf(rep("%s", 10), 1:10, character(0)), character(0))
expect_warning(stri_sprintf(rep("%s", 10), 1:5, 1:3))

expect_error(suppressWarnings(stri_sprintf("%000000000000000000$s", "a")))
expect_error(suppressWarnings(stri_sprintf("%0$s", "a")))
expect_error(suppressWarnings(stri_sprintf("%-3$s", "a")))

expect_identical(stri_sprintf("%%"), "%")
expect_error(suppressWarnings(stri_sprintf("abc%")))

expect_identical(stri_sprintf("%1$#- *0000002$f", 1.23456, 10), " 1.234560 ")
expect_identical(stri_sprintf("%0000000000000000001$#0+ *0000002$.*003$e", 1.23456, -12, 3),
    sprintf("%#0+-12.3e", 1.23456))
expect_identical(stri_sprintf("%0000000000000000001$#0+ *0000002$.*003$e", 1.23456, 12, 3),
    sprintf("%#0+12.3e", 1.23456))

f <- c("%10.3f", "%010.3f", "%+10.3f", "%- 10.3f")
x <- c(-Inf, -0, 0, Inf, NaN, NA_real_)
expect_identical(
as.character(outer(f, x, stri_sprintf, na_string="NA")),
    c("      -Inf", "      -Inf", "      -Inf", "-Inf      ",
    "    -0.000",    "-00000.000", "    -0.000", "-0.000    ",
    "     0.000", "000000.000",    "    +0.000", " 0.000    ",
    "       Inf", "       Inf", "      +Inf",    " Inf      ",
    "       NaN", "       NaN", "       NaN", " NaN      ",
    "        NA", "        NA", "        NA", " NA       ")
)

expect_identical(stri_sprintf("% .0f", x, na_string=NA, inf_string=NA, nan_string=NA),
    c(NA, "-0", " 0", NA, NA, NA))

expect_identical(stri_sprintf("%+5.f", x, na_string="\u200ba", inf_string="\u200bab", nan_string="\u200babc"),
    c("  -\u200bab", "   -0", "   +0", "  +\u200bab", "  \u200babc", "    \u200ba"))


expect_identical(stri_sprintf("% .0f", x, na_string="NA"), # base::sprintf has [ ]NaN/NA - OK
    c("-Inf", "-0", " 0", " Inf", " NaN", " NA"))
expect_identical(stri_sprintf("%+.0f", x, na_string="NA"), # should be: +NaN/NA (like in glibc) or [ ]NaN/NA, but it's not in base::sprintf
    c("-Inf", "-0", "+0", "+Inf", " NaN", " NA"))

expect_identical(stri_sprintf("% d", c(-1, 0, 1, NA_integer_), na_string="NA"), # should be: [ ]NA, but it's not in base::sprintf
    c("-1", " 0", " 1", " NA"))
expect_identical(stri_sprintf("%+d", c(-1, 0, 1, NA_integer_), na_string="NA"), # should be: [+ ]NA, but it's not in base::sprintf
    c("-1", "+0", "+1", " NA"))



x <- "abcdef"  # nbytes == length == width
expect_identical(stri_sprintf("%.*s", -1:8, x), stri_sub(x, length=c(stri_length(x), 0:8)))
expect_identical(stri_sprintf("%.*s", -1:8, x, use_length=TRUE), stri_sub(x, length=c(stri_length(x), 0:8)))

x <- "\u0105\u0106\u0107\u0108\u0109\u010a"  # nbytes > length == width
expect_identical(stri_sprintf("%.*s", -1:8, x), stri_sub(x, length=c(stri_length(x), 0:8)))
expect_identical(stri_sprintf("%.*s", -1:8, x, use_length=TRUE), stri_sub(x, length=c(stri_length(x), 0:8)))

x <- "\u200b\u200b\u200b\u200b\U0001F3F4\U000E0067\U000E0062\U000E0073\U000E0063\U000E0074\U000E007Fabcd"  # nbytes != length != width
expect_identical(stri_sprintf("%.*s", -1:8, x), stri_sub(x, length=c(stri_length(x), 4, 4, 11, 12, 13, 14, 15, 15, 15)))
expect_identical(stri_sprintf("%.*s", -1:8, x, use_length=TRUE), stri_sub(x, length=c(stri_length(x), 0:8)))

expect_identical(stri_sprintf("%*3$.*s", -1:8, x, 4), stri_pad(stri_sub(x, length=c(stri_length(x), 4, 4, 11, 12, 13, 14, 15, 15, 15)), 4))


expect_identical(stri_sprintf("[%-016.*s]", -1:8, x), "[" %s+% stri_pad_right(stri_sub(x, length=c(stri_length(x), 4, 4, 11, 12, 13, 14, 15, 15, 15)), 16) %s+% "]")
expect_identical(stri_sprintf("[%016.*s]", -1:8, x), "[" %s+% stri_pad_left(stri_sub(x, length=c(stri_length(x), 4, 4, 11, 12, 13, 14, 15, 15, 15)), 16) %s+% "]")

expect_equivalent(stri_width(stri_sprintf("[%*.*s]", 1:8, 1:8, x)), 2+1:8)

expect_identical(stri_sprintf("%+10.3f", c(-Inf, -0, 0, Inf, NaN, NA_real_), na_string="<NA>", nan_string="\U0001F4A9", inf_string="\u221E"),
    c("        -\u221E", "    -0.000", "    +0.000", "        +\u221E", "        \U0001F4A9", "      <NA>"))

expect_error(stri_sprintf("%0$s", "s"))
expect_error(stri_sprintf("%2$s", "s"))


expect_error(stri_sprintf("%s", as.name("symbols are not supported")))  # but the can be in the future

d <- Sys.Date()
t <- Sys.time()
expect_identical(suppressWarnings(stri_sprintf("%s", list(11:13))), sprintf("%s", list(11:13))  )  # ok, as.character called
expect_identical(stri_sprintf("%s", 11:13), sprintf("%s", 11:13)        )  # ok, as.character called
expect_identical(stri_sprintf("%s", factor(11:13)), sprintf("%s", factor(11:13)))  # as.character
expect_identical(stri_sprintf("%d", factor(11:13)), sprintf("%d", factor(11:13)))  # as.integer
expect_identical(stri_sprintf("%s", d), sprintf("%s", d)   )  # as.character
expect_identical(stri_sprintf("%s", t), sprintf("%s", t)   )  # as.character
expect_identical(stri_sprintf("%d", d), sprintf("%d", d)   )
expect_identical(stri_sprintf("%f", t), sprintf("%f", t)   )

expect_identical(stri_sprintf("UNIX time %1$d is %1$s.", t), sprintf("UNIX time %d is %s.", as.integer(t), t))
expect_identical(stri_sprintf("UNIX time %1$f is %1$s.", t), sprintf("UNIX time %1$f is %1$s.", t))


expect_identical(stri_sprintf(c("%s", "%f", "%d"), pi), c(sprintf("%s", pi), sprintf("%f", pi), sprintf("%d", as.integer(pi))))

expect_identical(stri_sprintf("% d", 123), sprintf("% d", 123)  )
expect_identical(stri_sprintf("% +d", 123), sprintf("% +d", 123) )
expect_identical(stri_sprintf("%+ d", 123), sprintf("%+ d", 123) )

expect_identical(stri_sprintf("%.0f", c(0, 0.5, 1, 1.5, 2)), sprintf("%.0f", c(0, 0.5, 1, 1.5, 2)))
expect_identical(stri_sprintf("%d", c(0, 0.5, 1, 1.5, 2)), sprintf("%d", as.integer(c(0, 0.5, 1, 1.5, 2))))

x <- as.integer(c(-1000000, 0, -532, 6, -2, 54326430))
expect_identical(stri_sprintf("%d", x), sprintf("%d", x))
expect_identical(stri_sprintf("%0i", x), sprintf("%0i", x))
expect_identical(stri_sprintf("%6i", x), sprintf("%6i", x))
expect_identical(stri_sprintf("%+6.3i", x), sprintf("%+6.3i", x))


expect_warning(stri_sprintf("%s %1$s %s", "a", "b", "c", "d"))
expect_warning(stri_sprintf("%s %4$s %s", "a", "b", "c", "d"))

x <- stri_rand_strings(10, 1:10, "\\p{L}")
expect_identical(stri_sprintf(x), x)


expect_equivalent(length(stri_sprintf("abc", NULL)), 0)
expect_equivalent(length(stri_sprintf("abc", character(0))), 0)


expect_error(stri_sprintf("%2$s", "x"))
expect_error(stri_sprintf("%s%s", "x"))
expect_warning(stri_sprintf("%2$s", NA, "y"))



# stringi has not have the 99 arg limit
x <- as.list(as.character(1:1000))
expect_identical(do.call(stri_sprintf, c(strrep("%s,", length(x)), x)), stri_flatten(1:1000, ",")%s+%",")



expect_warning(stri_sprintf(rep("%s", 10), 1:5, 1:13))
expect_warning(stri_sprintf(rep("%s", 10), 1:5, 1))
expect_equivalent(suppressWarnings(length(stri_sprintf(rep("%s", 10), 1:5, 1:13))), 13)
expect_equivalent(suppressWarnings(length(stri_sprintf(rep("%s", 10), 1:5, 1))), 10)

# somewhat controversial - unused argument (with a warning), but determines length (both in stringi and base R)
expect_equivalent(suppressWarnings(stri_sprintf(rep("%s", 10), 1:5, 1:20)), suppressWarnings(sprintf(rep("%s", 10), 1:5, 1:20)))

expect_equivalent(stri_sprintf(rep("%s%s", 10), 1:5, 7), sprintf(rep("%s%s", 10), 1:5, 7))
expect_equivalent(stri_sprintf(rep("%s%s", 10), 1:5, 1:2), sprintf(rep("%s%s", 10), 1:5, 1:2))
expect_equivalent(suppressWarnings(stri_sprintf(rep("%s%s", 10), 1:5, 1:3)), sprintf(rep("%s%s", 10), 1:5, c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1)))






expect_equivalent("value='%d'" %s$% 3, "value='3'")
expect_equivalent("value='%d'" %s$% 1:3, c("value='1'", "value='2'", "value='3'"))
expect_equivalent("%s='%d'" %s$% list("value", 3), "value='3'")
expect_equivalent("%s='%d'" %s$% list("value", 1:3), c("value='1'", "value='2'", "value='3'"))
expect_equivalent("%s='%d'" %s$% list(c("a", "b", "c"), 1), c("a='1'", "b='1'", "c='1'"))
expect_equivalent("%s='%d'" %s$% list(c("\u0105", "\u015B", "\u0107"), 1), c("\u0105='1'", "\u015B='1'", "\u0107='1'"))
expect_equivalent("%s='%d'" %s$% list(factor(c("\u0105", "\u015B", "\u0107")), 1), c("\u0105='1'", "\u015B='1'", "\u0107='1'"))
expect_equivalent("%s='%d'" %s$% list(c("a", "b", "c"), 1:3), c("a='1'", "b='2'", "c='3'"))

expect_equivalent("%s='%d'" %s$% list(c("a", NA, "c"), 1:3), c("a='1'", NA, "c='3'"))

expect_equivalent("%s='%d'" %s$% list(c("a", "b", "c"), NA), c(NA_character_, NA_character_, NA_character_))

expect_equivalent("%s='%d'" %s$% list(character(0), NA_character_), character(0))
expect_equivalent("%s" %s$% character(0), character(0))

expect_equivalent(character(0) %s$% character(0), character(0))
expect_equivalent(character(0) %s$% c(c("a", "b", "c"), 1), character(0))
expect_equivalent(character(0) %s$% c(NA_character_, NA_character_), character(0))
expect_equivalent(c(NA_character_, "%s", NA_character_) %s$% "a", c(NA_character_, "a", NA_character_))
expect_equivalent(c(NA_character_, "%s", NA_character_) %s$% c("a", NA_character_, "a"), c(NA_character_, NA_character_, NA_character_))
expect_equivalent(suppressWarnings(c(NA_character_) %s$% list("a", NA_character_, "a")), c(NA_character_))
expect_equivalent(suppressWarnings(c(NA_character_) %s$% list(c("a", NA_character_, "a"))), c(NA_character_, NA_character_, NA_character_))
expect_equivalent(c(NA_character_, "%s", NA_character_) %s$% c("a", "a", "a"), c(NA_character_, "a", NA_character_))
expect_equivalent(c(NA_character_, "%s") %s$% c("a", NA_character_, "a", NA_character_), c(NA_character_, NA_character_, NA_character_, NA_character_))
expect_equivalent(c(NA_character_, "%s") %s$% c(NA_character_, "a", NA_character_, "a"), c(NA_character_, "a", NA_character_, "a"))

expect_identical(stri_sprintf(NA), NA_character_)
expect_identical(stri_sprintf(NA_character_), NA_character_)

expect_identical(stri_sprintf(c("%d", "%s"), factor(11:12)), c("1", "12"))
expect_identical(stri_sprintf(c("%s", "%d"), factor(11:12)), c("11", "2"))
expect_identical(stri_sprintf("%1$s_%1$d", factor(11:12)), c("11_1", "12_2"))
expect_identical(stri_sprintf("%1$d_%1$s", factor(11:12)), c("1_11", "2_12"))
expect_identical(stri_sprintf("%s", factor(11:12)), c("11", "12"))
expect_identical(stri_sprintf("%d", factor(11:12)), c("1", "2"))


expect_identical(stri_sprintf("%#010x", 123), sprintf("%#010x", 123))
expect_identical(stri_sprintf("%f", 123), sprintf("%f", 123))
expect_identical(stri_sprintf("%#f", 123), sprintf("%#f", 123))
expect_identical(stri_sprintf("%#g", 123), sprintf("%#g", 123))
expect_identical(stri_sprintf("%g", 123), sprintf("%g", 123))
expect_identical(stri_sprintf("%#015g", 123), sprintf("%#015g", 123))
expect_identical(stri_sprintf("%5.3d", 1), sprintf("%5.3d", 1))
expect_identical(stri_sprintf("%5.8d", 1), sprintf("%5.8d", 1))
expect_identical(stri_sprintf("%5.8d", 123), sprintf("%5.8d", 123))
expect_identical(stri_sprintf("%5.8d", 12345678), sprintf("%5.8d", 12345678))
expect_identical(stri_sprintf("%5.8d", 123456789), sprintf("%5.8d", 123456789))
expect_identical(stri_sprintf("% 05d", c(-123, 123, 0)), sprintf("% 05d", c(-123, 123, 0)))
expect_identical(stri_sprintf("%+05d", c(-123, 123, 0)), sprintf("%+05d", c(-123, 123, 0)))
expect_identical(stri_sprintf("%+5d", c(-123, 123, 0)), sprintf("%+5d", c(-123, 123, 0)))
expect_identical(stri_sprintf("% 5d", c(-123, 123, 0)), sprintf("% 5d", c(-123, 123, 0)))
expect_identical(stri_sprintf("%- 5d", c(-123, 123, 0)), sprintf("%- 5d", c(-123, 123, 0)))
expect_identical(stri_sprintf("%-+5d", c(-123, 123, 0)), sprintf("%-+5d", c(-123, 123, 0)))
expect_identical(stri_sprintf("%-0+5d", c(-123, 123, 0)), sprintf("%-0+5d", c(-123, 123, 0)))
expect_identical(stri_sprintf("%-0 5d", c(-123, 123, 0)), sprintf("%-0 5d", c(-123, 123, 0)))
#expect_identical(stri_sprintf("%08s", "abc"), sprintf("%08s", "abc"))  # undefined behaviour for strings according to man 3 sprintf
expect_identical(stri_sprintf("%-8s", "abc"), sprintf("%-8s", "abc"))
expect_identical(stri_sprintf("%+8s", "abc"), sprintf("%+8s", "abc"))
expect_identical(stri_sprintf("%1$s %s %2$s %s", 1, 2), sprintf("%1$s %s %2$s %s", 1, 2))
expect_identical(suppressWarnings(stri_sprintf("%4$*3$s", 1, "a", 6, "b")), suppressWarnings(sprintf("%4$*3$s", 1, "a", 6, "b")))
expect_identical(suppressWarnings(stri_sprintf("%4$*3$.2f", 1, "a", 6, pi)), suppressWarnings(sprintf("%4$*3$.2f", 1, "a", 6, pi)))
expect_identical(suppressWarnings(stri_sprintf("%4$10.*3$f", 1, "a", 6, pi)), suppressWarnings(sprintf("%4$10.*3$f", 1, "a", 6, pi)))
expect_identical(suppressWarnings(stri_sprintf("%4$-*3$.2f", 1, "a", 6, pi)), suppressWarnings(sprintf("%4$-*3$.2f", 1, "a", 6, pi)))
expect_identical(stri_sprintf("e with %1$2d digits = %2$.*1$g", 10, exp(1)), sprintf("e with %1$2d digits = %2$.*1$g", 10, exp(1)))
expect_identical(stri_sprintf("%*1$d", 1:5), sprintf("%*1$d", 1:5))
expect_identical(stri_sprintf("%1$*1$d", 1:5), sprintf("%1$*1$d", 1:5))
expect_identical(stri_sprintf("%1$*d", 1:5), sprintf("%1$*d", 1:5))


# the following are from help("sprintf"):

expect_identical(stri_sprintf("%.0f%% said yes (out of a sample of size %.0f)", 66.666, 3), sprintf("%.0f%% said yes (out of a sample of size %.0f)", 66.666, 3))
expect_identical(stri_sprintf("%f", pi), sprintf("%f", pi))
expect_identical(stri_sprintf("%.3f", pi), sprintf("%.3f", pi))
expect_identical(stri_sprintf("%1.0f", pi), sprintf("%1.0f", pi))
expect_identical(stri_sprintf("%5.1f", pi), sprintf("%5.1f", pi))
expect_identical(stri_sprintf("%05.1f", pi), sprintf("%05.1f", pi))
expect_identical(stri_sprintf("%+f", pi), sprintf("%+f", pi))
expect_identical(stri_sprintf("% f", pi), sprintf("% f", pi))
expect_identical(stri_sprintf("%-10f", pi) , sprintf("%-10f", pi))
expect_identical(stri_sprintf("%e", pi), sprintf("%e", pi))
expect_identical(stri_sprintf("%E", pi), sprintf("%E", pi))
expect_identical(stri_sprintf("%g", pi), sprintf("%g", pi))
expect_identical(stri_sprintf("%g",   1e6 * pi) , sprintf("%g",   1e6 * pi))
expect_identical(stri_sprintf("%.9g", 1e6 * pi) , sprintf("%.9g", 1e6 * pi))
expect_identical(stri_sprintf("%G", 1e-6 * pi), sprintf("%G", 1e-6 * pi))
expect_identical(stri_sprintf("%1.f", 101), sprintf("%1.f", 101))
expect_identical(stri_sprintf("%1$d %1$x %1$X", 0:15), sprintf("%1$d %1$x %1$X", 0:15))
expect_identical(stri_sprintf("min 10-char string '%10s'", c("a", "ABC", "and an even longer one")), sprintf("min 10-char string '%10s'", c("a", "ABC", "and an even longer one")))
expect_identical(stri_sprintf("% 9s", month.name), sprintf("% 9s", month.name))
expect_identical(stri_sprintf(paste0("e with %2d digits = %.", 1:18, "g"), 1:18, exp(1)), sprintf(paste0("e with %2d digits = %.", 1:18, "g"), 1:18, exp(1)))
expect_identical(stri_sprintf("second %2$1.0f, first %1$5.2f, third %3$1.0f", pi, 2, 3), sprintf("second %2$1.0f, first %1$5.2f, third %3$1.0f", pi, 2, 3))
expect_identical(stri_sprintf("precision %.*f, width '%*.3f'", 3, pi, 8, pi), sprintf("precision %.*f, width '%*.3f'", 3, pi, 8, pi))
expect_identical(stri_sprintf("e with %1$2d digits = %2$.*1$g", 1:18, exp(1)), sprintf("e with %1$2d digits = %2$.*1$g", 1:18, exp(1)))
expect_identical(stri_sprintf("%s %d", "test", 1:3), sprintf("%s %d", "test", 1:3))
expect_identical(stri_sprintf("%a", seq(0, 1.0, 0.1)), sprintf("%a", seq(0, 1.0, 0.1)))
expect_identical(stri_sprintf("%a", c(0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1)), sprintf("%a", c(0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1)))

expect_identical(stri_sprintf("%.2s", NA, na_string="NAAAAAAA"), "NA")
expect_identical(stri_sprintf("%.2s", NA, na_string="NAAAAAAA", use_length=TRUE), "NA")
expect_identical(stri_sprintf("%.1s", NA, na_string="\U0001F4A9NAAAAAAA"), "")
expect_identical(stri_sprintf("%.2s", NA, na_string="\U0001F4A9NAAAAAAA"), "\U0001F4A9")
expect_identical(stri_sprintf("%.2s", NA, na_string="\U0001F4A9NAAAAAAA", use_length=TRUE), "\U0001F4A9N")

expect_identical(stri_sprintf("%*s", NA, "aaaaa"), NA_character_)
expect_identical(stri_sprintf("%*s", NA, "aaaaa", na_string="NA"), "NA")
expect_identical(stri_sprintf("%.*s", NA, "aaaaa"), NA_character_)
expect_identical(stri_sprintf("%.*s", NA, "aaaaa", na_string="NA"), "NA")
expect_identical(stri_sprintf("%*.2s", NA, "aaaaa", na_string="NAAAAAAA"), "NA")
expect_identical(stri_sprintf("%*.2s", NA, "aaaaa", na_string="NAAAAAAA", use_length=TRUE), "NA")
expect_identical(stri_sprintf("%*f", NA, pi), NA_character_)
expect_identical(stri_sprintf("%*f", NA, pi, na_string="NA"), "NA")
expect_identical(stri_sprintf("%*d", NA, pi), NA_character_)
expect_identical(stri_sprintf("%*d", NA, pi, na_string="NA"), "NA")
expect_identical(stri_sprintf("%*.f", NA, pi), NA_character_)
expect_identical(stri_sprintf("%*.f", NA, pi, na_string="NA"), "NA")
expect_identical(stri_sprintf("%*.d", NA, pi), NA_character_)
expect_identical(stri_sprintf("%*.d", NA, pi, na_string="NA"), "NA")
