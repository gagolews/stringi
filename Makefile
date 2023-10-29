# Copyright (c) 2013-2023, Marek Gagolewski <https://www.gagolewski.com/>

.PHONY:  r check build clean purge html docs test

.NOTPARALLEL: r check build clean purge html docs test

PKGNAME="stringi"

all: r

################################################################################

stop-on-utf8:
	# Stop if some files are not in ASCII:
	[ -z "`file -i DESCRIPTION configure configure.win \
	        NAMESPACE cleanup R/* src/* man/* inst/* tools/* | \
	    grep 'text/' | grep -v 'us-ascii' | tee /dev/stderr`" ]

autoconf:
	autoconf
	Rscript -e "\
	    source('.devel/roxygen2-patch.R');\
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

r-icu-bundle55:
	R CMD INSTALL . --configure-args='--disable-cxx11 --disable-pkg-config'

tinytest:
	Rscript -e 'source(".devel/tinytest.R")'

test: r tinytest
	# test (do not merge with tinytest - allows r-icu-system etc.)

build: autoconf
	cd .. && R CMD build ${PKGNAME}

check: stop-on-utf8 build
	cd .. && STRINGI_DISABLE_PKG_CONFIG=1 \
	    R_DEFAULT_INTERNET_TIMEOUT=240 \
	    _R_CHECK_CRAN_INCOMING_=FALSE \
	    _R_CHECK_CRAN_INCOMING_REMOTE_=FALSE \
	    R CMD check `ls -t ${PKGNAME}*.tar.gz | head -1` --as-cran --no-manual

check-revdep: r
	# remotes::install_github("r-lib/revdepcheck")
	# TODO rm -rf revdep/
	Rscript -e 'revdepcheck::revdep_check(num_workers=4, bioc=FALSE)'
	Rscript -e 'revdepcheck::revdep_report()'
	# TODO export revdep/*.md

check-rchk: build
	# https://github.com/kalibera/rchk
	cd .. && docker run -v `pwd`:/rchk/packages kalibera/rchk:latest \
	    /rchk/packages/`ls -t ${PKGNAME}*.tar.gz | head -1` | \
	    grep -v 'unsupported form of unprotect'


################################################################################

rd2myst:
	# https://github.com/gagolews/Rd2rst
	cd .devel/sphinx && Rscript -e "Rd2rst::Rd2myst('${PKGNAME}')"

weave-examples:
	cd .devel/sphinx/rapi && Rscript -e "Rd2rst::weave_examples('${PKGNAME}', '.')"

weave:
	cd .devel/sphinx/weave && make && cd ../../../

news:
	cd .devel/sphinx && cp ../../NEWS news.md
	cd .devel/sphinx && cp ../../INSTALL install.md

html: stop-on-utf8 r weave rd2myst news weave-examples
	rm -rf .devel/sphinx/_build/
	cd .devel/sphinx && make html
	.devel/sphinx/fix-html.sh .devel/sphinx/_build/html/rapi/
	.devel/sphinx/fix-html.sh .devel/sphinx/_build/html/weave/
	rm -rf .devel/sphinx/_build/html/_sources
	@echo "*** Browse the generated documentation at"\
	    "file://`pwd`/.devel/sphinx/_build/html/index.html"

docs: html
	@echo "*** Making 'docs' is only recommended when publishing an"\
	    "official release, because it updates the package homepage."
	@echo "*** Therefore, we check if the package version is like 1.2.3"\
	    "and not 1.2.2.9007."
	#Rscript --vanilla -e "stopifnot(length(unclass(packageVersion('${PKGNAME}'))[[1]]) < 4)"
	rm -rf docs/
	mkdir docs/
	cp -rf .devel/sphinx/_build/html/* docs/
	cp .devel/CNAME.tpl docs/CNAME
	touch docs/.nojekyll
	touch .nojekyll


################################################################################

clean:
	rm -f src/*.o src/*.so  # will not remove src/icuXY/*/*.o
	rm -f src/Makevars src/uconfig_local.h \
	    src/install.libs.R config.log config.status src/symbols.rds
	rm -rf .devel/sphinx/_build/
	rm -rf .devel/sphinx/rapi/
	rm -rf revdep/

purge: clean
	find src -name '*.o' -exec rm {} \;
	find src -name '*.so' -exec rm {} \;
	rm -fr autom4te.cache
	#rm -f man/*.Rd
	#rm -rf docs/
