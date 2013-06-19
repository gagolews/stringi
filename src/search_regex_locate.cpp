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




/** Locate all occurences of a regex pattern
 * @param s character vector
 * @param p character vector
 * @return list of integer matrices (2 columns)
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - StriContainerUTF16+deque usage
 */
SEXP stri_locate_all_regex(SEXP s, SEXP p)
{
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   p = stri_prepare_arg_string(p, "pattern"); // prepare string argument
   R_len_t ns = LENGTH(s);
   R_len_t np = LENGTH(p);
   R_len_t nout = stri__recycling_rule(true, 2, ns, np);
   // this will work for nmax == 0:
 
   StriContainerUTF16* ss = new StriContainerUTF16(s, nout);
   StriContainerUTF16* pp = new StriContainerUTF16(p, nout);
   
   SEXP notfound; // this matrix will be set iff not found or NA
   PROTECT(notfound = stri__matrix_NA_INTEGER(1, 2));
   
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP, nout));

   for (R_len_t i = pp->vectorize_init();
         i != pp->vectorize_end();
         i = pp->vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(*ss, *pp, SET_VECTOR_ELT(ret, i, notfound), SET_VECTOR_ELT(ret, i, notfound))
      
      RegexMatcher *matcher = pp->vectorize_getMatcher(i); // will be deleted automatically
      matcher->reset(ss->get(i));
      int found = (int)matcher->find();
      if (!found) {
         SET_VECTOR_ELT(ret, i, notfound);
      }
      else {
         deque<R_len_t_x2> occurences;
         while (found) {
            UErrorCode status = U_ZERO_ERROR;
            int start = (int)matcher->start(status);
            int end  =  (int)matcher->end(status);
            if (U_FAILURE(status)) error(MSG__REGEXP_FAILED);
            
            occurences.push_back(R_len_t_x2(start, end));
            found = (int)matcher->find();
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
         ss->UChar16_to_UChar32_index(i, INTEGER(ans),
               INTEGER(ans)+noccurences, noccurences,
               1, // 0-based index -> 1-based
               0  // end returns position of next character after match
         );
         SET_VECTOR_ELT(ret, i, ans);
         UNPROTECT(1);
      }
   }
   
   delete ss;
   delete pp;
   stri__locate_set_dimnames_list(ret);
   UNPROTECT(2);
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
   str     = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   // this will work for nmax == 0:

   StriContainerUTF16* ss = new StriContainerUTF16(str, nmax);
   StriContainerUTF16* pp = new StriContainerUTF16(pattern, nmax);
   
   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   
   int* iret = INTEGER(ret);
   for (R_len_t i = pp->vectorize_init();
         i != pp->vectorize_end();
         i = pp->vectorize_next(i))
   {
      iret[i] = NA_INTEGER;
      iret[i+nmax] = NA_INTEGER;
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(*ss, *pp, ;/*nothing*/, ;/*nothing*/)
      
      RegexMatcher *matcher = pp->vectorize_getMatcher(i); // will be deleted automatically
      matcher->reset(ss->get(i));
      int found = (int)matcher->find();
      if (found) { //find first matches
         UErrorCode status = U_ZERO_ERROR;
         int start = (int)matcher->start(status);
         int end   = (int)matcher->end(status);
         if (U_FAILURE(status)) error(MSG__REGEXP_FAILED);
         iret[i] = start;
         iret[i+nmax] = end;
         
         // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
         ss->UChar16_to_UChar32_index(i, 
               iret+i, iret+i+nmax, 1,
               1, // 0-based index -> 1-based
               0  // end returns position of next character after match
         );
      }
   }
   
   delete ss;
   delete pp;
   stri__locate_set_dimnames_matrix(ret);
   UNPROTECT(1);
   return ret;
}




/** Locate first occurence of a regex pattern
 * @param str character vector
 * @param pattern character vector
 * @return list of integer matrices (2 columns)
 * @version 0.1 (Bartlomiej Tartanus, 2013-06-10) - StriContainerUTF16
 */
SEXP stri_locate_last_regex(SEXP str, SEXP pattern)
{
   str     = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   // this will work for nmax == 0:

   StriContainerUTF16* ss = new StriContainerUTF16(str, nmax);
   StriContainerUTF16* pp = new StriContainerUTF16(pattern, nmax);
   
   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   
   int* iret = INTEGER(ret);
   for (R_len_t i = pp->vectorize_init();
         i != pp->vectorize_end();
         i = pp->vectorize_next(i))
   {
      iret[i] = NA_INTEGER;
      iret[i+nmax] = NA_INTEGER;
     
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(*ss, *pp, ;/*nothing*/, ;/*nothing*/)
     
      RegexMatcher *matcher = pp->vectorize_getMatcher(i); // will be deleted automatically
      matcher->reset(ss->get(i));
      int found = (int)matcher->find();
      if (found) { //find first matches
         int start, end;
         while (found) {
            UErrorCode status = U_ZERO_ERROR;
            start = (int)matcher->start(status);
            end   = (int)matcher->end(status);
            if (U_FAILURE(status)) error(MSG__REGEXP_FAILED);
            
            found = (int)matcher->find();
         }      
         
         iret[i] = start;
         iret[i+nmax] = end;
         
         // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
         ss->UChar16_to_UChar32_index(i, 
               iret+i, iret+i+nmax, 1,
               1, // 0-based index -> 1-based
               0  // end returns position of next character after match
         );
      }
   }
   
   delete ss;
   delete pp;
   stri__locate_set_dimnames_matrix(ret);
   UNPROTECT(1);
   return ret;
}


