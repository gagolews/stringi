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
#include "stri_ucnv.h"


/**
 * Sets current (default) ICU charset
 *
 * If given charset is unavailable, an error is raised
 *
 * @param enc new charset (single string)
 * @return nothing (\code{R_NilValue})
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski)
 *          use StriUcnv; make StriException-friendly
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_set(SEXP enc)
{
   // here, the default encoding may not be requested:
   const char* selected_enc
      = stri__prepare_arg_enc(enc, "enc", false/*no default*/); /* this is R_alloc'ed */

   STRI__ERROR_HANDLER_BEGIN(0)

   StriUcnv uconv_obj(selected_enc);
   // this will generate an error if selected_enc is not supported:
   UConverter* uconv = uconv_obj.getConverter();

   UErrorCode status = U_ZERO_ERROR;
   // get "official" encoding name:
   const char* name = ucnv_getName(uconv, &status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   ucnv_setDefaultName(name); // set as default

   return R_NilValue;

   STRI__ERROR_HANDLER_END({/* no special action on error */})
}


/**
 * Get all available ICU charsets and their aliases (elems 2,3,...)
 *
 * @return R list object; element name == ICU charset canonical name;
 * elements are character vectors (aliases)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski)
 *          use StriUcnv; make StriException-friendly
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_list()
{
   R_len_t c = (R_len_t)ucnv_countAvailable();

   STRI__ERROR_HANDLER_BEGIN(0)
   SEXP ret;
   SEXP names;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, c));
   STRI__PROTECT(names = Rf_allocVector(STRSXP, c));

   for (R_len_t i=0; i<c; ++i) {
      const char* canonical_name = ucnv_getAvailableName(i);
      if (!canonical_name) {
         SET_STRING_ELT(names, i, NA_STRING);
         continue;
      }

      SET_STRING_ELT(names, i, Rf_mkChar(canonical_name));

      UErrorCode status = U_ZERO_ERROR;
      R_len_t ci = (R_len_t)ucnv_countAliases(canonical_name, &status);
      if (U_FAILURE(status) || ci <= 0)
         SET_VECTOR_ELT(ret, i, Rf_ScalarString(NA_STRING));
      else {
         SEXP aliases;
         STRI__PROTECT(aliases = Rf_allocVector(STRSXP, ci));
         for (R_len_t j=0; j<ci; ++j) {
            status = U_ZERO_ERROR;
            const char* alias = ucnv_getAlias(canonical_name, j, &status);
            if (U_FAILURE(status) || !alias)
               SET_STRING_ELT(aliases, j, NA_STRING);
            else
               SET_STRING_ELT(aliases, j, Rf_mkChar(alias));
         }
         SET_VECTOR_ELT(ret, i, aliases);
         STRI__UNPROTECT(1);
      }
   }

   Rf_setAttrib(ret, R_NamesSymbol, names);
   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({/* no special action on error */})
}


