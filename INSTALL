# Installing *stringi*

In most cases, installing *stringi* is as simple as calling:

```r
install.packages("stringi")
```

However, due to the overwhelming complexity of the ICU4C library,
upon which *stringi* is based, and the diversity of environments
it operates on, you might still experience a few issues.
Hopefully, they can be resolved with the help of this short manual.

Below we also describe some available build process tweaks.


> To get the most out of stringi, you are strongly encouraged to rely
> on our custom ICU4C 74.1 bundle by calling:
>
> ```r
> install.packages("stringi", configure.args="--disable-pkg-config")
> ```
>
> This ensures maximum portability across all platforms
> (Windows and macOS users fetch the pre-compiled binaries
> from CRAN built precisely this way).





## ICU4C

The stringi package depends on the ICU4C >= 61 library.

ICU will be built together with stringi based on the customised
ICU4C 74.1 source bundle that is shipped with the package
if we install the package from sources and one of the following is true:

* this requirement is not met (check out <https://icu.unicode.org/download>,
    the `libicu-devel` package on Fedora/CentOS/OpenSUSE,
    `libicu-dev` on Ubuntu/Debian, etc.), or

* `pkg-config` fails to find appropriate build settings
    for ICU-based projects, or

* `R CMD INSTALL` is called with the `--configure-args='--disable-pkg-config'`
    argument, or the `STRINGI_DISABLE_PKG_CONFIG` environment variable
    is set to non-zero or
    `install.packages("stringi", configure.args="--disable-pkg-config")`
    is executed.



## Customising the Build Process

Additional features and options of the `./configure` script:

* `--disable-icu-bundle`: Enforce system ICU.

* `--disable-pkg-config`: Disable `pkg-config`;
    ICU4C will be compiled from sources.

* `--with-extra-cxxflags=FLAGS`: Additional C++ compiler flags.

* `--with-extra-cppflags=FLAGS`: Additional C++ preprocessor flags.

* `--with-extra-ldflags=FLAGS`: Additional linker flags.

* `--with-extra-libs=FLAGS`: Additional libraries to link against.



Some environment variables:

* `PKG_CONFIG_PATH`: An optional list of directories to search for
    `pkg-config`'s `.pc` files.

* `R_HOME`: Override the R directory, e.g.,
    `/usr/lib64/R`. Note that `$R_HOME/bin/R` point to the R executable.

* `CAT`: The `cat` command used to generate the list of source files to compile.

* `PKG_CONFIG`:The `pkg-config` command used to fetch the necessary compiler
    flags to link to the existing `libicu` installation.

* `STRINGI_DISABLE_PKG_CONFIG`: Compile ICU from sources;
    see also `--disable-pkg-config`.

* `STRINGI_DISABLE_ICU_BUNDLE`: Enforce system ICU;
    see also `--disable-icu-bundle`.

* `STRINGI_CXXFLAGS`: see `--with-extra-cxxflags`.

* `STRINGI_CPPFLAGS`: see `--with-extra-cppflags`.

* `STRINGI_LDFLAGS`: see `--with-extra-ldflags`.

* `STRINGI_LIBS`: see `--with-extra-libs`.




## Getting Help

If you do not manage to set up a successful build, do not
hesitate to [file a bug report](https://github.com/gagolews/stringi/issues).
However, please check the list of archived (closed) issues first --
it is quite likely that a solution to your problem has already been posted.

To help diagnose your error further, please run (from the terminal)
the following commands and submit the output from `./configure`
as well as the contents of `config.log`.

```bash
cd /tmp
wget https://github.com/gagolews/stringi/archive/master.zip
unzip master.zip
cd stringi-master
./configure
```
