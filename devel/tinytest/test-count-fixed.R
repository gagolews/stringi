library("tinytest")
library("stringi")


expect_identical(stri_count_fixed(character(0), " "), integer(0))
expect_identical(stri_count_fixed(NA, "a"), NA_integer_)
expect_identical(stri_count_fixed("NA", NA), NA_integer_)
expect_identical(stri_count_fixed("   ", " "), 3L)
expect_identical(stri_count_fixed("###", c("#", "##", "###")), c(3L, 1L, 1L))
expect_identical(stri_count_fixed("##########", c("#", "##", "###", "####", "#####",
    "######")), c(10L, 5L, 3L, 2L, 2L, 1L))
expect_identical(stri_count_fixed("a a", "a"), 2L)
expect_identical(stri_count_fixed("aba", "abcdef"), 0L)
suppressWarnings(expect_identical(stri_count_fixed("", ""), NA_integer_))
suppressWarnings(expect_identical(stri_count_fixed("a", ""), NA_integer_))
expect_identical(stri_count_fixed("", "a"), 0L)
expect_equivalent(stri_count_fixed("aaaab", "ab"), 1L)
expect_equivalent(stri_count_fixed("bababababaab", "aab"), 1L)
expect_equivalent(stri_count_fixed("bababababaab", "b"), 6L)
expect_equivalent(stri_count_fixed("bababababaab", "ba"), 5L)
expect_equivalent(stri_count_fixed("bababababaab", "bab"), 2L)
expect_equivalent(stri_count_fixed("bababababaab", "baba"), 2L)
expect_equivalent(stri_count_fixed("bababababaabababab", "ababab"), 2L)
expect_equivalent(stri_count_fixed("aaaab", "ab", case_insensitive = TRUE), 1L)
expect_equivalent(stri_count_fixed("bababababaab", "aAb", case_insensitive = TRUE),
    1L)
expect_equivalent(stri_count_fixed("bababaBabaab", "b", case_insensitive = TRUE),
    6L)
expect_equivalent(stri_count_fixed("baBabababaab", "ba", case_insensitive = TRUE),
    5L)
expect_equivalent(stri_count_fixed("babaBababaab", "bAb", case_insensitive = TRUE),
    2L)
expect_equivalent(stri_count_fixed("bababaBabaab", "baba", case_insensitive = TRUE),
    2L)
expect_equivalent(stri_count_fixed("bababababaababaBab", "ababab", case_insensitive = TRUE),
    2L)

# we have special cases for patterns of length 1,2,3,4
expect_equivalent(stri_count_fixed("ba", "b"), 1L)
expect_equivalent(stri_count_fixed("bba", "bb"), 1L)
expect_equivalent(stri_count_fixed("bbba", "bbb"), 1L)
expect_equivalent(stri_count_fixed("bbbba", "bbbb"), 1L)
expect_equivalent(stri_count_fixed("bbbbba", "bbbbb"), 1L)
expect_equivalent(stri_count_fixed("ba", "B", case_insensitive = TRUE), 1L)
expect_equivalent(stri_count_fixed("bba", "BB", case_insensitive = TRUE), 1L)
expect_equivalent(stri_count_fixed("bbba", "BBB", case_insensitive = TRUE), 1L)
expect_equivalent(stri_count_fixed("bbbba", "BBBB", case_insensitive = TRUE),
    1L)
expect_equivalent(stri_count_fixed("bbbbba", "BBBBB", case_insensitive = TRUE),
    1L)

for (p in stri_sub("abcdefghij", 1, 1:6)) {
    for (i in 0:5) {
        for (val in c(TRUE, FALSE)) {
            expect_equivalent(stri_count_fixed(stri_dup(p, i), p, case_insensitive = val,
                overlap = val), i)
            expect_equivalent(stri_count_fixed(stri_dup(stri_c("x", p, "y", case_insensitive = val,
                overlap = val), i), p), i)
            expect_equivalent(stri_count_fixed(stri_dup(stri_c("x", p, "yy",
                case_insensitive = val, overlap = val), i), p), i)
            expect_equivalent(stri_count_fixed(stri_dup(stri_c("x", p, "yyy",
                case_insensitive = val, overlap = val), i), p), i)
            expect_equivalent(stri_count_fixed(stri_dup(stri_c("x", p, "yyyy",
                case_insensitive = val, overlap = val), i), p), i)
            expect_equivalent(stri_count_fixed(stri_dup(stri_c("x", p, "yyyyy",
                case_insensitive = val, overlap = val), i), p), i)
        }
    }
}


s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin
nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel
lorem. Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac
diam. Quisque semper justo at risus. Donec venenatis, turpis vel
hendrerit interdum, dui ligula ultricies purus, sed posuere libero dui
id orci. Nam congue, pede vitae dapibus aliquet, elit magna vulputate
arcu, vel tempus metus leo non est. Etiam sit amet lectus quis est
congue mollis. Phasellus congue lacus eget neque. Phasellus ornare,
ante vitae consectetuer consequat, purus sapien ultricies dolor, et
mollis pede metus eget nisi. Praesent sodales velit quis augue. Cras
suscipit, urna at aliquam rhoncus, urna quam viverra nisi, in interdum
massa nibh nec erat."
s <- stri_dup(s, 1:3)
expect_warning(stri_count_fixed(s, c("o", "a")))
expect_identical(stri_count_fixed(s, "\n"), 1:3 * 11L)
expect_identical(stri_count_fixed(s, " "), 1:3 * 105L)
expect_identical(stri_count_fixed(s, "a"), 1:3 * 50L)
expect_identical(stri_count_fixed(s, "co"), 1:3 * 6L)
expect_identical(stri_count_fixed(s, "rem"), 1:3 * 2L)
s <- c("abababab babab abab bbaba", "a")
expect_identical(stri_count_fixed(s, "bab"), c(5L, 0L))
expect_identical(stri_count_fixed(c("lalal", "12l34l56", "\u0105\u00F3l\u0142"), "l"), 3:1)

expect_equivalent(stri_count_fixed(c("AaaaaaaA", "AAAA"), "a", case_insensitive = TRUE,
    overlap = TRUE), c(8, 4))
