# autoconf/configure script for stringi
# (C) 2013 M. Gagolewski
# http://stringi.rexamine.com

##### INIT ####################################################################

AC_INIT(stringi, 0.1, gagolews@rexamine.com)
ICU_VERSION_NEEDED="4.8" # minimal version of ICU4C required to build stringi;
                         # note that the next version after 4.8 == 49

##### OPTIONS #################################################################

# shell variables/arguments accepted:
# R_HOME - R's home dir
AC_ARG_VAR(R_HOME, [Override default directory with R installation, e.g. /usr/lib64/R.
                    Note that $R_HOME/bin/R should point to R executable.])

# PKG_CONFIG_PATH - full path to pkg-config's .pc files
AC_ARG_VAR(PKG_CONFIG_PATH, [A colon-separated (on Windows, semicolon-separated) 
   list of directories to search for pkg-config's .pc files.])


AC_ARG_ENABLE([icu_guess],
    AS_HELP_STRING([--disable-icu-guess],
      [Disable auto-detection of ICU4C-devel if pkg-config fails.]))
if test "x$enable_icu_guess" != "xno"; then
   enable_icu_guess="yes"
else
   enable_icu_guess="no"
fi

AC_ARG_ENABLE([pkg_config],
    AS_HELP_STRING([--disable-pkg-config],
      [Disable pkg-config usage for finding ICU4C-devel.]))
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


AC_ARG_ENABLE([prefer_static],
    AS_HELP_STRING([--disable-prefer-static],
      [Disable preferring static linking of ICU4C to dynamic linking.
       Note that normally you will not have static libraries installed
       anyway. Static linking is used to prepary binary distributions
       of stringi, especially on OS X. Static libraries are only detected
       with pkg-config.]))
if test "x$enable_prefer_static" != "xno"; then
   enable_prefer_static="yes"
else
   enable_prefer_static="no"
fi

AC_ARG_WITH([suffix_static],
    AS_HELP_STRING([--with-suffix-static="suffix"],
      [searches for pkg-config .pc files or static libraries names
      with given suffix; defaults to "_static" - in such case
      this script looks for e.g libicuuc_static.a and
      icu-uc_static.pc.]))
if test -z "${with_suffix_static}"; then
   with_suffix_static="_static" # default value
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
#echo enable_gcc_debug=$enable_gcc_debug
#echo enable_prefer_static=$enable_prefer_static
#echo with_suffix_static=$with_suffix_static
#echo enable_gcc_pedantic=$enable_gcc_pedantic
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
AC_MSG_CHECKING(CC proposed by R)
CC=`"${R_PATH}" CMD config CC`
AC_MSG_RESULT($CC)

AC_MSG_CHECKING(CXX proposed by R)
CXX=`"${R_PATH}" CMD config CXX`
AC_MSG_RESULT($CXX)

AC_MSG_CHECKING(CFLAGS proposed by R)
CFLAGS=`"${R_PATH}" CMD config CFLAGS`
AC_MSG_RESULT($CFLAGS)

AC_MSG_CHECKING(CPPFLAGS proposed by R)
CPPFLAGS=`"${R_PATH}" CMD config CPPFLAGS`
AC_MSG_RESULT($CPPFLAGS)

AC_MSG_CHECKING(CXXFLAGS proposed by R)
CXXFLAGS=`"${R_PATH}" CMD config CXXFLAGS`
AC_MSG_RESULT($CXXFLAGS)

AC_MSG_CHECKING(LDFLAGS proposed by R)
LDFLAGS=`"${R_PATH}" CMD config LDFLAGS`
AC_MSG_RESULT($LDFLAGS)

original_CFLAGS=$CFLAGS
original_CXXFLAGS=$CXXFLAGS
original_CPPFLAGS=$CPPFLAGS
original_LDFLAGS=$LDFLAGS
extra_CFLAGS=$with_extra_cflags
extra_CXXFLAGS=$with_extra_cxxflags
extra_CPPFLAGS=$with_extra_cppflags
extra_LDFLAGS=$with_extra_ldflags
CFLAGS="${original_CFLAGS} ${extra_CFLAGS}"
CXXFLAGS="${original_CXXFLAGS} ${extra_CXXFLAGS}"
CPPFLAGS="${original_CPPFLAGS} ${extra_CPPFLAGS}"
LDFLAGS="${original_LDFLAGS} ${extra_LDFLAGS}"

AC_PROG_CC
AC_PROG_CXX



##### CHECK FOR ICU4C ##########################################################



##### 1. Get settings from pkg-lib
# Note that according to http://userguide.icu-project.org/howtouseicu,
# icu-config is supported, but no longer recommended for production use.
# It has been indicated that icu-config may return 32bit libs
# when 64bit libs are not available, even though we compile a 64bit version.


detect_static_icu_with_pkg_config() {
   if test $enable_pkg_config = "no"; then
      # Use of pkg-config disabled, nothing to do
      return 1
   fi

   if test $enable_prefer_static = "no"; then
      # Use of pkg-config disabled, nothing to do
      return 1
   fi

   # Retrieve pkg-config's path 
   AC_PATH_PROG(PKG_CONFIG, pkg-config, no,
         [$PATH:/usr/local/bin:/bin:/usr/bin:ext/bin:ext:/sw/bin:/opt/bin]) # auto-detect

   if test ! -f "${PKG_CONFIG}"; then
      return 1 # go back immediately
   fi

   AC_MSG_CHECKING([with pkg-config for ICU4C$with_suffix_static installed])
   if ! `"${PKG_CONFIG}" --exists icu-uc$with_suffix_static`; then
      # pkg config doesn't know about icu-uc
      AC_MSG_RESULT(no)
      return 1 # nothing more to do
   fi
   
   # pkg config recognized icu-uc_suffix
   # check which version of ICU4C is installed
   ICU_VERSION=`"${PKG_CONFIG}" --modversion icu-uc$with_suffix_static`
   AC_MSG_RESULT($ICU_VERSION)

   # check for a suitable version
   AC_MSG_CHECKING(for ICU4C >= $ICU_VERSION_NEEDED)
   VERSION_CHECK=`expr $ICU_VERSION ">=" $ICU_VERSION_NEEDED`
   if test "$VERSION_CHECK" != "1" ; then
      AC_MSG_RESULT(no)
      return 1 # you may quit querying pkg-config here
   fi
   AC_MSG_RESULT(yes) # detected version of ICU4C is sufficient

   AC_MSG_CHECKING([for proper CPPFLAGS, LDFLAGS, and LIBS])
   ICU_CPPFLAGS=`"${PKG_CONFIG}" --cflags icu-uc$with_suffix_static \
      icu-i18n$with_suffix_static icu-io$with_suffix_static`" -DU_STATIC_IMPLEMENTATION"
   ICU_LDFLAGS=`"${PKG_CONFIG}" --libs-only-L icu-uc$with_suffix_static \
      icu-i18n$with_suffix_static icu-io$with_suffix_static`
   ICU_LIBS=`"${PKG_CONFIG}" --libs-only-l icu-uc$with_suffix_static \
      icu-i18n$with_suffix_static icu-io$with_suffix_static`
   AC_MSG_RESULT(done)

   ICU_FOUND=1 # DONE
   return 0
}

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
      echo "*** Make sure it is installed"
      return 1 # go back immediately
   fi

   # check if pkg-config knows about icu-uc
   AC_MSG_CHECKING(with pkg-config for ICU4C installed)
   if ! `"${PKG_CONFIG}" --exists icu-uc`; then
      # pkg config doesn't know about icu-uc
      AC_MSG_RESULT(no)
      echo "*** The pkg-config script did not detect ICU4C-devel libraries installed"
      echo "*** For more information check out the file stringi/INSTALL"
      return 1 # nothing more to do
   fi

   # check which version of ICU4C is installed
   ICU_VERSION=`"${PKG_CONFIG}" --modversion icu-uc`
   AC_MSG_RESULT($ICU_VERSION)

   # check for a suitable version
   AC_MSG_CHECKING(for ICU4C >= $ICU_VERSION_NEEDED)
   VERSION_CHECK=`expr $ICU_VERSION ">=" $ICU_VERSION_NEEDED`
   # this could also be done with pkg-config --atleast-pkgconfig-version=VERSION
   if test "$VERSION_CHECK" != "1" ; then
      AC_MSG_RESULT(no)
      echo "*** ICU4C ${ICU_VERSION} has been detected"
      echo "*** Minimal requirements, i.e. ICU4C >= ${ICU_VERSION_NEEDED}, are not met"
      echo "*** For more information check out the file stringi/INSTALL"
      return 1 # you may quit querying pkg-config here
   fi
   AC_MSG_RESULT(yes) # detected version of ICU4C is sufficient

   export PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 # always provide system -L
   if test $enable_prefer_static = "yes"; then
      AC_PROG_SED
      if test -z "${SED}"; then
         echo "*** Giving up trying to find ICU4C static libraries"
         echo "*** as egrep or sed does work sufficiently well"
      else
         AC_MSG_CHECKING(whether ICU4C may be statically linked by guessing .a names)
         icu_original_libs=`"${PKG_CONFIG}" --libs-only-l --static icu-uc icu-i18n icu-io`
         # GNU sed: -E is an undocumented option for compatibility 
         # with BSD sed, the same as -r
         icu_static_libs=`echo $icu_original_libs \
            | ${SED} -E "s/-licu(\S+|\"[^\"]+\")/-licu\1${with_suffix_static}/g"`
         icu_static_include=`"${PKG_CONFIG}" --cflags icu-uc icu-i18n icu-io`" -DU_STATIC_IMPLEMENTATION"
         icu_static_ldflags=`"${PKG_CONFIG}" --libs-only-L --static icu-uc icu-i18n icu-io`

         save_LIBS=$LIBS
         LIBS="${LIBS} ${icu_static_libs}"
         save_LDFLAGS=$LDFLAGS
         LDFLAGS="${LDFLAGS} ${icu_static_ldflags}"
         save_CPPFLAGS=$CPPFLAGS
         CPPFLAGS="${CPPFLAGS} ${icu_static_include}"
   
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
            ICU_CPPFLAGS=$icu_static_include
            ICU_LDFLAGS=$icu_static_ldflags
            ICU_LIBS=$icu_static_libs
            ICU_FOUND=1
         ],[AC_MSG_RESULT([no])])
   
         CPPFLAGS=$save_CPPFLAGS
         LDFLAGS=$save_LDFLAGS
         LIBS=$save_LIBS
   
         if test $ICU_FOUND = 1; then
            return 0 # nothing more to do
         fi
      fi
   fi

         #ICU_FOUND=1
         #return 0 # success

         #icu_lib_dirs=`echo $icu_libs_original \
         #   | ${EGREP} -E -o -e '-L(\S+|"[^"]+")' \
         #   | cut -c 3-`
         #icu_libs=`echo $icu_libs_original \
         #   | ${EGREP} -E -o -e '-licu(\S+|"[^"]+")' \
         #   | cut -c 3- \
         #   | ${SED} -E 's/(\S+)/lib\1.a/g'`
         ##echo $icu_lib_dirs
         ##echo $icu_libs
         #icu_static_libs=""
         #found=0
         #all=0
         #for l in $icu_libs; do
         #   ((all++)) # count libs
         #   for d in $icu_lib_dirs; do
         #      if test -f "${d}/${l}"; then
         #         icu_static_libs="${icu_static_libs} ${d}/${l}"
         #         ((found++)) # count found libs
         #         break # first match (if there are many)
         #      fi
         #   done
         #done
         #if test $found != $all; then
         #   AC_MSG_RESULT(no)
         #else
         #   AC_MSG_RESULT(yes)
         #
         #   AC_MSG_CHECKING(for proper ICU4C CPPFLAGS)
         #   ICU_FLAG_I=`"${PKG_CONFIG}" --cflags icu-uc icu-i18n icu-io`" -DU_STATIC_IMPLEMENTATION"
         #   AC_MSG_RESULT($ICU_FLAG_I)
         #
         #   AC_MSG_CHECKING(for proper ICU4C LDFLAGS (static libs))
         #   ICU_FLAG_L=$icu_static_libs
         #   #ICU_FLAG_L=`echo $icu_libs_original \
         #   #         | ${SED} -E 's/-licu(\S+|"[^"]+")//g'`" ${icu_static_libs}"
         #   AC_MSG_RESULT($ICU_FLAG_L)
         #
         #   ICU_FOUND=1
         #   return 0 # success
         #fi

   AC_MSG_CHECKING([for proper CPPFLAGS, LDFLAGS, and LIBS])
   ICU_CPPFLAGS=`"${PKG_CONFIG}" --cflags icu-uc icu-i18n icu-io`
   ICU_LDFLAGS=`"${PKG_CONFIG}" --libs-only-L icu-uc icu-i18n icu-io`
   ICU_LIBS=`"${PKG_CONFIG}" --libs-only-l icu-uc icu-i18n icu-io`
   AC_MSG_RESULT(done)

   ICU_FOUND=1 # DONE
   return 0
}



