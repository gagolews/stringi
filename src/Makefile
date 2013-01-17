## `stringi` Makefile
## Copyright 2013, M.Gagolewski, B.Tartanus, M.Bujarski



# ...t.b.d...
SRCS        =  stringi.cpp \
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
               uchar.cpp \
               length.cpp \
               locate.cpp \
               split.cpp \
               wrap.cpp

HEADERS     =  stringi.h

RM          =  rm -f

all: stringi


stringi: $(SRCS)
	R CMD SHLIB \
	$(SRCS) \
	-licuuc -licudata -licui18n -licuio -licule -liculx \
	-L/usr/local/lib \
	-I/usr/local/include


## ...t.b.d...
# R_HOME     :=  `R RHOME`
# CXX        :=  `R CMD config CXX`
# CXXFLAGS   :=  `R CMD config CXXFLAGS`
# CXXFLAGS   +=  `R CMD config CXXPICFLAGS`
# CXXFLAGS   +=  `R CMD config --cppflags`
# CXXFLAGS   +=  -I/usr/local/include
# RM         :=  rm -f
# LD         :=  `R CMD config SHLIB_LD`
# LDFLAGS    :=  `R CMD config SHLIB_LDFLAGS`
# LDFLAGS    +=  `R CMD config --ldflags`
# LDFLAGS    +=  -L/usr/local/lib
# LDFLAGS    +=  -licuuc -licudata -licui18n -licuio -licule -liculx
#
#
# SRCS        =  stringi.cpp \
#                common.cpp \
#                prepare_arg.cpp \
#                ICU_settings.cpp \
#                trim.cpp \
#                casefold.cpp \
#                dup.cpp \
#                join.cpp \
#                compare.cpp \
#                unicode_normalization.cpp \
#                ucnv.cpp \
#                uloc.cpp \
#                uchar.cpp \
#                length.cpp \
#                locate.cpp \
#                split.cpp \
#                wrap.cpp
#
# HEADERS     =  stringi.h
#
# OBJS        =  $(SRCS:.cpp=.o)
#
# SHLIB_EXT   = `R CMD config SHLIB_EXT`
#
# .PHONY: all
#
# all: stringi
#
#
# stringi: $(OBJS)
# 	$(LD) $^ $(LDFLAGS) -o stringi$(SHLIB_EXT)
#
# %.o: %.cpp $(HEADERS)
# 	$(CXX) $(CXXFLAGS) -c $< -o $@
#
# #clean:
# #	$(RM) *.o
