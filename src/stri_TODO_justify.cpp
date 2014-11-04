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
