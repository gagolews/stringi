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
 * Set colnames for matrix returned by stri_locate_first_* or stri_locate_last_*
 * @param matrix R matrix with two columns
 * @version 0.1 (Marek Gagolewski)
 */
void stri__locate_set_dimnames(SEXP matrix) {
   SEXP dimnames;
   SEXP colnames;
   PROTECT(dimnames = allocVector(VECSXP, 2));
   PROTECT(colnames = allocVector(STRSXP, 2));
   SET_STRING_ELT(colnames, 0, mkChar(MSG__LOCATE_DIM_START));
   SET_STRING_ELT(colnames, 1, mkChar(MSG__LOCATE_DIM_END));
   SET_VECTOR_ELT(dimnames, 1, colnames);
   setAttrib(matrix, R_DimNamesSymbol, dimnames);
   UNPROTECT(2);
}



/* CLASS */

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
void stri__locate_first_and_last_class1(const char* s, int n, int32_t* cls,
   int& first, int& last)
{
   int i;
   UChar32 chr;
   int charnum = 0;
   
   if (first != NA_INTEGER && last != NA_INTEGER) {
      first = -1;
      last  = -1;
   }   
   else if (first == NA_INTEGER)
      last  = -1;
   else
      first = -1;
   
   // if-for/else-for insted of for-if/else made here for efficiency reasons
#define STRI__LOCATE_FIRST_CLASS1_DO(__CHR_CLS_TEST__) \
      for (i=0; i<n; charnum++) {                      \
         U8_NEXT(s, i, n, chr);                        \
         if (__CHR_CLS_TEST__) {                       \
            if (last != NA_INTEGER)                    \
               last = charnum;                         \
            if (first != NA_INTEGER) {                 \
               first = charnum;                        \
               if (last == NA_INTEGER)                 \
                  return;                              \
            }                                          \
         }                                             \
      }
   
   if (STRI__UCHAR_IS_MATCHING_GCMASK(cls)) {
      // General Category (matching)
      int mask = STRI__UCHAR_GET_MATCHING_GCMASK(cls);
      STRI__LOCATE_FIRST_CLASS1_DO((U_GET_GC_MASK(chr) & mask) != 0)
   }
   else if (STRI__UCHAR_IS_COMPLEMENT_GCMASK(cls)) {
      // General Category (complement)
      int mask = STRI__UCHAR_GET_COMPLEMENT_GCMASK(cls);
      STRI__LOCATE_FIRST_CLASS1_DO((U_GET_GC_MASK(chr) & mask) == 0)
   }
   else if (STRI__UCHAR_IS_MATCHING_BINPROP(cls)) {
      // Binary property (matching)
      UProperty prop = (UProperty)STRI__UCHAR_GET_MATCHING_BINPROP(cls);
      STRI__LOCATE_FIRST_CLASS1_DO(u_hasBinaryProperty(chr, prop))
   }
   else if (STRI__UCHAR_IS_COMPLEMENT_BINPROP(cls)) {
      // Binary property (complement)
      UProperty prop = (UProperty)STRI__UCHAR_GET_COMPLEMENT_BINPROP(cls);
      STRI__LOCATE_FIRST_CLASS1_DO(!u_hasBinaryProperty(chr, prop))
   }
   else
      error(MSG__INCORRECT_UCHAR_CLASS_ID);
}



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
   s = stri_prepare_arg_string(s); // prepare string argument
   c = stri_prepare_arg_integer(c); // prepare integer argument
   R_len_t ns = LENGTH(s);
   R_len_t nc = LENGTH(c);
   if (ns <= 0 || nc <= 0) return stri__emptyList();
   if (nc % STRI__UCHAR_CLASS_LENGTH != 0)
      error(MSG__INCORRECT_UCHAR_CLASS_ID);
   nc /= STRI__UCHAR_CLASS_LENGTH;
   
   R_len_t nout = stri__recycling_rule(ns, nc);
      
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
      STRI__CREATE2NA_MATRIX(ans)      
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
         STRI__CREATE2NA_MATRIX(ans)
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
            STRI__CREATE2NA_MATRIX(ans)
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



