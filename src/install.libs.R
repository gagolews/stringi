# copy lib:
libfile <- paste0('stringi', SHLIB_EXT)
dest <- file.path(R_PACKAGE_DIR, paste0('libs', R_ARCH))
dir.create(dest, recursive=TRUE, showWarnings=FALSE)
file.copy(libfile, dest, overwrite=TRUE)

# copy icudt when building ICU from sources
copyicudt <- TRUE
if (file.exists('icu52_found.txt')) {
   copyicudt <- !as.logical(as.numeric(readChar('icu52_found.txt', 1)))
   if (is.na(copyicudt)) copyicudt <- TRUE
}

if (copyicudt) {
# Note that if the data file may not be found, some features will
# be unavailable (but the package itself will load properly,
# and UCD-independent functions will work properly)
   icudtpathL <- 'icu52/data/icudt52l.dat'
   icudtpathB <- 'icu52/data/icudt52b.dat'
   if (.Platform$endian == 'little') {
      if (file.exists(icudtpathL)) {
         icudatadir <- file.path(R_PACKAGE_DIR, paste0('libs'))
         file.copy(icudtpathL, icudatadir, overwrite=TRUE)
      }
   }
   else {
      if (file.exists(icudtpathB)) {
         icudatadir <- file.path(R_PACKAGE_DIR, paste0('libs'))
         file.copy(icudtpathB, icudatadir, overwrite=TRUE)
      }
   }
}

if (file.exists('symbols.rds'))
   file.copy('symbols.rds', dest, overwrite=TRUE)
