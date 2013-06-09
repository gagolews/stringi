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



/** Locate all occurences of pattern
 * @param s character vector
 * @param p character vector
 * @return list of integer matrices (2 columns)
 */
SEXP stri_locate_all_fixed(SEXP s, SEXP p)
{
   s = stri_prepare_arg_string(s, "stri"); // prepare string argument
   p = stri_prepare_arg_string(p, "pattern"); // prepare integer argument
   R_len_t ns = LENGTH(s);
   R_len_t np = LENGTH(p);
   R_len_t nout = stri__recycling_rule(true, 2, ns, np);
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
      PROTECT(ans = stri__matrix_NA_INTEGER(1,2));    
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
         PROTECT(ans = stri__matrix_NA_INTEGER(1,2));
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


/** Locate first or last occurences of pattern
 * @param s character vector
 * @param p character vector
 * @return list of integer matrices (2 columns)
 */
SEXP stri_locate_first_or_last_fixed(SEXP s, SEXP p, SEXP first)
{
   // TODO: .....prepare....1??
   first = stri_prepare_arg_logical(first, "first"); // prepare logical argument
   if (LENGTH(first) != 1 || LOGICAL(first)[0] == NA_LOGICAL)
      error(MSG__INCORRECT_INTERNAL_ARG);
      
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   p = stri_prepare_arg_string(p, "pattern"); // prepare integer argument
   R_len_t ns = LENGTH(s);
   R_len_t np = LENGTH(p);
   R_len_t nmax = stri__recycling_rule(true, 2, ns, np);
   // this will work for nmax == 0:
   
   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   stri__locate_set_dimnames_matrix(ret);
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



/** 
 * Locate a pattern occurs in a string [with collation]
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts passed to stri__ucol_open(),
 * if \code{NA}, then \code{stri_detect_fixed_byte} is called
 * @return list of integer matrices (2 columns)
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-09) StriContainerUTF16 & collator
 */
SEXP stri_locate_all_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   UCollator* col = stri__ucol_open(collator_opts);
   if (!col)
      return stri_detect_fixed_byte(str, pattern);
   
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   
   SEXP notfound; // this matrix will be set iff not found or NA
   PROTECT(notfound = stri__matrix_NA_INTEGER(1, 2));
   
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP, nmax));
   
   StriContainerUTF16* ss = new StriContainerUTF16(str, nmax);
   StriContainerUTF16* pp = new StriContainerUTF16(pattern, nmax);
   UErrorCode err = U_ZERO_ERROR;
   
   const UnicodeString* last_str = NULL;
   const UnicodeString* last_pat = NULL;
   err = U_ZERO_ERROR;
   UStringSearch *matcher = NULL;
   
   if (!U_SUCCESS(err))
      error(MSG__STRSEARCH_FAILED);
   
   for (R_len_t i = pp->vectorize_init();
         i != pp->vectorize_end();
         i = pp->vectorize_next(i))
   {
      //if string or pattern == NA then return matrix with NA
      if (pp->isNA(i) || ss->isNA(i)) {
         SET_VECTOR_ELT(ret, i, notfound);
      }
      else {
         const UnicodeString* cur_str = &(ss->get(i));
         const UnicodeString* cur_pat = &(pp->get(i));
         
         if (!matcher) {
            last_pat = cur_pat;
            last_str = cur_str;
            err = U_ZERO_ERROR;
            matcher = usearch_openFromCollator(last_pat->getBuffer(), last_pat->length(),
               last_str->getBuffer(), last_str->length(), col, NULL, &err);
            if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
//            usearch_setAttribute(matcher, USEARCH_OVERLAP, USEARCH_OFF, &err); // this is default
         }
         //if last pattern is equal to current then save time and dont change this   
         if (cur_pat != last_pat) {
            last_pat = cur_pat;
            err = U_ZERO_ERROR;
            usearch_setPattern(matcher, last_pat->getBuffer(), last_pat->length(), &err);
            if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
         }
         //as above, this time for string   
         if (cur_str != last_str) {
            last_str = cur_str;
            err = U_ZERO_ERROR;
            usearch_setText(matcher, last_str->getBuffer(), last_str->length(), &err);
            if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
         }
         
         usearch_reset(matcher);
         err = U_ZERO_ERROR;
         
         int start = (int)usearch_first(matcher, &err);
         
         //if we have match
         if(start != USEARCH_DONE){
            deque<R_len_t_x2> occurences;
            
            while (start != USEARCH_DONE) {
               occurences.push_back(R_len_t_x2(start, start+usearch_getMatchedLength(matcher)));
               err = U_ZERO_ERROR;
               start = usearch_next(matcher, &err);
               
               if (U_FAILURE(err)) error(MSG__STRSEARCH_FAILED);
            }
            
            R_len_t noccurences = occurences.size();
            SEXP ans;
            PROTECT(ans = allocMatrix(INTSXP, noccurences, 2));
            deque<R_len_t_x2>::iterator iter = occurences.begin();
            for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
               R_len_t_x2 match = *iter;
               INTEGER(ans)[j]             = match.v1; 
               INTEGER(ans)[j+noccurences] = match.v2;
            }
            
            // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
            stri__UChar16_to_UChar32_index(ss->get(i).getBuffer(),
                  ss->get(i).length(), INTEGER(ans),
                  INTEGER(ans)+noccurences, noccurences,
                  1, // 0-based index -> 1-based
                  0  // end returns position of next character after match
            );
            
            SET_VECTOR_ELT(ret, i, ans);
            UNPROTECT(1);
         }else{ //if dont, return 1x2 matrix with NA
            SET_VECTOR_ELT(ret, i, notfound);
         }
         
         if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
      }
   }
   
   if (col) ucol_close(col);
   if (matcher) usearch_close(matcher);
   delete ss;
   delete pp;
   stri__locate_set_dimnames_list(ret);
   UNPROTECT(2);
   return ret;
}



