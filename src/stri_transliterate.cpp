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
#include "stri_container_utf16.h"
#include <unicode/translit.h>
#include <string>


/** List available transliterators
 * 
 * @return character vector
 * 
 * @version 0.2-2 (Marek Gagolewski, 2014-04-19)
 */
SEXP stri_trans_list()
{
   STRI__ERROR_HANDLER_BEGIN
   int32_t n = Transliterator:: countAvailableIDs();
   SEXP ret, names;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, n));
//   STRI__PROTECT(names = Rf_allocVector(STRSXP, n));
   
   
   // MG: I reckon than IDs are more readable than DisplayNames
   for (R_len_t i=0; i<n; ++i) {
      UnicodeString id = Transliterator::getAvailableID(i);
//      UnicodeString name;
//      Transliterator::getDisplayName(id, name);
      std::string /*nameutf8, */idutf8;
//      name.toUTF8String(nameutf8);
      id.toUTF8String(idutf8);
//      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(nameutf8.c_str(), nameutf8.length(), CE_UTF8));
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(idutf8.c_str(), idutf8.length(), CE_UTF8));
   }
   
//   Rf_setAttrib(ret, R_NamesSymbol, names);
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({/* no op on err */})
}


/** General text transform with ICU Transliterator
 * 
 * @param str character vector
 * @param id single string
 * @return character vector
 * 
 * @version 0.2-2 (Marek Gagolewski, 2014-04-19)
 */
SEXP stri_trans_general(SEXP str, SEXP id)
{
   Rf_error("t.b.d.");
   return R_NilValue;
}
