# Copyright (c) 2013-2021, Marek Gagolewski <https://www.gagolewski.com>

FILES_RMD = \
	example.Rmd \
	design_principles.Rmd \
	basic_operations.Rmd \
	codepoint_comparing.Rmd \
	regular_expressions.Rmd \
	collation.Rmd \
	other_operations.Rmd \
	input_output.Rmd


RMD_MD_OUTPUTS=$(patsubst %.Rmd,%.md,$(FILES_RMD))
#RMD_RST_OUTPUTS=$(patsubst %.Rmd,%.rst,$(FILES_RMD))


%.md: %.Rmd
	Rscript -e 'knitr::knit("$<", "$@")'

all : rmd

rmd : $(RMD_MD_OUTPUTS)
