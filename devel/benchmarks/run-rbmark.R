# (r) benchmark suite
# (c) 2014, Marek Gagolewski


benchmarks_wildcard <- '*'

library('stringi')
library('stringr')
library('microbenchmark')
library('digest')

local({
## repo status version to log
bm_git_sha     <- system2('git', 'log --pretty=format:\'%h\' -n 1', stdout=TRUE)
bm_curdate     <- as.character(Sys.time())
bm_platform    <- R.version$platform
bm_Rversion    <- R.version$version.string
bm_Rexec       <- file.path(R.home("bin"), "R")
bm_cxx         <- system2(bm_Rexec, 'CMD config CXX', stdout=TRUE)
bm_cxxflags    <- system2(bm_Rexec, 'CMD config CXXFLAGS', stdout=TRUE)
bm_locale      <- Sys.getlocale("LC_CTYPE")
bm_unamen      <- system2('uname', '-n', stdout=TRUE)
bm_digest      <- stri_sub(digest(bm_unamen%s+%bm_Rversion%s+%bm_platform%s+%
      bm_locale%s+%bm_cxx%s+%bm_cxxflags, "sha256"), 1, 8)
bm_indir       <- 'devel/benchmarks'
bm_outdir      <- file.path(bm_indir, 'results-rbmark_'%s+%bm_digest)

cat("# platform="%s+%bm_platform%s+%"\n")
cat("# Rversion="%s+%bm_Rversion%s+%"\n")
cat("# Rexec="%s+%bm_Rexec%s+%"\n")
cat("# CXX="%s+%bm_cxx%s+%"\n")
cat("# CXXFLAGS="%s+%bm_cxxflags%s+%"\n")
cat("# LC_CTYPE="%s+%bm_locale%s+%"\n")
cat("# nodename="%s+%bm_unamen%s+%"\n")
cat("# platform_digest="%s+%bm_digest%s+%"\n")
cat("# git_sha="%s+%bm_git_sha%s+%"\n")
cat("# curdate="%s+%bm_curdate%s+%"\n")

# each benchmark item should return a data.frame with the following components:
# * user.self [code run, character]
# * sys.self [sec]
# * elapsed [sec]
# * user.child [sec]
# * sys.child [sec]
# * n [number of replications]

source('devel/benchmarks/rbenchmark.R', local=TRUE)

if (!file.exists(bm_outdir))
   dir.create(bm_outdir)

bmarks <- dir(bm_indir, glob2rx('rbmark-'%s+%benchmarks_wildcard%s+%'.R'))
for (b in bmarks) {
   cat('Filename:', b, '\n')
   local({
      infile <- file.path(bm_indir, b)
      source(infile, local=TRUE)
      res <- benchmark_do()
      print(res)

      benchmark <- stri_replace_last_regex(b, "\\.R$", "")
      res$benchmark <- benchmark
      res$git_sha <- bm_git_sha
      res$sys_sha <- bm_digest
      res$datetime <- bm_curdate

      outfile <- file.path(bm_outdir, benchmark%s+%".csv")
      if (!file.exists(outfile)) {
         f <- file(outfile, open="w")
         cat("# benchmark="%s+%benchmark%s+%"\n", file=f)
         cat("# description="%s+%benchmark_description%s+%"\n", file=f)
         cat("# platform="%s+%bm_platform%s+%"\n", file=f)
         cat("# Rversion="%s+%bm_Rversion%s+%"\n", file=f)
         cat("# Rexec="%s+%bm_Rexec%s+%"\n", file=f)
         cat("# CXX="%s+%bm_cxx%s+%"\n", file=f)
         cat("# CXXFLAGS="%s+%bm_cxxflags%s+%"\n", file=f)
         cat("# LC_CTYPE="%s+%bm_locale%s+%"\n", file=f)
         cat("# nodename="%s+%bm_unamen%s+%"\n", file=f)
         write.table(res, file=f, row.names=FALSE, sep=",", dec=".", qmethod="double")
         close(f)
      }
      else {
         f <- file(outfile, open="a")
         write.table(res, file=f, row.names=FALSE, col.names=FALSE, sep=",", dec=".", qmethod="double")
         close(f)
      }
   })
}

}) # local
