# autoconf/configure script for stringi
# (C) 2013-2014 M. Gagolewski
# http://stringi.rexamine.com

##### INIT ####################################################################

AC_INIT(stringi, 0.4, stringi@rexamine.com)

ICU_VERSION_NEEDED="50" # minimal version of ICU4C required to build stringi

##### OPTIONS #################################################################

# shell variables/arguments accepted:
# R_HOME - R's home dir
AC_ARG_VAR(R_HOME, [Override default directory with R installation, e.g. /usr/lib64/R.
                    Note that $R_HOME/bin/R should point to R executable.])

AC_ARG_ENABLE([pkg_config],
    AS_HELP_STRING([--disable-pkg-config],
      [Disable pkg-config usage for finding ICU4C-devel; in such a case ICU4C will be compiled from sources.]))
if test "x$enable_pkg_config" != "xno"; then
   enable_pkg_config="yes"
else
   enable_pkg_config="no"
fi

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
   # if it was determined by calling `R RHOME`, then this is likely a bug
   AC_MSG_RESULT(no)
   echo "*** Could not find R at R_HOME/bin/R, i.e. ${R_HOME}/bin/R"
   exit 1
fi
AC_MSG_RESULT($R_PATH)

CC=`"${R_PATH}" CMD config CC`
CXX=`"${R_PATH}" CMD config CXX`
CPP=`"${R_PATH}" CMD config CXXCPP`
LD=`"${R_PATH}" CMD config SHLIB_CXXLD`
CFLAGS=`"${R_HOME}/bin/R" CMD config CFLAGS`
CXXFLAGS=`"${R_HOME}/bin/R" CMD config CXXFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`

AC_LANG(C)
AC_PROG_CC
AC_LANG(C++)
AC_PROG_CXX

##### CHECK FOR CAT ############################################################

# Check for 'cat' and get full path.
AC_ARG_VAR([CAT], [the 'cat' command used for generating the list of source files to compile])
AC_PATH_PROG([CAT],[cat],[])
if test "x$CAT" = "x"; then
   AC_MSG_NOTICE([==> cat command not found!])
   AC_MSG_NOTICE([==> Set CAT variable if present in non-standard path])
fi

##### CHECK FOR ICU4C ##########################################################



##### 1. Get settings from pkg-lib
# Note that according to http://userguide.icu-project.org/howtouseicu,
# icu-config is supported, but no longer recommended for production use.


