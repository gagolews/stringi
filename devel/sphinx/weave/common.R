library("knitr")
opts_chunk$set(
#  fig.height=3.5,
#  fig.width=6,
#  dev=c("CairoPDF", "CairoSVG"),
#  out.width=NULL,
#  dpi=300,
#  dev.args=list(pointsize=11),
#  fig.show="hold",
#  fig.lp='fig:',
    tidy=FALSE,
    error=FALSE,
    autodep=TRUE,
    cache=TRUE
)

library("stringi")
stri_locale_set("en_AU")
library("stringr")
set.seed(123)

options(width=77)
options(useFancyQuotes=FALSE)
options(encoding="UTF-8")
options(digits=5)
options(max.print=99)
options(scipen=10)
options(showWarnCalls=FALSE)
#options(stringsAsFactors=FALSE) # default in R 4.0

cat("\n> This tutorial is based on the [paper on *stringi*](https://dx.doi.org/10.18637/jss.v103.i02) that has recently been published the *Journal of Statistical Software*, see {cite}`stringi`.\n\n")
