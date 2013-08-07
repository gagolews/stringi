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


/** Which string is ASCII-encoded
 *
 * simple check whether charcodes are in [1..127]
 * by using U8_IS_SINGLE
 *
 *  @param s character vector
 *  @return logical vector
 *
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_enc_isascii(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_length = LENGTH(str);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, str_length));
   int* ret_tab = LOGICAL(ret); // may be faster than LOGICAL(ret)[i] all the time

   for (R_len_t i=0; i < str_length; ++i) {
      SEXP str_cur = STRING_ELT(str, i);
      if (str_cur == NA_STRING) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }
      const char* str_cur_s = CHAR(str_cur);
      R_len_t str_cur_n = LENGTH(str_cur);
      ret_tab[i] = true;
      for (R_len_t j=0; j < str_cur_n; ++j) {
         if (!U8_IS_SINGLE(str_cur_s[j])) { // i.e. <= 127
            ret_tab[i] = false; // definitely not ASCII
            break;
         }
      }
   }

   UNPROTECT(1);
   return ret;
}




/** Which string is probably UTF-8-encoded
 *
 * simple check with U8_NEXT
 *
 *  @param s character vector
 *  @return logical vector
 *
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_enc_isutf8(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_length = LENGTH(str);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, str_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i=0; i < str_length; ++i) {
      SEXP str_cur = STRING_ELT(str, i);
      if (str_cur == NA_STRING){
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      const char* str_cur_s = CHAR(str_cur);
      R_len_t str_cur_n = LENGTH(str_cur);
      UChar32 c;
      ret_tab[i] = true;
      for (R_len_t j=0; j < str_cur_n; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, c);
         if (c < 0) { // ICU utf8.h doc for U8_NEXT: c -> output UChar32 variable, set to <0 in case of an error
            ret_tab[i] = false; // definitely not UTF-8
            break;
         }
      }
   }

   UNPROTECT(1);
   return ret;
}






/** Detect encoding and language
 * 
 * @param str character vector
 * @param filter_angle_brackets logical vector
 * 
 * @return list
 * 
 * @version 0.1 (2013-08-03) Marek Gagolewski
 */
SEXP stri_enc_detect(SEXP str, SEXP filter_angle_brackets)
{
   str = stri_prepare_arg_string(str, "str");
   filter_angle_brackets = stri_prepare_arg_logical(filter_angle_brackets, "filter_angle_brackets");
   
   UCharsetDetector* ucsdet = NULL;   
   STRI__ERROR_HANDLER_BEGIN
   UErrorCode status = U_ZERO_ERROR;
   ucsdet = ucsdet_open(&status);
   if (U_FAILURE(status)) throw StriException(status);
   
   R_len_t str_n = LENGTH(str);
   R_len_t vectorize_length = stri__recycling_rule(true, 2, str_n, LENGTH(filter_angle_brackets));
   
   SEXP ret, names, wrong;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));
   
   PROTECT(names = Rf_allocVector(STRSXP, 3));
   SET_STRING_ELT(names, 0, Rf_mkChar("Encoding"));
   SET_STRING_ELT(names, 1, Rf_mkChar("Language"));
   SET_STRING_ELT(names, 2, Rf_mkChar("Confidence"));
   
   PROTECT(wrong = Rf_allocVector(VECSXP, 3));
   SET_VECTOR_ELT(wrong, 0, stri__vector_NA_strings(1));
   SET_VECTOR_ELT(wrong, 1, stri__vector_NA_strings(1));
   SET_VECTOR_ELT(wrong, 2, stri__vector_NA_integers(1));
   Rf_setAttrib(wrong, R_NamesSymbol, names);

   StriContainerLogical filter(filter_angle_brackets, vectorize_length);
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (STRING_ELT(str, i%str_n) == NA_STRING || filter.isNA(i)) {
         SET_VECTOR_ELT(ret, i, wrong);
         continue;
      }
      
      const char* str_cur_s = CHAR(STRING_ELT(str, i%str_n));
      R_len_t str_cur_n = LENGTH(STRING_ELT(str, i%str_n));
      
      status = U_ZERO_ERROR;
      ucsdet_setText(ucsdet, str_cur_s, str_cur_n, &status);
		if (U_FAILURE(status)) throw StriException(status);
      ucsdet_enableInputFilter(ucsdet, filter.get(i));
      
      const UCharsetMatch* match = ucsdet_detect(ucsdet, &status);
		if (U_FAILURE(status)) {
         SET_VECTOR_ELT(ret, i, wrong);
         continue;
		}
      
      SEXP val;
      PROTECT(val = Rf_allocVector(VECSXP, 3));
      
      status = U_ZERO_ERROR;
      const char* name = ucsdet_getName(match, &status);
      if (U_FAILURE(status))
         SET_VECTOR_ELT(val, 0, stri__vector_NA_strings(1));
      else
         SET_VECTOR_ELT(val, 0, Rf_mkString(name));
      
      status = U_ZERO_ERROR;
 	   int32_t conf = ucsdet_getConfidence(match, &status);
      if (U_FAILURE(status))
         SET_VECTOR_ELT(val, 2, stri__vector_NA_integers(1));
      else
         SET_VECTOR_ELT(val, 2, Rf_ScalarInteger(conf));
      
      status = U_ZERO_ERROR;
 	   const char* lang = ucsdet_getLanguage(match, &status);
      if (U_FAILURE(status))
         SET_VECTOR_ELT(val, 1, stri__vector_NA_strings(1));
      else
         SET_VECTOR_ELT(val, 1, Rf_mkString(lang));
      
      Rf_setAttrib(val, R_NamesSymbol, names);
      SET_VECTOR_ELT(ret, i, val);
      UNPROTECT(1);
   }
   
   if (ucsdet) {
      ucsdet_close(ucsdet);
      ucsdet = NULL;  
   }
   UNPROTECT(3);
   return ret;

   STRI__ERROR_HANDLER_END(
      if (ucsdet) {
         ucsdet_close(ucsdet);
         ucsdet = NULL;  
      })
}


/** Detect encoding
 * 
 * @param str character vector
 * @param encodings character vector
 * @param characters character vector
 * 
 * @return list
 * 
 * @version 0.1 (2013-08-07) Marek Gagolewski
 */
SEXP stri_enc_detect2(SEXP str, SEXP encodings, SEXP characters)
{
   Rf_error("TO DO");
   return R_NilValue;
}

