/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#ifndef uconfig_local_h
#define uconfig_local_h

#define U_DISABLE_RENAMING 1



/* localtime_r is not a C++98 nor C99 function: it is POSIX.  Solaris has
   it, but only for C (thanks to Kurt Hornik for pointing this out) */
#if U_PLATFORM == U_PF_SOLARIS || defined(__SUNPRO_CC)
/*extern struct tm *localtime_r(const time_t *, struct tm *); */
#ifndef _REENTRANT
#define _REENTRANT 1
#endif

/* avoid including Solaris's feature_tests.h
   this conflicts with R's --std compile flags;
   this is the same hack as in
   http://www.opensource.apple.com/source/zfs/zfs-59/zfs_common/sys/feature_tests.h
   or in
   http://code.metager.de/source/xref/NetBSD/src/external/cddl/osnet/sys/sys/feature_tests.h
*/
#ifndef _SYS_FEATURE_TESTS_H
#define _SYS_FEATURE_TESTS_H
#endif
#endif


#endif
