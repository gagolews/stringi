The `devel` directory contains files used in the package's development process.
Its contents will not be included in the final build distributed on CRAN.


TO DO list - Preparing `stringi` for submission

1. #define NDEBUG in stringi.h
2. Remove contents of the man/dir
3. Rebuild & reinstall the package. Documentation files in man/ will be updated.
4. Call R CMD build --compact-vignettes
5. Call R CMD check --as-cran
6. Make sure string_*.tar.gz does not contain
