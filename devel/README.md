The `devel` directory contains files used in the package's development process.
Its contents will not be included in the final build distributed on CRAN.


TO DO list - Preparing `stringi` for submission

1. Remove contents of the man/ dir
2. Rebuild & reinstall the package. Documentation files in man/ will be updated
      via Roxygen2.
3. Call R CMD build --compact-vignettes
4. Call R CMD check --as-cran (also on the latest R-devel)
5. Make sure string_*.tar.gz does not contain devel/
6. Check how the package compiles with Oracle Solaris Studio, on Win and OS X
      Win: *** http://win-builder.r-project.org/ ***
7. test with valgrind, asan, ubsan
8. check with win-builder + then run tests on Windows
9. Check PDF manual: `R CMD Rd2pdf stringi/`
10. Check depending packages + email their authors:

```
pkgs <- c("qdapRegex", "RcmdrPlugin.temis", "rplexos")
install.packages(pkgs, INSTALL_opts = "--install-tests")
for (p in pkgs) {
   library(p,  character.only=TRUE)
   tryCatch({print(p); testthat::test_package(p)}, error=function(e) print(e))
   # example(package=p, character.only=TRUE)
}
```


Check examples when there is no icu52dt
(comment appropriate section in `src/install.libs.R`)

clang and Solaris Studio compile/check:
```
###
make clean
CC="clang" CXX="clang++" ./configure --prefix=/opt/R-devel-clang
make

clang -I. -Iunicode -Icommon -Ii18n -I/usr/local/include -I/usr/include/R -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG -w -std=c99 -c *.c
clang++ -I. -Iunicode -Icommon -Ii18n -I/usr/local/include -I/usr/include/R -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG -pedantic  -Wall -std=c++98 -c *.cpp


###
/opt/R-devel-clang/bin/R CMD check --as-cran /home/gagolews/Projekty/stringi_
###
setenv PATH /opt/oracle/solarisstudio12.3/bin:$PATH
setenv MANPATH /opt/oracle/solarisstudio12.3/man:$MANPATH

/opt/R-devel-clang/bin/R CMD INSTALL --configure-vars="CC=cc CXX=CC" \
   /home/gagolews/Projekty/stringi_0.1-20.tar.gz

PATH=/opt/oracle/solarisstudio12.3/bin:$PATH
MANPATH=/opt/oracle/solarisstudio12.3/man:$MANPATH
export PATH
export MANPATH

CC -I. -Iunicode -I/usr/local/include -I/usr/include/R -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG +w -c stri_*.cpp
CC -I. -Iunicode -Icommon -Ii18n -I/usr/local/include -I/usr/include/R -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG -w -erroff -c *.cpp
cc -I. -Iunicode -Icommon -Ii18n -I/usr/local/include -I/usr/include/R -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG -w -erroff -c *.c

g++ -I. -Iicu52 -Iicu52/unicode -Iicu52/common -Iicu52/i18n -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG -w -std=c++98 -ansi -c icu52/common/*.cpp icu52/i18n/*.cpp icu52/stubdata/*.cpp
gcc -I. -Iicu52 -Iicu52/unicode -Iicu52/common -Iicu52/i18n -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG -w -std=c99 -ansi -c icu52/common/*.c icu52/i18n/*.c icu52/stubdata/*.c

CC -compat=5 -I. -Iicu52 -Iicu52/unicode -Iicu52/common -Iicu52/i18n -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG -w -erroff -c icu52/common/*.cpp icu52/i18n/*.cpp icu52/stubdata/*.cpp
cc-5.0 -Xc -xc99 -xlibmieee -I. -Iicu52 -Iicu52/unicode -Iicu52/common -Iicu52/i18n -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG -w -erroff -c icu52/common/*.c icu52/i18n/*.c icu52/stubdata/*.c

gcc -I. -Iicu52 -Iicu52/unicode -Iicu52/common -Iicu52/i18n -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG -w -std=c99 -c icu52/common/*.c icu52/i18n/*.c icu52/stubdata/*.c
```
