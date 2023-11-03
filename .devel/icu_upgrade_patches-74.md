# ICU 74 Patching Info

## Diffs for ICU69 (Patches applied in due course)

```bash
COMMIT_ORIGINAL=bbbf25bbe6e1aa198389dd08636a3360b5788213
DIR_ORIGINAL=/tmp/stringi-${COMMIT_ORIGINAL}/src/icu69
DIR_CURRENT=~/R/stringi/src/icu69
DIR_DIFFS=~/R/stringi/.devel/icu69diffs
SUBDIRS=(
    unicode
    common
    i18n
    stubdata
)
```

```bash
cd /tmp
wget https://github.com/gagolews/stringi/archive/${COMMIT_ORIGINAL}.zip
unzip ${COMMIT_ORIGINAL}.zip
```

```bash
shopt -s nullglob
cd ${DIR_CURRENT}
for d in ${SUBDIRS[@]}; do
    mkdir -p ${DIR_DIFFS}/$d
    FILES=(
        ${d}/*.h
        ${d}/*.c
        ${d}/*.cpp
    )

    for f in ${FILES[@]}; do
        diff -u -d -b -B -Z -N ${DIR_ORIGINAL}/$f $f > ${DIR_DIFFS}/$f.diff
        [ -s ${DIR_DIFFS}/$f.diff ] && echo ${DIR_DIFFS}/$f.diff || rm -f ${DIR_DIFFS}/$f.diff
    done
done
```


## TODO: Download ICU

https://github.com/unicode-org/icu/releases/tag/release-74-1

https://github.com/unicode-org/icu/releases/download/release-74-1/icu4c-74_1-src.zip

icudt is available for download from:

https://github.com/unicode-org/icu/releases/download/release-74-1/icu4c-74_1-data-bin-b.zip
https://github.com/unicode-org/icu/releases/download/release-74-1/icu4c-74_1-data-bin-l.zip

Compress icudt-l with xz, include in the source bundle

icudt-b should be downloaded on demand during install


! Use `#ifdef U_STRINGI_PATCHES`


## TODO: Patch ICU


? use sources.txt.
