# **stringi** Package Installation & Building Information


## Getting ICU4C

ICU4C version >= 49 is required to build and use the package.
To test whether ICU has been installed correctly, run:

```
icu-config --version
```

This should give you the ICU version that is in use.


### Windows 

TO DO

Make sure the environmental variable `PATH` points at
`<ICU>\bin` and `<ICU>\lib`.

### Linux

#### Any Linux

```
cd /tmp
wget http://download.icu-project.org/files/icu4c/51.2/icu4c-51_2-src.tgz
tar -zxvf icu4c-51_2-src.tgz
....TODO: download FULL ICU data & decompress it to icu/source/data.....
cd icu/source/
./configure
make
sudo make install     # as root
```

#### Fedora/RedHat Linux

You may try with `yum install libicu-devel`.
Note that this may provide you with an outdated version of the ICU library.

#### Ubuntu

TO DO

### OS X

TO DO

### Solaris

TO DO


## Getting Development Version of **stringi** from GitHub

```
cd /tmp
git clone https://github.com/Rexamine/stringi.git
```

Please note that the man pages are not included in our GitHub archive.
You may generate them automatically with Roxygen2. Call:

```
roxygenize('.', roclets=c('rd', 'collate', 'namespace'))
```

To build & install:

```
R CMD build stringi
R CMD INSTALL --no-multiarch --html --byte-compile  stringi_VERSION.tar.gz
```
