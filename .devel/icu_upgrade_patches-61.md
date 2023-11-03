# ICU 61 Patching Info

copy common/
copy i18n/
copy stubdata/

move common/unicode and i18n/unicode to unicode/

remove *.rc *.vcproj *.vcxproj *filters

```R
library(stringi)
f <- list.files("~/R/stringi/src/icu61", recursive="TRUE", full.names=TRUE)
f <- f[!stri_detect_regex(f, "\\.(cpp|h|c|txt)$|LICENSE")]
file.remove(f)
```

New and removed files:

```R
d1 <- dir("~/R/stringi/src/icu55", recursive=TRUE)
d2 <- dir("~/R/stringi/src/icu61", recursive=TRUE)
sort(setdiff(d1, d2))
sort(setdiff(d2, d1))
```

"Makefile":

```R
path <- "~/R/stringi/src/"
base <- "icu61/i18n/"
cat(stri_paste(collapse=" \\\n", base, dir(stri_paste(path, base), pattern=glob2rx("*.cpp"))), file=stri_paste(path, "icu61_i18n_cpp.txt"), sep="\n")
cat(stri_paste(collapse=" \\\n", base, dir(stri_paste(path, base), pattern=glob2rx("*.c"))), file=stri_paste(path, "icu61_i18n_c.txt"))
base <- "icu61/common/"
cat(stri_paste(collapse=" \\\n", base, dir(stri_paste(path, base), pattern=glob2rx("*.cpp"))), file=stri_paste(path, "icu61_common_cpp.txt"), sep="\n")
cat(stri_paste(collapse=" \\\n", base, dir(stri_paste(path, base), pattern=glob2rx("*.c"))), file=stri_paste(path, "icu61_common_c.txt"))
base <- "icu61/stubdata/"
cat(stri_paste(collapse=" \\\n", base, dir(stri_paste(path, base), pattern=glob2rx("*.cpp"))), file=stri_paste(path, "icu61_stubdata_cpp.txt"), sep="\n")
cat(stri_paste(collapse=" \\\n", base, dir(stri_paste(path, base), pattern=glob2rx("*.c"))), file=stri_paste(path, "icu61_stubdata_c.txt"))
```

Build ICU data:

```R
# download icu data zip archive.... replace source/data with the new one
./runConfigureICU Linux/gcc --with-data-packaging=archive  --prefix=/tmp/icuinst
make
make install
# /tmp/icuinst/share/icu/61.1/ ...

```
