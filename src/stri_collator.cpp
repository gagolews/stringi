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
#include <unicode/ucol.h>
#include <unicode/usearch.h>

/**
 * Create & set up an ICU Collator
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 * @param opts_collator named R list
 * @return a Collator object that should be closed with ucol_close() after use
 *
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-17)
 *          allow for NULL opts_collator (identical to list())
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-09)
 *          disallow NA as opts_collator
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc;
 *    + many other bugs in settings establishment
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-06)
 *    Fetch opts vals first to avoid memleaks (missing ucol_close calls on Rf_error)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-08)
 *    #23: add `overlap` option
 */
UCollator* stri__ucol_open(SEXP opts_collator)
{
   if (!isNull(opts_collator) && !Rf_isVectorList(opts_collator))
      Rf_error(MSG__INCORRECT_COLLATOR_OPTION_SPEC); // error() allowed here

   R_len_t narg = isNull(opts_collator)?0:LENGTH(opts_collator);

   if (narg <= 0) { // no custom settings - use default Collator
      UErrorCode status = U_ZERO_ERROR;
      UCollator* col = ucol_open(NULL, &status);
      STRI__CHECKICUSTATUS_RFERROR(status, {/* do nothing special on err */}) // error() allowed here
      return col;
   }

   SEXP names = Rf_getAttrib(opts_collator, R_NamesSymbol);
   if (names == R_NilValue || LENGTH(names) != narg)
      Rf_error(MSG__INCORRECT_COLLATOR_OPTION_SPEC); // error() allowed here

   /* First, let's fetch collator's options --
   this process may call Rf_error, so we cannot do uloc_open yet (memleaks!) */
   UColAttributeValue  opt_FRENCH_COLLATION = UCOL_DEFAULT;
   UColAttributeValue  opt_ALTERNATE_HANDLING = UCOL_DEFAULT;
   UColAttributeValue  opt_CASE_FIRST = UCOL_DEFAULT;
   UColAttributeValue  opt_CASE_LEVEL = UCOL_DEFAULT;
   UColAttributeValue  opt_NORMALIZATION_MODE = UCOL_DEFAULT;
   UColAttributeValue  opt_STRENGTH =  UCOL_DEFAULT_STRENGTH;
   UColAttributeValue  opt_NUMERIC_COLLATION = UCOL_DEFAULT;
//   USearchAttributeValue  opt_OVERLAP = USEARCH_OFF;
   const char*         opt_LOCALE = NULL;

   for (R_len_t i=0; i<narg; ++i) {
      if (STRING_ELT(names, i) == NA_STRING)
         Rf_error(MSG__INCORRECT_COLLATOR_OPTION_SPEC); // error() allowed here

      const char* curname = CHAR(STRING_ELT(names, i));
      if (!strcmp(curname, "locale")) {
         opt_LOCALE = stri__prepare_arg_locale(VECTOR_ELT(opts_collator, i), "locale", true); /* this is R_alloc'ed */
      } else if  (!strcmp(curname, "strength")) {
         int val = stri__prepare_arg_integer_1_notNA(VECTOR_ELT(opts_collator, i), "strength");
         if (val < (int)UCOL_PRIMARY + 1) val = (int)UCOL_PRIMARY + 1;
         else if (val > (int)UCOL_STRENGTH_LIMIT + 1) val = (int)UCOL_STRENGTH_LIMIT + 1;
         opt_STRENGTH = (UColAttributeValue)(val-1);
//      } else if  (!strcmp(curname, "overlap") && allow_overlap) {
//         bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "overlap");
//         opt_OVERLAP = (val_bool?USEARCH_ON:USEARCH_OFF);
      } else if  (!strcmp(curname, "alternate_shifted")) {
         bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "alternate_shifted");
         opt_ALTERNATE_HANDLING = (val_bool?UCOL_SHIFTED:UCOL_NON_IGNORABLE);
      } else if  (!strcmp(curname, "uppercase_first")) {
         SEXP val;
         PROTECT(val = stri_prepare_arg_logical_1(VECTOR_ELT(opts_collator, i), "uppercase_first"));
         opt_CASE_FIRST = (LOGICAL(val)[0]==NA_LOGICAL?UCOL_OFF:
                          (LOGICAL(val)[0]?UCOL_UPPER_FIRST:UCOL_LOWER_FIRST));
         UNPROTECT(1);
      } else if  (!strcmp(curname, "french")) {
         bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "french");
         opt_FRENCH_COLLATION = (val_bool?UCOL_ON:UCOL_OFF);
      } else if  (!strcmp(curname, "case_level")) {
         bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "case_level");
         opt_CASE_LEVEL = (val_bool?UCOL_ON:UCOL_OFF);
      } else if  (!strcmp(curname, "normalization")) {
         bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "normalization");
         opt_NORMALIZATION_MODE = (val_bool?UCOL_ON:UCOL_OFF);
      } else if  (!strcmp(curname, "numeric")) {
         bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "numeric");
         opt_NUMERIC_COLLATION = (val_bool?UCOL_ON:UCOL_OFF);
      } else {
         Rf_warning(MSG__INCORRECT_COLLATOR_OPTION, curname);
      }
   }

   // create collator
   UErrorCode status = U_ZERO_ERROR;
   UCollator* col = ucol_open(opt_LOCALE, &status);
   STRI__CHECKICUSTATUS_RFERROR(status, { /* nothing special on err */ }) // error() allowed here

   // set other opts
