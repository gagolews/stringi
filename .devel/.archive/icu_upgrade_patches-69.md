# ICU 69 Patching Info

USE `#ifdef U_STRINGI_PATCHES`  - make diff between git commits (first, current)

Much like ICU 61, but use sources.txt.

ICU data files are now distributed alongside with ICU (github).

```bash
FILES=(
    common/putil.cpp
    common/rbbitblb.cpp
    common/ubiditransform.cpp
    common/ucnv2022.cpp
    common/ucurr.cpp
    common/uloc.cpp
    i18n/decNumber.cpp
    i18n/decNumber.h
    i18n/double-conversion-utils.h
    i18n/number_grouping.cpp
    i18n/ucal.cpp
    i18n/ucol_sit.cpp
    i18n/windtfmt.cpp
    i18n/winnmfmt.cpp
    unicode/umachine.h
)

mkdir -p ~/R/stringi/devel/icu61diffs/unicode
mkdir -p ~/R/stringi/devel/icu61diffs/common
mkdir -p ~/R/stringi/devel/icu61diffs/i18n

for f in ${FILES[@]}; do
    diff -u  -d  -b -B -Z /tmp/stringi-d268f16043fb6de40901e2eab31b39f1ecdcd3f3/src/icu61/$f ~/R/stringi/src/icu61/$f > ~/R/stringi/devel/icu61diffs/$f.diff
done
```





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
