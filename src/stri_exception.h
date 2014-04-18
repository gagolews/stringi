/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#ifndef __stri_exception_h
#define __stri_exception_h

#include <cstdarg>
using namespace std;


#define STRI__ERROR_HANDLER_BEGIN        \
   int __stri_protected_sexp_num = 0;    \
   try {

#define STRI__ERROR_HANDLER_END(cleanup) \
   }                                     \
   catch (StriException e) {             \
      cleanup;                           \
      STRI__UNPROTECT_ALL                \
      e.throwRerror();                   \
      /* to avoid compiler warning: */   \
      return R_NilValue;                 \
   }


#define STRI__PROTECT(s) {               \
   PROTECT(s);                           \
   ++__stri_protected_sexp_num; }

#ifndef NDEBUG
#define STRI__UNPROTECT(n) {             \
   UNPROTECT(n);                         \
   if (n > __stri_protected_sexp_num)    \
      Rf_warning("STRI__UNPROTECT: stack imbalance!"); \
   __stri_protected_sexp_num -= n; }
#else
#define STRI__UNPROTECT(n) {             \
   UNPROTECT(n);                         \
   __stri_protected_sexp_num -= n; }
#endif

#define STRI__UNPROTECT_ALL {            \
   UNPROTECT(__stri_protected_sexp_num); \
   __stri_protected_sexp_num = 0; }


#define StriException_BUFSIZE 1024


/**
 * A class representing exceptions
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 * 
 * @version 0.2-1 (Marek Gagolewski, 2014-04-18)
 *          do not use Rf_alloc for msg
 */
class StriException {

private:

   char msg[StriException_BUFSIZE]; ///< message to be passed to error()

public:

   StriException(const char* format, ...) {
      va_list args;
      va_start(args, format);
      vsprintf(msg, format, args);
      va_end(args);
   }

   StriException(UErrorCode status) {
      sprintf(msg, MSG__ICU_ERROR, getICUerrorName(status), u_errorName(status));
   }


   void throwRerror() {
      Rf_error(msg);
   }

   static const char* getICUerrorName(UErrorCode status);

};

#endif
