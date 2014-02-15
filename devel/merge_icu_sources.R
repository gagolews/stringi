type <- c("common", "i18n")[2]
indir <- "~/Desktop/"
outdir <- "~/Projekty/stringi/src/"
ext <- c(".c", ".cpp")[2]
prefix <- "icu52_"

outfile <- paste0(outdir, prefix, type, ext)
files <- dir(path=paste0(indir, type), pattern=glob2rx(paste0("*", ext)),
   full.names=TRUE)

for (f in files)
   file.copy(f, paste0(outdir, prefix, type, "_", basename(f)))

# outf <- file(outfile, "w")
# for (f in files) {
#    cat(paste0("\n\n/* ", basename(f), "*/\n\n"), file=outf)
#    writeLines(readLines(f), outf)
#    cat(f, "\n")
# }
# close(outf)
