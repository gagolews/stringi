# copy lib:
libfile <- paste0('stringi', SHLIB_EXT)
dest <- file.path(R_PACKAGE_DIR, paste0('libs', R_ARCH))
dir.create(dest, recursive=TRUE, showWarnings=FALSE)
file.copy(libfile, dest, overwrite=TRUE)

# copy icudt on little-endian systems:
icudtpath <- 'data/icudt52l.dat'
if (.Platform$endian == 'little' && file.exists(icudtpath)) {
   # we're shipping stringi only with little-endian ASCII version of icudt
   icudatadir <- file.path(R_PACKAGE_DIR, paste0('libs'))
   file.copy(icudtpath, icudatadir, overwrite=TRUE)
}

# not used:
# if(file.exists("symbols.rds"))
#     file.copy("symbols.rds", dest, overwrite = TRUE)
