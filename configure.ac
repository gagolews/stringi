# kate: hl bash
# autoconf/configure script for stringi <https://stringi.gagolewski.com/>
# Copyright (c) 2013-2023, Marek Gagolewski <https://www.gagolewski.com/>

##### COMPATIBILITY NOTES/CHANGELOG ############################################

# 2014-04-10 R 3.1 CXX1X
# 2017-04-21 R 3.4 CXX11, CXX14, CXX17
# 2020-04-24 R 4.0 A C++ compiler must conform to C++11

# 2015-04-01 ICU 55.1 was supported on old Solaris boxes (until stringi-1.8.1)
# 2017-11-01 ICU 60.1 requires full C++11 support
# 2018-03-26 ICU 61.1 has U_CHARSET_IS_UTF8=1 set by default and has no C files
                      (minimal requirement since stringi-1.8.1)
# 2021-04-07 ICU 69.1 (bundled with stringi 1.6.1)
# 2023-10-31 ICU 74.1 (bundled with stringi 1.8.1,
    together with icudata; compressed with xz and included in the package
    source tarball as suggested by BR)
# 2024-04-xx ICU 75 will require C++17 (!)


# TODO: The standard way to use external libraries on macOS and Windows
# TODO: in R is via the corresponding toolchain. For macOS, it is built via
# TODO: recipes maintained by Simon Urbanek:
# TODO: https://github.com/R-macos/recipes/blob/master/recipes/icu

# TODO: For Windows, in the new toolchain, it is built by MXE
# TODO: (with changes for R maintained by Tomas Kalibera):
# TODO: https://github.com/mxe/mxe/blob/master/src/icu4c.mk
# TODO: https://svn.r-project.org/R-dev-web/trunk/WindowsBuilds/winutf8/ucrt3/toolchain_libs/mxe/src/icu4c.mk

# TODO: Contribute updates to ICU via these channels



##### INIT ####################################################################

