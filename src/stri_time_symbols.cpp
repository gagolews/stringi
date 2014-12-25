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
#include <unicode/strenum.h>
#include <unicode/dtfmtsym.h>
#include <string>


/** List Localizable Date-Time Formatting Data 
 *
 * @param locale single string or NULL
 * @param context single string
 * @param width single string
 * @return list
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-25)
 */
SEXP stri_datetime_symbols(SEXP locale, SEXP context, SEXP width) {
   const char* qloc = stri__prepare_arg_locale(locale, "locale", true); /* this is R_alloc'ed */
   
   const char* context_str = stri__prepare_arg_string_1_notNA(context, "context");
   const char* context_opts[] = {"format", "standalone", NULL};
   int context_cur = stri__match_arg(context_str, context_opts);
   
   const char* width_str = stri__prepare_arg_string_1_notNA(width, "width");
   const char* width_opts[] = {"abbreviated", "wide", "narrow", NULL};
   int width_cur = stri__match_arg(width_str, width_opts);
   
   DateFormatSymbols::DtContextType context_val = DateFormatSymbols::STANDALONE;
   if (context_cur == 0)            context_val = DateFormatSymbols::FORMAT;
   
   DateFormatSymbols::DtWidthType width_val = DateFormatSymbols::WIDE;
        if (width_cur == 0)       width_val = DateFormatSymbols::ABBREVIATED;
   else if (width_cur == 2)       width_val = DateFormatSymbols::NARROW;
   
   UErrorCode status = U_ZERO_ERROR;
   DateFormatSymbols sym(Locale::createFromName(qloc), status);
   STRI__CHECKICUSTATUS_RFERROR(status, {/* do nothing special on err */})
   
   const R_len_t infosize = 5;
   SEXP vals;
   R_len_t j = -1;

   PROTECT(vals = Rf_allocVector(VECSXP, infosize));
   for (int i=0; i<infosize; ++i)
      SET_VECTOR_ELT(vals, i, R_NilValue);
      
   int32_t count;
   const UnicodeString* ret;
     
     
   // getMonths
   ++j;
   ret = sym.getMonths(count, context_val, width_val); //  (DateFormatSymbols retains ownership.) 
   SET_VECTOR_ELT(vals, j, Rf_allocVector(STRSXP, count));
   for (int32_t i=0; i<count; ++i) {
      std::string out;
      ret[i].toUTF8String(out);
      SET_STRING_ELT(VECTOR_ELT(vals, j), i, Rf_mkCharCE(out.c_str(), CE_UTF8));
   }
   
   // getWeekdays
   ++j;
   ret = sym.getWeekdays(count, context_val, width_val); //  (DateFormatSymbols retains ownership.) 
   if (count > 0 && ret[0].length() == 0) { // this always(?) returns an emty string at the beginning
      --count;
      ++ret;
   }
   SET_VECTOR_ELT(vals, j, Rf_allocVector(STRSXP, count));
   for (int32_t i=0; i<count; ++i) {
      std::string out;
      ret[i].toUTF8String(out);
      SET_STRING_ELT(VECTOR_ELT(vals, j), i, Rf_mkCharCE(out.c_str(), CE_UTF8));
   }
   
   // getQuarters
   ++j;
   ret = sym.getQuarters(count, context_val, width_val); //  (DateFormatSymbols retains ownership.) 
   SET_VECTOR_ELT(vals, j, Rf_allocVector(STRSXP, count));
   for (int32_t i=0; i<count; ++i) {
      std::string out;
      ret[i].toUTF8String(out);
      SET_STRING_ELT(VECTOR_ELT(vals, j), i, Rf_mkCharCE(out.c_str(), CE_UTF8));
   }
   
   // getAmPmStrings
   ++j;
   ret = sym.getAmPmStrings(count); //  (DateFormatSymbols retains ownership.) 
   SET_VECTOR_ELT(vals, j, Rf_allocVector(STRSXP, count));
   for (int32_t i=0; i<count; ++i) {
      std::string out;
      ret[i].toUTF8String(out);
      SET_STRING_ELT(VECTOR_ELT(vals, j), i, Rf_mkCharCE(out.c_str(), CE_UTF8));
   }
   
   // getEra
   ++j;
   if (width_val == DateFormatSymbols::WIDE)
      ret = sym.getEraNames(count);
   else if (width_val == DateFormatSymbols::ABBREVIATED)
      ret = sym.getEras(count);
   else
      ret = sym.getNarrowEras(count);
   SET_VECTOR_ELT(vals, j, Rf_allocVector(STRSXP, count));
   for (int32_t i=0; i<count; ++i) {
      std::string out;
      ret[i].toUTF8String(out);
      SET_STRING_ELT(VECTOR_ELT(vals, j), i, Rf_mkCharCE(out.c_str(), CE_UTF8));
   }
   
//   // getYearNames -- ICU54 draft
//   ++j;
//   ret = sym.getYearNames(count, context_val, width_val); //  (DateFormatSymbols retains ownership.) 
//   SET_VECTOR_ELT(vals, j, Rf_allocVector(STRSXP, count));
//   for (int32_t i=0; i<count; ++i) {
//      std::string out;
//      ret[i].toUTF8String(out);
//      SET_STRING_ELT(VECTOR_ELT(vals, j), i, Rf_mkCharCE(out.c_str(), CE_UTF8));
//   }
   
//   // getZodiacNames -- ICU54 draft
//   ++j;
//   ret = sym.getZodiacNames(count, context_val, width_val); //  (DateFormatSymbols retains ownership.) 
//   SET_VECTOR_ELT(vals, j, Rf_allocVector(STRSXP, count));
//   for (int32_t i=0; i<count; ++i) {
//      std::string out;
//      ret[i].toUTF8String(out);
//      SET_STRING_ELT(VECTOR_ELT(vals, j), i, Rf_mkCharCE(out.c_str(), CE_UTF8));
//   }
   

   stri__set_names(vals, infosize, "Months", "Weekdays", "Quarters", "AmPm", "Era");
   UNPROTECT(1);
   return vals;
}