/** 
 * Locate first occurences of pattern in a string [with collation]
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts passed to stri__ucol_open(),
 * if \code{NA}, then \code{stri_detect_fixed_byte} is called
 * @return integer matrix (2 columns)
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-09) StriContainerUTF16 & collator
 */
SEXP stri_locate_first_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   UCollator* col = stri__ucol_open(collator_opts);
   if (!col)
      return stri_detect_fixed_byte(str, pattern);
   
   str      = stri_prepare_arg_string(str, "str");
   pattern  = stri_prepare_arg_string(pattern, "pattern");
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   
   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   stri__locate_set_dimnames_matrix(ret);
   int* iret = INTEGER(ret);
   
   StriContainerUTF16* ss = new StriContainerUTF16(str, nmax);
   StriContainerUTF16* pp = new StriContainerUTF16(pattern, nmax);
   UErrorCode err = U_ZERO_ERROR;
   
   const UnicodeString* last_str = NULL;
   const UnicodeString* last_pat = NULL;
   err = U_ZERO_ERROR;
   UStringSearch *matcher = NULL;
   
   if (!U_SUCCESS(err))
      error(MSG__STRSEARCH_FAILED);
   
   for (R_len_t i = pp->vectorize_init();
         i != pp->vectorize_end();
         i = pp->vectorize_next(i))
   {
      //if string or pattern == NA then return matrix with NA
      if (pp->isNA(i) || ss->isNA(i)) {
         iret[i]      = NA_INTEGER;
         iret[i+nmax] = NA_INTEGER;
      }
      else {
         const UnicodeString* cur_str = &(ss->get(i));
         const UnicodeString* cur_pat = &(pp->get(i));
         
         if (!matcher) {
            last_pat = cur_pat;
            last_str = cur_str;
            err = U_ZERO_ERROR;
            matcher = usearch_openFromCollator(last_pat->getBuffer(), last_pat->length(),
               last_str->getBuffer(), last_str->length(), col, NULL, &err);
            if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
//            usearch_setAttribute(matcher, USEARCH_OVERLAP, USEARCH_OFF, &err); // this is default
         }
         //if last pattern is equal to current then save time and dont change this   
         if (cur_pat != last_pat) {
            last_pat = cur_pat;
            err = U_ZERO_ERROR;
            usearch_setPattern(matcher, last_pat->getBuffer(), last_pat->length(), &err);
            if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
         }
         //as above, this time for string   
         if (cur_str != last_str) {
            last_str = cur_str;
            err = U_ZERO_ERROR;
            usearch_setText(matcher, last_str->getBuffer(), last_str->length(), &err);
            if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
         }
         
         usearch_reset(matcher);
         err = U_ZERO_ERROR;
         
         int start = (int)usearch_first(matcher, &err);
         
         //if we have match
         if(start != USEARCH_DONE){
            iret[i]      = start;
            iret[i+nmax] = start+usearch_getMatchedLength(matcher);
            
            // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
            stri__UChar16_to_UChar32_index(ss->get(i).getBuffer(),
                  ss->get(i).length(), 
                  iret+i, iret+i+nmax, 1,
                  1, // 0-based index -> 1-based
                  0  // end returns position of next character after match
            );
         }else{ //if dont, return NA
            iret[i]      = NA_INTEGER;
            iret[i+nmax] = NA_INTEGER;
         }
         
         if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
      }
   }
   
   if (col) ucol_close(col);
   if (matcher) usearch_close(matcher);
   delete ss;
   delete pp;
   UNPROTECT(1);
   return ret;
}
