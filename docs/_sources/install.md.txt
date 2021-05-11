# Installing *stringi*



## Introduction

In 99.9% of cases, *stringi* can be successfully installed by simply calling:


```r
install.packages("stringi")
```


However, due to the overwhelming complexity of the ICU4C library,
upon which *stringi* is based, and the colourful diversity of operating systems,
their flavors, and particular setups, some users may still experience
a few issues that hopefully can be resolved with the help of this short manual.

Also, some additional build tweaks are possible in case we require a more
customised installation.


## ICU4C

The stringi package depends on the ICU4C >= 55 library.


If we install the package from sources and either:

* this requirement is not met (check out http://site.icu-project.org/download,
   the `libicu-devel` rpm on Fedora/CentOS/OpenSUSE,
   `libicu-dev` on Ubuntu/Debian, etc.),

* `pkg-config` is fails to find appropriate build settings
   for ICU-based projects, or

* `R CMD INSTALL` is called with the `--configure-args='--disable-pkg-config'`
    argument or
    `install.packages("stringi", configure.args="--disable-pkg-config")`
    is executed,

then ICU will be built together with stringi.
A custom subset of ICU4C 69.1 is shipped with the package.
We also include ICU4C 55.1 that can be used as a fallback version
(e.g., on older Solaris/SPARC boxes).


> To get the most out of stringi, you are strongly encouraged to rely on our
> ICU4C package bundle. This guarantees maximum portability.



If you choose to use our ICU4C bundle, then -- by default -- the ICU data
library will be downloaded from one of our mirror servers. However, if you
have already downloaded a version of `icudt*.zip` suitable for your platform
(big/little endian), you may wish to install the package by calling:

    install.packages("stringi", configure.vars="ICUDT_DIR=<icudt_dir>")

Moreover, if you have **no internet access** on the machines
you try to install stringi on, try fetching the latest development version
of the package, as it is shipped with the `ICU` data archives.
You can build a distributable source package that includes all the required
ICU data files (for off-line use) by omitting some relevant lines in
the `.Rbuildignore` file. The following command sequence should do the trick:

    wget https://github.com/gagolews/stringi/archive/master.zip -O stringi.zip
    unzip stringi.zip
    sed -i '/\/icu..\/data/d' stringi-master/.Rbuildignore
    R CMD build stringi-master

Assuming the most recent development version of the package is numbered 1.6.1,
a file named `stringi_1.6.1.tar.gz` is created in the current working directory.
The package can now be installed (the source bundle may be propagated via
`scp` etc.) by executing:

    R CMD INSTALL stringi_1.6.1.tar.gz

or by calling `install.packages("stringi_1.6.1.tar.gz", repos=NULL)`,
from within an R session.





## C++11 Support

For R >= 3.1.0, we suggest (by default) C++11 support to build the package
from sources. This is because older releases of ICU4C use the `long long`
type in a few functions, and this is not part of the C++98 standard. Moreover,
it has become required by newer versions of ICU4C.

However, if your compiler does not support C++11 or it has not been properly
configured (check out `<R_inst_dir>/etc/Makeconf`) but you are sure it
understands the `long long` type (which is very common -- this is checked by the
`configure` script anyway), you may disable C++11 by passing
the `--disable-cxx11` argument to the `configure` script.





## Customising the Build Process


Additional features and options of the `./configure` script:

* `--disable-cxx11`: Disable C++11; if you build ICU4C from
    sources, make sure your C++ compiler supports the `long long` type.

* `--disable-icu-bundle`: Enforce system ICU.

* `--disable-pkg-config`: Disable `pkg-config`;
    ICU4C will be compiled from sources.

* `--with-extra-cflags=FLAGS`: Additional C compiler flags.

* `--with-extra-cppflags=FLAGS`: Additional C/C++ preprocessor flags.

* `--with-extra-cxxflags=FLAGS`: Additional C++ compiler flags.

* `--with-extra-ldflags=FLAGS`: Additional linker flags.

* `--with-extra-libs=FLAGS`: Additional libraries to link against.



Some influential environment variables:

* `ICUDT_DIR`: Optional directory with an already downloaded ICU data
    archive (`icudt*.zip`); either an absolute path or a
    path relative to `<package source dir>/src`; defaults to `icuXX/data`.

* `PKG_CONFIG_PATH`: An optional list of directories to search for
    `pkg-config`s `.pc` files.

* `R_HOME`: Override the R directory, e.g.,
    `/usr/lib64/R`. Note that `$R_HOME/bin/R` point to the R executable.

* `CAT`: The `cat` command used to generate the list of source files to compile.

* `PKG_CONFIG`:The `pkg-config` command used to fetch the necessary compiler
    flags to link to and existing `libicu` installation.

* `STRINGI_DISABLE_CXX11`: Disable C++11,
    see also `--disable-cxx11`.

* `STRINGI_DISABLE_PKG_CONFIG`: Compile ICU from sources,
    see also `--disable-pkg-config`.

* `STRINGI_DISABLE_ICU_BUNDLE`: Enforce system ICU,
    see also `--disable-icu-bundle`.

* `STRINGI_CFLAGS`: see `--with-extra-cflags`.

* `STRINGI_CPPFLAGS`: see `--with-extra-cppflags`.

* `STRINGI_CXXFLAGS`: see `--with-extra-cxxflags`.

* `STRINGI_LDFLAGS`: see `--with-extra-ldflags`.

* `STRINGI_LIBS`: see `--with-extra-libs`.




## Conclusion

We expect that with a correctly configured C++11 compiler and properly
installed system ICU4C distribution, you should face no problems
with installing the package, especially if you use our ICU4C bundle and you
have a working internet access.

If you do not manage to set up a successful stringi build, do not
hesitate to [file a bug report](https://github.com/gagolews/stringi/issues).
However, please check the list of archived (closed) issues first --
it is very likely that a solution to your problem has already been posted.