AC_INIT([stringi], [1.8], [https://stringi.gagolewski.com/])

ICU_VERSION_NEEDED="61"  # minimal version of ICU4C required to build stringi
ICU_BUNDLE_VERSION="74"  # version of the ICU4C bundle shipped with stringi
ICUDT_DIR="icu${ICU_BUNDLE_VERSION}/data"

m4_ifndef([AC_CONFIG_MACRO_DIRS], [
    m4_defun([_AM_CONFIG_MACRO_DIRS], [])
    m4_defun([AC_CONFIG_MACRO_DIRS], [_AM_CONFIG_MACRO_DIRS($@)])
])
m4_include([tools/AC_CXX_HAVE_STL.m4])
m4_include([tools/AC_CXX_NAMESPACES.m4])


##### OPTIONS #################################################################

# shell variables/arguments accepted:
# R_HOME - R's home dir
AC_ARG_VAR(R_HOME, [Override the R directory,
    e.g., /usr/lib64/R, where /usr/lib64 is in the search path.
    Note that $R_HOME/bin/R should point to the R executable.])

AC_ARG_VAR([CAT], [The 'cat' command used for generating the list
    of source files to compile.])

AC_ARG_VAR([PKG_CONFIG], [The 'pkg-config' command to determine
    an appropriate build configuration for the system ICU.])

AC_ARG_VAR(PKG_CONFIG_PATH, [An optional list of directories to search for
    pkg-config's .pc files.])

#AC_ARG_VAR([CC], [(ignored)])

#AC_ARG_VAR([CFLAGS], [(ignored)])

#AC_ARG_VAR([CPP], [(ignored)])

AC_ARG_VAR([CPPFLAGS], [(ignored)])

AC_ARG_VAR([CXX], [(ignored)])

AC_ARG_VAR([CXXFLAGS], [(ignored)])

# AC_ARG_VAR([CXXCPP], [(ignored)])

AC_ARG_VAR([LDFLAGS], [(ignored)])

AC_ARG_VAR([LIBS], [(ignored)])



AC_ARG_ENABLE([icu_bundle],
    AS_HELP_STRING([--disable-icu-bundle],
        [Enforce system ICU.]))

AC_ARG_VAR([STRINGI_DISABLE_ICU_BUNDLE],
    [Enforce system ICU; see also --disable-icu-bundle.])

if test "x$enable_icu_bundle" != "xno" -a -z "${STRINGI_DISABLE_ICU_BUNDLE}"; then
    enable_icu_bundle="yes"
else
    enable_icu_bundle="no"
fi






AC_ARG_ENABLE([pkg_config],
    AS_HELP_STRING([--disable-pkg-config],
        [Disable locating the system ICU with 'pkg-config'; ICU4C will be
        compiled from sources (strongly recommended for portability
        across all the platforms).]))

AC_ARG_VAR([STRINGI_DISABLE_PKG_CONFIG],
    [Enforce our ICU source bundle; see also --disable-pkg-config.])

if test "x$enable_pkg_config" != "xno" -a -z "${STRINGI_DISABLE_PKG_CONFIG}"; then
    enable_pkg_config="yes"
else
    enable_pkg_config="no"
fi


AC_ARG_ENABLE([gcc_debug],
    AS_HELP_STRING([--enable-gcc-debug],
        [Enable -UNDEBUG when compiling stringi (for developers of stringi)]))

if test "x$enable_gcc_debug" = "xyes"; then
    enable_gcc_debug="yes"
else
    enable_gcc_debug="no"
fi


AC_ARG_ENABLE([gcc_pedantic],
    AS_HELP_STRING([--enable-gcc-pedantic],
        [Enable -Wall -Wextra -pedantic when compiling
        stringi with gcc/clang (for developers of stringi)]))

if test "x$enable_gcc_pedantic" = "xyes"; then
    enable_gcc_pedantic="yes"
else
    enable_gcc_pedantic="no"
fi


#AC_ARG_WITH([extra_cflags],
#    AS_HELP_STRING([--with-extra-cflags=FLAGS],
#        [Additional C compiler flags; see also the STRINGI_CFLAGS environment variable]))

AC_ARG_WITH([extra_cppflags],
    AS_HELP_STRING([--with-extra-cppflags=FLAGS],
        [Additional C/C++ preprocessor flags; see also the STRINGI_CPPFLAGS environment variable]))

AC_ARG_WITH([extra_cxxflags],
    AS_HELP_STRING([--with-extra-cxxflags=FLAGS],
        [Additional C++ compiler flags; see also the STRINGI_CXXFLAGS environment variable]))

AC_ARG_WITH([extra_ldflags],
    AS_HELP_STRING([--with-extra-ldflags=FLAGS],
        [Additional linker flags; see also the STRINGI_LDFLAGS environment variable]))

AC_ARG_WITH([extra_libs],
    AS_HELP_STRING([--with-extra-libs=FLAGS],
        [Additional libraries to link against; see also the STRINGI_LIBS environment variable]))

#AC_ARG_VAR([STRINGI_CFLAGS],
#    [Additional C compiler flags; see also --with-extra-cflags.])

AC_ARG_VAR([STRINGI_CPPFLAGS],
    [Additional C/C++ preprocessor flags; see also --with-extra-cppflags.])

AC_ARG_VAR([STRINGI_CXXFLAGS],
    [Additional C++ compiler flags; see also --with-extra-cxxflags.])

AC_ARG_VAR([STRINGI_LDFLAGS],
    [Additional linker flags; see also --with-extra-ldflags.])

AC_ARG_VAR([STRINGI_LIBS],
    [Additional libraries to link against; see also --with-extra-libs.])


with_extra_cppflags="${with_extra_cppflags} ${STRINGI_CPPFLAGS}"
with_extra_cxxflags="${with_extra_cxxflags} ${STRINGI_CXXFLAGS}"
with_extra_ldflags="${with_extra_ldflags} ${STRINGI_LDFLAGS}"
with_extra_libs="${with_extra_libs} ${STRINGI_LIBS}"

#####

MSG_CONFIG_FAIL="
*** *********************************************************************
*** 'stringi' cannot be built with the current settings in place.
*** See the INSTALL file for the solutions to the most common problems.
*** Moreover, explore the list of open and closed issues at
*** https://github.com/gagolews/stringi/issues
*** *********************************************************************
"


##### CHECK FOR R #############################################################

# this is inspired by the "Writing R Extensions" manual:
# determine R_HOME directory...
AC_MSG_CHECKING([for R_HOME])
if test -z "${R_HOME}"; then
    R_HOME=`R RHOME` # set R_HOME if it has not been set already
fi
if test -z "${R_HOME}"; then
    AC_MSG_RESULT(no)
    echo "*** Could not determine R_HOME. Is R installed?"
    exit 1
fi
AC_MSG_RESULT($R_HOME)
AC_SUBST(R_HOME)


# ...and then R_PATH
AC_MSG_CHECKING([for R])
R_PATH="${R_HOME}/bin/R" # see "Writing R Extensions"
if test ! -e "${R_PATH}"; then
    # if it was determined by calling `R RHOME`, then this is likely a bug
    AC_MSG_RESULT(no)
    echo "*** Could not find R at R_HOME/bin/R, i.e., ${R_HOME}/bin/R"
    exit 1
fi
AC_MSG_RESULT($R_PATH)


AC_MSG_CHECKING([for endianness])
"${R_PATH}" --vanilla --slave -e "if (.Platform\$endian!=\"little\") q(\"no\", 1, FALSE)"
if test $? -ne 0; then
    ICUDT_ENDIANNESS="big"
    AC_MSG_RESULT(big)
else
    ICUDT_ENDIANNESS="little"
    AC_MSG_RESULT(little)
fi



##### CHECK FOR CAT ############################################################

# Check for 'cat' and get full path.
AC_PATH_PROG([CAT],[cat],[])
if test "x$CAT" = "x"; then
    echo "*** The 'cat' command cannot be found."
    echo "*** Set the environment variable 'CAT' appropriately."
    exit 1
fi


###### SETUP COMPILER FLAGS FOR TESTING ########################################

if test "x$enable_gcc_debug" = "xyes"; then
    #  -fsanitize=address -fno-omit-frame-pointer
    with_extra_cppflags="${with_extra_cppflags} -DDEBUG -UNDEBUG"
else
    with_extra_cppflags="${with_extra_cppflags} -UDEBUG -DNDEBUG"
fi

if test "x$enable_gcc_pedantic" = "xyes"; then
    #with_extra_cflags="${with_extra_cflags} -Wall -Wextra -pedantic"
    with_extra_cxxflags="${with_extra_cxxflags} -Wall -Wextra -pedantic"
fi


################################################################################


### AUXILIARY FUNCTIONS ########################################################

enable_cxx11() {
    echo "*** Trying with C++11 compiler disabled."
    force_cxx11="yes"
    # unset cached C++ compiler features:
    unset ac_cv_cxx_compiler_gnu
    unset ac_cv_c_compiler_gnu
    unset ac_cv_prog_cxx_g
    unset ac_cv_prog_cc_g
    unset ac_cv_prog_cc_c89
    unset ac_cv_prog_CPP
    unset ac_cv_prog_CXX
    unset ac_cv_prog_CC
    unset ac_cv_header_stdc
    unset ac_cv_prog_ac_ct_CXX
    unset ac_cv_prog_ac_ct_CC
    unset ac_cv_cxx_namespaces
    unset ac_cv_cxx_have_stl
    unset ac_cv_objext
    return 0
}


# Basic C++ compiler checks: are long long type and stl data structures
# available? These are absolutely necessary to compile ICU>=55.
#
# If this is the case, return 0
check_cpp() {
    AC_LANG(C++)
    AC_PROG_CXX

    AC_MSG_CHECKING([whether the C++ compiler supports the 'long long' type])
    AC_LINK_IFELSE([AC_LANG_SOURCE([
        #include <iostream>
        using namespace std;

        int main() {
            long long x = 1;
            cout << x << endl;

            cout << 1LL << 1ULL << endl;
            cout << 9223372036854775807LL << 18446744073709551615ULL << endl;

            return 0;
        }
    ])],
    [
        AC_MSG_RESULT([yes])
    ],[
        AC_MSG_RESULT([no])
        return 1
    ])

    AC_CXX_HAVE_STL
    if test "$ac_cv_cxx_have_stl" = not; then
        return 1
    fi

    AC_MSG_CHECKING([whether std::map is available])
    AC_LINK_IFELSE([AC_LANG_SOURCE([
        #include <iostream>
        #include <map>
        #include <vector>
        #include <utility>

        int main() {
            std::map< int, std::vector< int > > curmap;
            std::vector<int> v1(10);
            curmap.insert(std::pair< int, std::vector< int > >(100, v1));
            std::cout << curmap.size() << std::endl;
            return 0;
        }
    ])],
    [
        AC_MSG_RESULT([yes])
    ],[
        AC_MSG_RESULT([no])
        return 1
    ])

    return 0
}  # end check_cpp()


detect_icu_with_pkg_config() {

    # Retrieve pkg-config's path
    AC_PATH_PROG(PKG_CONFIG, pkg-config, no,
        [$PATH:/usr/local/bin:/bin:/usr/bin:ext/bin:ext:/sw/bin:/opt/bin])

    if test ! -f "${PKG_CONFIG}"; then
        echo "*** 'pkg-config' not found"
        #echo "${MSG_CONFIG_FAIL}"
        return 1  # go back immediately
    fi

    # check if pkg-config knows about icu-i18n
    AC_MSG_CHECKING([with 'pkg-config' for the system ICU4C (icu-i18n icu-uc)])
    if ! `"${PKG_CONFIG}" --exists icu-i18n icu-uc`; then
        # pkg config doesn't know about icu-i18n
        AC_MSG_RESULT(no)
        echo "*** pkg-config did not detect ICU4C-devel libraries installed"
        #echo "${MSG_CONFIG_FAIL}"
        return 1 # nothing more to do
    fi

    # check which version of ICU4C is installed
    ICU_VERSION=`"${PKG_CONFIG}" --modversion icu-i18n`
    AC_MSG_RESULT($ICU_VERSION)

    # check for a suitable version
    AC_MSG_CHECKING([for ICU4C >= $ICU_VERSION_NEEDED])
    #VERSION_CHECK=`expr $ICU_VERSION ">=" $ICU_VERSION_NEEDED`
    #if test "$VERSION_CHECK" != "1" ; then
    if ! `"${PKG_CONFIG}" --atleast-version=${ICU_VERSION_NEEDED} icu-i18n icu-uc`; then
        AC_MSG_RESULT(no)
        echo "*** ICU4C ${ICU_VERSION} has been detected"
        echo "*** Minimal requirements, i.e., ICU4C >= ${ICU_VERSION_NEEDED}, are not met"
        #echo "${MSG_CONFIG_FAIL}"
        return 1 # you may quit querying pkg-config here
    fi
    AC_MSG_RESULT(yes) # detected version of ICU4C is sufficient

    export PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 # always provide system -L
    AC_MSG_CHECKING([for additional CPPFLAGS, LDFLAGS, and LIBS required])

    ICU_CPPFLAGS=`"${PKG_CONFIG}" --cflags icu-uc icu-i18n`
    ICU_LDFLAGS=`"${PKG_CONFIG}" --libs-only-L icu-uc icu-i18n`
    ICU_LIBS=`"${PKG_CONFIG}" --libs-only-l icu-uc icu-i18n`
    AC_MSG_RESULT(done)

    return 0
}  # end detect_icu_with_pkg_config()


check_icu_with_pkg_config() {
    CXXFLAGS="${with_extra_cxxflags} ${R_CXXPICFLAGS} ${R_CXXFLAGS}"
    CPPFLAGS="${with_extra_cppflags} ${ICU_CPPFLAGS} ${R_CPPFLAGS}"
    LDFLAGS="${with_extra_ldflags} ${ICU_LDFLAGS} ${R_LDFLAGS}"
    LIBS="${with_extra_libs} ${ICU_LIBS} ${R_LIBS}"

    AC_MSG_CHECKING([whether an ICU4C-based project can be built])
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
        }
    ])],
    [
        AC_MSG_RESULT([yes])
    ],[
        AC_MSG_RESULT([no])
        echo "*** This version of ICU4C cannot be used."
        #echo "${MSG_CONFIG_FAIL}"
        return 1
    ])

    AC_MSG_CHECKING([programmatically for sufficient U_ICU_VERSION_MAJOR_NUM])
    AC_LINK_IFELSE([AC_LANG_SOURCE([
        #include <unicode/uvernum.h>
        #if U_ICU_VERSION_MAJOR_NUM < ${ICU_VERSION_NEEDED}
        #error "insufficient U_ICU_VERSION_MAJOR_NUM"
        #endif

        int main() {
            return 0;
        }
    ])],
    [
        AC_MSG_RESULT([yes])
    ],[
        AC_MSG_RESULT([no])
        echo "*** This version of ICU4C cannot be used."
        #echo "${MSG_CONFIG_FAIL}"
        return 1
    ])

    AC_MSG_CHECKING([the capabilities of the ICU data library (ucnv, uloc, utrans)])
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
        #include <unicode/translit.h>
        #include <unicode/uclean.h>
        using namespace icu;

        int main() {
            UErrorCode status = U_ZERO_ERROR;
            u_init(&status);
            if (U_FAILURE(status)) {
                printf("ICU init failed: %s", u_errorName(status));
                return 10;
            }

            // check if we have some converters installed (icudt)
            int c = ucnv_countAvailable();
            if (c <= 0)
                return 11;

            // check if we have some locales defined (icudt)
            c = uloc_countAvailable();
            if (c <= 0)
                return 12;

            status = U_ZERO_ERROR;
            StringEnumeration* trans_enum = Transliterator::getAvailableIDs(status);
            if (!U_SUCCESS(status)) return 13;

            trans_enum->reset(status);
            if (!U_SUCCESS(status)) return 14;

            c = trans_enum->count(status);
            if (!U_SUCCESS(status)) return 15;
            if (c <= 0) return 16;

            delete trans_enum;
            return 0;
        }
    ])],
    [
        AC_MSG_RESULT([yes])
    ],[
        AC_MSG_RESULT([no])
        echo "*** The available ICU4C cannot be used."
        #echo "${MSG_CONFIG_FAIL}"
        return 1
    ])

    AC_MSG_CHECKING([the capabilities of the ICU data library (ucol)])
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
            UnicodeString a = UnicodeString::fromUTF8("hladny");
            UnicodeString b = UnicodeString::fromUTF8("chladny");

            UErrorCode status = U_ZERO_ERROR;
            Locale l = Locale::createFromName("sk_SK");
            Collator* c = Collator::createInstance(l, status);
            if (!U_SUCCESS(status))
                return 1;

            status = U_ZERO_ERROR;
            if (UCOL_GREATER != c->compare(a, b, status))
                return 2;
            if (!U_SUCCESS(status))
                return 3;

            delete c;
            return 0;
        }
    ])],
    [
        AC_MSG_RESULT([yes])
    ], [
        AC_MSG_RESULT([no])
        echo "*** The available ICU4C cannot be used."
        #echo "${MSG_CONFIG_FAIL}"
        return 1
    ])

    return 0
}  # end check_icu_with_pkg_config()


