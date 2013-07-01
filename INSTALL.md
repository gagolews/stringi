# **stringi** Package Installation & Building Information


## Getting ICU4C

ICU4C version >= 4.8 is required to build and use the package.
To test whether ICU has been installed correctly, run:

```
icu-config --version
```

This should give you the ICU version that is in use.


### Windows 

TO DO

Make sure the environmental variable `PATH` points at
`<ICU>\bin` and `<ICU>\lib`.

### Linux, Unix

#### General

```
cd /tmp
wget http://download.icu-project.org/files/icu4c/51.2/icu4c-51_2-src.tgz
tar -zxvf icu4c-51_2-src.tgz
cd icu/source/
./runConfigureICU <yourplatform>      # see ./runConfigureICU --help
make
sudo make install     # as root
```

#### Fedora/RedHat Linux

You may try with `yum install libicu-devel`.
Note that this may provide you with an outdated version of the ICU library.
You may try fetching the package from `updates` archive.

#### Ubuntu

TO DO

### MacOSX

Otherwise, check out the binary distribution
[here](http://download.icu-project.org/files/icu4c/51.2/icu4c-51_2-MacOSX64_GCC.tgz)
or compile yourself with `gcc`, see above (in Linux)

[NOT TESTED YET]


## Getting Development Version of **stringi** from GitHub

```
cd /tmp
wget https://github.com/Rexamine/stringi/archive/master.zip
mv stringi-master stringi
cd stringi
```

Please note that the man pages are not included in our GitHub archive.
You may generate them automatically with Roxygen2. Call:

```
roxygenize('.', roclets=c('rd', 'collate', 'namespace'))
```

To build & install:

```
cd ..
R CMD build stringi
R CMD INSTALL --no-multiarch --html --byte-compile  stringi_VERSION.tar.gz
```
