# autoconf/configure script for stringi
# (C) 2013 M. Gagolewski
# http://stringi.rexamine.com

##### INIT ####################################################################

AC_INIT(stringi, 0.1, gagolews@rexamine.com)
ICU_VERSION_NEEDED="4.8" # next version after 4.8 == 49

##### OPTIONS #################################################################

# shell variables/arguments accepted:
# R_HOME - R's home dir
AC_ARG_VAR(R_HOME, [Override default directory with R installation, e.g. /usr/lib64/R.
                    Note that $R_HOME/bin/R should point to R executable.])

# PKG_CONFIG_PATH - full path to pkg-config
AC_ARG_VAR(PKG_CONFIG_PATH, [Override default path to pkg-config,
                     e.g. /usr/bin/pkg-config])


AC_ARG_ENABLE([icu_guess],
    AS_HELP_STRING([--disable-icu-guess],
      [Disable auto-detection of ICU4C-devel]))
if test "x$enable_icu_guess" != "xno"; then
   enable_icu_guess="yes"
else
   enable_icu_guess="no"
fi

AC_ARG_ENABLE([pkg_config],
    AS_HELP_STRING([--disable-pkg-config],
      [Disable pkg-config usage for finding ICU4C-devel.
       Note that pkg-config will be used only after failure of auto-guessing
       or if you pass --disable-icu-guess]))
if test "x$enable_pkg_config" != "xno"; then
   enable_pkg_config="yes"
else
   enable_pkg_config="no"
fi

AC_ARG_ENABLE([debug],
    AS_HELP_STRING([--enable-debug],
      [Undefine NDEBUG when compiling stringi]))
if test "x$enable_debug" == "xyes"; then
   enable_debug="yes"
else
   enable_debug="no"
fi

AC_ARG_WITH([extra_cflags],
    AS_HELP_STRING([--with-extra-cflags=FLAGS],
      [Additional C compiler flags (except for those indicated by R)]))

AC_ARG_WITH([extra_cppflags],
    AS_HELP_STRING([--with-extra-cppflags=FLAGS],
      [Additional C/C++ preprocessor flags (except for those indicated by R),
      e.g. -I<dir> for pointing where to search for ICU4C headers]))

AC_ARG_WITH([extra_cxxflags],
    AS_HELP_STRING([--with-extra-cxxflags=FLAGS],
      [Additional C++ compiler flags (except for those indicated by R)]))

AC_ARG_WITH([extra_ldflags],
    AS_HELP_STRING([--with-extra-ldflags=FLAGS],
      [Additional linker flags (except for those indicated by R),
      e.g. -L<dir> for pointing where to search for ICU4C libs]))

DEFAULT_ICU_LIBS="-licuuc -licudata -licui18n -licuio"
AC_ARG_WITH([icu_libs],
    AS_HELP_STRING([--with-icu-libs=FLAGS],
      [Linker flags for including ICU4C libs during ICU4C auto-detect,
      i.e. if --disable-icu-guess is not set, 
      defaults to -licuuc -licudata -licui18n -licuio]))
if test -z $with_icu_libs; then
   with_icu_libs="${DEFAULT_ICU_LIBS}"
fi

## Test options values:
#echo R_HOME=$R_HOME
#echo PKG_CONFIG_PATH=$PKG_CONFIG_PATH
#echo enable_pkg_config=$enable_pkg_config
#echo enable_icu_guess=$enable_icu_guess
#echo enable_debug=$enable_debug
#echo with_extra_cflags=$with_extra_cflags
#echo with_extra_cppflags=$with_extra_cppflags
#echo with_extra_cxxflags=$with_extra_cxxflags
#echo with_extra_ldflags=$with_extra_ldflags
#echo with_icu_libs=$with_icu_libs

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

# check for a C and C++ compiler
AC_LANG(C++)
AC_MSG_CHECKING(CC)
CC=`"${R_PATH}" CMD config CC`
AC_MSG_RESULT($CC)

AC_MSG_CHECKING(CXX)
CXX=`"${R_PATH}" CMD config CXX`
AC_MSG_RESULT($CXX)

AC_MSG_CHECKING(CFLAGS)
CFLAGS=`"${R_PATH}" CMD config CFLAGS`" $with_extra_cflags"
AC_MSG_RESULT($CFLAGS)

AC_MSG_CHECKING(CPPFLAGS)
CPPFLAGS=`"${R_PATH}" CMD config CPPFLAGS`" $with_extra_cppflags"
AC_MSG_RESULT($CPPFLAGS)

AC_MSG_CHECKING(CXXFLAGS)
CXXFLAGS=`"${R_PATH}" CMD config CXXFLAGS`" $with_extra_cxxflags"
AC_MSG_RESULT($CXXFLAGS)

AC_MSG_CHECKING(LDFLAGS)
LDFLAGS=`"${R_PATH}" CMD config LDFLAGS`" $with_extra_ldflags"
AC_MSG_RESULT($LDFLAGS)

AC_PROG_CC
AC_PROG_CXX


##### CHECK FOR ICU4C ##########################################################

##### 1. Maybe it will just work : ICU4C auto-guess