check_flags_icu_bundle() {
    # files are relative to src/ now, then we'll make it the current dir
    ICU_CPPFLAGS="\
        -Isrc/icu${ICU_BUNDLE_VERSION} \
        -Isrc/icu${ICU_BUNDLE_VERSION}/unicode \
        -Isrc/icu${ICU_BUNDLE_VERSION}/common \
        -Isrc/icu${ICU_BUNDLE_VERSION}/i18n \
        -DU_STATIC_IMPLEMENTATION \
        -DU_COMMON_IMPLEMENTATION \
        -DU_I18N_IMPLEMENTATION \
        -D_REENTRANT \
        -DUCONFIG_USE_LOCAL"  # but don't use uconfig_local yet, see below
        #-DU_HIDE_DRAFT_API
        #-DU_HIDE_DEPRECATED_API"
    ICU_LDFLAGS=""
    ICU_LIBS=""

    CXXFLAGS="${with_extra_cxxflags} ${R_CXXPICFLAGS} ${R_CXXFLAGS}"
    CPPFLAGS="${with_extra_cppflags} ${ICU_CPPFLAGS} ${R_CPPFLAGS} -UUCONFIG_USE_LOCAL"  # don't use uconfig_local yet
    LDFLAGS="${with_extra_ldflags} ${ICU_LDFLAGS} ${R_LDFLAGS}"
    LIBS="${with_extra_libs} ${ICU_LIBS} ${R_LIBS}"

    # NOTE: One way for dealing with the *Compiler or options invalid for pre-UNIX 03
    # X/Open applications and pre-2001 POSIX applications* error on Solaris
    # is to file a patch for sys/feature_tests.h. Unfortunately, the original
    # file is copyrighted, so we have to cope with this error in another way:
    # add the -D_XPG6 flag manually.

    AC_MSG_CHECKING([whether we may compile src/icu${ICU_BUNDLE_VERSION}/common/putil.cpp])
    AC_COMPILE_IFELSE([
        AC_LANG_SOURCE([`${CAT} src/icu${ICU_BUNDLE_VERSION}/common/putil.cpp`])
    ],
    [
        AC_MSG_RESULT([yes])
    ],[
        AC_MSG_RESULT([no])
        echo "*** The ICU4C bundle cannot be built."
        return 1
    ])

    AC_MSG_CHECKING([whether we may compile src/icu${ICU_BUNDLE_VERSION}/i18n/number_affixutils.cpp])
    AC_COMPILE_IFELSE([
        AC_LANG_SOURCE([`${CAT} src/icu${ICU_BUNDLE_VERSION}/i18n/number_affixutils.cpp`])
    ],
    [
        AC_MSG_RESULT([yes])
    ],[
        AC_MSG_RESULT([no])
        echo "*** The ICU4C bundle cannot be built."
        return 1
    ])

    if test ${ICU_BUNDLE_VERSION} -ge 69; then

        AC_MSG_CHECKING([whether alignof(std::max_align_t) is available])
        AC_LINK_IFELSE([AC_LANG_SOURCE([
            #include <iostream>
            #include <cstddef>
            int main() {
                std::cout << alignof(std::max_align_t) << std::endl;
                return 0;
            }
        ])],
        [
            AC_MSG_RESULT([yes])
        ],[
            AC_MSG_RESULT([no])

            CPPFLAGS="${with_extra_cppflags} -DSTRINGI_MAX_ALIGN_T_STD ${ICU_CPPFLAGS} ${R_CPPFLAGS} -UUCONFIG_USE_LOCAL"
            AC_MSG_CHECKING([whether alignof(::max_align_t) is available])
            AC_LINK_IFELSE([AC_LANG_SOURCE([
                #include <iostream>
                #include <cstddef>

                #ifdef __cplusplus
                #include <stddef.h>
                extern "C++"
                {
                    namespace std
                    {
                        using ::max_align_t;
                    }
                }
                #endif

                int main() {
                    std::cout << alignof(std::max_align_t) << std::endl;
                    return 0;
                }
            ])],
            [
                AC_MSG_RESULT([yes])
                with_extra_cppflags="${with_extra_cppflags} -DSTRINGI_MAX_ALIGN_T_STD"
            ],[
                AC_MSG_RESULT([no])
                echo "*** The ICU4C bundle cannot be built."
                return 1
            ])
        ])

    fi

    return 0
}  # end check_flags_icu_bundle()


