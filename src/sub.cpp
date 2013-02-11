/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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
 

//ASSERT: length(from)==length(sub)
//note that from/to/length are indicating Unicode code points, not bytes
//OPTIONALLY: when from is omitted then either to or length must be integer matrices with 2 columns (what do you think?)
 
#include "stringi.h"

/** 
 * .... 
 * @param s ...
 * @param from integer vector ...
 * @param to integer vector ...
 * @return ...
 */


SEXP stri_sub(SEXP s, SEXP from, SEXP to)
{
   s = stri_prepare_arg_string(s);
   from = stri_prepare_arg_integer(from);
   to = stri_prepare_arg_integer(to);
   int ns = LENGTH(s);
   int nfrom = LENGTH(from);
   int nto = LENGTH(to);
   int nmax = ns;
   if(nfrom > nmax) nmax = nfrom;
   if(nto > nmax) nmax = nto;
   if (nmax % ns != 0 || nmax % nfrom != 0 || nmax % nto != 0)
      warning(MSG__WARN_RECYCLING_RULE);
   //idea to improve performance if ns << nmax
   //first - check every element of s and save position of every utf char
   //into where and now you can easliy get substring by where[from[i]]
   //int* where = (int*)R_alloc(curslen, sizeof(int));
   UChar32 c;
   SEXP e, curs, count;
   count = stri_length(s);
   int curfrom, curto, curslen;
   PROTECT(e = allocVector(STRSXP, nmax));
   int j=0,k=0,lastk=0,st=0,curcount=0;
   for (int i = 0; i < nmax; ++i)
   {
      curs = STRING_ELT(s, i % ns);
      curslen = LENGTH(curs);
      curfrom = INTEGER(from)[i % nfrom];
      curto = INTEGER(to)[i % nto];
      curcount = INTEGER(count)[i % ns];
      //if from or to <0 then count from the end 
      if(curfrom < 0)
         curfrom += curcount + 1;
      if(curto < 0)
         curto += curcount + 1;
      //if from is greater than to then return empty string
      if(curfrom > curto)
         SET_STRING_ELT(e, i, mkCharLen("",0));
      else{
         j = 0; 
         lastk = 0;
         for(k=0; k < curslen; ++j){
            if(j==curfrom){
            //lastk is here, bacause without it you dont know if the last 
            //char is one or two byte long so k-1 doesnt work every time
               st=lastk;
               //if substring to the last char copy now, dont waste time
               if(curto == curcount){
                  SET_STRING_ELT(e,i, mkCharLen(CHAR(curs)+st, curto-st));
                  break;
               }
            }
            if(j==curto){
               SET_STRING_ELT(e,i, mkCharLen(CHAR(curs)+st, k-st));
               break;
            }
            lastk = k;
            U8_NEXT(CHAR(curs), k, curslen, c);
         }
      }
   }
   UNPROTECT(1);
   return e;
}
