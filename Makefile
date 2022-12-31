# Copyright (c) 2013-2023, Marek Gagolewski <https://www.gagolewski.com>

.PHONY:  r check build clean purge sphinx docs test

.NOTPARALLEL: r check build clean purge sphinx docs test

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

r-icu-bundle55:
	R CMD INSTALL . --configure-args='--disable-cxx11 --disable-pkg-config'

# reload: r
# 	# https://github.com/gagolews/home_bin
# 	if [ `whoami` = "gagolews" ]; then \
# 		jupyter-qtconsole-sender --silent "reload('${PKGNAME}')"; \
# 	fi

tinytest:
	Rscript -e 'source("devel/tinytest.R")'

test: r tinytest

stop-on-utf8:
	# Stop if some files are not in ASCII:
	[ -z "`file -i DESCRIPTION configure configure.win \
	        NAMESPACE cleanup R/* src/* man/* inst/* tools/* | \
	    grep 'text/' | grep -v 'us-ascii' | tee /dev/stderr`" ]

build: autoconf
	cd .. && R CMD build ${PKGNAME}

check: stop-on-utf8 build
	cd .. && R CMD check `ls -t ${PKGNAME}*.tar.gz | head -1` --no-manual

check-cran: stop-on-utf8 build
	cd .. && STRINGI_DISABLE_PKG_CONFIG=1 \
	    R_DEFAULT_INTERNET_TIMEOUT=240 \
	    _R_CHECK_CRAN_INCOMING_=FALSE \
	    _R_CHECK_CRAN_INCOMING_REMOTE_=FALSE \
	    R CMD check `ls -t ${PKGNAME}*.tar.gz | head -1` --as-cran

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


############## Rd2rst: https://github.com/gagolews/Rd2rst ######################

rd2myst:
	cd devel/sphinx && Rscript -e "Rd2rst::Rd2myst('${PKGNAME}')"

news:
	cd devel/sphinx && cp ../../NEWS news.md
	cd devel/sphinx && cp ../../INSTALL install.md

weave:
	cd devel/sphinx/weave && make && cd ../../../
	devel/sphinx/fix-code-blocks.sh devel/sphinx/weave

weave-examples:
	cd devel/sphinx/rapi && Rscript -e "Rd2rst::weave_examples('${PKGNAME}', '.')"
	devel/sphinx/fix-code-blocks.sh devel/sphinx/rapi

sphinx: stop-on-utf8 r rd2myst weave news weave-examples
	rm -rf devel/sphinx/_build/
	cd devel/sphinx && make html
	@echo "*** Browse the generated documentation at"\
	    "file://`pwd`/devel/sphinx/_build/html/index.html"

docs: sphinx
	@echo "*** Making 'docs' is only recommended when publishing an"\
	    "official release, because it updates the package homepage."
	@echo "*** Therefore, we check if the package version is like 1.2.3"\
	    "and not 1.2.2.9007."
	Rscript --vanilla -e "stopifnot(length(unclass(packageVersion('${PKGNAME}'))[[1]]) < 4)"
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
	rm -rf devel/sphinx/rapi/
	rm -rf revdep/

purge: clean
	find src -name '*.o' -exec rm {} \;
	find src -name '*.so' -exec rm {} \;
	rm -fr autom4te.cache
	#rm -f man/*.Rd
	#rm -rf docs/
