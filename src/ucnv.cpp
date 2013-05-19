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


// ------------------------------------------------------------------------


/** Open UConverter for given character encoding
 * 
 *  If the converted could be opened, then an error is generated.
 * 
 *  @param enc encoding name or NULL for default encoding (please,
 *       use \code{stri__prepare_arg_enc()})
 *  @return opened UConverter* (must be closed manually after use)
 */
UConverter* stri__ucnv_open(const char* enc)
{
   UErrorCode err = U_ZERO_ERROR;
   UConverter* uconv = NULL;

   uconv = ucnv_open(enc, &err);
   if (U_FAILURE(err))
      error(MSG__ENC_ERROR_SET);
   
   return uconv;
}


// ------------------------------------------------------------------------

/**
 * Convert character vector between given encodings
 *
 * @param s     input character vector
 * @param from  source encoding, \code{NULL} or \code{""} for default enc
 * @param to    target encoding, \code{NULL} or \code{""} for default enc
 * @return a converted character vector
 * 
 * @TODO Encoding marking...
 * 
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_encode(SEXP s, SEXP from, SEXP to)
{
   s = stri_prepare_arg_string(s, "str");
   R_len_t ns = LENGTH(s);
   if (ns <= 0) return s;

   const char* selected_from = stri__prepare_arg_enc(from, "from", true);
   const char* selected_to   = stri__prepare_arg_enc(to, "to", true);
   UConverter* uconv_from = stri__ucnv_open(selected_from);
   UConverter* uconv_to = stri__ucnv_open(selected_to);

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
      return stri__vector_NA_strings(ns);

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
         warning("could not convert string #%d", i+1);
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      err = U_ZERO_ERROR;
      int buflen_need = trans.extract(buf, buflen, uconv_to, err);

      if (buflen_need >= 0 && U_FAILURE(err)) { // enlarge the buffer
#ifndef NDEBUG
         cerr << "DEBUG: stri_encode: expanding buffer"
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
         warning("could not convert string #%d", i+1);
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }


      SET_STRING_ELT(ret, i, mkCharLen(buf, buflen_need)); /// @TODO: mark encoding
   }
   
   delete [] buf;
   ucnv_close(uconv_from);
   ucnv_close(uconv_to);
   UNPROTECT(1);
   return ret;
}



// ------------------------------------------------------------------------


/** Check R encoding marking *for testing only*
 *  This function should not be exported
 * 
 *  @param s character vector
 * 
 *  Results are printed on STDERR
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_enc_Rmark(SEXP s)
{
   s = stri_prepare_arg_string(s, "str");
   int ns = LENGTH(s);
   for (int i=0; i < ns; ++i) {
      cerr << "Element #" <<  i << ":";
      SEXP curs = STRING_ELT(s, i);
      if (curs == NA_STRING){
         cerr << "\tNA" << endl;
         continue;
      }
      //const char* string = CHAR(curs);
      cerr << "\tMARK_ASCII =" << (IS_ASCII(curs) > 0);
      cerr << "\tMARK_UTF8  =" << (IS_UTF8(curs) > 0);
      cerr << "\tMARK_LATIN1=" << (IS_LATIN1(curs) > 0);
      cerr << "\tMARK_BYTES =" << (IS_BYTES(curs) > 0);
      cerr << endl;
   }
   return R_NilValue;
}


// ------------------------------------------------------------------------


/**
 * Sets current (default) ICU charset
 * 
 * If given charset is unavailable, an error is raised
 * 
 * @param enc new charset (single string)
 * @return nothing (\code{R_NilValue})
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_enc_set(SEXP enc)
{
   const char* selected_enc
      = stri__prepare_arg_enc(enc, "enc", false); // here, the default encoding may not be requested
      
   // this will generate an error if enc is not supported:
   UConverter* uconv = stri__ucnv_open(selected_enc); 

   UErrorCode err = U_ZERO_ERROR;
   const char* name = ucnv_getName(uconv, &err); // get "official" encoding name
   ucnv_close(uconv); // no longer needed
   if (U_FAILURE(err))
      error(MSG__ENC_ERROR_SET);
   ucnv_setDefaultName(name); // set as default
  
   return R_NilValue;
}





/**
 * Get all available ICU charsets and their aliases (elems 2,3,...)
 * 
 * @return R list object; element name == ICU charset canonical name;
 * elements are character vectors (aliases)
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_enc_list()
{
   //R_len_t cs;
   //const char** standards;
   //stri__ucnv_getStandards(standards, cs);

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

   //delete [] standards;
   setAttrib(ret, R_NamesSymbol, names);
   UNPROTECT(2);
   return ret;
}







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
SEXP stri_enc_isascii(SEXP s)
{
   s = stri_prepare_arg_string(s, "str");
   R_len_t ns = LENGTH(s);
   
   SEXP e, curs;
   PROTECT(e = allocVector(LGLSXP, ns));
   int* be = LOGICAL(e); // may be faster than LOGICAL(e)[i]
   for (R_len_t i=0; i < ns; ++i) {
      curs = STRING_ELT(s, i);
      if (curs == NA_STRING) {
         be[i] = NA_LOGICAL;
         continue;
      }
      const char* string = CHAR(curs);
      R_len_t ncurs = LENGTH(curs);
      be[i] = true;
      for (R_len_t j=0; j < ncurs; ++j){
         if (!U8_IS_SINGLE(string[j])) {
            be[i] = false;
            break;
         }
      }
      
   }
   UNPROTECT(1);
   return e;
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
SEXP stri_enc_isutf8(SEXP s)
{
   s = stri_prepare_arg_string(s, "str");
   R_len_t ns = LENGTH(s);
   UChar32 c;
   R_len_t ncurs;
   SEXP e, curs;
   PROTECT(e = allocVector(LGLSXP, ns));
   int* be = LOGICAL(e);
   for (R_len_t i=0; i < ns; ++i) {
      curs = STRING_ELT(s, i);
      if (curs == NA_STRING){
         be[i] = NA_LOGICAL;
         continue;
      }
      const char* string = CHAR(curs);
      ncurs = LENGTH(curs);
      be[i] = true;
      for(R_len_t j=0; j < ncurs; ) {
         U8_NEXT(string, j, ncurs, c);
         if(c < 0) {
            be[i] = false;
            break;
         }
      }
      
   }
   UNPROTECT(1);
   return e;
}







// ------------------------------------------------------------------------


/** 
 * Get ICU ucnv standard names and their count
 * 
 *  @param standards [OUT] - dynamically allocated array of char strings
 *  (items are are possesed by ICU, but the array should be freed)
 *  @param cs [out] - size of \code{standards}
 *  
 *  @version 0.1 (Marek Gagolewski)
 */
