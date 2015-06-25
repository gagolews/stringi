export MAKE="make -j 8"                                                  && \
cd /tmp                                                                  && \
git clone https://github.com/Rexamine/stringi.git                        && \
R CMD build stringi                                                      && \
R CMD INSTALL stringi_*.tar.gz                                              \
   --configure-args="--disable-icu-bundle" --no-html                     && \
R CMD check stringi_*.tar.gz                                             && \
Rscript --vanilla -e "install.packages(c('stringr', 'testthat'),            \
   repos='http://cran.rstudio.com/', quiet=TRUE)"                        && \
cd stringi                                                               && \
LC_ALL="en_US.UTF-8" Rscript --vanilla -e                                   \
   "source('devel/testthat/run_package_tests.R')"
