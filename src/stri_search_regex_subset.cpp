/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#include "stri_stringi.h"
#include "stri_container_utf16.h"
#include "stri_container_utf8.h"
#include "stri_container_regex.h"
#include <deque>

/**
 * Detect if a pattern occurs in a string
 *
 * @param str R character vector
 * @param pattern R character vector containing regular expressions
 * @param opts_regex list
 *
 * @version 0.3-1 (Bartlomiej Tartanus)
 *				first version
 */
SEXP stri_subset_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t vectorize_length =
      stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF16 str_cont(str, vectorize_length);
//   StriContainerUTF8 str_cont(str, vectorize_length); // utext_openUTF8, see below
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

	//this cannot be done with deque, because pattern is reused so the i does not 
	//go 0,1,2...n but 0,pat_len,2*pat_len,1,pat_len+1 and so on
	int* ret_tab = new int[vectorize_length];
	int result_counter = 0;
	
   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont,
         pattern_cont, ret_tab[i] = NA_LOGICAL; result_counter++, ret_tab[i] = FALSE)

      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      matcher->reset(str_cont.get(i));
      ret_tab[i] = (int)matcher->find();
      if(ret_tab[i]){ // returns UBool
      	result_counter++;
      }
   }
   
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, result_counter));
   for (R_len_t j = 0, i=0; j < vectorize_length; ++j) {
      if(ret_tab[j] == NA_LOGICAL){
      	SET_STRING_ELT(ret, i, NA_STRING);
      	i++;
      }else if(ret_tab[j]){
      	SET_STRING_ELT(ret, i, str_cont.toR(j));
      	i++;
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