/** Fetch information on an encoding
 *
 * @param enc either NULL or "" for default encoding,
 *        or one string with encoding name
 * @return R list object with many components (see R doc for details)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski)
 *          use StriUcnv; make StriException-friendly
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_info(SEXP enc)
{
   const char* selected_enc = stri__prepare_arg_enc(enc, "enc", true/*default ok*/); /* this is R_alloc'ed */

   STRI__ERROR_HANDLER_BEGIN(0)
   StriUcnv uconv_obj(selected_enc);
   //uconv_obj.setCallBackSubstitute(); // restore default callbacks (no warning)
   UConverter* uconv = uconv_obj.getConverter(false);
   UErrorCode status = U_ZERO_ERROR;

   // get the list of available standards
   vector<const char*> standards = StriUcnv::getStandards();
   R_len_t standards_n = (R_len_t)standards.size();

   // alloc output list
   SEXP vals;
   SEXP names;
   const int nval = standards_n+2+5;
   STRI__PROTECT(names = Rf_allocVector(STRSXP, nval));
   SET_STRING_ELT(names, 0, Rf_mkChar("Name.friendly"));
   SET_STRING_ELT(names, 1, Rf_mkChar("Name.ICU"));
   for (R_len_t i=0; i<standards_n; ++i) {
      if (standards[i])
         SET_STRING_ELT(names, i+2, Rf_mkChar((string("Name.")+standards[i]).c_str()));
   }
   SET_STRING_ELT(names, nval-5, Rf_mkChar("ASCII.subset"));
   SET_STRING_ELT(names, nval-4, Rf_mkChar("Unicode.1to1"));
   SET_STRING_ELT(names, nval-3, Rf_mkChar("CharSize.8bit"));
   SET_STRING_ELT(names, nval-2, Rf_mkChar("CharSize.min"));
   SET_STRING_ELT(names, nval-1, Rf_mkChar("CharSize.max"));

   STRI__PROTECT(vals = Rf_allocVector(VECSXP, nval));


   // get canonical (ICU) name
   status = U_ZERO_ERROR;
   const char* canname = ucnv_getName(uconv, &status);
   if (U_FAILURE(status) || !canname) {
      SET_VECTOR_ELT(vals, 1, Rf_ScalarString(NA_STRING));
      Rf_warning(MSG__ENC_ERROR_GETNAME);
   }
   else {
      SET_VECTOR_ELT(vals, 1, Rf_mkString(canname));

      // friendly name
      const char* frname = StriUcnv::getFriendlyName(canname);
      if (frname)  SET_VECTOR_ELT(vals, 0, Rf_mkString(frname));
      else         SET_VECTOR_ELT(vals, 0, Rf_ScalarString(NA_STRING));

      // has ASCII as its subset?
      SET_VECTOR_ELT(vals, nval-5, Rf_ScalarLogical((int)uconv_obj.hasASCIIsubset()));

      // min,max character size, is 8bit?
      int mincharsize = (int)ucnv_getMinCharSize(uconv);
      int maxcharsize = (int)ucnv_getMaxCharSize(uconv);
      int is8bit = (mincharsize==1 && maxcharsize == 1);
      SET_VECTOR_ELT(vals, nval-3, Rf_ScalarLogical(is8bit));
      SET_VECTOR_ELT(vals, nval-2, Rf_ScalarInteger(mincharsize));
      SET_VECTOR_ELT(vals, nval-1, Rf_ScalarInteger(maxcharsize));

      // is there a one-to-one correspondence with Unicode?
      if (!is8bit)
         SET_VECTOR_ELT(vals, nval-4, Rf_ScalarLogical(NA_LOGICAL));
      else
         SET_VECTOR_ELT(vals, nval-4, Rf_ScalarLogical((int)uconv_obj.is1to1Unicode()));

      // other standard names
      for (R_len_t i=0; i<standards_n; ++i) {
         if (!standards[i]) continue;

         status = U_ZERO_ERROR;
         const char* stdname = ucnv_getStandardName(canname, standards[i], &status);
         if (U_FAILURE(status) || !stdname)
            SET_VECTOR_ELT(vals, i+2, Rf_ScalarString(NA_STRING));
         else
            SET_VECTOR_ELT(vals, i+2, Rf_mkString(stdname));
      }
   }
   Rf_setAttrib(vals, R_NamesSymbol, names);
   STRI__UNPROTECT_ALL
   return vals;

   STRI__ERROR_HANDLER_END({/* no special action on error */})
}


/** Get Declared Encodings of Each String
 *
 * @param str a character vector or an object coercible to
 * @return a character vector
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-25)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_mark(SEXP str) {
   PROTECT(str = stri_prepare_arg_string(str, "str"));    // prepare string argument

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_len = LENGTH(str);

   // some of them will not be used in this call, but we're lazy
   SEXP mark_ascii, mark_latin1, mark_utf8, mark_native, mark_bytes;
   STRI__PROTECT(mark_ascii  = Rf_mkChar("ASCII"));
   STRI__PROTECT(mark_latin1 = Rf_mkChar("latin1"));
   STRI__PROTECT(mark_utf8   = Rf_mkChar("UTF-8"));
   STRI__PROTECT(mark_native = Rf_mkChar("native"));
   STRI__PROTECT(mark_bytes  = Rf_mkChar("bytes"));

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, str_len));

   for (R_len_t i=0; i<str_len; ++i) {
      SEXP curs = STRING_ELT(str, i);
      if (curs == NA_STRING) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      if (IS_ASCII(curs))
         SET_STRING_ELT(ret, i, mark_ascii);
      else if (IS_UTF8(curs))
         SET_STRING_ELT(ret, i, mark_utf8);
      else if (IS_BYTES(curs))
         SET_STRING_ELT(ret, i, mark_bytes);
      else if (IS_LATIN1(curs))
         SET_STRING_ELT(ret, i, mark_latin1);
      else
         SET_STRING_ELT(ret, i, mark_native);
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
