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


#include "stri_stringi.h"
#include "stri_container_utf8.h"
#include <unicode/calendar.h>


/** Get current date-time
 *
 * @return POSIXct
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-29)
 */
SEXP stri_datetime_now()
{
   UDate now = Calendar::getNow();
   SEXP ret, cl;
   PROTECT(ret = Rf_ScalarReal(((double)now)/1000.0)); // msec.->sec.
   PROTECT(cl = Rf_allocVector(STRSXP, 3));
   SET_STRING_ELT(cl, 0, Rf_mkChar("StringiTime"));
   SET_STRING_ELT(cl, 1, Rf_mkChar("POSIXct"));
   SET_STRING_ELT(cl, 2, Rf_mkChar("POSIXt"));
   Rf_setAttrib(ret, R_ClassSymbol, cl);
   UNPROTECT(2);
   return ret;
}


/** Date-time artithmetic
 * 
 * @param time
 * @param delta
 * @param units
 * @param calendar
 *
 * @return POSIXct
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-29)
 */
SEXP stri_datetime_add(SEXP time, SEXP delta, SEXP units, SEXP calendar) {
   // to do: arg check
   Rf_error("TO DO");
   return time;
}

