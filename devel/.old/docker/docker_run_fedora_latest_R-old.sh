#!/bin/sh

docker run --rm -ti fedora:latest /bin/bash -c "
dnf install -y -q libicu-devel git tar wget gcc-c++ readline-devel gcc-gfortran texlive-latex gettext-devel                          && \
cd /tmp                                                                                                                              && \
wget https://cran.r-project.org/src/base/R-2/R-2.14.0.tar.gz                                                                         && \
tar -zxf R-2.14.0.tar.gz                                                                                                             && \
cd R-2.14.0                                                                                                                          && \
./configure --disable-nls --with-x=no --with-readline=no --with-cairo=no --with-libpng=no --with-ICU=no --with-jpeglib=no --with-recommended-packages=no && \
make                                                                                                                                 && \
make install                                                                                                                         && \
cd /tmp                                                                                                                              && \
GIT_SSL_NO_VERIFY=true git clone https://github.com/gagolews/stringi.git                                                             && \
R CMD build stringi                                                                                                                  && \
R CMD INSTALL stringi_*.tar.gz --configure-args='--disable-icu-bundle' --preclean --no-html                                          && \
Rscript --vanilla -e 'stringi::stri_info()'                                                                                          && \
R CMD INSTALL stringi_*.tar.gz --configure-args='--disable-pkg-config' --preclean --no-html                                          && \
Rscript --vanilla -e 'stringi::stri_info()'                                                                                             \
"