//   if (opt_OVERLAP != UCOL_OFF) {
//      status = U_ZERO_ERROR;
//      ucol_setAttribute(col, UCOL_OVERLAP, opt_OVERLAP, &status);
//      STRI__CHECKICUSTATUS_RFERROR(status, { ucol_close(col); }) // error() allowed here
//   }

   if (opt_STRENGTH != UCOL_DEFAULT) {
      status = U_ZERO_ERROR;
      ucol_setAttribute(col, UCOL_STRENGTH, opt_STRENGTH, &status);
      STRI__CHECKICUSTATUS_RFERROR(status, { ucol_close(col); }) // error() allowed here
   }

   if (opt_FRENCH_COLLATION != UCOL_DEFAULT) {
      status = U_ZERO_ERROR;
      ucol_setAttribute(col, UCOL_FRENCH_COLLATION, opt_FRENCH_COLLATION, &status);
      STRI__CHECKICUSTATUS_RFERROR(status, { ucol_close(col); }) // error() allowed here
   }

   if (opt_ALTERNATE_HANDLING != UCOL_DEFAULT) {
      status = U_ZERO_ERROR;
      ucol_setAttribute(col, UCOL_ALTERNATE_HANDLING, opt_ALTERNATE_HANDLING, &status);
      STRI__CHECKICUSTATUS_RFERROR(status, { ucol_close(col); }) // error() allowed here
   }

   if (opt_CASE_FIRST != UCOL_DEFAULT) {
      status = U_ZERO_ERROR;
      ucol_setAttribute(col, UCOL_CASE_FIRST, opt_CASE_FIRST, &status);
      STRI__CHECKICUSTATUS_RFERROR(status, { ucol_close(col); }) // error() allowed here
   }

   if (opt_CASE_LEVEL != UCOL_DEFAULT) {
      status = U_ZERO_ERROR;
      ucol_setAttribute(col, UCOL_CASE_LEVEL, opt_CASE_LEVEL, &status);
      STRI__CHECKICUSTATUS_RFERROR(status, { ucol_close(col); }) // error() allowed here
   }

   if (opt_NORMALIZATION_MODE != UCOL_DEFAULT) {
      status = U_ZERO_ERROR;
      ucol_setAttribute(col, UCOL_NORMALIZATION_MODE, opt_NORMALIZATION_MODE, &status);
      STRI__CHECKICUSTATUS_RFERROR(status, { ucol_close(col); }) // error() allowed here
   }

   if (opt_NUMERIC_COLLATION != UCOL_DEFAULT) {
      status = U_ZERO_ERROR;
      ucol_setAttribute(col, UCOL_NUMERIC_COLLATION, opt_NUMERIC_COLLATION, &status);
      STRI__CHECKICUSTATUS_RFERROR(status, { ucol_close(col); }) // error() allowed here
   }

   return col;
}
