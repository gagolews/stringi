# (C) 2020 Marek Gagolewski, https://www.gagolewski.com

#VPATH="/home/gagolews/R/stringi"


.PHONY:  r r-check r-build clean sphinx weave

all: r

#CPPFLAGS="-fopenmp -march=native -mtune=native"
#LDFLAGS="-fopenmp"

r:
	Rscript -e 'roxygen2::roxygenise(roclets=c("rd", "collate", "namespace", "vignette"), load_code=roxygen2::load_installed)'
	R CMD INSTALL . --configure-args='--disable-pkg-config' --html

r-check: r
	Rscript -e 'devtools::check()'

r-test: r
	Rscript -e 'options(width=120); source("devel/testthat/run_package_tests.R")'


r-build:
	#Rscript -e 'Rcpp::compileAttributes()'
	Rscript -e 'roxygen2::roxygenise(roclets=c("rd", "collate", "namespace", "vignette"))'
	R CMD INSTALL . --preclean
	R CMD build .

weave:
	cd devel/sphinx/weave && make && cd ../../../

rd2rst:
	cd devel/sphinx && ./Rd2rst.R stringi && cd ../../

sphinx: r weave rd2rst
	rm -rf devel/sphinx/_build/
	cd devel/sphinx && make html && cd ../../
	rm -rf docs/
	mkdir docs/
	cp -rf devel/sphinx/_build/html/* docs/
	cp devel/CNAME.tpl docs/CNAME
	touch docs/.nojekyll

clean:
	rm -f src/*.o src/*.so
