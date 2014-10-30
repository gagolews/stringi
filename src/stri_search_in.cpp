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


//// VERSION III: naive O(n*m) - damn slower
//#include "stri_stringi.h"
//#include "stri_container_utf8.h"
//
//
///** Value Matching
// *
// * @param str character vector
// * @param table character vector
// * @nomatch single integer value
// *
// * @return integer vector
// *
// * @version 0.3-1 (Marek Gagolewski, 2014-06-06)
// */
//SEXP stri_in_fixed(SEXP str, SEXP table, SEXP nomatch)
//{
//   str = stri_prepare_arg_string(str, "str");
//   table = stri_prepare_arg_string(table, "table");
//   nomatch = stri_prepare_arg_integer_1(nomatch, "nomatch");
//   R_len_t str_length = LENGTH(str);
//   R_len_t table_length = LENGTH(table);
//
//   R_len_t nomatch_cur = INTEGER(nomatch)[0];
//
//   STRI__ERROR_HANDLER_BEGIN
//   StriContainerUTF8 str_cont(str, str_length);
//   StriContainerUTF8 table_cont(table, table_length);
//
//   SEXP ret;
//   STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_length));
//   int* ret_tab = INTEGER(ret);
//
//   for (R_len_t i = 0; i<str_length; ++i) {
//      if (str_cont.isNA(i)) {
//         ret_tab[i] = NA_INTEGER;
//         continue;
//      }
//
//      const char* str_cur = str_cont.get(i).c_str();
//
//      ret_tab[i] = nomatch_cur;
//      for (int j=0; j<table_length; ++j) {
//         if (table_cont.isNA(j)) continue;
//         if (!strcmp(str_cur, table_cont.get(j).c_str())) {
//            ret_tab[i] = j+1;
//            break;
//         }
//      }
//
//      // ... and so on
//      // it's already slower than match() for n <= 100000
//
////      if (it != dict.end())
////         ret_tab[i] = (*it).second;
////      else
////         ret_tab[i] = nomatch_cur;
//   }
//
//   STRI__UNPROTECT_ALL
//   return ret;
//   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
//}


//// VERSION II: sort() table, then (*unfinished*) bin search
//#include "stri_stringi.h"
//#include "stri_container_utf8.h"
//#include <algorithm>
//#include <vector>
//
///** helper struct (comparer) for stri_in_fixed
// *
// */
//struct cmp_str
//{
//   StriContainerUTF8* cont;
//
//   cmp_str(StriContainerUTF8* _cont) {
//      cont = _cont;
//   }
//
//   bool operator()(int i, int j)
//   {
//      if (cont->isNA(i)) return false;
//      else if (cont->isNA(j)) return true;
//      else return strcmp(cont->get(i).c_str(), cont->get(j).c_str()) < 0;
//   }
//};
//
//
///** Value Matching
// *
// * @param str character vector
// * @param table character vector
// * @nomatch single integer value
// *
// * @return integer vector
// *
// * @version 0.3-1 (Marek Gagolewski, 2014-06-06)
// */
//SEXP stri_in_fixed(SEXP str, SEXP table, SEXP nomatch)
//{
//   str = stri_prepare_arg_string(str, "str");
//   table = stri_prepare_arg_string(table, "table");
//   nomatch = stri_prepare_arg_integer_1(nomatch, "nomatch");
//   R_len_t str_length = LENGTH(str);
//   R_len_t table_length = LENGTH(table);
//
//   R_len_t nomatch_cur = INTEGER(nomatch)[0];
//
//   STRI__ERROR_HANDLER_BEGIN
//   StriContainerUTF8 str_cont(str, str_length);
//   StriContainerUTF8 table_cont(table, table_length);
//
//   cmp_str comparer(&str_cont);
//   std::vector<int> idx(table_length);
//   for (int i=0; i<table_length; ++i) {
//      idx[i] = i;
//   }
//
//   std::sort(idx.begin(), idx.end(), comparer);
//
//   SEXP ret;
//   STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_length));
//   int* ret_tab = INTEGER(ret);
//
//   for (R_len_t i = 0; i<str_length; ++i) {
//      if (str_cont.isNA(i)) {
//         ret_tab[i] = NA_INTEGER;
//         continue;
//      }
//
//      // ... and so on
//      // it's already slower than match() for n <= 100000
//
////      if (it != dict.end())
////         ret_tab[i] = (*it).second;
////      else
////         ret_tab[i] = nomatch_cur;
//   }
//
//   STRI__UNPROTECT_ALL
//   return ret;
//   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
//}


// // VERSION I: using boost's unordered_map
//
//#include "stri_stringi.h"
//#include "stri_container_utf8.h"
//#include <boost/unordered/unordered_map.hpp>
//#include <string>
//
//
///** Value Matching
// *
// * @param str character vector
// * @param table character vector
// * @nomatch single integer value
// *
// * @return integer vector
// *
// * @version 0.3-1 (Marek Gagolewski, 2014-06-06)
// */
//SEXP stri_in_fixed(SEXP str, SEXP table, SEXP nomatch)
//{
//   str = stri_prepare_arg_string(str, "str");
//   table = stri_prepare_arg_string(table, "table");
//   nomatch = stri_prepare_arg_integer_1(nomatch, "nomatch");
//   R_len_t str_length = LENGTH(str);
//   R_len_t table_length = LENGTH(table);
//
//   R_len_t nomatch_cur = INTEGER(nomatch)[0];
//
//   STRI__ERROR_HANDLER_BEGIN
//   StriContainerUTF8 str_cont(str, str_length);
//   StriContainerUTF8 table_cont(table, table_length);
//
//   boost::unordered_map<std::string, R_len_t> dict(table_length);
//   for (R_len_t i=table_length-1; i>=0; --i) {
//      if (table_cont.isNA(i)) continue;
//      dict[std::string(table_cont.get(i).c_str())] = i+1; // 0-based index -> 1-based
//   }
//
//   SEXP ret;
//   STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_length));
//   int* ret_tab = INTEGER(ret);
//
//   for (R_len_t i = 0; i<str_length; ++i) {
//      if (str_cont.isNA(i)) {
//         ret_tab[i] = NA_INTEGER;
//         continue;
//      }
//
//      std::string str_cur(str_cont.get(i).c_str());
//      boost::unordered_map<std::string, R_len_t>::iterator it = dict.find(str_cur);
//      if (it != dict.end())
//         ret_tab[i] = (*it).second;
//      else
//         ret_tab[i] = nomatch_cur;
//   }
//
//   STRI__UNPROTECT_ALL
//   return ret;
//   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
//}