detect_icu_with_pkg_config() {
   if test $enable_pkg_config = "no"; then
      # Use of pkg-config disabled, nothing to do
      return 1
   fi

   # Retrieve pkg-config's path
   AC_PATH_PROG(PKG_CONFIG, pkg-config, no,
         [$PATH:/usr/local/bin:/bin:/usr/bin:ext/bin:ext:/sw/bin:/opt/bin]) # auto-detect

   if test ! -f "${PKG_CONFIG}"; then
      echo "*** The pkg-config script could not be found"
      echo "*** Make sure it is installed if you want to use system ICU4C-devel installation"
      return 1 # go back immediately
   fi

   # check if pkg-config knows about icu-i18n
   AC_MSG_CHECKING(with pkg-config for ICU4C installed)
   if ! `"${PKG_CONFIG}" --exists icu-i18n  icu-uc`; then
      # pkg config doesn't know about icu-i18n
      AC_MSG_RESULT(no)
      echo "*** The pkg-config script did not detect ICU4C-devel libraries installed"
      echo "*** We will build ICU4C from sources"
      return 1 # nothing more to do
   fi

   # check which version of ICU4C is installed
   ICU_VERSION=`"${PKG_CONFIG}" --modversion icu-i18n`
   AC_MSG_RESULT($ICU_VERSION)

   # check for a suitable version
   AC_MSG_CHECKING(for ICU4C >= $ICU_VERSION_NEEDED)
   #VERSION_CHECK=`expr $ICU_VERSION ">=" $ICU_VERSION_NEEDED`
   #if test "$VERSION_CHECK" != "1" ; then
   if ! `"${PKG_CONFIG}" --atleast-version=${ICU_VERSION_NEEDED} icu-i18n  icu-uc`; then
      AC_MSG_RESULT(no)
      echo "*** ICU4C ${ICU_VERSION} has been detected"
      echo "*** Minimal requirements, i.e. ICU4C >= ${ICU_VERSION_NEEDED}, are not met"
      echo "*** We will build ICU4C from sources"
      return 1 # you may quit querying pkg-config here
   fi
   AC_MSG_RESULT(yes) # detected version of ICU4C is sufficient

   export PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 # always provide system -L
   AC_MSG_CHECKING([for proper CPPFLAGS, LDFLAGS, and LIBS])
   ICU_CPPFLAGS=`"${PKG_CONFIG}" --cflags icu-uc icu-i18n`
   ICU_LDFLAGS=`"${PKG_CONFIG}" --libs-only-L icu-uc icu-i18n`
   ICU_LIBS=`"${PKG_CONFIG}" --libs-only-l icu-uc icu-i18n`
   AC_MSG_RESULT(done)


   # It has been indicated that icu-config may return 32bit libs
   # when 64bit libs are not available, even if we compile a 64bit version.
   # Thus, let us check if everything works
   CPPFLAGS="${CPPFLAGS} ${ICU_CPPFLAGS}"
   LDFLAGS="${ICU_LDFLAGS} ${ICU_LIBS}"

   AC_LANG(C++)

   AC_MSG_CHECKING([whether we may build a simple ICU-dependent project])
   AC_LINK_IFELSE([AC_LANG_SOURCE([
      #include <unicode/unistr.h>
      #include <unicode/uvernum.h>
      #include <unicode/ptypes.h>
      #include <unicode/uchar.h>
      #include <unicode/utypes.h>
      #include <stdio.h>
      using namespace icu;

      int main() {
        // base tests
        UnicodeString x("abc");
        x = x+x;
        printf(U_ICU_VERSION);

        return 0;
      }])
   ],
   [
      AC_MSG_RESULT([yes])
   ],[
      AC_MSG_RESULT([no]) # could not detect icu version
      echo "*** We will build ICU4C from sources"
      return 1
   ])

   AC_MSG_CHECKING([whether we may build a more complex ICU-dependent project])
   AC_LINK_IFELSE([AC_LANG_SOURCE([
      #include <unicode/unistr.h>
      #include <unicode/uvernum.h>
      #include <unicode/ptypes.h>
      #include <unicode/uchar.h>
      #include <unicode/utypes.h>
      #include <unicode/ucnv.h>
      #include <unicode/ustring.h>
      #include <unicode/stringpiece.h>
      #include <unicode/utf8.h>
      #include <unicode/utf16.h>
      #include <unicode/normalizer2.h>
      #include <unicode/locid.h>
      #include <unicode/uloc.h>
      #include <unicode/regex.h>
      #include <unicode/brkiter.h>
      #include <unicode/coll.h>
      #include <unicode/ucol.h>
      #include <unicode/ucsdet.h>
      #include <unicode/stsearch.h>
      #include <unicode/ulocdata.h>
      #include <unicode/usearch.h>
      #include <unicode/uniset.h>
      #include <stdio.h>
      using namespace icu;

      int main() {
        // check if we have some converters installed (icudt)
        int c = ucnv_countAvailable();
        if (c == 0)
          return 11;

        // check if we have some locales defined (icudt)
        c = uloc_countAvailable();
        if (c == 0)
          return 12;

        return 0;
      }])
   ],
   [
      AC_MSG_RESULT([yes])
   ],[
      AC_MSG_RESULT([no]) # could not detect icu version
      echo "*** We will build ICU4C from sources"
      return 1
   ])

   ICU_FOUND=1 # DONE
   return 0
}

ICU_FOUND=0

if test $ICU_FOUND = 0; then
   detect_icu_with_pkg_config
fi

##### PREPARE LIST OF SOURCE FILES #############################################

STRINGI_SOURCES_CPP=`${CAT} src/stri_cpp.txt`
AC_SUBST(STRINGI_SOURCES_CPP)

STRINGI_ICU_COMMON_SOURCES_CPP=`${CAT} src/icu52_common_cpp.txt`
AC_SUBST(STRINGI_ICU_COMMON_SOURCES_CPP)

STRINGI_ICU_COMMON_SOURCES_C=`${CAT} src/icu52_common_c.txt`
AC_SUBST(STRINGI_ICU_COMMON_SOURCES_C)

STRINGI_ICU_I18N_SOURCES_CPP=`${CAT} src/icu52_i18n_cpp.txt`
AC_SUBST(STRINGI_ICU_I18N_SOURCES_CPP)

STRINGI_ICU_I18N_SOURCES_C=`${CAT} src/icu52_i18n_c.txt`
AC_SUBST(STRINGI_ICU_I18N_SOURCES_C)

STRINGI_ICU_STUBDATA_SOURCES_CPP=`${CAT} src/icu52_stubdata_cpp.txt`
AC_SUBST(STRINGI_ICU_STUBDATA_SOURCES_CPP)

