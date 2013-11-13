# autoconf script for stringi
# (C) 2013 M. Gagolewski
# http://stringi.rexamine.com

# shell variables accepted:
# R - path to R
# PKG_CONFIG - path to pkg-config
# ICU_CONFIG - path to icu-config [deprecated]
# ICU_CFLAGS - c flags
# ICU_CXXFLAGS - cxx flags
# ICU_LIBS - linker flags

AC_INIT([stringi], 0.1)
ICU_VERSION_NEEDED="4.8"



# check for ICU (fun)
AC_DEFUN([AC_CHECK_ICU], [
succeeded=no

# Retrieve pkg-config's path [it may be provided by env. var.]
if test -z "$PKG_CONFIG"; then
   AC_PATH_PROG(PKG_CONFIG, pkg-config, no)
elif test ! -e "$PKG_CONFIG"; then
   AC_MSG_CHECKING(for pkg-config)
   PKG_CONFIG=no
   AC_MSG_RESULT(no)
fi

# According to http://userguide.icu-project.org/howtouseicu,
# icu-config is supported, but no longer recommended for production use.
# However, some systems still don't support pkg-config
# Thus, we use icu-config iff pkg-config fails.

# Retrieve icu-config's path [it may be provided by env. var.]
if test -z "$ICU_CONFIG"; then
   AC_PATH_PROG(ICU_CONFIG, icu-config, no)
elif test ! -e "$ICU_CONFIG"; then
   AC_MSG_CHECKING(for pkg-config)
   ICU_CONFIG=no
   AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(for ICU installed)
if test "$PKG_CONFIG" != "no" && `$PKG_CONFIG --exists icu-uc`
then
   ICU_VERSION=`$PKG_CONFIG --modversion icu-uc`
   AC_MSG_RESULT(found version $ICU_VERSION using $PKG_CONFIG)
   AC_MSG_CHECKING(for ICU >= $1)
   VERSION_CHECK=`expr $ICU_VERSION ">=" $1`
   # this could also be done with pkg-config --atleast-pkgconfig-version=VERSION
   if test "$VERSION_CHECK" = "1" ; then
      AC_MSG_RESULT(yes)
      succeeded=yes
      AC_MSG_CHECKING(for ICU includepath compiler flags)
      ICU_FLAG_I=`$PKG_CONFIG --cflags-only-I icu-uc icu-i18n icu-io`
      AC_MSG_RESULT($ICU_FLAG_I)

      AC_MSG_CHECKING(for ICU libpath compiler flags)
      ICU_FLAG_L=`$PKG_CONFIG  --libs-only-l icu-uc icu-i18n icu-io`
      AC_MSG_RESULT($ICU_FLAG_L)
   else
      ICU_FLAG_I=""
      ICU_FLAG_L=""
      ifelse([$3], ,echo "cannot find ICU >= $1",)
   fi
elif test "$ICU_CONFIG" != "no" ; then
   ICU_VERSION=`$ICU_CONFIG --version`
   AC_MSG_RESULT(found version $ICU_VERSION using $ICU_CONFIG)
   AC_MSG_CHECKING(for ICU >= $1)
   VERSION_CHECK=`expr $ICU_VERSION ">=" $1`
   if test "$VERSION_CHECK" = "1" ; then
      AC_MSG_RESULT(yes)
      succeeded=yes

      AC_MSG_CHECKING(for ICU compiler flags)
      ICU_FLAG_I=`$ICU_CONFIG --cppflags-searchpath`
      AC_MSG_RESULT($ICU_FLAG_I)

      AC_MSG_CHECKING(for ICU linker flags)
      ICU_FLAG_L=`$ICU_CONFIG --ldflags-searchpath --ldflags-icuio --ldflags-libsonly`
      AC_MSG_RESULT($ICU_FLAG_L)
   else
      ICU_FLAG_I=""
      ICU_FLAG_L=""
      ifelse([$3], ,echo "cannot find ICU >= $1",)
   fi
else
   AC_MSG_RESULT(failed)
   echo "*** The pkg-config or icu-config script could not be found."
   echo "*** Make sure it is in your system PATH."
   echo "*** For more information check out the file stringi/INSTALL.md."
fi

if test $succeeded = yes; then
   ifelse([$2], , :, [$2])
else
   ifelse([$3], , AC_MSG_ERROR([Library requirements (ICU) not met.]), [$3])
fi
])
# check for ICU (/fun)





AC_CHECK_ICU($ICU_VERSION_NEEDED, HAVE_ICU="1",
   AC_MSG_ERROR(ICU version $ICU_VERSION_NEEDED required)) 

AC_CHECK_HEADERS(unicode/uconfig.h)
if test "${ac_cv_header_uconfig_h}" = no; then
   AC_MSG_ERROR("ICU header unicode/uconfig.h not found")
fi

AC_CHECK_HEADERS(unicode/uchar.h)
if test "${ac_cv_header_uchar_h}" = no; then
   AC_MSG_ERROR("ICU header unicode/uchar.h not found")
fi

AC_CHECK_HEADERS(unicode/ucnv.h)
if test "${ac_cv_header_ucnv_h}" = no; then
   AC_MSG_ERROR("ICU header unicode/ucnv.h not found")
fi

AC_CHECK_HEADERS(unicode/regex.h)
if test "${ac_cv_header_regex_h}" = no; then
   AC_MSG_ERROR("ICU header unicode/regex.h not found")
fi

AC_CHECK_HEADERS(unicode/normalizer2.h)
if test "${ac_cv_header_normalizer2_h}" = no; then
   AC_MSG_ERROR("ICU header unicode/normalizer2.h not found")
fi

AC_SUBST(ICU_CFLAGS)
AC_SUBST(ICU_CXXFLAGS)
AC_SUBST(ICU_LIBS)
stringi_CXXFLAGS=$ICU_FLAG_I
stringi_LIBS=$ICU_FLAG_L



# check for R
if test -z "$R"; then
   AC_PATH_PROG(R, R, no)
fi
if test ! -e "$R"; then
   AC_MSG_CHECKING(for R)
   AC_MSG_ERROR(Could not find R. Do you have R installed? Is it in your PATH?)
fi
# /check for R

AC_LANG(C++)
CC=`"${R}" CMD config CC`
CXX=`"${R}" CMD config CXX`
CFLAGS=`"${R}" CMD config CFLAGS`
CPPFLAGS=`"${R}" CMD config CPPFLAGS`
CXXFLAGS=`"${R}" CMD config CXXFLAGS`
LDFLAGS=`"${R}" CMD config LDFLAGS`
AC_PROG_CC
AC_PROG_CXX

my_save_cflags="$CFLAGS"
CFLAGS="-Wall -Wextra -ansi -pedantic"
stringi_ADDCXXFLAGS=""
AC_MSG_CHECKING([whether CC supports -Wall -Wextra -ansi -pedantic])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
    [AC_MSG_RESULT([yes])]
    [stringi_ADDCXXFLAGS="-Wall -Wextra -ansi -pedantic"],
    [AC_MSG_RESULT([no])]
    stringi_ADDCXXFLAGS=""
)
CFLAGS="$my_save_cflags"
AC_SUBST(stringi_ADDCXXFLAGS)

AC_SUBST(stringi_CXXFLAGS)
AC_SUBST(stringi_LIBS)
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
