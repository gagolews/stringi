# copy lib:
libfile <- paste0("stringi", SHLIB_EXT)
dest <- file.path(R_PACKAGE_DIR, paste0("libs", R_ARCH))
dir.create(dest, recursive=TRUE, showWarnings=FALSE)
file.copy(libfile, dest, overwrite=TRUE)

# copy icudt when building ICU from sources
copyicudt <- TRUE
if (file.exists('icu52_found.txt')) {
   copyicudt <- !as.logical(as.numeric(readChar('icu52_found.txt', 1)))
   if (is.na(copyicudt)) copyicudt <- TRUE
}

if (copyicudt) {
   source('../R/install.R')
   outdir <- file.path(R_PACKAGE_DIR, "libs")
   if (length(dir(outdir, pattern=glob2rx("*.dat"))) == 0) {
      # avoids multiple download attempts while multiarch building
      stri_install_icudt(FALSE, outdir, "icu52/data/")
   }
# Note that if the data file is not found, some features will
# be unavailable (but the package itself will load properly,
# and UCD-independent functions will work properly)
}

# Copy symbols.rds
if (file.exists('symbols.rds'))
   file.copy('symbols.rds', dest, overwrite=TRUE)