ICU_GUESS="no"
if test $enable_icu_guess == "yes"
then
   save_LDFLAGS=$LDFLAGS
   LDFLAGS="${LDFLAGS} $with_icu_libs"
   
   AC_MSG_CHECKING([for ICU4C-devel])
   AC_LINK_IFELSE([AC_LANG_SOURCE([
   #include <unicode/unistr.h>
   #include <unicode/uvernum.h>
   #include <stdio.h>
   using namespace icu;
   
   int main() {
     UnicodeString x;
     x = x+x;
     printf(U_ICU_VERSION);
     return 0;
   }])],[
      AC_MSG_RESULT([yes])
      AC_MSG_CHECKING([for ICU4C-devel version])
      AC_RUN_IFELSE([AC_LANG_SOURCE([
      #include <unicode/unistr.h>
      #include <unicode/uvernum.h>
      #include <stdio.h>
      using namespace icu;
      
      int main() {
        FILE* fp = fopen("conftest.out", "w");
        fprintf(fp, U_ICU_VERSION);
        fclose(fp);
        return 0;
      }])],[
         ICU_VERSION=`cat conftest.out`
         AC_MSG_RESULT($ICU_VERSION)

         AC_MSG_CHECKING(for ICU4C >= $ICU_VERSION_NEEDED)
         VERSION_CHECK=`expr $ICU_VERSION ">=" $ICU_VERSION_NEEDED`
         if test "$VERSION_CHECK" = "1" ; then
            AC_MSG_RESULT(yes)
            ICU_FLAG_I="" # leave defaults
            ICU_FLAG_L=$with_icu_libs # add given libs
            ICU_GUESS="yes"
         else
            AC_MSG_RESULT(no)
            echo "*** ICU4C ${ICU_VERSION} has been detected"
            echo "*** Minimal requirements, i.e. ICU4C >= ${ICU_VERSION_NEEDED}, are not met"
            echo "*** For more information check out the file stringi/INSTALL.md"
         fi
      ],[
         AC_MSG_RESULT([no]) # could not detect icu version
      ])
   ],[
      AC_MSG_RESULT([no]) # could not compile an ICU-based project
   ])

   LDFLAGS=$save_LDFLAGS # restore ldflags
fi

##### 2. Get settings from pkg-lib
# Note that According to http://userguide.icu-project.org/howtouseicu,
# icu-config is supported, but no longer recommended for production use.

PKG_GUESS="no"
if test $ICU_GUESS == "no" && test $enable_pkg_config == "yes"
then
   # Retrieve pkg-config's path [it may be provided by an env.var.]
   if test -z "${PKG_CONFIG_PATH}"
   then
      AC_PATH_PROG(PKG_CONFIG_PATH, pkg-config, no,
         [$PATH:/usr/local/bin:ext/bin:ext:/sw/bin:/opt/bin]) # auto-detect
   elif test ! -f "${PKG_CONFIG_PATH}"; then
      AC_MSG_CHECKING(for pkg-config)
      AC_MSG_RESULT(no)
      echo "*** The pkg-config script could not be found"
      echo "*** Make sure it is in your system PATH or provide PKG_CONFIG_PATH"
      echo "*** For more information check out the file stringi/INSTALL.md"
      exit 1 # you may exit here
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
      AC_MSG_CHECKING(for ICU4C >= $ICU_VERSION_NEEDED)
      VERSION_CHECK=`expr $ICU_VERSION ">=" $ICU_VERSION_NEEDED`
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

         PKG_GUESS="yes" # DONE
      else
         # a newer version of ICU4C is required
         AC_MSG_RESULT(no)
         echo "*** ICU4C ${ICU_VERSION} has been detected"
         echo "*** Minimal requirements, i.e. ICU4C >= ${ICU_VERSION_NEEDED}, are not met"
         echo "*** For more information check out the file stringi/INSTALL.md"
         exit 1 # you may exit here
      fi
   else
      # pkg config doesn't know about icu-uc
      AC_MSG_RESULT(no)
      echo "*** The pkg-config script did not detect ICU4C-devel libraries installed"
      echo "*** For more information check out the file stringi/INSTALL.md"
      exit 1 #you may exit here
   fi
fi
# check for ICU

#### 3. Final check
if test $ICU_GUESS == "no" && test $PKG_GUESS == "no"
then
   echo "*** ICU4C-devel libraries cannot be found"
   echo "*** For more information check out the file stringi/INSTALL.md"
   exit 1
fi


##### CHECK FOR ICU HEADERS ####################################################

# AC_CONFIG_SRCDIR([src/stringi.cpp])
# AC_CONFIG_HEADER([src/stringi.h])

stringi_CXXFLAGS=$ICU_FLAG_I
stringi_LIBS=$ICU_FLAG_L
if test "$enable_debug" == "yes"; then
   stringi_CXXFLAGSDEBUG="-UNDEBUG"
else
   stringi_CXXFLAGSDEBUG="-DNDEBUG"
fi

AC_SUBST(stringi_CXXFLAGS)
AC_SUBST(stringi_CXXFLAGSDEBUG)
AC_SUBST(stringi_LIBS)



AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
