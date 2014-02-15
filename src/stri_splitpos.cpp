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