STRINGI_ICU_STUBDATA_SOURCES_C=`${CAT} src/icu52_stubdata_c.txt`
AC_SUBST(STRINGI_ICU_STUBDATA_SOURCES_C)


##### SETUP COMPILER 2 ###########################################################


if test "$enable_gcc_debug" == "yes"; then
   #  -fsanitize=address -fno-omit-frame-pointer
   with_extra_cflags="${with_extra_cflags} -UNDEBUG"
   with_extra_cxxflags="${with_extra_cxxflags} -UNDEBUG"
   with_extra_ldflags="${with_extra_ldflags}"
fi

if test "$enable_gcc_pedantic" == "yes"; then
   with_extra_cflags="${with_extra_cflags} -Wall -Wextra -ansi -pedantic -std=c99 -ansi"
   with_extra_cxxflags="${with_extra_cxxflags} -Wall -Wextra -ansi -pedantic -std=c++98 -ansi"
fi


if test $ICU_FOUND = 0; then
   # build ICU4C from sources
   STRINGI_OBJECTS="\$(STRI_OBJECTS) \$(ICU_COMMON_OBJECTS) \$(ICU_I18N_OBJECTS) \$(ICU_STUBDATA_OBJECTS)"
   STRINGI_CFLAGS=""
   STRINGI_CPPFLAGS="-I. -Iicu52 -Iicu52/unicode -Iicu52/common -Iicu52/i18n -DU_STATIC_IMPLEMENTATION \
-DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL \
-DNDEBUG"
   STRINGI_CXXFLAGS=""
   STRINGI_LDFLAGS=""
else
   # use system ICU4C
   STRINGI_OBJECTS="\$(STRI_OBJECTS)"
   STRINGI_CFLAGS=""
   STRINGI_CPPFLAGS="-DNDEBUG -I. ${ICU_CPPFLAGS}"
   STRINGI_CXXFLAGS=""
   STRINGI_LDFLAGS="${ICU_LDFLAGS} ${ICU_LIBS}"
fi
AC_SUBST(STRINGI_OBJECTS)

AC_CHECK_HEADER([elf.h],
       [
            with_extra_cflags="${with_extra_cflags} -DU_HAVE_ELF_H"
            with_extra_cxxflags="${with_extra_cxxflags} -DU_HAVE_ELF_H"
       ])

STRINGI_CFLAGS="${STRINGI_CFLAGS} ${with_extra_cflags}"
STRINGI_CPPFLAGS="${STRINGI_CPPFLAGS} ${with_extra_cppflags}"
STRINGI_CXXFLAGS="${STRINGI_CXXFLAGS} ${with_extra_cxxflags}"
STRINGI_LDFLAGS="${STRINGI_LDFLAGS} ${with_extra_ldflags}"


#############################################################################
#AC_CANONICAL_HOST
#
#case "${host}" in
#   *-*-solaris*) 	platform=U_SOLARIS ;;
#	*-*-linux*|*-*-gnu|*-*-k*bsd*-gnu|*-*-kopensolaris*-gnu) platform=U_LINUX ;;
#	*-*-*bsd*|*-*-dragonfly*) 	platform=U_BSD ;;
#	*-*-aix*) 	platform=U_AIX ;;
#	*-*-hpux*) 	platform=U_HPUX ;;
#	*-apple-darwin*|*-apple-rhapsody*)	platform=U_DARWIN ;;
#	*-*-cygwin*)	platform=U_CYGWIN ;;
#	*-*-mingw*)	platform=U_MINGW ;;
#	*-*ibm-openedition*|*-*-os390*)	platform=OS390 ;;
#	*-*-os400*)	platform=OS400 ;;
#	*-*-nto*)	platform=U_QNX ;;
#	*-dec-osf*) 	platform=U_OSF ;;
#	*-*-beos)		platform=U_BEOS ;;
#	*-*-irix*)		platform=U_IRIX ;;
#	*-ncr-*)		platform=U_MPRAS ;;
#	*) 		platform=U_UNKNOWN_PLATFORM ;;
#esac
#
#AC_SUBST(platform)
#############################################################################



AC_SUBST(STRINGI_CXXFLAGS)
AC_SUBST(STRINGI_CPPFLAGS)
AC_SUBST(STRINGI_CFLAGS)
AC_SUBST(STRINGI_LDFLAGS)

AC_CONFIG_FILES([src/Makevars])

AC_SUBST(ICU_FOUND)
AC_CONFIG_FILES([src/icu52_found.txt])
AC_OUTPUT
