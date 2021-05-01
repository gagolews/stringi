ICU 52.1 patches to apply
==========================

1. replace Collator::EComparisonResult with UCollationResult (for Solaris CC) in:
   * unicode/coll.h
   * unicode/sortkey.h
   * i18n/sortkey.cpp
   * i18n/coll.cpp



ICU 55
======

copy common/
copy i18n/
copy stubdata/

move common/unicode and i18n/unicode to unicode/

remove *.rc *.vcproj *.vcxproj and others

mkdir data/

d1 <- dir("src/icu52", recursive=TRUE)
d2 <- dir("src/icu55", recursive=TRUE)
setdiff

ICU 61
======

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


Patches:

* ....


## ICU 69

Much like ICU 61, but use sources.txt.

ICU data files are now distributed alongside with ICU (github).

Patches:

* ....

Warning: Found the following significant warnings:
  icu69/common/uidna.cpp:514:17: warning: 'uidna_toASCII_69_stringi' is deprecated [-Wdeprecated-declarations]
  icu69/common/uidna.cpp:527:22: warning: 'uidna_toASCII_69_stringi' is deprecated [-Wdeprecated-declarations]

Warning: File which contains pragma(s) suppressing important diagnostics
  ‘src/icu69/i18n/decNumber.cpp’
File which contains pragma(s) suppressing diagnostics:
  ‘src/icu69/common/umutex.h’

Warning: File ‘stringi/libs/stringi.so’:
  Found ‘_abort’, possibly from ‘abort’ (C)
    Objects: ‘icu69/common/loadednormalizer2impl.o’,
      ‘icu69/common/normalizer2impl.o’, ‘icu69/common/rbbi_cache.o’,
      ‘icu69/common/ubidi.o’, ‘icu69/common/ubidiln.o’,
      ‘icu69/common/uhash.o’, ‘icu69/common/uloc_keytype.o’,
      ‘icu69/common/ustr_titlecase_brkiter.o’, ‘icu69/common/utrace.o’,
      ‘icu69/i18n/collationbuilder.o’,
      ‘icu69/i18n/collationdatabuilder.o’,
      ‘icu69/i18n/double-conversion-bignum-dtoa.o’,
      ‘icu69/i18n/double-conversion-bignum.o’,
      ‘icu69/i18n/double-conversion-double-to-string.o’,
      ‘icu69/i18n/double-conversion-fast-dtoa.o’,
      ‘icu69/i18n/double-conversion-string-to-double.o’,
      ‘icu69/i18n/double-conversion-strtod.o’, ‘icu69/i18n/dtptngen.o’,
      ‘icu69/i18n/formattedvalue.o’, ‘icu69/i18n/islamcal.o’,
      ‘icu69/i18n/number_affixutils.o’, ‘icu69/i18n/number_grouping.o’,
      ‘icu69/i18n/number_longnames.o’, ‘icu69/i18n/number_modifiers.o’,
      ‘icu69/i18n/number_patternmodifier.o’,
      ‘icu69/i18n/number_patternstring.o’,
      ‘icu69/i18n/number_rounding.o’, ‘icu69/i18n/number_scientific.o’,
      ‘icu69/i18n/number_skeletons.o’,
      ‘icu69/i18n/number_usageprefs.o’, ‘icu69/i18n/number_utils.o’,
      ‘icu69/i18n/numparse_affixes.o’, ‘icu69/i18n/numrange_impl.o’,
      ‘icu69/i18n/plurrule.o’, ‘icu69/i18n/regexcmp.o’,
      ‘icu69/i18n/rematch.o’, ‘icu69/i18n/smpdtfmt.o’,
      ‘icu69/i18n/timezone.o’, ‘icu69/i18n/tmunit.o’,
      ‘icu69/i18n/transreg.o’, ‘icu69/i18n/tzfmt.o’,
      ‘icu69/i18n/umsg.o’, ‘icu69/i18n/uspoof_impl.o’

Compiled code should not call entry points which might terminate R nor
write to stdout/stderr instead of to the console, nor use Fortran I/O
nor system RNGs.