##### 2. Maybe it will just work : ICU4C auto-guess

detect_icu_with_guess() {
   if test $enable_icu_guess != "yes"; then
      # Use of icu-guess disabled, nothing to do
      return 1
   fi
  
   save_LIBS=$LIBS
   LIBS="${LIBS} $with_icu_libs"
      
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
      }])
   ],
   [
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
         }])
      ],[
         ICU_VERSION=`cat conftest.out`
         AC_MSG_RESULT($ICU_VERSION)

         AC_MSG_CHECKING(for ICU4C >= $ICU_VERSION_NEEDED)
         VERSION_CHECK=`expr $ICU_VERSION ">=" $ICU_VERSION_NEEDED`
         if test "$VERSION_CHECK" = "1" ; then
            AC_MSG_RESULT(yes)
            ICU_CPPFLAGS="" # leave defaults, this just works with-extra-cppflags
            ICU_LDFLAGS=""  # leave defaults, this just works with-extra-ldflags
            ICU_LIBS=$with_icu_libs # add given libs
            ICU_FOUND=1
         else
            AC_MSG_RESULT(no)
            echo "*** ICU4C ${ICU_VERSION} has been detected"
            echo "*** Minimal requirements, i.e. ICU4C >= ${ICU_VERSION_NEEDED}, are not met"
            echo "*** For more information check out the file stringi/INSTALL"
         fi
      ],[
         AC_MSG_RESULT([no]) # could not detect icu version
      ])
   ],[
      AC_MSG_RESULT([no]) # could not compile an ICU-based project
   ])
   
   LIBS=$save_LIBS # restore ldflags
}