/** Locate the first or the last occurence of each character class
 * @param s character vector
 * @param c integer vector (general category or binary property code
 *  - use macros: STRI__UCHAR_IS_BINPROP, STRI__UCHAR_GET_BINPROP
 *    and/or STRI__UCHAR_IS_GC_MASK
 * @param first logical; TRUE if the first or FALSE if the last
 *    occurence is of interest
 * @return integer vector of length |s|
 */
SEXP stri_locate_first_or_last_class(SEXP s, SEXP c, SEXP first)
{
   first = stri_prepare_arg_logical(first); // prepare logical argument
   if (LENGTH(first) != 1 || LOGICAL(first)[0] == NA_LOGICAL)
      error(MSG__INCORRECT_INTERNAL_ARG);
      
   /* @TODO: this function should return a matrix with 2 columns
      now this is assured by some R code :-( */
      
   s = stri_prepare_arg_string(s); // prepare string argument
   c = stri_prepare_arg_integer(c); // prepare integer argument
   R_len_t ns = LENGTH(s);
   R_len_t nc = LENGTH(c);
   if (ns <= 0 || nc <= 0) return allocVector(INTSXP, 0);
   if (nc % STRI__UCHAR_CLASS_LENGTH != 0)
      error(MSG__INCORRECT_UCHAR_CLASS_ID);
   nc /= STRI__UCHAR_CLASS_LENGTH;
   
   R_len_t nout = stri__recycling_rule(ns, nc);
   
   int* cc = INTEGER(c);
   
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, nout));
   int* ret_int = INTEGER(ret);

   if (LOGICAL(first)[0]) {
      int fnd_first = -1;
      int fnd_last = NA_INTEGER;
      for (R_len_t i=0; i<nout; ++i) {                           
         SEXP curs = STRING_ELT(s, i%ns);                        
         int32_t* curc = cc + STRI__UCHAR_CLASS_LENGTH*(i%nc);   
         R_len_t cursl = LENGTH(curs);                           
         if (curs == NA_STRING || cursl == 0)                    
            ret_int[i] = NA_INTEGER;                             
         else {
            stri__locate_first_and_last_class1(CHAR(curs),       
               cursl, curc, fnd_first, fnd_last);                        
            if (fnd_first >= 0)
               ret_int[i] = fnd_first+1;
            else
               ret_int[i] = NA_INTEGER;
         }
      }
   }
   else {
      int fnd_first = NA_INTEGER;
      int fnd_last  = -1;
      for (R_len_t i=0; i<nout; ++i) {                           
         SEXP curs = STRING_ELT(s, i%ns);                        
         int32_t* curc = cc + STRI__UCHAR_CLASS_LENGTH*(i%nc);   
         R_len_t cursl = LENGTH(curs);                           
         if (curs == NA_STRING || cursl == 0)                    
            ret_int[i] = NA_INTEGER;                             
         else {
            stri__locate_first_and_last_class1(CHAR(curs),       
               cursl, curc, fnd_first, fnd_last);                        
            if (fnd_last >= 0)
               ret_int[i] = fnd_last+1;
            else
               ret_int[i] = NA_INTEGER;
         }
      }
   }

   
   UNPROTECT(1);
   return ret;
}

/* FIXED */

/** Locate the first and/or the last occurence of character pattern in one string
 * 
 *  @param s string
 *  @param n numbytes for s
 *  @param p pattern
 *  @param first [IN/OUT] code point index of the first occurence, 
 *       -1 if not found; 0-based
 *  @param last  [IN/OUT] code point index of the last occurence,
 *       -1 if not found; 0-based
 */