################################################################################

force_cxx11="no"  # start by using the default 'CXX' compiler

while true; do
    # Step 1.  force_cxx11="no"
    # Step 2.  force_cxx11="yes"
    # Step 3.  Fail.

    LD=`"${R_PATH}" CMD config SHLIB_CXXLD`

    R_CPPFLAGS=`"${R_PATH}" CMD config CPPFLAGS`
    R_LIBS=
    R_LDFLAGS=


    if test $force_cxx11 = "no"; then
        STRINGI_CXXSTD=""

        CXX=`"${R_PATH}" CMD config CXX`

        R_CXXFLAGS=`"${R_PATH}" CMD config CXXFLAGS`
        R_CXXPICFLAGS=`"${R_PATH}" CMD config CXXPICFLAGS`
    else
        STRINGI_CXXSTD="CXX_STD=CXX11"

        CXX_tmp1=`"${R_PATH}" CMD config CXX11`
        CXX_tmp2=`"${R_PATH}" CMD config CXX11STD`
        CXX="${CXX_tmp1} ${CXX_tmp2}"

        R_CXXFLAGS=`"${R_PATH}" CMD config CXX11FLAGS`
        R_CXXPICFLAGS=`"${R_PATH}" CMD config CXX11PICFLAGS`
    fi


    CXXFLAGS="${with_extra_cxxflags} ${R_CXXFLAGS}"
    CPPFLAGS="${with_extra_cppflags} ${R_CPPFLAGS}"
    LDFLAGS="${with_extra_ldflags} ${R_LDFLAGS}"
    LIBS="${with_extra_libs} ${R_LIBS}"

    if ! check_cpp; then
        if test $force_cxx11 = "no"; then
            enable_cxx11
            continue
        else
            echo "${MSG_CONFIG_FAIL}"
            exit 1
        fi
    fi

    ##### CHECK FOR ICU4C ##########################################################

    ICU_FOUND=0
    if test $enable_pkg_config = "no"; then
        # Use of pkg-config disabled, nothing to do
        echo "*** System ICU4C has been disabled."
    else
        if ! detect_icu_with_pkg_config; then
            echo "*** Trying with 'standard' fallback flags"
            # (#238, #220) trying "standard" fallback flags
            ICU_CPPFLAGS=""
            ICU_LDFLAGS=""
            ICU_LIBS="-licui18n -licuuc -licudata"
        fi
        if check_icu_with_pkg_config; then
            ICU_FOUND=1  # success
        fi
    fi


    if test $ICU_FOUND = 1; then
        break  # all set!
    fi

    if test $enable_icu_bundle = "no"; then
        echo "*** *********************************************************************"
        echo "*** Failed to configure 'stringi' with the enforced use of the system ICU"
        echo "*** Consider installing, e.g., libicu-devel (RHEL, Fedora)"
        echo "*** or libicu-dev (Debian, Ubuntu) along with 'pkg-config'"
        if test $force_cxx11 = "no"; then
            enable_cxx11
            continue
        else
            echo "${MSG_CONFIG_FAIL}"
            exit 1
        fi
    fi

    echo "*** Using the ICU ${ICU_BUNDLE_VERSION} bundle that comes with 'stringi'."

    ICU_BUNDLE_OK=0
    if check_flags_icu_bundle; then
        ICU_BUNDLE_OK=1  # success
    fi

    if test $ICU_BUNDLE_OK = 1; then
        break  # all set!
    fi

    echo "*** Failed to configure package build with the ICU bundle usage."
    if test $force_cxx11 = "no"; then
        enable_cxx11
        continue
    else
        echo "${MSG_CONFIG_FAIL}"
        exit 1
    fi

