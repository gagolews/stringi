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
#include "stri_container_integer.h"
#include <cstring>
#include <vector>


/** Match an option from a set of options 
 * 
 * @param option
 * @param set
 * @return index in set, negative value for no match
 */
int stri__match_arg(const char* option, const char** set) {
   int set_length = 0;
   while (set[set_length] != NULL) ++set_length;
   if (set_length <= 0) return -1;
    // this could be substituted for a linked list:
   std::vector<bool> excluded(set_length, false);
   
   for (int k=0; option[k] != '\0'; ++k) {
      for (int i=0; i<set_length; ++i) {
         if (excluded[i]) continue;
         if (set[i][k] == '\0' || set[i][k] != option[k])
            excluded[i] = true;
      }
   }
   
   int which = -1;
   for (int i=0; i<set_length; ++i) {
      if (excluded[i]) continue;
      if (which < 0) which = i;
      else return -1; // more than one match
   }
   return which;
}



/**
 * Pad a string
 *
 * vectorized over str, length and pad
 * if str or pad or length is NA the result will be NA
 *
 * @param str character vector
 * @param min_length integer vector
 * @param side character vector (left/right/both)
 * @param pad character vector
 * @return character vector
 *
 * @version 0.1-?? (Bartlomiej Tartanus)
 * 
 * @version 0.2-2 (Marek Gagolewski, 2014-04-20)
 *          use stri_error_handler, pad should be a single code point, not byte
*/
SEXP stri_pad(SEXP str, SEXP min_length, SEXP side, SEXP pad)
{
   str        = stri_prepare_arg_string(str, "str");
   min_length = stri_prepare_arg_integer(min_length, "min_length");
   side       = stri_prepare_arg_string(side, "side");
   pad        = stri_prepare_arg_string(pad, "pad");
   const char* side_opts[] = {"left", "right", "both", NULL};

   R_len_t str_length     = LENGTH(str);
   R_len_t length_length  = LENGTH(min_length);
   R_len_t side_length    = LENGTH(side);
   R_len_t pad_length     = LENGTH(pad);
   
   R_len_t vectorize_length = stri__recycling_rule(true, 4,
      str_length, length_length, side_length, pad_length);
      
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8       str_cont(str, vectorize_length);
   StriContainerInteger length_cont(min_length, vectorize_length);
   StriContainerUTF8      side_cont(side, vectorize_length);
   StriContainerUTF8       pad_cont(pad, vectorize_length);
   
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));
   
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (str_cont.isNA(i) || pad_cont.isNA(i)
          || side_cont.isNA(i) || length_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      // get the current string
      R_len_t str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t str_cur_len = 0; // TODO: calculate length of str
      
      throw StriException("TO DO");
      
      // get the padding code point
      UChar32 pad_cur = 0;
      R_len_t pad_cur_n = pad_cont.get(i).length();
      const char* pad_cur_s = pad_cont.get(i).c_str();
      R_len_t k = 0;
      U8_NEXT(pad_cur_s, k, pad_cur_n, pad_cur);
      if (pad_cur <= 0 || k < pad_cur_n)
         throw StriException(MSG__NOT_EQ_N_CODEPOINTS, "pad", 1);
      
      // get the minimal length
      R_len_t length_cur = length_cont.get(i);
      
      // get the desired pad side
      const char* side_cur_s = side_cont.get(i).c_str();
      int side_cur = stri__match_arg(side_cur_s, side_opts);
      if (side_cur < 0)
         throw StriException(MSG__INCORRECT_MATCH_OPTION, "side");

//
//   int needed=0;
//
//   int* iwidth = INTEGER(width);
//   int* iside  = INTEGER(side);
//   int* islen  = INTEGER(stri_length(s));
//   int* isnum  = INTEGER(stri_numbytes(s));
//   int* ipnum  = INTEGER(stri_numbytes(pad));
//
//   for (R_len_t i=0; i<nmax; ++i) {
//      curs = STRING_ELT(s, i % ns);
//      const char* p = CHAR(STRING_ELT(pad, i % np));
//      if(curs == NA_STRING || iwidth[i % nwidth] == NA_INTEGER){
//         SET_STRING_ELT(ret, i, NA_STRING);
//         continue;
//      }
//      //if current string is long enough - return with no change
//      needed = max(0, iwidth[i % nwidth] - islen[i % ns]);
//      if(needed == 0){
//         SET_STRING_ELT(ret, i, curs);
//         continue;
//      }
//      char* buf = R_alloc(isnum[i%ns]+ipnum[i%np]*needed, (int)sizeof(char));
//      char* buf2 = buf;
//      switch(iside[i % nside]){
//         //pad from left
//         case 1:
//         for(int j=0; j<needed; ++j){
//            memcpy(buf2, p, (size_t)ipnum[i%np]);
//            buf2 += ipnum[i%np];
//         }
//         memcpy(buf2, CHAR(curs), (size_t)isnum[i % ns]);
//         break;
//         //right
//         case 2:
//         memcpy(buf2, CHAR(curs), (size_t)isnum[i % ns]);
//         buf2 += isnum[i % ns];
//         for(int j=0; j<needed; ++j){
//            memcpy(buf2, p, (size_t)ipnum[i%np]);
//            buf2 += ipnum[i%np];
//         }
//         break;
//         //both
//         case 3:
//         for(int j=0; j<floor(needed/2); ++j){
//            memcpy(buf2, p, (size_t)ipnum[i%np]);
//            buf2 += ipnum[i%np];
//         }
//         memcpy(buf2, CHAR(curs), (size_t)isnum[i % ns]);
//         buf2 += isnum[i % ns];
//         for(int j=0; j<ceil(double(needed)/2); ++j){
//            memcpy(buf2, p, (size_t)ipnum[i%np]);
//            buf2 += ipnum[i%np];
//         }
//         break;
//      }
//      SET_STRING_ELT(ret, i, mkCharLen(buf, isnum[i%ns]+ipnum[i%np]*needed));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


// // Second version by BT: uses StriContainerUTF16 & ICU's padLeading
//{
//   str    = stri_prepare_arg_string(str, "str"); // prepare string argument
//   length = stri_prepare_arg_integer(length, "length");
//   pad    = stri_prepare_arg_string(pad, "pad");
//
//   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(length), LENGTH(pad));
//
//   SEXP ret;
//   PROTECT(ret = allocVector(STRSXP, vectorize_length));
//
//   STRI__ERROR_HANDLER_BEGIN
//   StriContainerUTF16 str_cont(str, vectorize_length, false);
//   StriContainerUTF16 pad_cont(pad, vectorize_length);
//   StriContainerInteger length_cont(length, vectorize_length);
//
//   for (R_len_t i = 0; i < vectorize_length; i++)
//   {
//      if (pad_cont.isNA(i) || str_cont.isNA(i) || length_cont.isNA(i)) {
//         SET_STRING_ELT(ret, i, NA_STRING);
//         continue;
//      }
//
//      if (pad_cont.get(i).length() > 0) {
//         UChar cur_pad = (pad_cont.get(i))[0]; // This is Uchar - 16 bit.....
//         str_cont.getWritable(i).padLeading(length_cont.get(i), cur_pad);
//      }
//
//      SET_STRING_ELT(ret, i, str_cont.toR(i));
//   }
//
//   UNPROTECT(1);
//   return ret;
//   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
//}

