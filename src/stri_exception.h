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


#define StriException_BUFSIZE 1024


#define STRI__ERROR_HANDLER_BEGIN(nprotect)                 \
   int __stri_protected_sexp_num = nprotect;                \
   char* __stri_error_msg = (char*)NULL;                    \
   try {

#define STRI__ERROR_HANDLER_END(cleanup)                    \
   }                                                        \
   catch (StriException e) {                                \
      cleanup;                                              \
      STRI__UNPROTECT_ALL                                   \
      /*don't do this, memleaks!: e.throwRerror();*/        \
      __stri_error_msg = R_alloc(StriException_BUFSIZE, 1); \
      strcpy(__stri_error_msg, e.getMessage());             \
      /*return R_NilValue;*/                                \
   }                                                        \
   /* call Rf_error here, when e is deleted, no memleaks */ \
   Rf_error(__stri_error_msg);                              \
   /* to avoid compiler warning: */                         \
   return R_NilValue;


#define STRI__PROTECT(s) {                                  \
   PROTECT(s);                                              \
   ++__stri_protected_sexp_num; }

#ifndef NDEBUG
#define STRI__UNPROTECT(n) {                                \
   UNPROTECT(n);                                            \
   if (n > __stri_protected_sexp_num)                       \
      Rf_warning("STRI__UNPROTECT: stack imbalance!");      \
   __stri_protected_sexp_num -= n; }
#else
#define STRI__UNPROTECT(n) {                                \
   UNPROTECT(n);                                            \
   __stri_protected_sexp_num -= n; }
#endif

#define STRI__UNPROTECT_ALL {                               \
   UNPROTECT(__stri_protected_sexp_num);                    \
   __stri_protected_sexp_num = 0; }


#define STRI__CHECKICUSTATUS_THROW(status, onerror) {       \
   if (U_FAILURE(status)) {                                 \
      onerror;                                              \
      throw StriException(status);                          \
   }                                                        \
   else if (status <= U_ERROR_WARNING_LIMIT && status > U_USING_DEFAULT_WARNING) { \
      Rf_warning(MSG__ICU_WARNING,                          \
         StriException::getICUerrorName(status),            \
         u_errorName(status));                              \
   }                                                        \
}


#define STRI__CHECKICUSTATUS_RFERROR(status, onerror) {     \
   if (U_FAILURE(status)) {                                 \
      onerror;                                              \
      Rf_error(MSG__ICU_ERROR,                              \
         StriException::getICUerrorName(status),            \
         u_errorName(status));                              \
   }                                                        \
   else if (status <= U_ERROR_WARNING_LIMIT && status > U_USING_DEFAULT_WARNING) { \
      Rf_warning(MSG__ICU_WARNING,                          \
         StriException::getICUerrorName(status),            \
         u_errorName(status));                              \
   }                                                        \
}


/**
 * A class representing exceptions
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-18)
 *          do not use R_alloc for msg
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

   const char* getMessage() const {
      return msg;
   }

   static const char* getICUerrorName(UErrorCode status);
};

#endif
