# Copyright (c) 2013-2021, Marek Gagolewski <https://www.gagolewski.com>


.PHONY:  r check build clean purge sphinx test

PKGNAME="stringi"

all: r

autoconf:
	autoconf
	Rscript -e "\
	    source('devel/roxygen2-patch.R');\
	    roxygenise(\
	        roclets=c('rd', 'collate', 'namespace', 'vignette'),\
	        load_code=roxygen2::load_installed\
	    )"

r: autoconf
	R CMD INSTALL . --html \
	    --configure-args="--disable-pkg-config \
	                      --enable-gcc-debug \
	                      --enable-gcc-pedantic"

r-icu-system:
	R CMD INSTALL .

r-icu-bundle:
	R CMD INSTALL . --configure-args='--disable-pkg-config'

tinytest:
	Rscript -e 'source("devel/tinytest.R")'

test: r tinytest

stop-on-utf8:
	# Stop if some files are not in ASCII:
	[ -z "`file -i DESCRIPTION configure configure.win \
	        NAMESPACE cleanup R/* src/* man/* inst/* tools/* | \
	    grep 'text/' | grep -v 'us-ascii' | tee /dev/stderr`" ]

build:
	cd .. && R CMD build ${PKGNAME}

check: stop-on-utf8 build
	cd .. && R CMD check `ls -t ${PKGNAME}*.tar.gz | head -1` --no-manual

check-cran: stop-on-utf8 build
	cd .. && STRINGI_DISABLE_PKG_CONFIG=1 \
	    R_DEFAULT_INTERNET_TIMEOUT=240 \
	    _R_CHECK_CRAN_INCOMING_REMOTE_=FALSE \
	    R CMD check `ls -t ${PKGNAME}*.tar.gz | head -1` --as-cran


############## Rd2rst: https://github.com/gagolews/Rd2rst ######################

rd2myst:
	cd devel/sphinx && Rscript -e "Rd2rst::Rd2myst('${PKGNAME}')"

news:
	cd devel/sphinx && cp ../../NEWS news.md
	cd devel/sphinx && cp ../../INSTALL install.md

weave-examples:
	cd devel/sphinx/rapi && Rscript -e "Rd2rst::weave_examples('${PKGNAME}', '.')"
	devel/sphinx/fix-code-blocks.sh devel/sphinx/rapi

sphinx: r rd2myst news weave-examples
	rm -rf devel/sphinx/_build/
	cd devel/sphinx && make html
	rm -rf docs/
	mkdir docs/
	cp -rf devel/sphinx/_build/html/* docs/
	cp devel/CNAME.tpl docs/CNAME
	touch docs/.nojekyll
	touch .nojekyll


################################################################################

clean:
	rm -f src/*.o src/*.so  # will not remove src/icuXY/*/*.o
	rm -f src/Makevars src/uconfig_local.h \
	    src/install.libs.R config.log config.status src/symbols.rds
	rm -rf devel/sphinx/_build/

purge: clean
	find src -name '*.o' -exec rm {} \;
	find src -name '*.so' -exec rm {} \;
	rm -fr autom4te.cache
	rm -f man/*.Rd
	rm -rf devel/sphinx/rapi/
	rm -rf docs/
