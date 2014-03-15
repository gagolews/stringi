# benchmark suite
# (c) 2014, Marek Gagolewski

library('stringi')
library('stringr')
library('microbenchmark')
source('devel/benchmarks/microbenchmark2.R')

local({
## repo status version to log
git_sha     <- system2('git', 'log --pretty=format:\'%h\' -n 1', stdout=TRUE)
git_curdate <- as.character(Sys.time())

# each benchmark item should return a data.frame with the following components:
# * expr [code run, character]
# * min.time [sec]
# * q1.time [sec]
# * median.time [sec]
# * q2.time [sec]
# * max.time [sec]
# * n [number of replications tested]

bmarks <- dir('devel/benchmarks', glob2rx('benchmark-*.R'))
for (b in bmarks) {
   cat('Filename:', b, '\n')
   local({
      source(file.path('devel/benchmarks', b))
      res <- do_benchmark()
      print(res)
   })
}

   
}) # local