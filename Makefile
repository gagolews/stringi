# Copyright (c) 2013-2021, Marek Gagolewski <https://www.gagolewski.com>



.PHONY:  r check build clean purge sphinx test

PKGNAME="stringi"

all: r

autoconf:
	autoconf
	Rscript -e 'roxygen2::roxygenise(roclets=c("rd", "collate", "namespace", "vignette"), load_code=roxygen2::load_installed)'

r: autoconf
	R CMD INSTALL . --configure-args='--disable-pkg-config --enable-gcc-debug --enable-gcc-pedantic' --html

r-icu-system:
	R CMD INSTALL .

r-icu-bundle:
	R CMD INSTALL . --configure-args='--disable-pkg-config'

tinytest:
	Rscript -e 'source("devel/tinytest.R")'

test: r tinytest

# install:
# 	cd .. && R CMD INSTALL ${PKGNAME} --preclean --html
# 	make clean

build:
	cd .. && R CMD build ${PKGNAME}

check: build
	cd .. && R CMD check `ls -t ${PKGNAME}*.tar.gz | head -1` --no-manual

check-cran: build
	cd .. && STRINGI_DISABLE_PKG_CONFIG=1 R CMD check `ls -t ${PKGNAME}*.tar.gz | head -1` --as-cran

weave:
	cd devel/sphinx/weave && make && cd ../../../

rd2rst:
	# https://github.com/gagolews/Rd2rst
	# TODO: if need be, you can also use MyST in the future
	cd devel/sphinx && Rscript -e "Rd2rst::Rd2rst('${PKGNAME}')" && cd ../../

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
	rm -f src/*.o src/*.so  # will not remove src/icuXY/*/*.o
	rm -f src/Makevars src/uconfig_local.h \
		src/install.libs.R config.log config.status src/symbols.rds

purge: clean
	find src -name '*.o' -exec rm {} \;
	find src -name '*.so' -exec rm {} \;
	rm -f man/*.Rd
	rm -fr autom4te.cache
