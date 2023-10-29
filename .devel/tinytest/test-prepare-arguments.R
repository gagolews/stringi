library("tinytest")
library("stringi")

suppressWarnings({

    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string(LETTERS),
        LETTERS))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string(NA), NA_character_))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string(integer(0)),
        character(0)))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string(c(TRUE, FALSE,
        TRUE)), c("TRUE", "FALSE", "TRUE")))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string(seq(0, 1,
        0.25)), as.character(seq(0, 1, 0.25))))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string(c(1 + (0+1i),
        2 + (0+2i))), as.character(c(1 + (0+1i), 2 + (0+2i)))))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string(as.name("name234")),
        "name234"))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string(as.factor(letters[c(1,
        1, 1, 2, 1, 1, 1)])), letters[c(1, 1, 1, 2, 1, 1, 1)]))

    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_string(matrix(1:10,
        nrow = 2)), matrix(as.character(1:10), nrow = 2)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_string(matrix(letters[1:10],
        nrow = 2)), matrix(letters[1:10], nrow = 2)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_string(ts(1:10)),
        as.character(ts(1:10))))


    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string(NULL), character(0)))
    expect_identical(stringi:::stri_prepare_arg_string(list(1, 2, 3)), as.character(list(1,
        2, 3)))
    expect_identical(stringi:::stri_prepare_arg_string(data.frame(1, 2, 3)), as.character(data.frame(1,
        2, 3)))


})

suppressWarnings({
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double(NA), NA_real_))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double(c("1", "2")),
        1:2))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double(character(0)),
        numeric(0)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double(1:5), 1:5))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double(1.5:5),
        1.5:5))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double(as.factor(1:5)),
        1:5))


    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_double(NULL), numeric(0)))
    expect_identical(stringi:::stri_prepare_arg_double(list(1, 2, 3)), as.double(list(1,
        2, 3)))
    expect_identical(stringi:::stri_prepare_arg_double(data.frame(1, 2, 3)), as.double(data.frame(1,
        2, 3)))
})


suppressWarnings({
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer(NA), NA_integer_))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer(1:10),
        1:10))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer(seq(0,
        1, by = 0.5)), c(0L, 0L, 1L)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer(c(TRUE,
        FALSE)), c(1L, 0L)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer(factor(c("4",
        "1", "1", "2", "4"))), c(4L, 1L, 1L, 2L, 4L)))
    suppressWarnings(suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer(c("1",
        "one", "1.5")), c(1L, NA_integer_, 1L))))

    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_integer(NULL), integer(0)))
    expect_identical(stringi:::stri_prepare_arg_integer(list(1, 2, 3)), as.integer(list(1,
        2, 3)))
    expect_identical(stringi:::stri_prepare_arg_integer(data.frame(1, 2, 3)), as.integer(data.frame(1,
        2, 3)))
})


suppressWarnings({
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_logical(NA), NA))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_logical((-3):3),
        c(T, T, T, F, T, T, T)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_logical(c("TRUE",
        "FALSE", "T", "F", NA)), c(T, F, T, F, NA)))

    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_logical(NULL), logical(0)))
    expect_identical(stringi:::stri_prepare_arg_logical(list(1, 2, 3)), as.logical(list(1,
        2, 3)))
    expect_identical(stringi:::stri_prepare_arg_logical(data.frame(1, 2, 3)), as.logical(data.frame(1,
        2, 3)))
})

suppressWarnings({
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_raw(0:3), as.raw(0:3)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_raw(c(T, F, T,
        F)), as.raw(c(T, F, T, F))))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_raw(NULL), raw(0)))
})

## ---- tests for prepare_1 ----

suppressWarnings({

    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string_1(LETTERS),
        LETTERS[1]))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string_1(NA), NA_character_))
    #expect_error(stringi:::stri_prepare_arg_string_1(integer(0)))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string_1(c(TRUE,
        FALSE, TRUE)), c("TRUE")))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string_1(seq(0,
        1, 0.25)), as.character(0)))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string_1(c(1 + (0+1i),
        2 + (0+2i))), as.character(1 + (0+1i))))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string_1(as.name("name234")),
        "name234"))
    suppressWarnings(expect_identical(stringi:::stri_prepare_arg_string_1(as.factor(letters[c(1,
        1, 1, 2, 1, 1, 1)])), letters[1]))

    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_string_1(matrix(1:10,
        nrow = 2)), as.character(1)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_string_1(matrix(letters[1:10],
        nrow = 2)), letters[1]))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_string_1(ts(1:10)),
        as.character(1)))


    suppressWarnings(expect_error(stringi:::stri_prepare_arg_string_1(NULL)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_string_1(list(1,
        2, 3)), "1"))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_string_1(data.frame(1,
        2, 3)), "1"))

})

suppressWarnings({
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double_1(NA), NA_real_))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double_1(c("1",
        "2")), 1))
    #suppressWarnings(stringi:::stri_prepare_arg_double_1(character(0)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double_1(1:5),
        1))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double_1(1.5:5),
        1.5))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double_1(as.factor(10 +
        1:5)), 10 + 1))


    suppressWarnings(expect_error(stringi:::stri_prepare_arg_double_1(NULL)))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double_1(list(1,
        2, 3)), 1))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_double_1(data.frame(1,
        2, 3)), 1))
})


suppressWarnings({
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer_1(NA),
        NA_integer_))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer_1(1:10),
        1))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer_1(seq(0,
        1, by = 0.5)), 0L))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer_1(c(TRUE,
        FALSE)), 1L))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer_1(factor(c("4",
        "1", "1", "2", "4"))), 4L))
    suppressWarnings(suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_integer_1(c("1",
        "one", "1.5")), 1L)))

    suppressWarnings(expect_error(stringi:::stri_prepare_arg_integer_1(NULL)))
})


suppressWarnings({
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_logical_1(NA),
        NA))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_logical_1((-3):3),
        T))
    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_logical_1(c("TRUE",
        "FALSE", "T", "F", NA)), T))

    suppressWarnings(expect_error(stringi:::stri_prepare_arg_integer_1(NULL)))
})

# suppressWarnings({
#    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_raw_1(0:3), as.raw(0)))
#    suppressWarnings(expect_equivalent(stringi:::stri_prepare_arg_raw_1(c(T,F,T,F)), as.raw(T)))
# })
