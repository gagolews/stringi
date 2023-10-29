#!/bin/sh

docker run --rm -ti fedora:latest /bin/bash -c "
dnf upgrade -y -q --refresh                                                                                                          && \
dnf install -y -q R-devel git tar wget                                                                                               && \
cd /tmp                                                                                                                              && \
wget http://download.icu-project.org/files/icu4c/59rc/icu4c-59rc-src.tgz                                                             && \
tar -zxf icu4c-*-src.tgz                                                                                                             && \
cd icu/source/                                                                                                                       && \
./runConfigureICU Linux/gcc                                                                                                          && \
make                                                                                                                                 && \
make install                                                                                                                         && \
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/                                                                                     && \
export LD_LIBRARY_PATH=/usr/local/lib/                                                                                               && \
export STRINGI_CPPFLAGS='-DU_HIDE_DRAFT_API -DU_HIDE_DEPRECATED_API -DU_HIDE_OBSOLETE_API'                                           && \
cd /tmp                                                                                                                              && \
GIT_SSL_NO_VERIFY=true git clone https://github.com/gagolews/stringi.git                                                             && \
R CMD build stringi                                                                                                                  && \
R CMD INSTALL stringi_*.tar.gz --configure-args='--disable-icu-bundle' --no-html                                                     && \
Rscript --vanilla -e 'install.packages(c(\"Rcpp\", \"stringr\", \"testthat\"), repos=\"http://cran.rstudio.com/\", quiet=TRUE)'        && \
LC_ALL='en_US.UTF-8' Rscript --vanilla -e 'setwd(\"stringi\"); source(\"devel/testthat/run_package_tests.R\")'                          \
"