done # end while


AC_CHECK_HEADER([elf.h], [
    with_extra_cppflags="${with_extra_cppflags} -DU_HAVE_ELF_H"
])


###### DOWNLOAD ICUDT (IF NEEDED) ##############################################

if test $ICU_FOUND = 0; then
    # There are systems with no internet access
    AC_MSG_CHECKING([whether the ICU data library is available])
    "${R_PATH}" --vanilla -s -e "setwd(\"src/\"); \
        source(\"../R/install.R\"); \
        if (identical(FALSE,stri_download_icudt(\"${ICUDT_DIR}\",${ICU_BUNDLE_VERSION}))) \
            stop(\"Stopping on error\")"
    if test $? -ne 0; then
        echo "*** *********************************************************************"
        echo "*** Failed to download the ICU data library (icudt). Stopping now."
        echo "*** For build environments that have no internet access,"
        echo "*** see the INSTALL file for a workaround."
        echo "*** *********************************************************************"
        exit 1
    fi
fi


##### PREPARE SOURCE FILES LISTS ###############################################

STRINGI_SOURCES_CPP=`${CAT} src/stri_cpp.txt`
AC_SUBST(STRINGI_SOURCES_CPP)

STRINGI_ICU_COMMON_SOURCES_CPP=`${CAT} src/icu${ICU_BUNDLE_VERSION}_common_cpp.txt`
AC_SUBST(STRINGI_ICU_COMMON_SOURCES_CPP)