void stri__ucnv_getStandards(const char**& standards, R_len_t& cs)
{
   UErrorCode err;
   cs = (R_len_t)ucnv_countStandards()-1; // -1 - this is not documented in ICU4C
   if (cs <= 0) error(MSG__ENC_ERROR_SET);
   standards = new const char*[cs];

   for (R_len_t i=0; i<cs; ++i) {
      err = U_ZERO_ERROR;
      standards[i] = ucnv_getStandard(i, &err);
      if (U_FAILURE(err)) {
#ifndef NDEBUG
         warning("could not get standard name (stri_list)");
#endif
         standards[i] = NULL;
      }
   }
}



/** 
 * Get friendly encoding name
 *  
 * @param canname Canonical (ICU) encoding name
 * @return First existing of: MIME name or JAVA name or Canonical
 * 
 * @version 0.1 (Marek Gagolewski)
 */
const char* stri__ucnv_getFriendlyName(const char* canname)
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



/**
 * Convert each ASCII character (1..127) to UTF-8 
 * and checks whether it gets the same result
 * 
 * This sould be used only on 8-bit converters
 * 
 * @param conv ICU charset converter
 * 
 * @version 0.1 (Marek Gagolewski)
 */
bool stri__ucnv_hasASCIIsubset(UConverter* conv)
{
   if (ucnv_getMinCharSize(conv) != 1) return false;
   
   const int ascii_from = 0x0001;
   const int ascii_to   = 0x007f;
   char ascii[ascii_to-ascii_from+2]; // + \0
   for (int i=ascii_from; i<=ascii_to; ++i)
      ascii[i-ascii_from] = (char)i;
   ascii[ascii_to-ascii_from+1] = '\0';
   
   UChar32 c;
   
   const char* ascii_last = ascii;
   const char* ascii1 = ascii;
   const char* ascii2 = ascii+(ascii_to-ascii_from)+1;
   
   ucnv_reset(conv);
   
   while (ascii1 < ascii2) {
      UErrorCode err = U_ZERO_ERROR;
      c = ucnv_getNextUChar(conv, &ascii1, ascii2, &err);
      if (U_FAILURE(err)) {
#ifndef NDEBUG
         warning("Cannot convert ASCII character 0x%2x (encoding=%s)",
            (int)(unsigned char)ascii_last[0],
            ucnv_getName(conv, &err));
#endif
         return false;
      }
      
      // Has just one byte been consumed? (??is that necessary??)
      // How many code units (bytes) are used for the UTF-8 encoding
      // of this Unicode code point? Does this code unit (byte)
      // encode a code point by itself (US-ASCII 0..0x7f)?
      // Is that the same ASCII char?
      if (ascii_last != ascii1-1
         || U8_LENGTH(c) != 1
         || c != (int)ascii_last[0]) {
         return false;
      }
      ascii_last = ascii1;
   } 
   
   return true;  
}


