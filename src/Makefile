.PHONY: all

all: stringi.cpp prepare_arg.cpp ICU_settings.cpp trim.cpp \
      casefold.cpp dup.cpp join.cpp \
      unicode_normalization.cpp compare.cpp
	R CMD SHLIB \
      stringi.cpp \
      common.cpp \
      prepare_arg.cpp \
      ICU_settings.cpp \
      trim.cpp \
      casefold.cpp \
      dup.cpp \
      join.cpp \
      compare.cpp \
      unicode_normalization.cpp \
      ucnv.cpp \
      uloc.cpp \
      length.cpp \
		split.cpp \
		wrap.cpp \
      -O2 -licuuc -licudata -licui18n -licuio -licule -liculx \
      -I/usr/local/include \
      -L/usr/local/lib