STRINGI_ICU_I18N_SOURCES_CPP=`${CAT} src/icu${ICU_BUNDLE_VERSION}_i18n_cpp.txt`
AC_SUBST(STRINGI_ICU_I18N_SOURCES_CPP)

STRINGI_ICU_STUBDATA_SOURCES_CPP=`${CAT} src/icu${ICU_BUNDLE_VERSION}_stubdata_cpp.txt`
AC_SUBST(STRINGI_ICU_STUBDATA_SOURCES_CPP)


##### SETUP COMPILER 2 #########################################################

if test $ICU_FOUND = 0; then
    if test $enable_icu_bundle = "no"; then
        echo "*** *********************************************************************"
        echo "*** Failed to configure 'stringi' with the enforced use of the system ICU"
        echo "*** Consider installing, e.g., libicu-devel (RHEL, Fedora)"
        echo "*** or libicu-dev (Debian, Ubuntu) along with 'pkg-config'"
        echo "${MSG_CONFIG_FAIL}"
        exit 1
    fi

    # build ICU4C from sources
    STRINGI_OBJECTS="\$(STRI_OBJECTS) \$(ICU_COMMON_OBJECTS) \
        \$(ICU_I18N_OBJECTS) \$(ICU_STUBDATA_OBJECTS)"

    # replace all occurrences of -Isrc/* with -I* in ICU_CPPFLAGS via a rich man's 'sed' ;)
    ICU_CPPFLAGS=`"${R_PATH}" --vanilla -s -e "cat(gsub('-Isrc/', '-I', '${ICU_CPPFLAGS}', fixed=TRUE))"`