/**
 * Converts each character (23..255) to UTF-8 and the back to original enc
 * and checks whether it gets the same result
 * 
 * This sould be used only on 8-bit converters
 * 
 * @param conv ICU charset converter
 * 
 * @version 0.1 (Marek Gagolewski)
 */
bool stri__ucnv_is1to1Unicode(UConverter* conv)
{
   if (ucnv_getMinCharSize(conv) != 1) return false;
   
   const int ascii_from = 32;
   const int ascii_to = 0x00ff;
   char ascii[ascii_to-ascii_from+2]; // + \0
   for (int i=ascii_from; i<=ascii_to; ++i)
      ascii[i-ascii_from] = (char)i;
   ascii[ascii_to-ascii_from+1] = '\0';
   
   UChar32 c;
   const int buflen =  UCNV_GET_MAX_BYTES_FOR_STRING(1, 1);
   char buf[buflen];
   
   const char* ascii_last = ascii;
   const char* ascii1 = ascii;
   const char* ascii2 = ascii+(ascii_to-ascii_from)+1;
   
   UErrorCode err = U_ZERO_ERROR;
   ucnv_reset(conv);
   
   while (ascii1 < ascii2) {
      c = ucnv_getNextUChar(conv, &ascii1, ascii2, &err);
      if (U_FAILURE(err)) {
#ifndef NDEBUG
         warning("Cannot convert character 0x%2x (encoding=%s)",
            (int)(unsigned char)ascii_last[0],
            ucnv_getName(conv, &err));
#endif
         return false;
      }
      
//      cerr << (int)(unsigned char)ascii_last[0] << " -> " << c << endl;
      if (ascii_last != ascii1-1) // one byte should be consumed
         return false;
         
      // check whether the character is represented
      // by a single UTF-16 code point
      UChar lead = U16_LEAD(c); //, trail = U16_TRAIL(c);
      if (!U16_IS_SINGLE(lead)) {
#ifndef NDEBUG
         warning("Problematic character 0x%2x -> \\u%8x (encoding=%s)",
            (int)(unsigned char)ascii_last[0],
            c,
            ucnv_getName(conv, &err));
#endif
         return false;
      }
      
      // character not convertable => ignore
      if (c != UCHAR_REPLACEMENT) {    
         ucnv_fromUChars(conv, buf, buflen, (UChar*)&c, 1, &err);
         if (U_FAILURE(err)) {
#ifndef NDEBUG
            warning("Cannot convert character 0x%2x (encoding=%s)",
            (int)(unsigned char)ascii_last[0],
            ucnv_getName(conv, &err));
#endif
            return false;
         }
         
         if (buf[1] != '\0' || buf[0] != ascii_last[0]) {
#ifndef NDEBUG
            warning("Problematic character 0x%2x -> \\u%8x -> 0x%2x (encoding=%s)",
               (int)(unsigned char)ascii_last[0],
               c,
               (int)buf[0],
               ucnv_getName(conv, &err));
#endif
            return false;
         }
      }      
      
      
      // @TODO: check tolower, toupper etc. (???)

      ascii_last = ascii1;
   } 
   
   return true;  
}


