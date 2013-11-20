# **stringi** Package Installation & Building Info


## Obtaining `ICU4C`

The package compiles with ICU4C >= 4.8.
However, note that we have observed some issues with UREGEX_LITERAL
regex flag in ICU4C 4.8.1.
Everything is OK with ICU4C 50, 51, and 52.


### Windows 

#### Using binary version of **stringi** (default)

`ICU4C` since stringi-0.1-11 is statically linked with stringi.dll.
Everything works out of the box.

#### Compiling **stringi** with our binary version of ICU4C

If you are an advanced `R` user, you may wish to
use [`Rtools`](http://cran.r-project.org/bin/windows/Rtools/)
chain to compile `stringi` manually.

In such case, download and decompress
[our binary distribution of `ICU4C'](http://static.rexamine.com/packages/windows/icu4c_52_1-mingw-distrib-static-devel.zip),
which allows for static linking, e.g. to `c:\icu-distrib`.

Set up the environmental variable `ICU_PATH` so that it points
to the above-mentioned directory, e.g. `c:/icu-distrib` (note the slash).
Make sure this directory contains `lib/` and `include`.
Not doing so will result in compilation process failure.



#### Compiling `ICU4C` manually (for static linking)

If you're a true geek, you may wish to set up everything on your own.
Below you'll find a description on how we created 
[our binary distribution of `ICU4C'](http://static.rexamine.com/packages/windows/icu4c_52_1-mingw-distrib-static-devel.zip)
on an 64-bit Windows 8 system. This will enable static linking of ICU4C
libs.

Tools needed:
[Rtools](http://cran.r-project.org/bin/windows/Rtools/) (includes `MinGW64`),
[MSYS](http://www.mingw.org/wiki/MSYS) (the `gcc` compiler is located
in sth like `C:/Rtools/gcc-4.6.3`)

Download the source package for [ICU4C 52.1](http://site.icu-project.org/download/52).

To build a 32bit version of `ICU4C`:

```
# run MSYS
cd /c/icu/source # path to decompressed ICU sources
./runConfigureICU MinGW  --prefix=/c/icu-distrib-i386 \
   --with-library-bits=32 --disable-samples --disable-tests \
   --disable-layout --disable-shared --enable-static \
   --disable-extras --enable-icuio --with-data-packaging=static
# (ignore warnings and continue)
make clean # in case you run build previously
make
make install
```


To build a 64bit version of `ICU4C`:

```
make clean # clean after the 32bit build
./runConfigureICU MinGW  --prefix=/c/icu-distrib-x64 \
   --with-library-bits=64 --disable-samples --disable-tests \
   --disable-layout --disable-shared --enable-static \
   --disable-extras --enable-icuio --with-data-packaging=static
# (ignore warnings and continue)
make
make install
```

Create minimal install of `ICU4C`:

```
mkdir /c/icu-distrib # your favorite dir
cp -R /c/icu-distrib-i386/include /c/icu-distrib
mkdir /c/icu-distrib/lib
cd /c/icu-distrib-i386/lib/
for f in *.a; do cp $f /c/icu-distrib/lib/`echo $f | sed -r "s/(.*)\.a/\1_i386.a/"`; done
rm /c/icu-distrib/lib/libsicudt.a -f
cp sicudt.a /c/icu-distrib/lib/libsicudt_i386.a -f
cd /c/icu-distrib-x64/lib/
for f in *.a; do cp $f /c/icu-distrib/lib/`echo $f | sed -r "s/(.*)\.a/\1_x64.a/"`; done
rm /c/icu-distrib/lib/libsicudt.a -f
cp sicudt.a /c/icu-distrib/lib/libsicudt_x64.a -f
```

Set the environmental variable `ICU_PATH` to point
at the directory with your pre-compiled
`ICU4C ` distribution, e.g. `c:/icu-distrib` (note the slash).


### OS X ***TO DO***

A typical OS X user, just like the one who uses Windows,
does not possess any C++ compiler.
Note that OS X 10.X is shipped with ICU, but the lib version 
is much below our requirements.

#### Using binary version of **stringi** (default)

`ICU4C` WILL BE statically linked with stringi.dylib.
Everything works out of the box.

#### Compiling **stringi** with our binary version of ICU4C ***TO DO***

If you are an advanced `R` user, you may wish to
use [`Xcode`](http://www.cyberciti.biz/faq/howto-apple-mac-os-x-install-gcc-compiler/) 
with the `GCC` compiler.

`xcode-select --install`

In such case, download and decompress
[our binary distribution of `ICU4C'](http://static.rexamine.com/packages/osx/TO_BE_DONE),
which allows for static linking, e.g. to `TO DO`.


#### Compiling `ICU4C` manually (for static linking) ***TO DO***


```
TO DO
...download...
...decompress...
cd....
CFLAGS="-fPIC" CXXFLAGS="-fPIC" ./runConfigureICU MacOSX \
   --prefix=../compiled \
   --enable-static --disable-shared --disable-samples \
   --disable-layout --disable-tests
...
TO DO
```


### GNU/Linux, Unix, OS X (with dynamically linked ICU4C)

Except OS X, for which prepared binary builds will be prepared,
[ICU4C](http://site.icu-project.org/download) version >= 4.8
is required to build and use the package (however, the latest
version is recommended). To test whether `ICU4C` is ready to build
its derivatives, run:

```
pkg-config --modversion icu-uc
```

This should give you the ICU version that is available to the build chain.



#### Fedora/RedHat Linux

You may try with `yum install libicu-devel`.
Note that this may sometimes give you a quite old version of the ICU library.
You may try fetching the package from `updates` archive.
Fedora 19 has currently ICU4C 50.

#### Ubuntu

You may try with `sudo apt-get install libicu-dev`.
Note that this may provide you with an outdated version of the ICU library.

#### Compiling ICU4C manually 

```
cd /tmp
wget http://download.icu-project.org/files/icu4c/52.1/icu4c-52_1-src.tgz
tar -zxvf icu4c-52_1-src.tgz
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

#### OS X


Make sure you have Xcode Tools installed.

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
R CMD INSTALL --html --byte-compile  stringi_VERSION.tar.gz
```
