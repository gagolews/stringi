# copy lib:
libfile <- paste0('stringi', SHLIB_EXT)
dest <- file.path(R_PACKAGE_DIR, paste0('libs', R_ARCH))
dir.create(dest, recursive=TRUE, showWarnings=FALSE)
file.copy(libfile, dest, overwrite=TRUE)

# copy icudt:
if (.Platform$endian == 'little') {
   # we're shipping stringi only with little-endian ASCII version of icudt
   icudatadir <- file.path(R_PACKAGE_DIR, paste0('libs'))
   file.copy('data/icudt52l.dat', icudatadir, overwrite=TRUE)
}

# not used:
# if(file.exists("symbols.rds"))
#     file.copy("symbols.rds", dest, overwrite = TRUE)
