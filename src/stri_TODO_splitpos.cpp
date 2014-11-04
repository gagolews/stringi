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


/// TO DO: DEL ME????


///**
// * ....
// * @param s ...
// * @param from integer vector ...
// * @param to integer vector ...
// * @return ...
// */
//SEXP stri_split_pos(SEXP s, SEXP from, SEXP to)
//{
//   s = STRING_ELT(stri_prepare_arg_string(s, "str"),0);
//   from = stri_prepare_arg_integer(from, "from");
//   to = stri_prepare_arg_integer(to, "to");
//   if(s == NA_STRING)
//      return NA_STRING;
//   int ns = LENGTH(s);
//   int nfrom = LENGTH(from);
//   if(nfrom!=LENGTH(to))
//      error("'from' and 'to' lengths differ");
//   UChar32 c;
//   SEXP e;
//   PROTECT(e = allocVector(STRSXP,nfrom));
//   int j=0,lasti=0,k=0,st=0,i=0;
//   for (i = 0; lasti < ns; ++j)
//   {
//      //printf("i=%d c=%c k=%d j=%d \n",i,c,k,j);
//      if(j==INTEGER(from)[k]){
//         //lasti is here, bacause without it you dont know if the last char
//         //is one or two byte long so i-1 doesnt work every time
//         st=lasti;
//      }
//      if(j==INTEGER(to)[k]){
//         SET_STRING_ELT(e,k, mkCharLen(CHAR(s)+st, i-st));
//         k++;
//      }
//      lasti = i;
//      U8_NEXT(CHAR(s), i, ns, c);
//   }
//   if(INTEGER(to)[nfrom] > j)
//      SET_STRING_ELT(e,k, mkCharLen(CHAR(s)+st, ns-st));
//   UNPROTECT(1);
//   return e;
//}


///**
// * This function is implemented only for stri_trim_all
// * @param s ...
// * @param from integer vector ...
// * @param to integer vector ...
// * @param ns length of s
// * @param n length of from and tos
// * @return ...
// */
//SEXP stri__split_pos(const char* s, int* from, int* to, int ns, int n)
//{
//   UChar32 c;
//   SEXP e;
//   PROTECT(e = allocVector(STRSXP,n));
//   int j=0,lasti=0,k=0,st=0,i=0;
//   for (i = 0; lasti < ns; ++j)
//   {
//      if(j==from[k])
//         //lasti is here, bacause without it you dont know if the last char
//         //is one or two byte long so i-1 doesnt work every time
//         st=lasti;
//      if(j==to[k]){
//         SET_STRING_ELT(e,k, mkCharLen(s+st, i-st));
//         k++;
//      }
//      lasti = i;
//      U8_NEXT(s, i, ns, c);
//   }
//   UNPROTECT(1);
//   return e;
//}
