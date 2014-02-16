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


#include "stri_stringi.h"


/**
 * Create & set up an ICU Collator
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 * @param opts_collator named R list or NA
 * @return NULL if no collator is requested (iff opts_collator equals NA);
 * otherwise, a Collator object that should be closed with ucol_close()
 * after use
 *
 *
 * @version 0.1 (Marek Gagolewski)
 */
UCollator* stri__ucol_open(SEXP opts_collator)
{
   if (Rf_isVectorList(opts_collator)) {
      R_len_t narg = LENGTH(opts_collator);

      if (narg <= 0) { // no custom settings - Collator'll be default-as-hell
         UErrorCode err = U_ZERO_ERROR;
         UCollator* col = ucol_open(NULL, &err);
         if (U_FAILURE(err)) {
            Rf_error(MSG__RESOURCE_ERROR_GET); // error() allowed here
         }
         return col;
      }

      SEXP names = Rf_getAttrib(opts_collator, R_NamesSymbol);
      if (names == R_NilValue || LENGTH(names) != narg)
         Rf_error(MSG__RESOURCE_ERROR_GET); // error() allowed here

      // search for locale & create collator
      UErrorCode err = U_ZERO_ERROR;
      UCollator* col = NULL;
      for (R_len_t i=0; i<narg; ++i) {
         if (STRING_ELT(names, i) == NA_STRING)
            Rf_error(MSG__RESOURCE_ERROR_GET); // error() allowed here
         const char* curname = CHAR(STRING_ELT(names, i));
         if (!strcmp(curname, "locale")) {
            const char* qloc = stri__prepare_arg_locale(VECTOR_ELT(opts_collator, i), "locale", true);
            col = ucol_open(qloc, &err);
            break;
         }
      }

      if (!col) col = ucol_open(NULL, &err); // default locale

      if (U_FAILURE(err)) {
         Rf_error(MSG__RESOURCE_ERROR_GET); // error() allowed here
      }

      // other opts
      for (R_len_t i=0; i<narg; ++i) {
         if (STRING_ELT(names, i) == NA_STRING)
            Rf_error(MSG__RESOURCE_ERROR_GET); // error() allowed here

         const char* curname = CHAR(STRING_ELT(names, i));
         err = U_ZERO_ERROR;

         if (!strcmp(curname, "locale")) {
            // ignore
         } else if  (!strcmp(curname, "strength")) {
            SEXP val = stri_prepare_arg_integer_1(VECTOR_ELT(opts_collator, i), "strength");
            ucol_setAttribute(col, UCOL_STRENGTH, (UColAttributeValue)(INTEGER(val)[0]-1), &err);
         } else if  (!strcmp(curname, "alternate_shifted")) {
            SEXP val = stri_prepare_arg_string_1(VECTOR_ELT(opts_collator, i), "alternate_shifted");
            ucol_setAttribute(col, UCOL_ALTERNATE_HANDLING, LOGICAL(val)[0]?UCOL_SHIFTED:UCOL_NON_IGNORABLE, &err);
         } else if  (!strcmp(curname, "french")) {
            SEXP val = stri_prepare_arg_logical_1(VECTOR_ELT(opts_collator, i), "french");
            ucol_setAttribute(col, UCOL_CASE_FIRST,
               (LOGICAL(val)[0]==NA_LOGICAL?UCOL_OFF:(LOGICAL(val)[0]?UCOL_UPPER_FIRST:UCOL_LOWER_FIRST)), &err);
         } else if  (!strcmp(curname, "uppercase_first")) {
            bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "uppercase_first");
            ucol_setAttribute(col, UCOL_ALTERNATE_HANDLING, val_bool?UCOL_ON:UCOL_OFF, &err);
         } else if  (!strcmp(curname, "case_level")) {
            bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "case_level");
            ucol_setAttribute(col, UCOL_CASE_LEVEL, val_bool?UCOL_ON:UCOL_OFF, &err);
         } else if  (!strcmp(curname, "normalization")) {
            bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "normalization");
            ucol_setAttribute(col, UCOL_NORMALIZATION_MODE, val_bool?UCOL_ON:UCOL_OFF, &err);
         } else if  (!strcmp(curname, "numeric")) {
            bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_collator, i), "numeric");
            ucol_setAttribute(col, UCOL_NUMERIC_COLLATION, val_bool?UCOL_ON:UCOL_OFF, &err);
         } else {
            Rf_warning(MSG__INCORRECT_COLLATOR_OPTION, curname);
         }

         if (U_FAILURE(err)) {
            Rf_error(MSG__RESOURCE_ERROR_GET); // error() allowed here
         }
      }

      return col;
   }
   else {
      // arg is not a list - is it a single NA then?
      opts_collator = stri_prepare_arg_logical_1(opts_collator, "opts_collator_not_list");
      if (LOGICAL(opts_collator)[0] != NA_LOGICAL)
         Rf_error(MSG__INCORRECT_INTERNAL_ARG); // error() allowed here
      return NULL;
   }
}
