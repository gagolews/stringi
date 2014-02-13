# autoconf/configure script for stringi
# (C) 2013-2014 M. Gagolewski
# http://stringi.rexamine.com

##### INIT ####################################################################

AC_INIT(stringi, 0.1, gagolews@rexamine.com)

##### OPTIONS #################################################################

# shell variables/arguments accepted:
# R_HOME - R's home dir
AC_ARG_VAR(R_HOME, [Override default directory with R installation, e.g. /usr/lib64/R.
                    Note that $R_HOME/bin/R should point to R executable.])

AC_ARG_ENABLE([gcc_debug],
    AS_HELP_STRING([--enable-gcc-debug],
      [Enable -UNDEBUG when compiling stringi with gcc/g++ /for stringi developers/]))
if test "x$enable_gcc_debug" == "xyes"; then
   enable_gcc_debug="yes"
else
   enable_gcc_debug="no"
fi

AC_ARG_ENABLE([gcc_pedantic],
    AS_HELP_STRING([--enable-gcc-pedantic],
      [Enable -Wall -Wextra -ansi -pedantic when compiling stringi with gcc/g++ /for stringi developers/]))
if test "x$enable_gcc_pedantic" == "xyes"; then
   enable_gcc_pedantic="yes"
else
   enable_gcc_pedantic="no"
fi

AC_ARG_WITH([extra_cflags],
    AS_HELP_STRING([--with-extra-cflags=FLAGS],
      [Additional C compiler flags (except for those indicated by R)]))

AC_ARG_WITH([extra_cppflags],
    AS_HELP_STRING([--with-extra-cppflags=FLAGS],
      [Additional C/C++ preprocessor flags (except for those indicated by R)]))

AC_ARG_WITH([extra_cxxflags],
    AS_HELP_STRING([--with-extra-cxxflags=FLAGS],
      [Additional C++ compiler flags (except for those indicated by R)]))

AC_ARG_WITH([extra_ldflags],
    AS_HELP_STRING([--with-extra-ldflags=FLAGS],
      [Additional linker flags (except for those indicated by R)]))


##### CHECK FOR R #############################################################

# this is inspired by "Writing R Extensions" manual:
# determine R_HOME directory...
AC_MSG_CHECKING(for R_HOME)
if test -z "${R_HOME}"; then
   R_HOME=`R RHOME` # set R_HOME if it isn't already set
fi
if test -z "${R_HOME}"; then
   AC_MSG_RESULT(no)
   echo "*** Could not determine R_HOME. Do you have R installed?"
   exit 1
fi
AC_MSG_RESULT($R_HOME)
AC_SUBST(R_HOME)

# ...and then R_PATH
AC_MSG_CHECKING(for R)
R_PATH="${R_HOME}/bin/R" # see "Writing R Extensions"
if test ! -e "${R_PATH}"; then
   # if it was determined by calling `R RHOME`, this is a bug
   AC_MSG_RESULT(no)
   echo "*** Could not find R at R_HOME/bin/R, i.e. ${R_HOME}/bin/R"
   exit 1
fi
AC_MSG_RESULT($R_PATH)

##### SETUP COMPILER ###########################################################


CC=`"${R_PATH}" CMD config CC`
CXX=`"${R_PATH}" CMD config CXX`
CPP=`"${R_PATH}" CMD config CXXCPP`
LD=`"${R_PATH}" CMD config SHLIB_CXXLD`

CFLAGS=`"${R_PATH}" CMD config CFLAGS`
CFLAGS+=" "
CFLAGS+=`"${R_PATH}" CMD config CPICFLAGS`
CFLAGS+=" "
CFLAGS+=`"${R_PATH}" CMD config SHLIB_CFLAGS`

CPPFLAGS=`"${R_PATH}" CMD config CPPFLAGS`
CPPFLAGS+=" "
CPPFLAGS+=`"${R_PATH}" CMD config --cppflags`

CXXFLAGS=`"${R_PATH}" CMD config CXXFLAGS`
CXXFLAGS+=" "
CXXFLAGS+=`"${R_PATH}" CMD config CXXPICFLAGS`
CXXFLAGS+=" "
CXXFLAGS+=`"${R_PATH}" CMD config SHLIB_CFLAGS`



CFLAGS="${CFLAGS} ${with_extra_cflags}"
CPPFLAGS="${CPPFLAGS} ${with_extra_cppflags}"
CXXFLAGS="${CXXFLAGS} ${with_extra_cxxflags}"
LDFLAGS="${LDFLAGS} ${with_extra_ldflags}"

if test "$enable_gcc_debug" == "yes"; then
   CXXFLAGS="${CXXFLAGS} -UNDEBUG"
   CFLAGS="${CFLAGS} -UNDEBUG"
fi

if test "$enable_gcc_pedantic" == "yes"; then
   CXXFLAGS="${CXXFLAGS} -Wall -Wextra -ansi -pedantic"
   CFLAGS="${CFLAGS} -Wall -Wextra -ansi -pedantic"
fi

SHLIB_EXT=`"${R_PATH}" CMD config SHLIB_EXT`

AC_PROG_CC
AC_PROG_CXX

LDFLAGS=`"${R_PATH}" CMD config LDFLAGS`
LDFLAGS+=" "
LDFLAGS+=`"${R_PATH}" CMD config SHLIB_CXXLDFLAGS`
LDFLAGS+=" "
LDFLAGS+=`"${R_PATH}" CMD config --ldflags`


AC_SUBST(CXXFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(CFLAGS)
AC_SUBST(LDFLAGS)

AC_SUBST(CC)
AC_SUBST(CPP)
AC_SUBST(CXX)
AC_SUBST(LD)

AC_SUBST(SHLIB_EXT)


AC_CONFIG_FILES([src/Makefile])
AC_OUTPUT
