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



/** Get Desired Normalizer2 instance
 *
 * @param type R object, will be tested whether it's an integer vector of length 1
 * @return unmodifiable singleton instance. Do not delete it.
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.1 (Marek Gagolewski, 2013-06-29) don't use getNFCInstance as it's in ICU DRAFT API
 */
const Normalizer2* stri__normalizer_get(SEXP type)
{
   if (!Rf_isInteger(type) || LENGTH(type) != 1)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG); // this is an internal arg, check manually, error() allowed here
   int _type = INTEGER(type)[0];

   UErrorCode status = U_ZERO_ERROR;
   const Normalizer2* normalizer = NULL;

   switch (_type) {
      case STRI_NFC:
         normalizer = Normalizer2::getInstance(NULL, "nfc", UNORM2_COMPOSE, status);
//         normalizer = Normalizer2::getNFCInstance(status);
         break;

      case STRI_NFD:
         normalizer = Normalizer2::getInstance(NULL, "nfc", UNORM2_DECOMPOSE, status);
//         normalizer = Normalizer2::getNFDInstance(status);
         break;

      case STRI_NFKC:
         normalizer = Normalizer2::getInstance(NULL, "nfkc", UNORM2_COMPOSE, status);
//         normalizer = Normalizer2::getNFKCInstance(status);
         break;

      case STRI_NFKD:
         normalizer = Normalizer2::getInstance(NULL, "nfkc", UNORM2_DECOMPOSE, status);
//         normalizer = Normalizer2::getNFKDInstance(status);
         break;

      case STRI_NFKC_CASEFOLD:
         normalizer = Normalizer2::getInstance(NULL, "nfkc_cf", UNORM2_COMPOSE, status);
//         normalizer = Normalizer2::getNFKCCasefoldInstance(status);
         break;

      default:
         Rf_error(MSG__INCORRECT_INTERNAL_ARG); // error() allowed here
   }

   if (U_FAILURE(status))
      Rf_error(MSG__RESOURCE_ERROR_GET);

   return normalizer;
}




/**
 * Perform Unicode Normalization
 *
 * @param str character vector
 * @param type normalization type [internal]
 * @return character vector
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF16 & ICU facilities
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_enc_nf(SEXP str, SEXP type)
{
   str = stri_prepare_arg_string(str, "str");    // prepare string argument
   R_len_t str_length = LENGTH(str);

   const Normalizer2* normalizer =
      stri__normalizer_get(type); // auto `type` check here, call before ERROR_HANDLER

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF16 str_cont(str, str_length, false); // writable, no recycle

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (!str_cont.isNA(i)) {
         UErrorCode status = U_ZERO_ERROR;
         str_cont.set(i, normalizer->normalize(str_cont.get(i), status));
         if (U_FAILURE(status))
            throw StriException(status);
      }
   }

   // normalizer shall not be deleted at all
   return str_cont.toR();
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/**
 * Check if String is Normalized
 *
 * @param str character vector
 * @param type normalization type [internal]
 * @return logical vector
 * @version 0.1 (Marek Gagolewski) - use StriContainerUTF16
 * @version 0.2 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_enc_isnf(SEXP str, SEXP type)
{
   str = stri_prepare_arg_string(str, "str");    // prepare string argument
   R_len_t str_length = LENGTH(str);

   const Normalizer2* normalizer =
      stri__normalizer_get(type); // auto `type` check here, call before ERROR_HANDLER

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF16 str_cont(str, str_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, str_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      UErrorCode status = U_ZERO_ERROR;
      ret_tab[i] = normalizer->isNormalized(str_cont.get(i), status);
      if (U_FAILURE(status))
         throw StriException(status);
   }

   // normalizer shall not be deleted at all
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
