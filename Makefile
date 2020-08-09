# (C) 2020 Marek Gagolewski, https://www.gagolewski.com

#VPATH="/home/gagolews/Python/genieclust"


.PHONY:  r r-check r-build clean

all: r

#CPPFLAGS="-fopenmp -march=native -mtune=native"
#LDFLAGS="-fopenmp"

r:
	Rscript -e 'Rcpp::compileAttributes()'
	R CMD INSTALL .
	# AVOID ADDING THE -O0 flag!!!
	Rscript -e 'roxygen2::roxygenise(roclets=c("rd", "collate", "namespace", "vignette"), load_code=roxygen2::load_installed)'
	R CMD INSTALL .

r-check: r
	Rscript -e 'devtools::check()'

r-test: r
	Rscript -e 'options(width=120); source("devel/testthat/run_package_tests.R")'


r-build:
	Rscript -e 'Rcpp::compileAttributes()'
	Rscript -e 'roxygen2::roxygenise(roclets=c("rd", "collate", "namespace", "vignette"))'
	R CMD INSTALL . --preclean
	R CMD build .


clean:
	rm -f src/*.o src/*.so
