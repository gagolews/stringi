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
#include "stri_container_utf8.h"
#include "stri_container_utf16.h"
#include "stri_container_usearch.h"
#include "stri_container_bytesearch.h"
#include <unicode/uregex.h>
#include <deque>
#include <utility>
using namespace std;


/**
 * Returns vector elements if a pattern occurs in a string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.3-1 (Bartek Tartanus)
 *		first version
 * 
 */
 
 
SEXP stri_subset_fixed(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");


   STRI__ERROR_HANDLER_BEGIN
   int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length);

	deque< int > result;

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         result.push_back(NA_LOGICAL),
         /* nothing */)

      pattern_cont.setupMatcherFwd(i, str_cont.get(i).c_str(), str_cont.get(i).length());
      if((int)(pattern_cont.findFirst() != USEARCH_DONE)){
      	result.push_back(i);
      }
   }
   
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, result.size()));
   deque< int >::iterator iter = result.begin();
   for (R_len_t j = 0; iter != result.end(); ++iter, ++j) {
      if(*iter != NA_LOGICAL){
      	SET_STRING_ELT(ret, j, str_cont.toR(*iter));
      }else{
      	SET_STRING_ELT(ret, j, NA_STRING);
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}
