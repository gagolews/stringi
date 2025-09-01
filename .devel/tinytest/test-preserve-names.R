library("tinytest")
library("stringi")

# From https://github.com/tidyverse/stringr/issues/575

x <- c(A = "3", B = "2", C = "1")
expect_equal(stri_sort(x), c(C = "1", B = "2", A = "3"))
expect_equal(stri_replace_all_fixed(x, "2", "0"), c(A = "3", B = "0", C = "1"))

# Helper
expect_names_equal <- function(obj, nm) expect_equal(names(obj), nm)

# Basic fixtures
xc <- c(A = "alpha", B = "beta", C = "gamma", D = NA_character_)

# replace_na
expect_equal(names(stri_replace_na(xc, replacement = "NA")), names(xc))

# detect_* (logical vector) should preserve names
expect_names_equal(stri_detect_fixed(xc, "a"), names(xc))
expect_names_equal(stri_detect_regex(xc, "a"), names(xc))
expect_names_equal(stri_detect_coll(xc, "a"), names(xc))
expect_names_equal(stri_detect_charclass(xc, "\\p{L}"), names(xc))

# count_* (integer vector) should preserve names
expect_names_equal(stri_count_fixed(xc, "a"), names(xc))
expect_names_equal(stri_count_regex(xc, "a"), names(xc))
expect_names_equal(stri_count_coll(xc, "a"), names(xc))
expect_names_equal(stri_count_charclass(xc, "\\p{L}"), names(xc))

# startswith/endswith (logical vector) should preserve names
expect_names_equal(stri_startswith_fixed(xc, "a"), names(xc))
expect_names_equal(stri_endswith_fixed(xc, "a"), names(xc))
expect_names_equal(stri_startswith_coll(xc, "a"), names(xc))
expect_names_equal(stri_endswith_coll(xc, "a"), names(xc))
expect_names_equal(stri_startswith_charclass(xc, "\\p{L}"), names(xc))
expect_names_equal(stri_endswith_charclass(xc, "\\p{L}"), names(xc))

# subset_* should preserve names of selected elements
sub_fixed <- stri_subset_fixed(xc, "a")
expect_equal(names(sub_fixed), names(xc)[stri_detect_fixed(xc, "a") %in% c(TRUE, NA)])
sub_regex <- stri_subset_regex(xc, "a")
expect_equal(names(sub_regex), names(xc)[stri_detect_regex(xc, "a") %in% c(TRUE, NA)])
sub_coll <- stri_subset_coll(xc, "a")
expect_equal(names(sub_coll), names(xc)[stri_detect_coll(xc, "a") %in% c(TRUE, NA)])
sub_cc <- stri_subset_charclass(xc, "\\p{L}")
expect_equal(names(sub_cc), names(xc)[stri_detect_charclass(xc, "\\p{L}") %in% c(TRUE, NA)])

# replace_* result length unchanged; names preserved
expect_names_equal(stri_replace_first_fixed(xc, "a", "A"), names(xc))
expect_names_equal(stri_replace_last_fixed(xc, "a", "A"), names(xc))
expect_names_equal(stri_replace_all_fixed(xc, "a", "A"), names(xc))

expect_names_equal(stri_replace_first_regex(xc, "a", "A"), names(xc))
expect_names_equal(stri_replace_last_regex(xc, "a", "A"), names(xc))
expect_names_equal(stri_replace_all_regex(xc, "a", "A"), names(xc))

expect_names_equal(stri_replace_first_coll(xc, "a", "A"), names(xc))
expect_names_equal(stri_replace_last_coll(xc, "a", "A"), names(xc))
expect_names_equal(stri_replace_all_coll(xc, "a", "A"), names(xc))

expect_names_equal(stri_replace_first_charclass(xc, "\\p{L}", "X"), names(xc))
expect_names_equal(stri_replace_last_charclass(xc, "\\p{L}", "X"), names(xc))
expect_names_equal(stri_replace_all_charclass(xc, "\\p{L}", "X", merge = TRUE), names(xc))

# extract first/last (character vector) should preserve names
expect_names_equal(stri_extract_first_fixed(xc, "a"), names(xc))
expect_names_equal(stri_extract_last_fixed(xc, "a"), names(xc))
expect_names_equal(stri_extract_first_regex(xc, "a"), names(xc))
expect_names_equal(stri_extract_last_regex(xc, "a"), names(xc))
expect_names_equal(stri_extract_first_coll(xc, "a"), names(xc))
expect_names_equal(stri_extract_last_coll(xc, "a"), names(xc))
expect_names_equal(stri_extract_first_charclass(xc, "\\p{L}"), names(xc))
expect_names_equal(stri_extract_last_charclass(xc, "\\p{L}"), names(xc))

# extract_all_* (list) top-level names preserved
expect_equal(names(stri_extract_all_fixed(xc, "a")), names(xc))
expect_equal(names(stri_extract_all_regex(xc, "a", simplify = FALSE, omit_no_match = FALSE)), names(xc))
expect_equal(names(stri_extract_all_coll(xc, "a")), names(xc))
expect_equal(names(stri_extract_all_charclass(xc, "\\p{L}", merge = TRUE)), names(xc))

# locate_all_* (list) top-level names preserved
expect_equal(names(stri_locate_all_fixed(xc, "a")), names(xc))
expect_equal(names(stri_locate_all_regex(xc, "a", omit_no_match = FALSE, capture_groups = FALSE, get_length = FALSE)), names(xc))
expect_equal(names(stri_locate_all_coll(xc, "a")), names(xc))
expect_equal(names(stri_locate_all_charclass(xc, "\\p{L}", merge = TRUE)), names(xc))

# split_* (list) top-level names preserved
expect_equal(names(stri_split_fixed(xc, "a")), names(xc))
expect_equal(names(stri_split_regex(xc, "a")), names(xc))
expect_equal(names(stri_split_coll(xc, "a")), names(xc))
expect_equal(names(stri_split_charclass(xc, "\\p{L}")), names(xc))
expect_equal(names(stri_split_lines(xc)), names(xc))

# boundaries count preserves names
expect_names_equal(stri_count_boundaries(xc), names(xc))
