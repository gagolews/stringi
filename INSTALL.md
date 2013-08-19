# **stringi** Package Installation & Building Info


## Obtaining `ICU4C`

### Windows 

#### Using precompiled version of **stringi** (default)

The pre-compiled version of the `ICU4C` library will be downloaded 
from our servers automatically on the first call to `library()`/`require()`.

#### Compiling **stringi** with our precompiled version of ICU4C

If you're an advanced `R` user, you may wish to
use the [`Rtools`](http://cran.r-project.org/bin/windows/Rtools/)
chain to compile `stringi` on your own.

In such case, download and decompress
[our pre-compiled binary distribution of `ICU4C'](http://static.rexamine.com/packages/windows/icu4c_51_2-mingw-distrib-devel.zip),
e.g. to `c:\icu-distrib`.

Set up the environmental variable `ICU_PATH` so that it points
to the above-mentioned directory. Otherwise, the compilation process
will fail.

Moreover, the `PATH` variable must point to the `lib` subdirectory,
e.g. `c:\icu-distrib\lib`.
This folder contains DLLs needed to work with `stringi`.
If this is not set, `stringi` will have to download the necessary
libraries from our server.



#### Compiling `ICU4C` yourself

If you're a true geek, you may wish to set up everything on your own.
Below you'll find a description on how we created 
[our pre-compiled binary distribution of `ICU4C'](http://static.rexamine.com/packages/windows/icu4c_51_2-mingw-distrib-devel.zip).

Tools needed:
[Rtools](http://cran.r-project.org/bin/windows/Rtools/) (includes `MinGW64`),
[MSYS](http://www.mingw.org/wiki/MSYS) (the `gcc` compiler is located
in sth like `C:/Rtools/gcc-4.6.3`)

To build a 32bit version of `ICU4C`:

```
# run MSYS
cd /c/icu/source # path to decompressed ICU sources
CFLAGS="-DU_HAVE_LIB_SUFFIX=1 -DU_LIB_SUFFIX_C_NAME=__i386_" \
   CPPFLAGS="-DU_HAVE_LIB_SUFFIX=1 -DU_LIB_SUFFIX_C_NAME=__i386_" \
   CXXFLAGS="-DU_HAVE_LIB_SUFFIX=1 -DU_LIB_SUFFIX_C_NAME=__i386_" \
   ./runConfigureICU MinGW --with-library-suffix=_i386_ --prefix=/c/icu-distrib-i386 \
   --with-library-bits=32 --disable-samples  --disable-tests --disable-layout
make clean # in case you run build previously
make
make install
```


To build a 64bit version of `ICU4C`:

```
make clean # clean after 32bit build
CFLAGS="-DU_HAVE_LIB_SUFFIX=1 -DU_LIB_SUFFIX_C_NAME=__x64_" \
   CPPFLAGS="-DU_HAVE_LIB_SUFFIX=1 -DU_LIB_SUFFIX_C_NAME=__x64_" \
   CXXFLAGS="-DU_HAVE_LIB_SUFFIX=1 -DU_LIB_SUFFIX_C_NAME=__x64_" \
   ./runConfigureICU MinGW --with-library-suffix=_x64_ --prefix=/c/icu-distrib-x64 \
   --with-library-bits=64 --disable-samples  --disable-tests --disable-layout
make
make install
```

Create minimal install of `ICU4C`:

```
mkdir /c/icu-distrib # your favorite dir
cp -R /c/icu-distrib-i386/include /c/icu-distrib
mkdir /c/icu-distrib/lib
cp /c/icu-distrib-i386/lib/*51.dll /c/icu-distrib/lib
cp /c/icu-distrib-x64/lib/*51.dll /c/icu-distrib/lib
cp /c/icu-distrib-i386/lib/*.lib /c/icu-distrib/lib
cp /c/icu-distrib-x64/lib/*.lib /c/icu-distrib/lib
cd /c/icu-distrib/lib
for f in *.lib; do mv $f `echo $f | sed -r "s/(.*)\.lib/\151.lib/"`; done
```

Set the environmental variable `ICU_PATH` to point
to the directory with your pre-compiled
`ICU4C ` distribution, e.g. `c:\icu-distrib`.
Moreover, the `PATH` variable must point at `c:\icu-distrib\lib`,
i.e. the directory containing the compiled DLLs.


### GNU/Linux, Unix, MacOSX

[ICU4C](http://site.icu-project.org/download) version >= 4.8
is required to build and use the package (however, the latest
version is recommended).
To test whether `ICU4C` is properly prepared to build
its derivatives, run:

```
icu-config --version
```

This should give you the ICU version that is in use.

#### Fedora/RedHat Linux

You may try with `yum install libicu-devel`.
Note that this may provide you with an outdated version of the ICU library.
You may try fetching the package from `updates` archive.

#### Ubuntu

TO DO

#### Compiling ICU4C yourself (general)

```
cd /tmp
wget http://download.icu-project.org/files/icu4c/51.2/icu4c-51_2-src.tgz
tar -zxvf icu4c-51_2-src.tgz
cd icu/source/
./runConfigureICU <yourplatform>      # see ./runConfigureICU --help
make
sudo make install     # as root
```


#### Solaris

```
./runConfigureICU Solaris # or SolarisX86; compile with CC/cc
```

or

```
./runConfigureICU Solaris/GCC # compile with CC/cc
```

You should use the same compiler which was used to build
`R` and which `R` uses to build R packages.

#### MacOSX

You may check out the binary distribution
[here](http://download.icu-project.org/files/icu4c/51.2/icu4c-51_2-MacOSX64_GCC.tgz)
or compile yourself with `gcc`, see above (in Linux)

[NOT TESTED YET]

or

```
./runConfigureICU MacOSX # Use the GNU gcc/g++ compilers on MacOS X (Darwin)
```

## Fetching a Development Version of **stringi** from GitHub

```
cd /tmp
wget https://github.com/Rexamine/stringi/archive/master.zip
unzip master.zip
mv stringi-master stringi
cd stringi
```

Please note that the man pages are not included in our GitHub archive
(they are, however, [available online](http://stringi.rexamine.com/)).
You may generate them automatically with the `roxygen2` package.
To do that, call:

```
roxygenize('.', roclets=c('rd', 'collate', 'namespace'))
```

To build & install:

```
cd ..
R CMD build stringi
R CMD INSTALL --no-multiarch --html --byte-compile  stringi_VERSION.tar.gz
```
