if (!file.exists('devel/benchmarks/test1.csv.gz')) {
   # don't change the URL!
   download.file('http://cran-logs.rstudio.com/2014/2014-03-18.csv.gz',
      'devel/benchmarks/test1.csv.gz')
}

f <- gzfile('devel/benchmarks/test1.csv.gz')
data <- enc2native(readLines(f, encoding="ASCII"))
close(f)

require('stringi')
require('stringr')


system.time(stri_match_first_regex(data,
   '^\\"(.*)\\",\\"(.*)\\",(.*),\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",(.*)$')[,-1])

# Perl regexps not supported by regexec
system.time(str_match(data,
   '^\\"(.*)\\",\\"(.*)\\",(.*),\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",\\"(.*)\\",(.*)$')[,-1])



system.time(stri_match_first_regex(data,
   '^\\"(.*?)\\",\\"(.*?)\\",(.*?),\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",(.*?)$')[,-1])

system.time(str_match(data,
   '^\\"(.*?)\\",\\"(.*?)\\",(.*?),\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",(.*?)$')[,-1])



system.time(stri_detect_regex(data,
   '^\\"(.*?)\\",\\"(.*?)\\",(.*?),\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",\\"stringi\\",\\"(.*?)\\",\\"(.*?)\\",(.*?)$'))

system.time(str_detect(data,
   '^\\"(.*?)\\",\\"(.*?)\\",(.*?),\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",\\"stringi\\",\\"(.*?)\\",\\"(.*?)\\",(.*?)$'))

system.time(str_detect(data,
   perl('^\\"(.*?)\\",\\"(.*?)\\",(.*?),\\"(.*?)\\",\\"(.*?)\\",\\"(.*?)\\",\\"stringi\\",\\"(.*?)\\",\\"(.*?)\\",(.*?)$')))


system.time(stri_sort(data))
system.time(sort(data))

# # This is already being benchmarked in benchmark-search1.R
#
# system.time(stri_detect_regex(data, ',\\"stringi\\",'))
#
# system.time(stri_detect_fixed(data, ',\\"stringi\\",'))
#
# system.time(stri_detect_fixed(data, ',\\"stringi\\",', opts=NA))
#
# system.time(str_detect(data, ',\\"stringi\\",'))
#
# system.time(str_detect(data, perl(',\\"stringi\\",')))
#
# system.time(str_detect(data, fixed(',\\"stringi\\",')))
#
# system.time(grepl(',\\"stringi\\",', data))
#
# system.time(grepl(',\\"stringi\\",', data, perl=TRUE))
#
# system.time(grepl(',\\"stringi\\",', data, fixed=TRUE))
