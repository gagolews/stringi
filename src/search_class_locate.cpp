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



/** 
 * Locate first or last occurences of a character class occurences in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return matrix with 2 columns
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-04)
 */
SEXP stri__locate_firstlast_charclass(SEXP str, SEXP pattern, bool first)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t npat = LENGTH(pattern);
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), npat);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   
   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   stri__locate_set_dimnames_matrix(ret);
   int* ret_tab = INTEGER(ret);
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP cur_pattern = STRING_ELT(pattern, i%npat); // TO DO: same patterns should form a sequence
      
      ret_tab[i]      = NA_INTEGER;
      ret_tab[i+nmax] = NA_INTEGER;
      
      if (ss->isNA(i) || cur_pattern == NA_STRING)
         continue;
         
      if (last_pattern != CHAR(cur_pattern)) {
         last_pattern = CHAR(cur_pattern);
         cc = CharClass(cur_pattern); // it's a simple struct => fast copy
      }
      
      if (cc.isNA())
         continue;
      
      R_len_t curn = ss->get(i).length();
      const char* curs = ss->get(i).c_str();
      R_len_t j;
      R_len_t k = 0;
      UChar32 chr;
         
      for (j=0; j<curn; ) {
         U8_NEXT(curs, j, curn, chr);
         k++; // 1-based index
         if (cc.test(chr)) {
            ret_tab[i]      = k;
            if (first) break; // that's enough for first
            // note that for last, we can't go backwards from the end, as we need a proper index!
         }
      }
      ret_tab[i+nmax] = ret_tab[i];
   }

   delete ss;
   UNPROTECT(1);
   return ret;
}



/** 
 * Locate first occurences of a character class occurences in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return matrix with 2 columns
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-04)
 */
SEXP stri_locate_first_charclass(SEXP str, SEXP pattern)
{
   return stri__locate_firstlast_charclass(str, pattern, true);
}


/** 
 * Locate first occurences of a character class occurences in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return matrix with 2 columns
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-04)
 */
SEXP stri_locate_last_charclass(SEXP str, SEXP pattern)
{
   return stri__locate_firstlast_charclass(str, pattern, false);
}



// -----------------------------------------------------------------------
// OLD: ------------------------------------------------------------------


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
      error(MSG__INCORRECT_UCHAR_CLASS_ID);
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
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   c = stri_prepare_arg_integer(c, "class"); // prepare integer argument
   R_len_t ns = LENGTH(s);
   R_len_t nc = LENGTH(c);
   if (ns <= 0 || nc <= 0) return stri__emptyList();
   if (nc % STRI__UCHAR_CLASS_LENGTH != 0)
      error(MSG__INCORRECT_UCHAR_CLASS_ID);
   nc /= STRI__UCHAR_CLASS_LENGTH;
   
   R_len_t nout = stri__recycling_rule(true, 2, ns, nc);
      
   SEXP ans;
   SEXP dimnames;
   SEXP colnames;
   SEXP ret;
   /* @TODO: use stri__locate_set_dimnames or its modified version  */
   PROTECT(ret = allocVector(VECSXP, nout));
   PROTECT(dimnames = allocVector(VECSXP, 2));
   PROTECT(colnames = allocVector(STRSXP, 2));
   SET_STRING_ELT(colnames, 0, mkChar("start"));
   SET_STRING_ELT(colnames, 1, mkChar("end"));
   SET_VECTOR_ELT(dimnames, 1, colnames);

   /* @TODO: use STL stack class here */
   R_len_t nmax = stri__numbytes_max(s);
   if (nmax <= 0) {
      PROTECT(ans = stri__matrix_NA_INTEGER(1,2));
      setAttrib(ans, R_DimNamesSymbol, dimnames); 
      
      for (R_len_t i=0; i<nout; ++i)
         SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(4);  
      return ret;
   }
      
   int* start = new int[nmax];
   int* end = new int[nmax];
   int  occurences;
   int* cc = INTEGER(c);
   
   for (R_len_t i=0; i<nout; ++i) {
      SEXP curs = STRING_ELT(s, i%ns);
      int32_t* curc = cc + STRI__UCHAR_CLASS_LENGTH*(i%nc);
      R_len_t cursl = LENGTH(curs);

      if (curs == NA_STRING || cursl == 0) {
         PROTECT(ans = stri__matrix_NA_INTEGER(1,2));
      }
      else {
         stri__locate_all_class1(CHAR(curs), cursl, curc,
            start, end, occurences);
         
         if (occurences > 0) {
            PROTECT(ans = allocMatrix(INTSXP, occurences, 2));
            int* ians = INTEGER(ans);
            for(int j = 0; j < occurences; j++) {
               ians[j+0*occurences] = start[j] + 1; // 0-based index -> 1-based
               ians[j+1*occurences] = end[j] + 1;
            }
         }
         else {
            PROTECT(ans = stri__matrix_NA_INTEGER(1,2));
         }
      }
         
      setAttrib(ans, R_DimNamesSymbol, dimnames); 
      SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(1);  
   }
   
   delete [] start;
   delete [] end;
   UNPROTECT(3);
   return ret;
}

