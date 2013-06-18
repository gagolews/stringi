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
 * Count the number of recurrences of \code{pattern} in \code{str} [fast but dummy bitewise compare]
 * 
 * @param str strings to search in
 * @param pattern patterns to search for
 * @return integer vector
 * 
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8
 * @version 0.3 (Marek Gagolewski) - corrected behavior on empty str/pattern
 */
SEXP stri_count_fixed_byte(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   int ns = LENGTH(str);
   int np = LENGTH(pattern);
   if (ns <= 0 || np <= 0) return allocVector(INTSXP, 0);
   int nmax = stri__recycling_rule(true, 2, ns, np);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* sp = new StriContainerUTF8(pattern, nmax);

   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, nmax));
   int* ret_tab = INTEGER(ret);
   
   for (R_len_t i=0; i<nmax; ++i) {  
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(*ss, *sp, ret_tab[i] = NA_INTEGER, ret_tab[i] = 0)
      
      ret_tab[i] = 0;
      const String8* curs = &ss->get(i);
      const String8* curp = &sp->get(i);
      const char* chs = curs->c_str();
      const char* chp = curp->c_str();
      int ns = curs->length();
      int np = curp->length();
      
      ret_tab[i] = false;
      for (int j=0; j<ns-np+1; ++j) {                  // O(ns*np) algorithm
         int k=0;
         while(k<np && chs[j+k] == chp[k])
            k++;
      	if(k == np) {
            ++ret_tab[i];
            //if match then skip and check next element of s
            j += np-1; // skip next np chars (-1, as we do ++j)
   		}
   	}
   }
   
   delete ss;
   delete sp;
   UNPROTECT(1);
   return ret;
}




/** 
 * Count pattern occurcess in a string [with collation]
 * 
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts passed to stri__ucol_open(),
 * if \code{NA}, then \code{stri_detect_fixed_byte} is called
 * @return integer vector
 * 
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - corrected behavior on empty str/pattern
 */
SEXP stri_count_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   UCollator* col = stri__ucol_open(collator_opts);
   if (!col)
      return stri_count_fixed_byte(str, pattern);
   
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, nmax));
   int* ret_tab = INTEGER(ret);
   
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
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(*ss, *pp, ret_tab[i] = NA_INTEGER, ret_tab[i] = 0)
      
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

      if (cur_pat != last_pat) {
         last_pat = cur_pat;
         err = U_ZERO_ERROR;
         usearch_setPattern(matcher, last_pat->getBuffer(), last_pat->length(), &err);
         if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
      }

      if (cur_str != last_str) {
         last_str = cur_str;
         err = U_ZERO_ERROR;
         usearch_setText(matcher, last_str->getBuffer(), last_str->length(), &err);
         if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
      }
      
      usearch_reset(matcher);
      err = U_ZERO_ERROR;
      ret_tab[i] = 0;
      int result = (int)usearch_first(matcher, &err); // this is F*G slow! :-(
      if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
      while (result != USEARCH_DONE && U_SUCCESS(err))
      {
         ++ret_tab[i];
         result = (int)usearch_next(matcher, &err);
      }
      if (!U_SUCCESS(err)) error(MSG__STRSEARCH_FAILED);
   }
   
   if (col) ucol_close(col);
   if (matcher) usearch_close(matcher);
   delete ss;
   delete pp;
   UNPROTECT(1);
   return ret;
}

