export MAKE="make -j 8"                                                   && \
cd /tmp                                                                   && \
GIT_SSL_NO_VERIFY=true git clone https://github.com/gagolews/stringi.git  && \
R CMD build stringi                                                       && \
R CMD INSTALL stringi_*.tar.gz                                               \
   --configure-args="--disable-icu-bundle" --no-html                      && \
Rscript --vanilla -e "install.packages(c('Rcpp', 'stringr', 'testthat'),     \
   repos='http://cran.rstudio.com/', quiet=TRUE)"                         && \
STRINGI_icudt_donwload_test="TRUE" LC_ALL="en_US.UTF-8" Rscript --vanilla -e \
   "setwd('stringi'); source('devel/testthat/run_package_tests.R')"       && \
R CMD INSTALL stringi_*.tar.gz                                               \
   --configure-args="--disable-pkg-config" --no-html                      && \
STRINGI_icudt_donwload_test="TRUE" LC_ALL="en_US.UTF-8" Rscript --vanilla -e \
   "setwd('stringi'); source('devel/testthat/run_package_tests.R')"       && \
R CMD check stringi_*.tar.gz                                                 \

# 1. --disable-icu-bundle - use the system  ICU
# 2. --disable-pkg-config - use the stringi ICU
