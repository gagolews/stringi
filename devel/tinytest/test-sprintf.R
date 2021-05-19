library("tinytest")
library("stringi")

expect_identical(stri_sprintf(character(0), 1:10), character(0))
expect_identical(stri_sprintf("%s", NULL), character(0))
expect_identical(stri_sprintf("%s", 1:10, character(0)), character(0))
expect_identical(stri_sprintf(rep("%s", 10), 1:10, character(0)), character(0))
expect_warning(stri_sprintf(rep("%s", 10), 1:5, 1:3))

'

sprintf("%s", as.name("symbols are not supported"))
sprintf("%s", list(11:13))  # ok, as.character called
sprintf("%s", 11:13)  # ok, as.character called
sprintf("%s", factor(11:13))  # as.character
sprintf("%d", factor(11:13))  # as.integer
sprintf("%s", Sys.Date())  # as.character
sprintf("%s", Sys.time())  # as.character
sprintf("%d", Sys.Date())
sprintf("%f", Sys.time())


# NAs not propagated correctly  [this is a string formatting function, so there should be an option to treat NA as "NA" etc. though)
sprintf(NA, "this should yield NA")  # error, but should be NA_character_
sprintf(NA_character_, "this should yield NA")  # "NA", but should be NA_character_

# not fully vectorised:
sprintf(c("%d", "%s"), factor(11:12))  # error, converts to int only and then fails
sprintf(c("%s", "%d"), factor(11:12))  # error, converts to character only and then fails
sprintf("%1$s_%1$d", factor(11:12))  # does not work either

sprintf("%d%d", 1:3, 1:2)  # error, but should be a warning about partial recycling

sprintf("%s%d", character(0), 1:10)  # ok, empty vector

sprintf(c(x="%s", y="%s"), c(a=1, b=2))  # attributes not preserved

# "prefix 0 for characters zero-pads on some platforms and is ignored on others."

sprintf("%#010x", 123)
sprintf("%f", 123)# "123.000000"
sprintf("%#f", 123)# "123.000000"
sprintf("%#g", 123)# "123.000"
sprintf("%g", 123) # "123"
sprintf("%#015g", 123) # "00000000123.000"

sprintf("%5.3d", 1)  # "  001"
sprintf("%5.8d", 1)  # "00000001"
sprintf("%5.8d", 123)# "00000123"
sprintf("%5.8d", 12345678) # "12345678"
sprintf("%5.8d", 123456789)# "123456789"

sprintf("% 05d", c(-123, 123, 0))  # "-0123" " 0123" " 0000"
sprintf("%+05d", c(-123, 123, 0))  # "-0123" "+0123" "+0000"
sprintf("%+5d", c(-123, 123, 0))   # " -123" " +123" "   +0"
sprintf("% 5d", c(-123, 123, 0))   # " -123" "  123" "    0"
sprintf("%- 5d", c(-123, 123, 0))  # "-123 " " 123 " " 0   "
sprintf("%-+5d", c(-123, 123, 0))  # "-123 " "+123 " "+0   "
sprintf("%-0+5d", c(-123, 123, 0)) # "-123 " "+123 " "+0   "
sprintf("%-0 5d", c(-123, 123, 0)) # "-123 " " 123 " " 0   "


sprintf("%08s", "abc")
sprintf("%-8s", "abc")
sprintf("%+8s", "abc")

sprintf("% d", 123)
sprintf("% +d", 123)
sprintf("%+ d", 123)

sprintf("%4$*3$s", 1, "a", 6, "b")
sprintf("%4$*3$.2f", 1, "a", 6, pi)
sprintf("%4$10.*3$f", 1, "a", 6, pi)
sprintf("%4$-*3$.2f", 1, "a", 6, pi)
sprintf("e with %1$2d digits = %2$.*1$g", 10, exp(1))

sprintf("%*1$d", 1:5)
sprintf("%1$*1$d", 1:5)
sprintf("%1$*d", 1:5)

sprintf("%.0f", c(0, 0.5, 1, 1.5, 2))
sprintf("%d", c(0, 0.5, 1, 1.5, 2))



sprintf("%s %1$s %s", "a", "b", "c", "d")

sprintf("%s %4$s %s", "a", "b", "c", "d")

sprintf("abc")


sprintf("abc", NULL)
sprintf("abc", character(0))
sprintf("abc", 1:5)


sprintf("%2$s", "x")
sprintf("%s%s", "x")
sprintf("%2$s", NA, "y")


x <- as.list(as.character(1:2))
do.call(sprintf, c(strrep("%s,", length(x)), x))

x <- as.list(as.character(1:99))
do.call(sprintf, c(strrep("%s,", length(x)), x))

x <- as.list(as.character(1:100))
do.call(sprintf, c(strrep("%s,", length(x)), x))

x <- as.list(as.character(1:1000))
do.call(sprintf, c(strrep("%s,", length(x)), x))





stri_sprintf(rep("%s", 10), 1:5, 7)
stri_sprintf(rep("%s", 10), 1:5, 1:2)
stri_sprintf(rep("%s", 10), 1:5, 1:3)

sprintf(c("%2s", "%5s", "%9s", "%10s", "%15s"), "abcdefghi")

stri_sprintf("%4s=%.3f", c("e", "e\u00b2", "\u03c0", "\u03c0\u00b2"), c(exp(1), exp(2), pi, pi^2))
'
