library("tinytest")
library("stringi")
library("stringr")


# basic tests (ASCII, border-line):
expect_equivalent(stri_trim_both(character(0)), character(0))
expect_equivalent(stri_trim_both(NA), NA_character_)

expect_equivalent(stri_trim_both("      "), "")
expect_equivalent(stri_trim_both(" \tA  "), "A")
expect_equivalent(stri_trim_both("A \t\n"), "A")
expect_equivalent(stri_trim_both("     A"), "A")
expect_equivalent(stri_trim_both(" \t"), "")
expect_equivalent(stri_trim_both("\n"), "")
expect_equivalent(stri_trim_both(" \t ą \n "), "ą")

expect_equivalent(stri_trim_both(LETTERS), LETTERS)

expect_equivalent(stri_trim_both(stri_dup(" ", 1:100)), rep("", 100))
expect_equivalent(stri_trim_both(stri_dup(" \n \t", 1:100)), rep("", 100))
expect_equivalent(stri_trim_both(stri_dup("\n\t\n", 1:100)), rep("", 100))


# basic tests (ASCII, border-line):
expect_equivalent(stri_trim_left(character(0)), character(0))
expect_equivalent(stri_trim_left(NA), NA_character_)

expect_equivalent(stri_trim_left("      "), "")
expect_equivalent(stri_trim_left("   \n A  "), "A  ")
expect_equivalent(stri_trim_left("A     "), "A     ")
expect_equivalent(stri_trim_left("     A"), "A")
expect_equivalent(stri_trim_left(" \t"), "")
expect_equivalent(stri_trim_left("\n"), "")
expect_equivalent(stri_trim_left(" \t ą \n "), "ą \n ")

expect_equivalent(stri_trim_left(LETTERS), LETTERS)

expect_equivalent(stri_trim_left(stri_dup(" ", 1:100)), rep("", 100))
expect_equivalent(stri_trim_left(stri_dup("\n", 1:100)), rep("", 100))
expect_equivalent(stri_trim_left(stri_dup(" \t \n", 1:100)), rep("", 100))


# basic tests (ASCII, border-line):
expect_equivalent(stri_trim_right(character(0)), character(0))
expect_equivalent(stri_trim_right(NA), NA_character_)

expect_equivalent(stri_trim_right("      "), "")
expect_equivalent(stri_trim_right("   A \t "), "   A")
expect_equivalent(stri_trim_right("A  \n   "), "A")
expect_equivalent(stri_trim_right("    \n A"), "    \n A")
expect_equivalent(stri_trim_right("\t "), "")
expect_equivalent(stri_trim_right("\n"), "")
expect_equivalent(stri_trim_right(" \t ą \n "), " \t ą")

expect_equivalent(stri_trim_right(LETTERS), LETTERS)

expect_equivalent(stri_trim_right(stri_dup(" ", 1:100)), rep("", 100))
expect_equivalent(stri_trim_right(stri_dup("\n", 1:100)), rep("", 100))
expect_equivalent(stri_trim_right(stri_dup(" \t\n", 1:100)), rep("", 100))


# test_that('stri_trim_double', {
#
#    # basic tests (ASCII, border-line):
#    expect_equivalent(stri_trim_double(character(0)), character(0))
#    expect_equivalent(stri_trim_double(NA), NA_character_)
#    expect_equivalent(stri_trim_double(''),'')
#    expect_equivalent(stri_trim_double('         '), '')
#    expect_equivalent(stri_trim_double('  \t A \n '), 'A')
#    expect_equivalent(stri_trim_double(' A A  A  \t A  '), 'A A A A')
#
#    expect_equivalent(stri_trim_double(LETTERS), LETTERS)
#
#    expect_equivalent(stri_trim_double(stri_dup(' ', 1:100)), rep('', 100))
#    s <- stri_flatten(LETTERS%s+%stri_dup(' ',1:26))
#    expect_equivalent(stri_trim_double(s),stri_flatten(LETTERS,' '))
# })
