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
 * Convert character vector between given encodings
 *
 * @param s     input character vector
 * @param from  source encoding
 * @param to    target encoding
 * @return a character vector with s converted
 * @TODO Encoding marking...
 */
SEXP stri_ucnv_encode(SEXP s, SEXP from, SEXP to)
{
   s = stri_prepare_arg_string(s);
   R_len_t ns = LENGTH(s);
   if (ns <= 0) return s;

   UConverter* uconv_from = stri__ucnv_open(from);
   if (!uconv_from) return stri__mkStringNA(ns);

   UConverter* uconv_to = stri__ucnv_open(to);
   if (!uconv_to) {
      ucnv_close(uconv_from);
      return stri__mkStringNA(ns);
   }

   // possibly we could check whether from's and to's canonical names
   // are the same and then return the input as-is (maybe with an Encoding
   // marking?). this is, however, a rare case. moreover, calling with
   // from==to may serve as a test for this
   // function (we check if it's an identity function)
   
   
   int buflen = -1;
   for (R_len_t i=0; i<ns; ++i) {
      SEXP si = STRING_ELT(s, i);
      if (si == NA_STRING) continue;
      R_len_t ni = LENGTH(si);      
      if (ni > buflen) buflen = ni;
   }
   
   if (buflen < 0)
      return stri__mkStringNA(ns);

   // this may suffice, but not necessarily
   // for utf-8 input this may be overestimated
   buflen = UCNV_GET_MAX_BYTES_FOR_STRING(buflen,
      (int)ucnv_getMaxCharSize(uconv_to))+1;
   char* buf = new char[buflen];
   
   UErrorCode err;
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, ns));
      
   
   // encode each string
   for (R_len_t i=0; i<ns; ++i) {
      SEXP si = STRING_ELT(s, i);
      if (si == NA_STRING) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      R_len_t ni = LENGTH(si);
//      if (ni == 0) {...} // do we need that? give it a break :)

      err = U_ZERO_ERROR;
      UnicodeString trans(CHAR(si), ni, uconv_from, err); // to UTF-16
      if (U_FAILURE(err)) {
         warning(SSTR("could not convert string #" << (i+1)).c_str());
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      err = U_ZERO_ERROR;
      int buflen_need = trans.extract(buf, buflen, uconv_to, err);

      if (buflen_need >= 0 && U_FAILURE(err)) { // enlarge the buffer
#ifndef NDEBUG
         cerr << "DEBUG: stri_ucnv_encode: expanding buffer"
            << buflen << " -> " << buflen_need + 1 << endl;
#endif
         buflen = buflen_need + 1;
         // no buf deallocation needed
         delete [] buf;
         buf = new char[buflen];

         err = U_ZERO_ERROR;
         buflen_need = trans.extract(buf, buflen, uconv_to, err); // try again
      }

      if (buflen_need < 0 || U_FAILURE(err)) {
         warning(SSTR("could not convert string #" << (i+1)).c_str());
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

////    CE_NATIVE = 0,
////    CE_UTF8   = 1,
////    CE_LATIN1 = 2,
////    CE_BYTES  = 3,
////    CE_SYMBOL = 5,
      SET_STRING_ELT(ret, i, mkCharLen(buf, buflen_need)); /// @TODO: mark encoding
   }
   
   delete [] buf;
   ucnv_close(uconv_from);
   ucnv_close(uconv_to);
   UNPROTECT(1);
   return ret;
}





/** Fetch information on given encoding
 * @param enc either NULL or "" for default encoding, or one string with encoding name
 * @ret a list
 *
 * @TODO Has ASCII subset?
 * @TODO How many (max) UTF-8 chars correspond to one char in this encoding?
 */
SEXP stri_ucnv_encinfo(SEXP enc)
{
   UConverter* uconv = stri__ucnv_open(enc);
   if (!uconv) return R_NilValue;

   UErrorCode err;

   // get list of available standards
   R_len_t cs;
   const char** standards;
   stri__ucnv_getStandards(standards, cs);

   // alloc output list
   SEXP vals;
   SEXP names;
   const int nval = cs+4;
   PROTECT(names = allocVector(STRSXP, nval));
   SET_STRING_ELT(names, 0, mkChar("Name.friendly"));
   SET_STRING_ELT(names, 1, mkChar("Name.ICU"));
   for (R_len_t i=0; i<cs; ++i)
      SET_STRING_ELT(names, i+2, mkChar((string("Name.")+standards[i]).c_str()));
   SET_STRING_ELT(names, nval-2, mkChar("CharSize.min"));
   SET_STRING_ELT(names, nval-1, mkChar("CharSize.max"));

   PROTECT(vals = allocVector(VECSXP, nval));


   // get canonical (ICU) name
   err = U_ZERO_ERROR;
   const char* canname = ucnv_getName(uconv, &err);

   if (U_FAILURE(err) || !canname) {
      SET_VECTOR_ELT(vals, 1, ScalarString(NA_STRING));
      warning("could not get canonical (ICU) encoding name (stri_ucnv_encinfo)");
   }
   else {
      SET_VECTOR_ELT(vals, 1, mkString(canname));

      // friendly name
      const char* frname = stri___ucnv_getFriendlyName(canname);
      if (frname)  SET_VECTOR_ELT(vals, 0, mkString(frname));
      else         SET_VECTOR_ELT(vals, 0, ScalarString(NA_STRING));

      // min,max character size
      SET_VECTOR_ELT(vals, nval-2, ScalarInteger((int)ucnv_getMinCharSize(uconv)));
      SET_VECTOR_ELT(vals, nval-1, ScalarInteger((int)ucnv_getMaxCharSize(uconv)));

      // other standard names
      for (R_len_t i=0; i<cs; ++i) {
         err = U_ZERO_ERROR;
         const char* stdname = ucnv_getStandardName(canname, standards[i], &err);
         if (U_FAILURE(err) || !stdname)
            SET_VECTOR_ELT(vals, i+2, ScalarString(NA_STRING));
         else
            SET_VECTOR_ELT(vals, i+2, mkString(stdname));
      }
   }
   ucnv_close(uconv);

   setAttrib(vals, R_NamesSymbol, names);
   UNPROTECT(2);
   return vals;
}



/**
 * ...
 */
SEXP stri_ucnv_enclist()
{
   R_len_t cs;
   const char** standards;
   stri__ucnv_getStandards(standards, cs);

   UErrorCode err;

   R_len_t c = (R_len_t)ucnv_countAvailable();
   SEXP ret;
   SEXP names;


   PROTECT(ret = allocVector(VECSXP, c));
   PROTECT(names = allocVector(STRSXP, c));

   for (R_len_t i=0; i<c; ++i) {
      const char* canonical_name = ucnv_getAvailableName(i);
      if (!canonical_name) {
         SET_STRING_ELT(names, i, NA_STRING);
         continue;
      }

      SET_STRING_ELT(names, i, mkChar(canonical_name));

      err = U_ZERO_ERROR;
      R_len_t ci = (R_len_t)ucnv_countAliases(canonical_name, &err);
      if (U_FAILURE(err) || ci <= 0)
         SET_VECTOR_ELT(ret, i, ScalarString(NA_STRING));
      else {
         SEXP aliases;
         PROTECT(aliases = allocVector(STRSXP, ci));
         for (R_len_t j=0; j<ci; ++j) {
            err = U_ZERO_ERROR;
            const char* alias = ucnv_getAlias(canonical_name, j, &err);
            if (U_FAILURE(err) || !alias)
               SET_STRING_ELT(aliases, j, NA_STRING);
            else
               SET_STRING_ELT(aliases, j, mkChar(alias));
         }
         UNPROTECT(1);
         SET_VECTOR_ELT(ret, i, aliases);
      }
   }

   setAttrib(ret, R_NamesSymbol, names);
   UNPROTECT(2);
   return ret;
}







/** Get ICU ucnv standard names and their count
 *  @param standards [OUT]
 *  @param cs [OUT]
 *  Memory is allocated via R_alloc()
 */
void stri__ucnv_getStandards(const char**& standards, R_len_t& cs)
{
   UErrorCode err;
   cs = (R_len_t)ucnv_countStandards()-1; // -1 - this is not documented in ICU4C
   if (cs <= 0) {
#ifndef NDEBUG
      error("DEBUG: number of standard names is not positive (stri_ucnv_list)");
#endif
      standards = NULL;
      cs = 0;
   }
   standards = (const char**)R_alloc(cs, sizeof(char*));
   R_len_t j=0;

   for (R_len_t i=0; i<cs; ++i) {
      err = U_ZERO_ERROR;
      standards[i] = ucnv_getStandard(i, &err);
      if (U_FAILURE(err)) {
#ifndef NDEBUG
         error("could not gen standard name (stri_ucnv_list)");
#endif
         standards[i] = NULL;
      }
   }
}



/** Get friendly endoding name
 *  @param canname Canonical (ICU) encoding name
 *  @return First existing of: MIME name or JAVA name or Canonical
 */
const char* stri___ucnv_getFriendlyName(const char* canname)
{
   if (!canname) return NULL;

   UErrorCode err;
   const char* frname;

   err = U_ZERO_ERROR;
   frname = ucnv_getStandardName(canname, "MIME", &err);
   if (U_SUCCESS(err) && frname)
      return frname;

   err = U_ZERO_ERROR;
   frname = ucnv_getStandardName(canname, "JAVA", &err);
   if (U_SUCCESS(err) && frname)
      return frname;

   return canname;
}


/** Open UEncoder for given locale
 *  @param enc encoding name or NULL/empty string for default encoding
 *  @return NULL on error + a warning
 */
UConverter* stri__ucnv_open(const char* enc)
{
   UErrorCode err = U_ZERO_ERROR;
   UConverter* uconv = NULL;

   if (!enc || !enc[0]) {
      // use default encoding
      uconv = ucnv_open(NULL, &err);
      if (U_FAILURE(err)) {
         warning("could not open default converter");
         return NULL;
      }
      else
         return uconv;

   } else {
      // use given encoding
      uconv = ucnv_open(enc, &err);
      if (U_FAILURE(err)) {
         warning("could not find converter for given encoding");
         return NULL;
      }
      else
         return uconv;
   }
}



/** Open UEncoder for given locale
 *  @param enc either NULL or "" for default encoding, or one string with encoding name
 *  @return NULL on error + a warning
 */
UConverter* stri__ucnv_open(SEXP enc)
{
   if (isNull(enc))
      return stri__ucnv_open((const char*)NULL); // use default encoding

   enc = stri_prepare_arg_string(enc);

   if (LENGTH(enc) >= 1 && STRING_ELT(enc, 0) != NA_STRING) {
      if (LENGTH(enc) > 1) // this shouldn't happen
         warning("only one encoding specifier supported. taking first");

      if (LENGTH(STRING_ELT(enc, 0)) == 0)
         return stri__ucnv_open((const char*)NULL); // use default encoding
      else
         return stri__ucnv_open((const char*)CHAR(STRING_ELT(enc, 0)));
   }

   error("incorrect encoding specifier");
   return NULL; // to avoid compilation warnings
}
