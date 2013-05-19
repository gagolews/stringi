/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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



/** Locate the first and/or the last occurence of character class in one string
 * 
 *  if first/last is NA_INTEGER on input, then we are not interested in that
 *  @param s string
 *  @param n numbytes for s
 *  @param cls class identifier (internal)
 *  - use macros: STRI__UCHAR_IS_ANY_BINPROP, STRI__UCHAR_IS_ANY_GCMASK, ...
 *  @param first [IN/OUT] code point index of the first occurence, 
 *       -1 if not found; 0-based
 *  @param last  [IN/OUT] code point index of the last occurence,
 *       -1 if not found; 0-based
 */
bool stri__detect_class1(const char* s, int n, int32_t* cls)
{
   int i;
   UChar32 chr;
      
   // if-for/else-for insted of for-if/else made here for efficiency reasons
#define STRI__DETECT_CLASS1_DO(__CHR_CLS_TEST__)   \
      for (i=0; i<n; ) {                           \
         U8_NEXT(s, i, n, chr);                    \
         if (__CHR_CLS_TEST__) {                   \
            return true;                           \
         }                                         \
      }                                            \
      return false;
   
   if (STRI__UCHAR_IS_MATCHING_GCMASK(cls)) {
      // General Category (matching)
      int mask = STRI__UCHAR_GET_MATCHING_GCMASK(cls);
      STRI__DETECT_CLASS1_DO((U_GET_GC_MASK(chr) & mask) != 0)
   }
   else if (STRI__UCHAR_IS_COMPLEMENT_GCMASK(cls)) {
      // General Category (complement)
      int mask = STRI__UCHAR_GET_COMPLEMENT_GCMASK(cls);
      STRI__DETECT_CLASS1_DO((U_GET_GC_MASK(chr) & mask) == 0)
   }
   else if (STRI__UCHAR_IS_MATCHING_BINPROP(cls)) {
      // Binary property (matching)
      UProperty prop = (UProperty)STRI__UCHAR_GET_MATCHING_BINPROP(cls);
      STRI__DETECT_CLASS1_DO(u_hasBinaryProperty(chr, prop))
   }
   else if (STRI__UCHAR_IS_COMPLEMENT_BINPROP(cls)) {
      // Binary property (complement)
      UProperty prop = (UProperty)STRI__UCHAR_GET_COMPLEMENT_BINPROP(cls);
      STRI__DETECT_CLASS1_DO(!u_hasBinaryProperty(chr, prop))
   }
   else
      error(MSG__INCORRECT_UCHAR_CLASS_ID);
}


/** 
 * Detect if a character class occurs in a string
 * @param s ...
 * @param c ...
 * @return ...
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_detect_class(SEXP s, SEXP c)
{
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   c = stri_prepare_arg_integer(c, "class"); // prepare integer argument
   R_len_t ns = LENGTH(s);
   R_len_t nc = LENGTH(c);
   if (ns <= 0 || nc <= 0) return allocVector(INTSXP, 0);
   if (nc % STRI__UCHAR_CLASS_LENGTH != 0)
      error(MSG__INCORRECT_UCHAR_CLASS_ID);
   nc /= STRI__UCHAR_CLASS_LENGTH;
   
   R_len_t nout = stri__recycling_rule(true, 2, ns, nc);
   
   int* cc = INTEGER(c);
   
   SEXP ret;
   PROTECT(ret = allocVector(LGLSXP, nout));
   int* iret = INTEGER(ret);
   
   for (R_len_t i=0; i<nout; ++i) {                           
         SEXP curs = STRING_ELT(s, i%ns);                        
         int32_t* curc = cc + STRI__UCHAR_CLASS_LENGTH*(i%nc);   
         R_len_t cursl = LENGTH(curs);                           
         if (curs == NA_STRING)                    
            iret[i] = NA_INTEGER;                             
         else
            iret[i] = stri__detect_class1(CHAR(curs), cursl, curc);                        
      }

   UNPROTECT(1);
   return ret;
}



