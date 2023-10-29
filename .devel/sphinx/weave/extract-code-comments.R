# Copyright (C) 2020-2023, Marek Gagolewski <https://www.gagolewski.com>

# Moves #> comments inside Markdown *highlighted* code blocks outside

library("stringi")  # of course lol


extract_code_comments <- function(fname)
{
    whole_input <- readLines(fname)
    out <- file(fname, open="w")

    codeblk <- rep(NA_character_, 4)
    # codeblk[1] == "    ```r"
    # codeblk[2] == "    "  (can be empty)
    # codeblk[3] == "```" (or more)
    # codeblk[4] == "r"

    code_started <- FALSE

    for (f in whole_input) {
        if (!is.na(codeblk[1])) {
            # is inside a code block

            x <- stri_match_first_regex(
                f,
                "^" %s+% codeblk[2] %s+% "#>[ ]*(.*)"
            )[1, ]

            if (!is.na(x[1])) {
                # it is a comment block inside a code block!
                if (code_started) {
                    # end code block
                    writeLines(codeblk[2] %s+% codeblk[3], con=out)
                    writeLines("", con=out)
                    code_started <- FALSE
                }

                # write the comment block as-is
                writeLines(codeblk[2] %s+%
                    if (!is.na(x[2])) x[2] else "", con=out)
            }
            else if (
                stri_detect_regex(
                    f,
                    "^" %s+% codeblk[2] %s+% codeblk[3]
                )
            ) {
                # end of code block
                if (code_started)
                    writeLines(f, con=out)

                codeblk <- rep(NA_character_, 4)
                code_started <- FALSE
            }
            else {
                # it is not a comment block
                if (!code_started) {
                    # delayed code block start!
                    writeLines("", con=out)
                    writeLines(codeblk[1], con=out)
                    code_started <- TRUE
                }
                writeLines(f, con=out)
            }
        }
        else {
            # we're not inside a code block
            x <- stri_match_first_regex(f, "^([ ]*)(```+)([a-zA-Z0-9]+)$")[1, ]
            if (!is.na(x[1])) {
                # but we are one now
                codeblk <- x
                code_started <- FALSE
                next
            }
            else {
                # plain text
                writeLines(f, con=out)
            }
        }
    }

    close(out)
    invisible(NULL)
}
