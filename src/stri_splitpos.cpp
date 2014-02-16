/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
