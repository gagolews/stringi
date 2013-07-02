AC_INIT([stringi], 0.1-4)


AC_DEFUN([AC_CHECK_ICU], [
succeeded=no

if test -z "$ICU_CONFIG"; then
   AC_PATH_PROG(ICU_CONFIG, icu-config, no)
fi

AC_MSG_CHECKING(for ICU installed)
if test "$ICU_CONFIG" = "no" ; then
   AC_MSG_RESULT(failed)
   echo "*** The icu-config script could not be found."
   echo "*** Make sure it is in your PATH."
   echo "*** For more information check out the file stringi/INSTALL.md."
else
   ICU_VERSION=`$ICU_CONFIG --version`
   AC_MSG_RESULT(found version $ICU_VERSION)
   AC_MSG_CHECKING(for ICU >= $1)
      VERSION_CHECK=`expr $ICU_VERSION ">=" $1`
      if test "$VERSION_CHECK" = "1" ; then
            AC_MSG_RESULT(yes)
            succeeded=yes

            AC_MSG_CHECKING(for ICU includepath compiler flags)
            ICU_INCLUDEPATH=`$ICU_CONFIG --cppflags-searchpath`
            AC_MSG_RESULT($ICU_INCLUDEPATH)

            AC_MSG_CHECKING(for ICU libpath compiler flags)
            ICU_LIBPATH=`$ICU_CONFIG --ldflags-searchpath`
            AC_MSG_RESULT($ICU_LIBPATH)
      else
            ICU_INCLUDEPATH=""
            ICU_LIBPATH=""
            ifelse([$3], ,echo "can't find ICU >= $1",)
      fi

      AC_SUBST(ICU_CFLAGS)
      AC_SUBST(ICU_CXXFLAGS)
      AC_SUBST(ICU_LIBS)
fi

if test $succeeded = yes; then
   ifelse([$2], , :, [$2])
else
   ifelse([$3], , AC_MSG_ERROR([Library requirements (ICU) not met.]), [$3])
fi
])


ICU_VERSION_NEEDED="4.8"
AC_CHECK_ICU($ICU_VERSION_NEEDED, HAVE_ICU="1", AC_MSG_ERROR(ICU version $ICU_VERSION_NEEDED required)) 

AC_CHECK_HEADERS(unicode/uconfig.h)
if test "${ac_cv_header_uconfig_h}" = no; then
   AC_MSG_ERROR("ICU header unicode/uconfig.h not found")
fi

stringi_CXXFLAGS=$ICU_INCLUDEPATH
stringi_LIBS="$ICU_LIBPATH -licuuc -licudata -licui18n -licuio"

AC_MSG_CHECKING(R_HOME)
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  AC_MSG_ERROR(Could not determine R_HOME)
fi
AC_MSG_RESULT($R_HOME)

AC_LANG(C++)
CC=`"${R_HOME}/bin/R" CMD config CC`
CXX=`"${R_HOME}/bin/R" CMD config CXX`
CFLAGS=`"${R_HOME}/bin/R" CMD config CFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`
CXXFLAGS=`"${R_HOME}/bin/R" CMD config CXXFLAGS`
LDFLAGS=`"${R_HOME}/bin/R" CMD config LDFLAGS`
AC_PROG_CC
AC_PROG_CXX

AC_SUBST(stringi_CXXFLAGS)
AC_SUBST(stringi_LIBS)
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
