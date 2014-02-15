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


///**
//   vectorized over s
//   if s is NA the result will be NA
//
//*/
//SEXP stri_justify(SEXP s, SEXP width)
//{
//   s = stri_prepare_arg_string(s, "str"); // prepare string argument
//   width = stri_prepare_arg_integer(width, "width");
//
//   int ns = LENGTH(s);
//   int nwidth = LENGTH(width);
//   int nmax = ns;
//   if(nwidth > nmax) nmax = nwidth;
//   if(ns == 0 || nwidth == 0)
//      return allocVector(STRSXP, 0);
//   if(nmax % ns != 0 || nmax % nwidth != 0)
//      warning(MSG__WARN_RECYCLING_RULE);
//
//   SEXP e, curs;
//   PROTECT(e = allocVector(STRSXP, nmax));
//   int j=0,k=0,curwidth;
//
//   for (int i=0; i < nmax; ++i)
//   {
//      curs = STRING_ELT(s, i % ns);
//      curwidth = INTEGER(width)[i % nwidth];
//      if (curs == NA_STRING || curwidth == NA_INTEGER){
//         SET_STRING_ELT(e, i, NA_STRING);
//         continue;
//      }
//      const char* string = CHAR(curs);
//      int nstring = LENGTH(curs);
//      for(j=0; j < nstring ; ++j){
//         if(string[j] != ' ')
//            break;
//      }
//      for(k=0; k < nstring ; ++k){
//         if(string[nstring-1-k] != ' ')
//            break;
//      }
//      SET_STRING_ELT(e, i, mkCharLen(string+j, max(0,nstring-k-j)));
//
//   }
//   UNPROTECT(1);
//   return e;
//}