void stri__locate_first_and_last_fixed1(const char* s, int ns,const char* p,  int np,
   int& start, int& end, int& o, bool first)
{
   o = 0;
   int charnum = 0,charnump=0;
   int j,k;
   UChar32 chr;
   
   if(first){
      for (int i=0; i<ns; ++charnum) {
         k=0;
         while(k < np && i+k < ns && s[i+k]==p[k]){
            ++k;
         }
         if(k==np){
            o = 1;
            start = charnum;
            j=i+k;
            for(/* NOOP */; i<j; ++charnum)
               U8_NEXT(s, i, ns, chr);
            --charnum;
            end = charnum;
            break;
         }else
            U8_NEXT(s, i, ns, chr);
      }
   }else{
      //this is not the most efficient, but it works. It is only a little 
      //bit faster than stri_locate_all_fixed, which is bad
//      for (int i=0; i<ns; ++charnum) {
//         k=0;
//         while(s[i+k]==p[k] && k< np){
//            ++k;
//         }
//         if(k==np){
//            o = 1;
//            start = charnum;
//            j=i+k;
//            for(i; i<j; ++charnum)
//               U8_NEXT(s, i, ns, chr);
//            --charnum;
//            end = charnum;
//         }else
//            U8_NEXT(s, i, ns, chr);
//      }

//this version is almost two times faster than this one from above
//but it's still not even close to stri_locate_first
//IMPORTANT: in this version stri_locate_last("aaa","aa")==(2,3) 
//previous (above) version returns (1,2)
      for (int i=ns-np; i>=0; --i) {
         k=0;
         while(k < np && i+k < ns && s[i+k]==p[k]){
            ++k;
         }
         if(k==np){
            o = 1;
            for(j=0; j<i; ++charnum)
               U8_NEXT(s, j, i, chr);
            for(j=0; j<np; ++charnump)
               U8_NEXT(p, j, np, chr);
            start = charnum;
            end = charnum + charnump - 1;
            break;
         }
      }
   }
}


/** Locate all occurences of character pattern in one string
 *  @param s string
 *  @param n numbytes for s
 *  @param p pattern to locate
 * @param start [out] indices  (0-based)
 * @param end [out] indices (0-based)
 * @param o [out] number of occurences (compact subsequences are merged)
 */
void stri__locate_all_fixed1(const char* s, int ns, const char* p,  int np,
   int* start, int* end, int& o)
{
   o = 0;
   int charnum = 0;
   int j,k;
   UChar32 chr;
   
   for (int i=0; i<ns; ++charnum) {
      k=0;
      while(s[i+k]==p[k] && k< np){
         ++k;
      }
      if(k==np){
         ++o;
         start[o-1] = charnum;
         j=i+k;
         //if we found match there is no point of checking next k bytes
         for(/* NOOP */; i<j; ++charnum)
            U8_NEXT(s, i, ns, chr);
         //this line is here, because it was easier to --charnum than check
         //if j in loop should be i+k-1 or i+k-2 (value depends on many 
         //bytes long is last character)
         --charnum;
         end[o-1] = charnum;
      }else
         //the reason why this is in else and not outside the if/else 
         //statement is simple - if k==np then this line is done in loop.
         //it's easier that way - check previous comment
         U8_NEXT(s, i, ns, chr);
   }
}



/** Locate all occurences of pattern
 * @param s character vector
 * @param p character vector
 * @return list of integer matrices (2 columns)
 */
