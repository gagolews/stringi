/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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
