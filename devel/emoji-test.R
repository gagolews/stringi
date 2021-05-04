# a very basic parser for https://unicode.org/Public/emoji/13.1/emoji-test.txt

# see also:
# https://unicode.org/Public/emoji/13.1/emoji-sequences.txt
# https://unicode.org/Public/emoji/13.1/emoji-zwj-sequences.txt


library("stringi")
x <- readLines("https://unicode.org/Public/emoji/13.1/emoji-test.txt")
x <- stri_match_first_regex(x, "^\\s*([A-Fa-f0-9 ]+).*?#\\s*(.*)$")
x <- x[!is.na(x[, 1]), -1]
x[, 1] <- stri_replace_all_regex(x[, 1], "\\b([A-Fa-f0-9]{5})\\b", "\\\\U000$1")
x[, 1] <- stri_replace_all_regex(x[, 1], "\\b([A-Fa-f0-9]{4})\\b", "\\\\u$1")
x[, 1] <- stri_replace_all_regex(x[, 1], "\\s", "")

y <- data.frame(
    emoji=stri_unescape_unicode(x[, 1]),
    width=stri_width(stri_unescape_unicode(x[, 1])),
    sequence=x[, 1],
    name=x[, 2])

y_tab <- knitr::kable(y[order(y[, "width"]), ], row.names=FALSE)
cat(y_tab, sep="\n", file="/tmp/emoji.txt")
