#' aa
#' @useDynLib ICU
.onAttach <- function(lib, pkg)
{
# auto load by @useDynLib:
#    library.dynam("ICU", pkg, lib, verbose=TRUE)
   
# TEMP:
   print(stri_getinfo())  
}

# .onLoad <- function(lib, pkg)
# {
# 
# }

.onUnload <- function(libpath)
{
   library.dynam.unload("ICU", libpath)
}