/** Fetch information on given encoding
 * 
 * @param enc either NULL or "" for default encoding, or one string with encoding name
 * @return R list object with many components (see R doc for details)
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_enc_info(SEXP enc)
{
   const char* selected_enc = stri__prepare_arg_enc(enc, "enc", true);
   UConverter* uconv = stri__ucnv_open(selected_enc); 
   UErrorCode err;

   // get list of available standards
   R_len_t cs;
   const char** standards;
   stri__ucnv_getStandards(standards, cs);

   // alloc output list
   SEXP vals;
   SEXP names;
   const int nval = cs+2+5;
   PROTECT(names = allocVector(STRSXP, nval));
   SET_STRING_ELT(names, 0, mkChar("Name.friendly"));
   SET_STRING_ELT(names, 1, mkChar("Name.ICU"));
   for (R_len_t i=0; i<cs; ++i)
      SET_STRING_ELT(names, i+2, mkChar((string("Name.")+standards[i]).c_str()));
   SET_STRING_ELT(names, nval-5, mkChar("ASCII.subset"));
   SET_STRING_ELT(names, nval-4, mkChar("Unicode.1to1"));
   SET_STRING_ELT(names, nval-3, mkChar("CharSize.8bit"));
   SET_STRING_ELT(names, nval-2, mkChar("CharSize.min"));
   SET_STRING_ELT(names, nval-1, mkChar("CharSize.max"));

   PROTECT(vals = allocVector(VECSXP, nval));


   // get canonical (ICU) name
   err = U_ZERO_ERROR;
   const char* canname = ucnv_getName(uconv, &err);

   if (U_FAILURE(err) || !canname) {
      SET_VECTOR_ELT(vals, 1, ScalarString(NA_STRING));
      warning(MSG__ENC_ERROR_GETNAME);
   }
   else {
      SET_VECTOR_ELT(vals, 1, mkString(canname));

      // friendly name
      const char* frname = stri__ucnv_getFriendlyName(canname);
      if (frname)  SET_VECTOR_ELT(vals, 0, mkString(frname));
      else         SET_VECTOR_ELT(vals, 0, ScalarString(NA_STRING));


      // has ASCII as its subset?
      SET_VECTOR_ELT(vals, nval-5, ScalarLogical((int)stri__ucnv_hasASCIIsubset(uconv)));
      
      // min,max character size, is 8bit?
      int mincharsize = (int)ucnv_getMinCharSize(uconv);
      int maxcharsize = (int)ucnv_getMaxCharSize(uconv);
      int is8bit = (mincharsize==1 && maxcharsize == 1);
      SET_VECTOR_ELT(vals, nval-3, ScalarLogical(is8bit));
      SET_VECTOR_ELT(vals, nval-2, ScalarInteger(mincharsize));
      SET_VECTOR_ELT(vals, nval-1, ScalarInteger(maxcharsize));
      
      // is there a one-to-one correspondence with Unicode?
      if (!is8bit)
         SET_VECTOR_ELT(vals, nval-4, ScalarLogical(NA_LOGICAL));
      else
         SET_VECTOR_ELT(vals, nval-4, ScalarLogical((int)stri__ucnv_is1to1Unicode(uconv)));
         
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
   delete [] standards;
   setAttrib(vals, R_NamesSymbol, names);
   UNPROTECT(2);
   return vals;
}

