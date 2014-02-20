# copy lib:
libfile <- paste0('stringi', SHLIB_EXT)
dest <- file.path(R_PACKAGE_DIR, paste0('libs', R_ARCH))
dir.create(dest, recursive=TRUE, showWarnings=FALSE)
file.copy(libfile, dest, overwrite=TRUE)

# copy icudt on little-endian systems AND in case of building ICU from sources
copyicudt <- TRUE
if (file.exists('icu52_found.txt')) {
   copyicudt <- !as.logical(as.numeric(readChar('icu52_found.txt', 1)))
   if (is.na(copyicudt)) copyicudt <- TRUE
}

icudtpath <- 'icu52/data/icudt52l.dat'
if (copyicudt && .Platform$endian == 'little' && file.exists(icudtpath)) {
   # we are shipping stringi only with little-endian ASCII version of icudt
   # on big-endian it will work without it, but some features will be unavailable
   icudatadir <- file.path(R_PACKAGE_DIR, paste0('libs'))
   file.copy(icudtpath, icudatadir, overwrite=TRUE)
}

if(file.exists("symbols.rds"))
   file.copy("symbols.rds", dest, overwrite = TRUE)
