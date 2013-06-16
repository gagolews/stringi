/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus
 * 
 * 'stringi' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * 'stringi' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.
 */
 
#include "stringi.h"


/** 
 * Create & set up an ICU Collator
 * 
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 * 
 * @param collator_opts named R list or NA
 * @return NULL if no collator is requested (iff collator_opts equals NA);
 * otherwise, a Collator object that should be closed with ucol_close()
 * after use
 * 
 * 
 * @version 0.1 (Marek Gagolewski)
 */
UCollator* stri__ucol_open(SEXP collator_opts)
{
   if (isVectorList(collator_opts)) {
      R_len_t narg = LENGTH(collator_opts);
      
      if (narg <= 0) { // no custom settings - Collator'll be default-as-hell
         UErrorCode err = U_ZERO_ERROR;
         UCollator* col = ucol_open(NULL, &err);
         if (!U_SUCCESS(err)) {
            error(MSG__RESOURCE_ERROR_GET);
         }
         return col;
      }
      
      SEXP names = getAttrib(collator_opts, R_NamesSymbol);
      if (names == R_NilValue || LENGTH(names) != narg)
         error(MSG__RESOURCE_ERROR_GET);
      
      // search for locale & create collator
      UErrorCode err = U_ZERO_ERROR;
      UCollator* col = NULL;
      for (R_len_t i=0; i<narg; ++i) {
         if (STRING_ELT(names, i) == NA_STRING)
            error(MSG__RESOURCE_ERROR_GET);
         const char* curname = CHAR(STRING_ELT(names, i));
         if (!strcmp(curname, "locale")) {
            const char* qloc = stri__prepare_arg_locale(VECTOR_ELT(collator_opts, i), "locale", true);
            col = ucol_open(qloc, &err);
            break;
         }
      }
      
      if (!col) col = ucol_open(NULL, &err); // default locale
      
      if (!U_SUCCESS(err)) {
         error(MSG__RESOURCE_ERROR_GET);
      }
      
      // other opts
      for (R_len_t i=0; i<narg; ++i) {
         if (STRING_ELT(names, i) == NA_STRING)
            error(MSG__RESOURCE_ERROR_GET);
            
         const char* curname = CHAR(STRING_ELT(names, i));
         err = U_ZERO_ERROR;
         
         if (!strcmp(curname, "locale")) {
            // ignore            
         } else if  (!strcmp(curname, "strength")) {
            SEXP val = stri_prepare_arg_integer_1(VECTOR_ELT(collator_opts, i), "strength");
            ucol_setAttribute(col, UCOL_STRENGTH, (UColAttributeValue)(INTEGER(val)[0]-1), &err);
         } else if  (!strcmp(curname, "alternate_shifted")) {
            SEXP val = stri_prepare_arg_string_1(VECTOR_ELT(collator_opts, i), "alternate_shifted");
            ucol_setAttribute(col, UCOL_ALTERNATE_HANDLING, LOGICAL(val)[0]?UCOL_SHIFTED:UCOL_NON_IGNORABLE, &err);
         } else if  (!strcmp(curname, "french")) {
            SEXP val = stri_prepare_arg_logical_1(VECTOR_ELT(collator_opts, i), "french");
            ucol_setAttribute(col, UCOL_CASE_FIRST,
               (LOGICAL(val)[0]==NA_LOGICAL?UCOL_OFF:(LOGICAL(val)[0]?UCOL_UPPER_FIRST:UCOL_LOWER_FIRST)), &err);
         } else if  (!strcmp(curname, "uppercase_first")) {
            bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(collator_opts, i), "uppercase_first");
            ucol_setAttribute(col, UCOL_ALTERNATE_HANDLING, val_bool?UCOL_ON:UCOL_OFF, &err);
         } else if  (!strcmp(curname, "case_level")) {
            bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(collator_opts, i), "case_level");
            ucol_setAttribute(col, UCOL_CASE_LEVEL, val_bool?UCOL_ON:UCOL_OFF, &err);
         } else if  (!strcmp(curname, "normalization")) {
            bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(collator_opts, i), "normalization");
            ucol_setAttribute(col, UCOL_NORMALIZATION_MODE, val_bool?UCOL_ON:UCOL_OFF, &err);
         } else if  (!strcmp(curname, "numeric")) {
            bool val_bool = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(collator_opts, i), "numeric");
            ucol_setAttribute(col, UCOL_NUMERIC_COLLATION, val_bool?UCOL_ON:UCOL_OFF, &err);
         } else {
            warning(MSG__INCORRECT_COLLATOR_OPTION, curname);
         }
         
         if (!U_SUCCESS(err)) {
            error(MSG__RESOURCE_ERROR_GET);
         }
      }

      return col;
   }
   else {
      // arg is not a list - is it a single NA then?
      collator_opts = stri_prepare_arg_logical_1(collator_opts, "collator_opts_not_list");
      if (LOGICAL(collator_opts)[0] != NA_LOGICAL)
         error(MSG__INCORRECT_INTERNAL_ARG);
      return NULL;
   }
}
