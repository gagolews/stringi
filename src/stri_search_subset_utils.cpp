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
#include "stri_container_usearch.h"
#include <unicode/uregex.h>


/**
 * Subset str_cont to SEXP by logical table ret_tab
 *
 * @version 0.3-1 (Bartlomiej Tartanus, 2014-07-25)
 *          first version
 */
SEXP stri__subset_by_logical(StriContainerUTF8 str_cont, int* ret_tab, int result_counter)
{
	STRI__ERROR_HANDLER_BEGIN
	SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, result_counter));
   for (R_len_t j = 0, i=0; i < result_counter; ++j) {
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
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}


/**
 * Subset str_cont to SEXP by logical table ret_tab
 *
 * @version 0.3-1 (Bartlomiej Tartanus, 2014-07-25)
 *          first version
 */
SEXP stri__subset_by_logical(StriContainerUTF16 str_cont, int* ret_tab, int result_counter)
{
	STRI__ERROR_HANDLER_BEGIN
	SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, result_counter));
   for (R_len_t j = 0, i=0; i < result_counter; ++j) {
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
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}