else
    # use system ICU4C
    STRINGI_OBJECTS="\$(STRI_OBJECTS)"
fi

STRINGI_CXXFLAGS="${with_extra_cxxflags} ${R_CXXPICFLAGS}"
STRINGI_CPPFLAGS="-I. ${with_extra_cppflags} ${ICU_CPPFLAGS}"
STRINGI_LDFLAGS="${with_extra_ldflags} ${ICU_LDFLAGS}"
STRINGI_LIBS="${with_extra_libs} ${ICU_LIBS}"

DISABLE_RESOLVE_LOCALE_NAME=1  # this does not apply on non-Windows platforms
AC_SUBST(DISABLE_RESOLVE_LOCALE_NAME)

AC_SUBST(STRINGI_OBJECTS)
AC_SUBST(STRINGI_CXXSTD)
#AC_SUBST(STRINGI_CFLAGS)
AC_SUBST(STRINGI_CXXFLAGS)
AC_SUBST(STRINGI_CPPFLAGS)
AC_SUBST(STRINGI_LDFLAGS)
AC_SUBST(STRINGI_LIBS)
AC_SUBST(ICU_FOUND)
AC_SUBST(ICUDT_DIR)
AC_SUBST(ICU_BUNDLE_VERSION)
AC_SUBST(ICUDT_ENDIANNESS)