SEXP stri_locate_all_fixed(SEXP s, SEXP p)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   p = stri_prepare_arg_string(p); // prepare integer argument
   R_len_t ns = LENGTH(s);
   R_len_t np = LENGTH(p);
   R_len_t nout = stri__recycling_rule(ns, np);
   if (nout <= 0) return stri__emptyList();
      
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
      /* @TODO: use stri__locate_set_dimnames or its modified version  */
   /* @TODO: use STL stack class here */
   R_len_t nmax = stri__numbytes_max(s);
   if (nmax <= 0) {
      STRI__CREATE2NA_MATRIX(ans)      
      setAttrib(ans, R_DimNamesSymbol, dimnames); 
      
      for (R_len_t i=0; i<nout; ++i)
         SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(4);  
      return ret;
   }
      
   int* start = new int[nmax];
   int* end = new int[nmax];
   int  occurences=0;
   
   for (R_len_t i=0; i<nout; ++i) {
      SEXP curs = STRING_ELT(s, i%ns);
      SEXP curp = STRING_ELT(p, i%np);
      R_len_t cursl = LENGTH(curs);
      R_len_t curpl = LENGTH(curp);

      if (curs == NA_STRING || cursl == 0 || curp == NA_STRING || curpl == 0) {
         STRI__CREATE2NA_MATRIX(ans)
      }
      else {
         stri__locate_all_fixed1(CHAR(curs), cursl, CHAR(curp), curpl,
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
            STRI__CREATE2NA_MATRIX(ans)
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


/** Locate first or last occurences of pattern
 * @param s character vector
 * @param p character vector
 * @return list of integer matrices (2 columns)
 */
SEXP stri_locate_first_or_last_fixed(SEXP s, SEXP p, SEXP first)
{
   first = stri_prepare_arg_logical(first); // prepare logical argument
   if (LENGTH(first) != 1 || LOGICAL(first)[0] == NA_LOGICAL)
      error(MSG__INCORRECT_INTERNAL_ARG);
      
   s = stri_prepare_arg_string(s); // prepare string argument
   p = stri_prepare_arg_string(p); // prepare integer argument
   R_len_t ns = LENGTH(s);
   R_len_t np = LENGTH(p);
   R_len_t nmax = stri__recycling_rule(ns, np);
   // this will work for nmax == 0:
   
   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   stri__locate_set_dimnames(ret);
   int* iret = INTEGER(ret);
   
   int start, end, occurences=0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP curs = STRING_ELT(s, i%ns);
      SEXP curp = STRING_ELT(p, i%np);
      R_len_t cursl = LENGTH(curs);
      R_len_t curpl = LENGTH(curp);

      if (curs == NA_STRING || cursl == 0 || curp == NA_STRING || curpl == 0) {
         iret[i] = NA_INTEGER; 
         iret[i+nmax] = NA_INTEGER;
      }
      else {
         stri__locate_first_and_last_fixed1(CHAR(curs), cursl, CHAR(curp), curpl,
            start, end, occurences, LOGICAL(first)[0]);
         
         if (occurences > 0) {
            iret[i] = start + 1; // 0-based index -> 1-based
            iret[i+nmax] = end + 1;
         }
         else {
            iret[i] = NA_INTEGER;
            iret[i+nmax] = NA_INTEGER;
         }
      } 
   }
   
   UNPROTECT(1);
   return ret;
}


/* REGEX */

/** Locate all occurences of a regex pattern
 * @param s character vector
 * @param p character vector
 * @return list of integer matrices (2 columns)
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_locate_all_regex(SEXP s, SEXP p)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   p = stri_prepare_arg_string(p); // prepare string argument
   R_len_t ns = LENGTH(s);
   R_len_t np = LENGTH(p);
   R_len_t nout = stri__recycling_rule(ns, np);
   if (nout <= 0) return stri__emptyList(); // at least one arg of length 0?
   
   UErrorCode status;
 
   StriContainerUTF16* ss = new StriContainerUTF16(s, nout);
   StriContainerUTF16* pp = new StriContainerUTF16(p, nout);
   
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
   
   R_len_t nmax = stri__numbytes_max(s);
   if (nmax <= 0) {
      STRI__CREATE2NA_MATRIX(ans)
      setAttrib(ans, R_DimNamesSymbol, dimnames); 
      
      for (R_len_t i=0; i<nout; ++i)
         SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(4);  
      return ret;
   }
      
   int* start = new int[nmax];
   int* end = new int[nmax];
   int  occurences=0;
   
   for (int i = 0; i < np; i++) { // for each pattern
      if (pp->isNA(i)) {
         for (int j = i; j < nmax; j += np)
            INTEGER(ret)[j] = NA_INTEGER;
      }
      else {
         status = U_ZERO_ERROR;
         RegexMatcher *matcher = new RegexMatcher(pp->get(i), 0, status);
         if (U_FAILURE(status))
            error(u_errorName(status));
         for (int j = i; j < nmax; j += np) {
            if (ss->isNA(j % ns))
               INTEGER(ret)[j] = NA_INTEGER;
            else {
               matcher->reset(ss->get(j%ns));
               occurences = 0;
               int found = (int)matcher->find();
               while(found){ //find all matches
                  start[occurences] = (int)matcher->start(status);
                  end[occurences] = (int)matcher->end(status);
                  ++occurences;
                  found = (int)matcher->find();
               }
               if (occurences > 0) { //rewrite them
                  PROTECT(ans = allocMatrix(INTSXP, occurences, 2));
                  int* ians = INTEGER(ans);
                  for(int j = 0; j < occurences; j++) {
                     ians[j+0*occurences] = start[j] + 1; // 0-based index -> 1-based
                     ians[j+1*occurences] = end[j]; //end returns position of next character after match
                  }
               }
               else { //if not found, return matrix with NA
                  STRI__CREATE2NA_MATRIX(ans)
               }
               
            setAttrib(ans, R_DimNamesSymbol, dimnames); 
            SET_VECTOR_ELT(ret, i, ans);  // !!!!! `ans` may be used uninitialized in this function !!!!!
            UNPROTECT(1); 
            }
         }
         delete matcher;
      }   
   }
   
   delete [] start;
   delete [] end;
   
   delete ss;
   delete pp;
   UNPROTECT(3);
   return ret;
}


/** Locate first occurence of a regex pattern
 * @param str character vector
 * @param pattern character vector
 * @return list of integer matrices (2 columns)
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - StriContainerUTF16
 */
SEXP stri_locate_first_regex(SEXP str, SEXP pattern)
{
   str     = stri_prepare_arg_string(str);
   pattern = stri_prepare_arg_string(pattern);
   R_len_t nmax = stri__recycling_rule(LENGTH(str), LENGTH(pattern));
   // this will work for nmax == 0:

   StriContainerUTF16* ss = new StriContainerUTF16(str, nmax);
   StriContainerUTF16* pp = new StriContainerUTF16(pattern, nmax);
   
   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   stri__locate_set_dimnames(ret);
   
   int* iret = INTEGER(ret);
   for (R_len_t i = pp->vectorize_init();
         i != pp->vectorize_end();
         i = pp->vectorize_next(i))
   {
      if (pp->isNA(i) || ss->isNA(i)) {
         iret[i] = NA_INTEGER;
         iret[i+nmax] = NA_INTEGER;
      }
      else {
         RegexMatcher *matcher = pp->vectorize_getMatcher(i); // will be deleted automatically
         matcher->reset(ss->get(i));
         int found = (int)matcher->find();
         if (found) { //find first matches
            UErrorCode status = U_ZERO_ERROR;
            int start = (int)matcher->start(status);
            int end   = (int)matcher->end(status);
            if (U_FAILURE(status)) error(MSG__REGEXP_FAILED);

            // @ TODO : Adjush UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)

            iret[i] = start + 1; // 0-based index -> 1-based
            iret[i+nmax] = end;  // end returns position of next character after match
         }
         else {
            iret[i] = NA_INTEGER;
            iret[i+nmax] = NA_INTEGER;
         }
      }   
   }
   
   delete ss;
   delete pp;
   UNPROTECT(1);
   return ret;
}

