#!/usr/bin/Rscript

# Detects non-ASCII chars in .R source files and replaces them with \uxxxx
# This uses a brute force approach!

# Last used: 2021-05-04 (devel/tinytest/*)

require('stringi')

# we are in the root dir of stringi
srcfiles <- dir('.', pattern='\\.(R|cpp|h)$', recursive=TRUE, ignore.case=TRUE)

# sprintf("%x", unlist(stri_enc_toutf32(c(UTF8chars))))

for (f in srcfiles) {
    cf <- stri_read_raw(f)
    if (!stri_enc_isascii(cf)) {
        cat(sprintf('%s\n', f))

        cf2 <- stri_encode(cf, "UTF-8", "UTF-8")
        cf2 <- stri_trans_general(cf2, "[^\\u0000-\\u007f] Any-Hex/C")
#         cat(cf2, file=f)  # !!!!!!!!!!!!!!!
    }
}
