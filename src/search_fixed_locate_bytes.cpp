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



/** Locate all occurences of fixed-byte pattern
 * 
 * @param s character vector
 * @param p character vector
 * @return list of integer matrices (2 columns)
 * 
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri__locate_all_fixed_byte(SEXP s, SEXP p)
{
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   p = stri_prepare_arg_string(p, "pattern"); // prepare integer argument
   R_len_t nout = stri__recycling_rule(true, 2, LENGTH(s), LENGTH(p));
   if (nout <= 0) return stri__emptyList();
   
   StriContainerUTF8* ss = new StriContainerUTF8(s, nout);
   StriContainerUTF8* sp = new StriContainerUTF8(p, nout);
   
   SEXP notfound; // this matrix will be set iff not found or NA
   PROTECT(notfound = stri__matrix_NA_INTEGER(1, 2));
   
   SEXP ans;
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP, nout));
   /* @TODO: use STL stack class here - deque  */
   R_len_t nmax = stri__numbytes_max(s);
   if (nmax <= 0) {
      for (R_len_t i=0; i<nout; ++i)
         SET_VECTOR_ELT(ret, i, notfound);
      stri__locate_set_dimnames_list(ret);
      UNPROTECT(2);
      return ret;
   }
      
   int* start = new int[nmax];
   int* end = new int[nmax];
   int  occurences = 0;

   for (R_len_t i=0; i<nout; ++i) {  
      const String8* curs = &ss->get(i);
      const String8* curp = &sp->get(i);
      int ns = curs->length();
      int np = curp->length();
      
      if (ss->isNA(i) || sp->isNA(i) || ns <= 0 || np <= 0) {
         SET_VECTOR_ELT(ret, i, notfound);
         continue;
      }
      
      const char* chs = curs->c_str();
      const char* chp = curp->c_str();
      
      stri__locate_all_fixed1(chs, ns, chp, np, start, end, occurences);
         
      if (occurences > 0) {
         PROTECT(ans = allocMatrix(INTSXP, occurences, 2));
         int* ians = INTEGER(ans);
         for(int j = 0; j < occurences; j++) {
            ians[j+0*occurences] = start[j] + 1; // 0-based index -> 1-based
            ians[j+1*occurences] = end[j] + 1;
         }
         SET_VECTOR_ELT(ret, i, ans);
         UNPROTECT(1);
      }
      else {
         SET_VECTOR_ELT(ret, i, notfound);
      }
   }
   stri__locate_set_dimnames_list(ret);
   delete [] start;
   delete [] end;
   UNPROTECT(1);
   return ret;
}


/** Locate first occurence of fixed-byte pattern
 * 
 * @param s character vector
 * @param p character vector
 * @return list of integer matrices (2 columns)
 * 
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri__locate_first_fixed_byte(SEXP s, SEXP p)
{
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   p = stri_prepare_arg_string(p, "pattern"); // prepare integer argument
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(s), LENGTH(p));
   // this will work for nmax == 0:
   
   StriContainerUTF8* ss = new StriContainerUTF8(s, nmax);
   StriContainerUTF8* sp = new StriContainerUTF8(p, nmax);
   
   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   stri__locate_set_dimnames_matrix(ret);
   int* iret = INTEGER(ret);
   
   int start, end, occurences=0;
   for (R_len_t i=0; i<nmax; ++i) {  
      iret[i]      = NA_INTEGER; 
      iret[i+nmax] = NA_INTEGER;
      
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(*ss, *sp, ;/*nothing*/, ;/*nothing*/ )
      const String8* curs = &ss->get(i);
      const String8* curp = &sp->get(i);
      int ns = curs->length();
      int np = curp->length();
      
      const char* chs = curs->c_str();
      const char* chp = curp->c_str();
      
      stri__locate_first_and_last_fixed1(chs, ns, chp, np, start, end, occurences, true);
      
      if (occurences > 0) {
         iret[i]      = start + 1; // 0-based index -> 1-based
         iret[i+nmax] = end + 1;
      }
   }
   
   UNPROTECT(1);
   return ret;
}


/** Locate last occurence of a fixed-byte pattern
 * 
 * @param s character vector
 * @param p character vector
 * @return list of integer matrices (2 columns)
 * 
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri__locate_last_fixed_byte(SEXP s, SEXP p)
{
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   p = stri_prepare_arg_string(p, "pattern"); // prepare integer argument
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(s), LENGTH(p));
   // this will work for nmax == 0:

   StriContainerUTF8* ss = new StriContainerUTF8(s, nmax);
   StriContainerUTF8* sp = new StriContainerUTF8(p, nmax);

   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   stri__locate_set_dimnames_matrix(ret);
   int* iret = INTEGER(ret);
   
   int start, end, occurences=0;
   for (R_len_t i=0; i<nmax; ++i) {
      iret[i]      = NA_INTEGER; 
      iret[i+nmax] = NA_INTEGER;
      
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(*ss, *sp, ;/*nothing*/, ;/*nothing*/ )
      const String8* curs = &ss->get(i);
      const String8* curp = &sp->get(i);
      int ns = curs->length();
      int np = curp->length();
      
      const char* chs = curs->c_str();
      const char* chp = curp->c_str();
      
      stri__locate_first_and_last_fixed1(chs, ns, chp, np, start, end, occurences, false);
      
      if (occurences > 0) {
         iret[i]      = start + 1; // 0-based index -> 1-based
         iret[i+nmax] = end + 1;
      }
   }
   
   UNPROTECT(1);
   return ret;
}