# Remember to update the configure.win file too
AC_CONFIG_FILES([src/Makevars])
AC_CONFIG_FILES([src/uconfig_local.h])
AC_CONFIG_FILES([src/install.libs.R])

AC_OUTPUT

echo ""
echo "*** stringi configure summary:"
echo "    ICU_FOUND=${ICU_FOUND}"
if test $ICU_FOUND = 0; then
    echo "    ICUDT_DIR=${ICUDT_DIR}"
    echo "    ICU_BUNDLE_VERSION=${ICU_BUNDLE_VERSION}"
    echo "    ICUDT_ENDIANNESS=${ICUDT_ENDIANNESS}"
fi
echo "    STRINGI_CXXSTD=${STRINGI_CXXSTD}"
echo "    STRINGI_CXXFLAGS=${STRINGI_CXXFLAGS}"
echo "    STRINGI_CPPFLAGS=${STRINGI_CPPFLAGS}"
echo "    STRINGI_LDFLAGS=${STRINGI_LDFLAGS}"
echo "    STRINGI_LIBS=${STRINGI_LIBS}"
echo ""
echo "*** Compiler settings used:"
#echo "    CC=${CC}"
#echo "    CPP=${CPP}"
#echo "    CFLAGS=${CFLAGS}"
echo "    CXX=${CXX}"
echo "    LD=${LD}"
echo "    CXXFLAGS=${R_CXXFLAGS}"
echo "    CPPFLAGS=${R_CPPFLAGS}"
echo "    LDFLAGS=${R_LDFLAGS}"
echo "    LIBS=${R_LIBS}"
echo ""
