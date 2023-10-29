# Copyright (c) 2013-2023, Marek Gagolewski <https://www.gagolewski.com/>

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

%.md: %.Rmd
	./Rmd2md.sh "$<"

all : rmd

rmd : $(RMD_MD_OUTPUTS)

clean:
	rm -f $(RMD_MD_OUTPUTS)
	rm -rf cache
