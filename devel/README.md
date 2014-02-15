The `devel` directory contains files used in the package's development process.
Its contents will not be included in the final build distributed on CRAN.


TO DO list - Preparing `stringi` for submission

1. Remove contents of the man/ dir
2. Rebuild & reinstall the package. Documentation files in man/ will be updated
      via Roxygen2.
3. Call R CMD build --compact-vignettes
4. Call R CMD check --as-cran
5. Make sure string_*.tar.gz does not contain devel/
6. Check how the package compiles with Oracle Solaris Studio, on Win and OS X
