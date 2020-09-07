# (C) 2020 Marek Gagolewski, https://www.gagolewski.com

#VPATH="/home/gagolews/R/stringi"


.PHONY:  r r-check r-build clean sphinx weave

all: r

#CPPFLAGS="-fopenmp -march=native -mtune=native"
#LDFLAGS="-fopenmp"

r:
	Rscript -e 'roxygen2::roxygenise(roclets=c("rd", "collate", "namespace", "vignette"), load_code=roxygen2::load_installed)'
	R CMD INSTALL . --configure-args='--disable-pkg-config --enable-gcc-debug --enable-gcc-pedantic' --html

r-check: r
	Rscript -e 'devtools::check(cran=TRUE, remote=FALSE, manual=TRUE)'
	make clean

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
	#devtools::install_github('gagolews/Rd2rst')
	cd devel/sphinx && Rscript -e "Rd2rst::Rd2rst('stringi')" && cd ../../

news:
	cd devel/sphinx && pandoc ../../NEWS -f markdown -t rst -o news.rst
	cd devel/sphinx && pandoc ../../INSTALL -f markdown -t rst -o install.rst

sphinx: r weave rd2rst news

	rm -rf devel/sphinx/_build/
	cd devel/sphinx && make html && cd ../../
	rm -rf docs/
	mkdir docs/
	cp -rf devel/sphinx/_build/html/* docs/
	cp devel/CNAME.tpl docs/CNAME
	touch docs/.nojekyll

clean:
	rm -f src/*.o src/*.so
