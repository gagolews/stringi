Example Use Case: Data Preparation
==================================


> This tutorial is based on the [paper on *stringi*](https://stringi.gagolewski.com/_static/vignette/stringi.pdf) that will appear in the *Journal of Statistical Software*.

What follows is a short case study where we prepare a
web-scraped data set for further processing.

Assume we wish to gather and analyse climate data for major cities
around the world based on information downloaded from Wikipedia. For
each location from a given list of settlements (e.g., fetched from one
of the pages linked under
<https://en.wikipedia.org/wiki/Lists_of_cities>), we would like to
harvest the relevant temperature and precipitation data. Without harm in
generality, let us focus on the city of Melbourne, VIC, Australia.

The parsing of the city's Wikipedia page can be done by means of the
functions from the [*xml2*](https://CRAN.R-project.org/package=xml2)
and [*rvest*](https://CRAN.R-project.org/package=rvest) packages.


```r
library("xml2")
library("rvest")
```

First, let us load and parse the HTML file downloaded on 2020-09-17
(see <https://github.com/gagolews/stringi/tree/master/docs/_static/vignette>):


```r
f <- read_html("20200917_wikipedia_melbourne.html")
```

Second, we extract all `table` elements and gather them in a list of
HTML nodes, `all_tables`. We then extract the underlying raw text data
and store them in a character vector named `text_tables`.


```r
all_tables <- html_nodes(f, "table")
text_tables <- sapply(all_tables, html_text)
str(text_tables, nchar.max=65, vec.len=5, strict.width="wrap") # preview
## chr [1:45] "MelbourneVictoriaFrom top, left to right: Flinde"| __truncated__
##    "Mean max temp\n Mean min temp\n Annual rainfal"| __truncated__ "This
##    section needs additional citations for veri"| __truncated__ "Climate data
##    for Melbourne Regional Office (1991"| __truncated__ "Country of Birth
##    (2016)[178]Birthplace[N 1]\nPop"| __truncated__ ...
```

Most Wikipedia pages related to particular cities include a table
labelled as "Climate data". We need to pinpoint it amongst all the other
tables. For this, we will rely on *stringi*'s `stri_detect_fixed()`
function that, in the configuration below, is used to extract the index
of the relevant table.


```r
library("stringi")
(idx <- which(stri_detect_fixed(text_tables, "climate data",
  case_insensitive=TRUE, max_count=1)))
## [1] 4
```

Let's use *rvest*'s `html_table()` to convert the above table
to a data frame object.


```r
(x <- as.data.frame(html_table(all_tables[[idx]], fill=TRUE)))
```


```
##    Climate data for Melbourne Regional Office (1991–2015)
## 1                                                   Month
## 2                                     Record high °C (°F)
## 3                                    Average high °C (°F)
## 4                                      Daily mean °C (°F)
## 5                                     Average low °C (°F)
## 6                                      Record low °C (°F)
## 7                            Average rainfall mm (inches)
## 8                              Average rainy days (≥ 1mm)
## 9                 Average afternoon relative humidity (%)
## 10                            Mean monthly sunshine hours
## 11             Source: Bureau of Meteorology.[85][86][87]
##    Climate data for Melbourne Regional Office (1991–2015).1 ...
## 1                                                       Jan ...
## 2                                               45.6(114.1) ...
## 3                                                27.0(80.6) ...
## 4                                                21.6(70.9) ...
## 5                                                16.1(61.0) ...
## 6                                                 5.5(41.9) ...
## 7                                                44.2(1.74) ...
## 8                                                       5.6 ...
## 9                                                        47 ...
## 10                                                      279 ...
## 11               Source: Bureau of Meteorology.[85][86][87] ...
##    Climate data for Melbourne Regional Office (1991–2015).3
## 1                                                      Year
## 2                                               46.4(115.5)
## 3                                                20.8(69.4)
## 4                                                16.2(61.2)
## 5                                                11.6(52.9)
## 6                                                −2.8(27.0)
## 7                                              600.9(23.66)
## 8                                                      90.6
## 9                                                        51
## 10                                                    2,191
## 11               Source: Bureau of Meteorology.[85][86][87]
```

It is evident that this object requires some significant cleansing and
transforming before it can be subject to any statistical analyses.
First, for the sake of convenience, let us convert it to a character
matrix so that the processing of all the cells can be vectorised (a
matrix in R is just a single "long" vector, whereas a data frame is a
list of many atomic vectors).


```r
x <- as.matrix(x)
```

The `as.numeric()` function will find the parsing of the Unicode MINUS
SIGN (U+2212, "−") difficult, therefore let us call the transliterator
first in order to replace it (and other potentially problematic
characters) with its simpler equivalent:


```r
x[, ] <- stri_trans_general(x, "Publishing-Any; Any-ASCII")
```

Note that it is the first row of the matrix that defines the column
names. Moreover, the last row just gives the data source and hence may
be removed.


```r
dimnames(x) <- list(x[, 1], x[1, ])  # row, column names
x <- x[2:(nrow(x) - 1), 2:ncol(x)]   # skip 1st/last row and 1st column
x[, c(1, ncol(x))]                   # example columns
##                                         Jan           Year          
## Record high °C (°F)                     "45.6(114.1)" "46.4(115.5)" 
## Average high °C (°F)                    "27.0(80.6)"  "20.8(69.4)"  
## Daily mean °C (°F)                      "21.6(70.9)"  "16.2(61.2)"  
## Average low °C (°F)                     "16.1(61.0)"  "11.6(52.9)"  
## Record low °C (°F)                      "5.5(41.9)"   "-2.8(27.0)"  
## Average rainfall mm (inches)            "44.2(1.74)"  "600.9(23.66)"
## Average rainy days (>= 1mm)             "5.6"         "90.6"        
## Average afternoon relative humidity (%) "47"          "51"          
## Mean monthly sunshine hours             "279"         "2,191"
```

Commas that are used as thousands separators (commas surrounded by
digits) should be dropped:


```r
x[, ] <- stri_replace_all_regex(x, "(?<=\\d),(?=\\d)", "")
```

The numbers and alternative units in parentheses are redundant,
therefore these should be taken care of as well:


```r
x[, ] <- stri_replace_all_regex(x,
  "(\\d+(?:\\.\\d+)?)\\(\\d+(?:\\.\\d+)?\\)", "$1")
dimnames(x)[[1]] <- stri_replace_all_fixed(dimnames(x)[[1]],
  c(" (°F)", " (inches)"), c("", ""), vectorise_all=FALSE)
```

At last, `as.numeric()` can be used to re-interpret all the strings as
numbers:


```r
x <- structure(as.numeric(x), dim=dim(x), dimnames=dimnames(x))
x[, c(1, 6, ncol(x))]  # example columns
##                                           Jan   Jun   Year
## Record high °C                           45.6  22.4   46.4
## Average high °C                          27.0  15.1   20.8
## Daily mean °C                            21.6  11.7   16.2
## Average low °C                           16.1   8.2   11.6
## Record low °C                             5.5  -2.2   -2.8
## Average rainfall mm                      44.2  49.5  600.9
## Average rainy days (>= 1mm)               5.6   8.6   90.6
## Average afternoon relative humidity (%)  47.0  61.0   51.0
## Mean monthly sunshine hours             279.0 108.0 2191.0
```

We now have a cleansed matrix at our disposal. We can, for instance,
compute the monthly temperature ranges:


```r
x["Record high °C", -ncol(x)] - x["Record low °C", -ncol(x)]
##  Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec 
## 40.1 41.9 38.9 33.4 29.8 24.6 26.1 28.6 31.9 36.8 38.4 39.3
```

or the average daily precipitation:


```r
sum(x["Average rainfall mm", -ncol(x)]) / 365.25
## [1] 1.6463
```

and so forth.

For the climate data on other cities, very similar operations will need
to be performed -- the whole process of scraping and cleansing data can
be automated quite easily.

