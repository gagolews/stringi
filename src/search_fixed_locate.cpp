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
 * Locate all pattern occurences in a string [with collation]
 * 
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts passed to stri__ucol_open(),
 * if \code{NA}, then \code{stri__locate_all_fixed_byte} is called
 * @return list of integer matrices (2 columns)
 * 
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-09) StriContainerUTF16 & collator
 */
SEXP stri_locate_all_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   UCollator* col = stri__ucol_open(collator_opts);
   if (!col)
      return stri__locate_all_fixed_byte(str, pattern);
   
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
         continue;
      }

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
      
      
      if (start == USEARCH_DONE) {
         SET_VECTOR_ELT(ret, i, notfound);
      }
      else { // if we have match
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
         int* ans_tab = INTEGER(ans);
         deque<R_len_t_x2>::iterator iter = occurences.begin();
         for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
            R_len_t_x2 match = *iter;
            ans_tab[j]             = match.v1; 
            ans_tab[j+noccurences] = match.v2;
         }
         
         // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
         stri__UChar16_to_UChar32_index(cur_str->getBuffer(),
               cur_str->length(), ans_tab,
               ans_tab+noccurences, noccurences,
               1, // 0-based index -> 1-based
               0  // end returns position of next character after match
         );
         
         SET_VECTOR_ELT(ret, i, ans);
         UNPROTECT(1);
      }
      
      if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
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
 * 
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts passed to stri__ucol_open(),
 * if \code{NA}, then \code{stri__locate_first_fixed_byte} is called
 * @return integer matrix (2 columns)
 * 
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-09) StriContainerUTF16 & collator
 */
SEXP stri_locate_first_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   UCollator* col = stri__ucol_open(collator_opts);
   if (!col)
      return stri__locate_first_fixed_byte(str, pattern);
   
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
         
         int start = usearch_first(matcher, &err);
         
         //if we have match
         if(start != USEARCH_DONE){
            iret[i]      = start;
            iret[i+nmax] = start + usearch_getMatchedLength(matcher);
            
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




/** 
 * Locate last occurences of pattern in a string [with collation]
 * 
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts passed to stri__ucol_open(),
 * if \code{NA}, then \code{stri__locate_last_fixed_byte} is called
 * @return integer matrix (2 columns)
 * 
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-09) StriContainerUTF16 & collator
 */
SEXP stri_locate_last_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   UCollator* col = stri__ucol_open(collator_opts);
   if (!col)
      return stri__locate_last_fixed_byte(str, pattern);
   
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
         
         int start = usearch_last(matcher, &err);
         // this properly detects overlapping matches
         // (search is performed from-the-end, and no from-beginning
         
         
         //if we have match
         if(start != USEARCH_DONE){
            iret[i]      = start;
            iret[i+nmax] = start + usearch_getMatchedLength(matcher);
   
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
