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
