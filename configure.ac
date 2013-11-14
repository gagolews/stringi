# autoconf/configure script for stringi
# (C) 2013 M. Gagolewski
# http://stringi.rexamine.com

##############################################################################

# shell variables accepted:
# R_HOME - R's home dir
# PKG_CONFIG_PATH - full path to pkg-config
# ICU_CFLAGS - c flags
# ICU_CXXFLAGS - cxx flags
# ICU_LIBS - linker flags

##### INIT ####################################################################

AC_INIT(stringi, 0.1, gagolews@rexamine.com)
ICU_VERSION_NEEDED="4.8"

##### CHECK FOR R #############################################################

# this is inspired by "Writing R Extensions" manual:
# determine R_HOME directory...
AC_MSG_CHECKING(for R)
: ${R_HOME=`R RHOME`} # set R_HOME if it isn't already set and don't mind retval
if test -z "${R_HOME}"; then
   AC_MSG_RESULT(no)
   echo "*** Could not determine R_HOME. Do you have R installed?"
   exit 1
fi

# ...and then R_PATH
R_PATH="${R_HOME}/bin/R" # see "Writing R Extensions"
if test ! -e "${R_PATH}"; then
   # if it was determined by calling `R RHOME`, this is a bug
   AC_MSG_RESULT(no)
   echo "*** Could not find R at R_HOME/bin/R, i.e. ${R_HOME}/bin/R"
   exit 1
fi
AC_MSG_RESULT($R_PATH)
AC_SUBST(R_HOME)


##### CHECK FOR ICU ############################################################

# check for ICU (fun)
AC_DEFUN([AC_CHECK_ICU], [
   succeeded=no
   
   # According to http://userguide.icu-project.org/howtouseicu,
   # icu-config is supported, but no longer recommended for production use.
   # Thus, we'll use pkg-config
   
   # Retrieve pkg-config's path [it may be provided by an env.var.]
   if test -z "${PKG_CONFIG_PATH}"; then
      AC_PATH_PROG(PKG_CONFIG_PATH, pkg-config, no,
         [$PATH:/usr/local/bin:ext/bin:ext:/sw/bin:/opt/bin]) # auto-detect
   elif test ! -f "${PKG_CONFIG_PATH}"; then
      AC_MSG_CHECKING(for pkg-config)
      AC_MSG_RESULT(no)
      echo "*** The pkg-config script could not be found"
      echo "*** Make sure it is in your system PATH or provide PKG_CONFIG_PATH"
      echo "*** For more information check out the file stringi/INSTALL.md"
      exit 1
   fi

   # check if pkg-config knows about icu-uc
   AC_MSG_CHECKING(with pkg-config for ICU4C installed)
   if `"${PKG_CONFIG_PATH}" --exists icu-uc`
   then
      # pkg config knows about icu-uc

      # check which version of ICU4C is installed
      ICU_VERSION=`"${PKG_CONFIG_PATH}" --modversion icu-uc`
      AC_MSG_RESULT($ICU_VERSION)

      # check for a suitable version
      AC_MSG_CHECKING(for ICU4C >= $1)
      VERSION_CHECK=`expr $ICU_VERSION ">=" $1`
      # this could also be done with pkg-config --atleast-pkgconfig-version=VERSION
      if test "$VERSION_CHECK" = "1" ; then
         # detected version of ICU4C is sufficient
         AC_MSG_RESULT(yes)
         AC_MSG_CHECKING(for ICU4C includepath compiler flags)
         ICU_FLAG_I=`"$PKG_CONFIG_PATH" --cflags-only-I icu-uc icu-i18n icu-io`
         AC_MSG_RESULT($ICU_FLAG_I)
   
         AC_MSG_CHECKING(for ICU4C libpath compiler flags)
         ICU_FLAG_L=`"$PKG_CONFIG_PATH"  --libs-only-l icu-uc icu-i18n icu-io`
         AC_MSG_RESULT($ICU_FLAG_L)

         succeeded=yes # DONE
      else
         # a newer version of ICU4C is required
         AC_MSG_RESULT(no)
         echo "*** ICU4C ${ICU_VERSION} has been detected"
         echo "*** Minimal requirements, i.e. ICU4C >= $1, are not met"
         echo "*** For more information check out the file stringi/INSTALL.md"
         exit 1
      fi
   else
      # pkg config doesn't know about icu-uc
      AC_MSG_RESULT(no)
      echo "*** The pkg-config script did not detect ICU4C-devel libraries installed"
      echo "*** For more information check out the file stringi/INSTALL.md"
      exit 1
   fi
   
   if test $succeeded = yes; then
      ifelse([$2], , :, [$2])
   else
      # will exit before anyway
      ifelse([$3], , AC_MSG_ERROR([Library requirements (ICU4C) not met.]), [$3])
   fi
])
# check for ICU (/fun)

# call the above function
AC_CHECK_ICU($ICU_VERSION_NEEDED, HAVE_ICU="1",
   AC_MSG_ERROR(ICU4C version >= $ICU_VERSION_NEEDED required)) 


##### CHECK FOR ICU HEADERS ####################################################

# AC_CONFIG_SRCDIR([src/stringi.cpp])
# AC_CONFIG_HEADER([src/stringi.h])

stringi_CXXFLAGS=$ICU_FLAG_I
stringi_LIBS=$ICU_FLAG_L
AC_SUBST(stringi_CXXFLAGS)
AC_SUBST(stringi_LIBS)

# check for a C and C++ compiler
AC_LANG(C++)
CC=`"${R_PATH}" CMD config CC`
CXX=`"${R_PATH}" CMD config CXX`
CFLAGS=`"${R_PATH}" CMD config CFLAGS`
CPPFLAGS=`"${R_PATH}" CMD config CPPFLAGS`
CXXFLAGS=`"${R_PATH}" CMD config CXXFLAGS`
LDFLAGS=`"${R_PATH}" CMD config LDFLAGS`
AC_PROG_CC
AC_PROG_CXX


AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
