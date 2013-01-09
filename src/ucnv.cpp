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


/** Fetch information on given encoding
 * @param enc either NULL or "" for default encoding, or one string with encoding name
 * @ret a list
 * 
 * @TODO Has ASCII subset?
 * @TODO How many (max) UTF-8 chars correspond to one char in this encoding?
 */
SEXP stri_ucnv_encinfo(SEXP enc)
{
   // check enc argument and get ICU ucnv converter for given name
   if (!isNull(enc)) enc = stri_prepare_arg_string(enc);
   
   UErrorCode err;
   UConverter* uconv = NULL;
   const char* queried_enc;
   bool useDefaultEncoding = false;

   if (isString(enc)) {
      if (LENGTH(enc) < 1)
         error("incorrect argument to stri_ucnv_getinfo");
      else if (LENGTH(enc) > 1) // this shouldn't happen
         warning("stri_ucnv_getinfo: vector is longer than 1. taking the first element");

      if (STRING_ELT(enc, 0) == NA_STRING)
         error("incorrect argument to stri_ucnv_getinfo");
      else if (LENGTH(STRING_ELT(enc, 0)) == 0)
         useDefaultEncoding = true;
      else {
         queried_enc = CHAR(STRING_ELT(enc, 0));
         err = U_ZERO_ERROR;
         uconv = ucnv_open(queried_enc, &err);
         if (U_FAILURE(err)) {
            warning("could not find converter for given name (stri_ucnv_getinfo)");
            return R_NilValue;
         }
      }
   }
   
   if (!uconv) {
      if (isNull(enc) || useDefaultEncoding) {
         queried_enc = ucnv_getDefaultName();
         err = U_ZERO_ERROR;
         uconv = ucnv_open(NULL, &err);
         if (U_FAILURE(err))
            error("could not open default converter (stri_ucnv_getinfo)");
      }
      else
         error("incorrect argument to stri_ucnv_getinfo");
   }
      
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
