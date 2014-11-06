VALGRIND memleak check:

```
R -d "valgrind --tool=memcheck --leak-check=full"
source("devel/testthat/run_package_tests.R")
q()
n

```



Latest R-devel check --as-cran:

```
wget ftp://ftp.stat.math.ethz.ch/Software/R/R-devel.tar.bz2
tar -jxvf R-devel.tar.bz2
# ...
# -fsanitize=address
# MAIN_LDFLAGS="-fsanitize=address" \
CC="clang -std=gnu99" \  
CXX="clang++ -std=gnu++98" \
CFLAGS="-fno-omit-frame-pointer -O2 -Wall -pedantic -mtune=native" \
MAIN_CFLAGS="-fno-omit-frame-pointer -O2 -Wall -pedantic -mtune=native" \
./configure  --enable-memory-profiling \
--enable-R-profiling --prefix='/opt/R-devel-clang/' 
make
make install
# ...
```


Run tests:

```
/opt/R-devel-clang/bin/R CMD INSTALL  /home/gagolews/Projekty/stringi_0.3-1.tar.gz 
/opt/R-devel-clang/bin/R
setwd("/home/gagolews/Projekty/stringi")
source("devel/testthat/run_package_tests.R")

/opt/R-devel-clang/bin/R CMD INSTALL  /home/gagolews/Projekty/stringi_0.3-1.tar.gz  --configure-args="--disable-pkg-config"
LC_ALL="pl_PL.iso-8859-2" /opt/R-devel-clang/bin/R
setwd("/home/gagolews/Projekty/stringi")
source("devel/testthat/run_package_tests.R")
```


Run check:

```
/opt/R-devel-clang/bin/R CMD check --as-cran --run-donttest  /home/gagolews/Projekty/stringi_0.3-1.tar.gz 
```



ASAN/UBSAN [TODO: is that working???]

```
#/opt/R-devel-clang/bin/R CMD INSTALL --configure-args="--disable-pkg-config --with-extra-cppflags=\"-fsanitize=undefined-trap,unsigned-integer-overflow  -Wall -pedantic -fsanitize-undefined-trap-on-error\" --with-extra-ldflags=\"-lasan\"" /home/gagolews/Projekty/stringi_0.3-1.tar.gz
ASAN_OPTIONS="detect_leaks=1" /opt/R-devel-clang/bin/R
setwd('/home/gagolews/Projekty/stringi')
source('devel/testthat/run_package_tests.R')

# ...
R CMD INSTALL --configure-args="--with-extra-cppflags=\"-fsanitize=address  -Wall -pedantic -fno-omit-frame-pointer\" --with-extra-ldflags=\"-fsanitize=address -fno-omit-frame-pointer -lasan\"" /home/gagolews/Projekty/stringi_0.3-1.tar.gz

ASAN_OPTIONS="detect_leaks=1" R
setwd('/home/gagolews/Projekty/stringi')
source('devel/testthat/run_package_tests.R')
```
