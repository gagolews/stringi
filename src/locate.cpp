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



/** Locate all occurences of character class in one string
 *  @param s string
 *  @param n numbytes for s
 *  @param cls class identifier (internal)
 *  - use macros: STRI__UCHAR_IS_ANY_BINPROP, STRI__UCHAR_IS_ANY_GCMASK, ...
 * @param start [out] indices  (0-based)
 * @param end [out] indices (0-based)
 * @param o [out] number of occurences (compact subsequences are merged)
 */
void stri__locate_all_class1(const char* s, int n, int32_t* cls,
   int* start, int* end, int& o)
{
   int i;
   UChar32 chr;
   o = 0;
   bool newsubseq = true;
   int charnum = 0;
      
// if-for/else-for insted of for-if/else made here for efficiency reasons
#define STRI__LOCATE_ALL_CLASS1_DO(__CHR_CLS_TEST__) \
      for (i=0; i<n; ++charnum) {                    \
         U8_NEXT(s, i, n, chr);                      \
         if (__CHR_CLS_TEST__) {                     \
            if (newsubseq) {                         \
               ++o;                                  \
               start[o-1] = charnum;                 \
               end[o-1] = charnum;                   \
               newsubseq = false;                    \
            }                                        \
            else                                     \
               end[o-1] = charnum;                   \
         } else                                      \
            newsubseq = true;                        \
      }

//   cerr << cls[0] << " " << cls[1] << endl;
//   cerr << STRI__UCHAR_IS_MATCHING_GCMASK(cls);
//   cerr << STRI__UCHAR_IS_COMPLEMENT_GCMASK(cls);
//   cerr << STRI__UCHAR_IS_MATCHING_BINPROP(cls);
//   cerr << STRI__UCHAR_IS_COMPLEMENT_BINPROP(cls);
//   cerr << endl;
   
   
   if (STRI__UCHAR_IS_MATCHING_GCMASK(cls)) {
      // General Category (matching)
      int mask = STRI__UCHAR_GET_MATCHING_GCMASK(cls);
      STRI__LOCATE_ALL_CLASS1_DO((U_GET_GC_MASK(chr) & mask) != 0)
   }
   else if (STRI__UCHAR_IS_COMPLEMENT_GCMASK(cls)) {
      // General Category (complement)
      int mask = STRI__UCHAR_GET_COMPLEMENT_GCMASK(cls);
      STRI__LOCATE_ALL_CLASS1_DO((U_GET_GC_MASK(chr) & mask) == 0)
   }
   else if (STRI__UCHAR_IS_MATCHING_BINPROP(cls)) {
      // Binary property (matching)
      UProperty prop = (UProperty)STRI__UCHAR_GET_MATCHING_BINPROP(cls);
      STRI__LOCATE_ALL_CLASS1_DO(u_hasBinaryProperty(chr, prop))
   }
   else if (STRI__UCHAR_IS_COMPLEMENT_BINPROP(cls)) {
      // Binary property (complement)
      UProperty prop = (UProperty)STRI__UCHAR_GET_COMPLEMENT_BINPROP(cls);
      STRI__LOCATE_ALL_CLASS1_DO(!u_hasBinaryProperty(chr, prop))
   }
   else
      error("incorrect class identifier");
}


/** Locate all occurences of character classes
 * @param s character vector
 * @param c integer vector (general category or binary property code
 *  - use macros: STRI__UCHAR_IS_BINPROP, STRI__UCHAR_GET_BINPROP
 *    and/or STRI__UCHAR_IS_GC_MASK
 * @return list of integer matrices (2 columns)
 */
SEXP stri_locate_all_class(SEXP s, SEXP c)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   c = stri_prepare_arg_integer(c); // prepare string argument
   R_len_t ns = LENGTH(s);
   R_len_t nc = LENGTH(c);
   if (ns <= 0 || nc <= 0) return stri__emptyList();
   if (nc % STRI__UCHAR_CLASS_LENGTH != 0)
      error("incorrect class identifier");
   nc /= STRI__UCHAR_CLASS_LENGTH;
   
   R_len_t nout = max(ns, nc);
   if (nout % ns != 0 || nout % nc != 0)
      warning("longer object length is not a multiple of shorter object length");
   

   
   R_len_t nmax = stri__numbytes_max(s);
   int* start = new int[nmax];
   int* end = new int[nmax];
   int  occurences;
   int* cc = INTEGER(c);
   
   SEXP ans;
   SEXP dimnames;
   SEXP colnames;
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP, nout));
   PROTECT(dimnames = allocVector(VECSXP, 2));
   PROTECT(colnames = allocVector(STRSXP, 2));
   SET_STRING_ELT(colnames, 0, mkChar("start"));
   SET_STRING_ELT(colnames, 1, mkChar("end"));
   SET_VECTOR_ELT(dimnames, 1, colnames);
   
   for (R_len_t i=0; i<nout; ++i) {
      SEXP curs = STRING_ELT(s, i%ns);
      int32_t* curc = cc + STRI__UCHAR_CLASS_LENGTH*(i%nc);
      R_len_t cursl = LENGTH(curs);

      
      if (curs == NA_STRING || cursl == 0) {
         PROTECT(ans = allocMatrix(INTSXP, 0, 2));
      }
      else {
         stri__locate_all_class1(CHAR(curs), cursl, curc,
            start, end, occurences);
         
         PROTECT(ans = allocMatrix(INTSXP, occurences, 2));
         int* ians = INTEGER(ans);
         for(int j = 0; j < occurences; j++) {
            ians[j+0*occurences] = start[j] + 1; // 0-based index -> 1-based
            ians[j+1*occurences] = end[j] + 1;
         }
      }
         
      setAttrib(ans, R_DimNamesSymbol, dimnames);
      UNPROTECT(1);   
      SET_VECTOR_ELT(ret, i, ans);
   }
   
   delete [] start;
   delete [] end;
   UNPROTECT(3);
   return ret;
}
