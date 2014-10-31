# do spell check
require('stringi')

x <- aspell_package_Rd_files(".", )

x <- x[!(x$Original %in% c("ZWSP", "UTF", "UTR", "POSIX", "regex", "ipsum",
   "Ipsum", "Kile", "NUL", "NFKD", "NFKC", "NFC", "NFD", "icudt", "amet",
   "ogonek", "UCD", "Zipf", "Zl", "Zp", "JDK", "JIS", "LF", "NEL", "CRLF", "Cn",
   "EUC", "BreakIterator", "de", "Ps", "Pe", "ZWNBSP", "lorem", "Lorem", "Pc",
   "Mc", "NULs", "Nl", "Tf",
   "vectorized", "Vectorized", "LaTeX", "KOI", "IEC", "FCD", "FFFB", "FFFF",
   "Vectorization", "UnicodeSet", "UChar", "transliterators", "Friedl",
   "Transliterators", "stringi", "Solaris", "Regex", "regexes", "CTYPE", 
   "nondecreasing", "nonincreasing", "CJKV", "CN", "BOM", "BOMs", "API")),]

print(x)

print(levels(as.factor(x$Original)))