# check for ICU

ICU_FOUND=0

if test $ICU_FOUND = 0; then
   detect_static_icu_with_pkg_config
fi

if test $ICU_FOUND = 0; then
   detect_icu_with_pkg_config
fi

if test $ICU_FOUND = 0; then
   detect_icu_with_guess
fi

if test $ICU_FOUND = 0; then
   echo "*** ICU4C-devel libraries cannot be found"
   echo "*** For more information check out the file stringi/INSTALL"
   exit 1
fi


##### CHECK FOR ICU HEADERS ####################################################

# AC_CONFIG_SRCDIR([src/stringi.cpp])
# AC_CONFIG_HEADER([src/stringi.h])

stringi_CXXFLAGS="${extra_CXXFLAGS}"
stringi_LIBS="${ICU_LDFLAGS} ${ICU_LIBS} ${extra_LDFLAGS}"
stringi_CPPFLAGS="${ICU_CPPFLAGS} ${extra_CPPFLAGS}"
stringi_CFLAGS="${extra_CFLAGS}"

if test "$enable_gcc_debug" == "yes"; then
   stringi_CXXFLAGS="${stringi_CXXFLAGS} -UNDEBUG"
   stringi_CFLAGS="${stringi_CFLAGS} -UNDEBUG"
fi

if test "$enable_gcc_pedantic" == "yes"; then
   stringi_CXXFLAGS="${stringi_CXXFLAGS} -Wall -Wextra -ansi -pedantic"
   stringi_CFLAGS="${stringi_CFLAGS} -Wall -Wextra -ansi -pedantic"
fi

AC_MSG_CHECKING([PKG_CXXFLAGS])
AC_SUBST(stringi_CXXFLAGS)
AC_MSG_RESULT($stringi_CXXFLAGS)

AC_MSG_CHECKING([PKG_CPPFLAGS])
AC_SUBST(stringi_CPPFLAGS)
AC_MSG_RESULT($stringi_CPPFLAGS)

AC_MSG_CHECKING([PKG_CFLAGS])
AC_SUBST(stringi_CFLAGS)
AC_MSG_RESULT($stringi_CFLAGS)

AC_MSG_CHECKING([PKG_LIBS])
AC_SUBST(stringi_LIBS)
AC_MSG_RESULT($stringi_LIBS)


AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
