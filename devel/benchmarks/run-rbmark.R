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
bm_digest      <- stri_sub(digest(bm_unamen%+%bm_Rversion%+%bm_platform%+%
      bm_locale%+%bm_cxx%+%bm_cxxflags, "sha256"), 1, 8)
bm_indir       <- 'devel/benchmarks'
bm_outdir      <- file.path(bm_indir, 'results-rbmark_'%+%bm_digest)

cat("# platform="%+%bm_platform%+%"\n")
cat("# Rversion="%+%bm_Rversion%+%"\n")
cat("# Rexec="%+%bm_Rexec%+%"\n")
cat("# CXX="%+%bm_cxx%+%"\n")
cat("# CXXFLAGS="%+%bm_cxxflags%+%"\n")
cat("# LC_CTYPE="%+%bm_locale%+%"\n")
cat("# nodename="%+%bm_unamen%+%"\n")
cat("# platform_digest="%+%bm_digest%+%"\n")
cat("# git_sha="%+%bm_git_sha%+%"\n")
cat("# curdate="%+%bm_curdate%+%"\n")

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

bmarks <- dir(bm_indir, glob2rx('rbmark-'%+%benchmarks_wildcard%+%'.R'))
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

      outfile <- file.path(bm_outdir, benchmark%+%".csv")
      if (!file.exists(outfile)) {
         f <- file(outfile, open="w")
         cat("# benchmark="%+%benchmark%+%"\n", file=f)
         cat("# description="%+%benchmark_description%+%"\n", file=f)
         cat("# platform="%+%bm_platform%+%"\n", file=f)
         cat("# Rversion="%+%bm_Rversion%+%"\n", file=f)
         cat("# Rexec="%+%bm_Rexec%+%"\n", file=f)
         cat("# CXX="%+%bm_cxx%+%"\n", file=f)
         cat("# CXXFLAGS="%+%bm_cxxflags%+%"\n", file=f)
         cat("# LC_CTYPE="%+%bm_locale%+%"\n", file=f)
         cat("# nodename="%+%bm_unamen%+%"\n", file=f)
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
