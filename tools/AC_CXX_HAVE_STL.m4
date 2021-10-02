dnl
dnl AC_CXX_HAVE_STL
dnl
dnl Description
dnl
dnl  If the compiler supports the Standard Template Library, define HAVE_STL.
dnl
dnl Version: 1.2.1 (last modified: 2021-10-02)
dnl Author: Luc Maisonobe
dnl
dnl from http://www.gnu.org/software/ac-archive/htmldoc/index.html
dnl
dnl License:
dnl GNU General Public License
dnl [http://www.gnu.org/software/ac-archive/htmldoc/COPYING.html]
dnl with this special exception
dnl [http://www.gnu.org/software/ac-archive/htmldoc/COPYING-Exception.html].


dnl Marek's 2021-10-02 update: replace obsolete AC_TRY_COMPILE, AC_LANG_CPLUSPLUS


AC_DEFUN([AC_CXX_HAVE_STL],
[AC_CACHE_CHECK(whether the compiler supports the Standard Template Library,
ac_cv_cxx_have_stl,
[AC_REQUIRE([AC_CXX_NAMESPACES])
 AC_LANG_SAVE
 AC_LANG([C++])
 AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <list>
#include <deque>
#ifdef HAVE_NAMESPACES
using namespace std;
#endif]],[[list<int> x; x.push_back(5);
list<int>::iterator iter = x.begin(); if (iter != x.end()) ++iter; return 0;]])],
 [ac_cv_cxx_have_stl=yes], [ac_cv_cxx_have_stl=no])
 AC_LANG_RESTORE
])
if test "$ac_cv_cxx_have_stl" = yes; then
  AC_DEFINE(HAVE_STL,,[define if the compiler supports Standard Template Library])
fi
])
