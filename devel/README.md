The `devel` directory contains files used in the package's development process.
Its contents will not be included in the final build distributed on CRAN.


TO DO list - Preparing `stringi` for submission

1. Remove contents of the man/ dir
2. Rebuild & reinstall the package. Documentation files in man/ will be updated
      via Roxygen2.
3. Call R CMD build --compact-vignettes
4. Call R CMD check --as-cran
5. Make sure string_*.tar.gz does not contain devel/
6. Check how the package compiles with Oracle Solaris Studio, on Win and OS X


clang and Solaris Studio compile/check:
```
###
make clean
CC="clang" CXX="clang++" ./configure --prefix=/opt/R-devel-clang
make
###
/opt/R-devel-clang/bin/R CMD check --as-cran /home/gagolews/Projekty/stringi_
###
setenv PATH /opt/oracle/solarisstudio12.3/bin:$PATH
setenv MANPATH /opt/oracle/solarisstudio12.3/man:$MANPATH

 /opt/R-devel-clang/bin/R CMD INSTALL --configure-vars="CC=cc CXX=CC" /home/gagolews/Projekty/stringi_0.1-20.tar.gz

PATH=/opt/oracle/solarisstudio12.3/bin:$PATH
MANPATH=/opt/oracle/solarisstudio12.3/man:$MANPATH
export PATH
export MANPATH

CC -I. -Iunicode -I/usr/local/include -I/usr/include/R -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DU_TOOLUTIL_IMPLEMENTATI -DNDEBUG +w -c stri_*.cpp
CC -I. -Iunicode -I/usr/local/include -I/usr/include/R -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DU_TOOLUTIL_IMPLEMENTATI -DNDEBUG -w -erroff -c *.cpp
cc -I. -Iunicode -I/usr/local/include -I/usr/include/R -DU_STATIC_IMPLEMENTATION -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DU_TOOLUTIL_IMPLEMENTATI -DNDEBUG -w -erroff -c *.c
```
