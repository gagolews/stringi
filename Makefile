# (C) 2020 Marek Gagolewski, https://www.gagolewski.com

#VPATH="/home/gagolews/R/stringi"


.PHONY:  r check build clean sphinx test

all: r

#CPPFLAGS="-fopenmp -march=native -mtune=native"
#LDFLAGS="-fopenmp"

r:
	Rscript -e 'roxygen2::roxygenise(roclets=c("rd", "collate", "namespace", "vignette"), load_code=roxygen2::load_installed)'
	R CMD INSTALL . --configure-args='--disable-pkg-config --enable-gcc-debug --enable-gcc-pedantic' --html

build: r
	#Rscript -e 'Rcpp::compileAttributes()'
	Rscript -e 'roxygen2::roxygenise(roclets=c("rd", "collate", "namespace", "vignette"))'
	cd .. && R CMD INSTALL stringi --preclean --html
	cd .. && R CMD build stringi

check: build
	#Rscript -e 'devtools::check(cran=TRUE, remote=FALSE, manual=TRUE)'   # avoid redundant dependencies
	cd .. && R CMD check `ls -t stringi*.tar.gz | head -1` --no-manual # --as-cran
	make clean

test: r
	Rscript -e 'options(width=120); source("devel/tinytest.R")'

weave:
	cd devel/sphinx/weave && make && cd ../../../

rd2rst:
	# https://github.com/gagolews/Rd2rst
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
