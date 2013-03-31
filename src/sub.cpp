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
   
   if(ns == 0 || nfrom == 0 || nto == 0)
      return allocVector(STRSXP,0);
   
   int nmax = stri__recycling_rule(ns, nfrom, nto);
   
   //idea to improve performance if ns << nmax
   //first - check every element of s and save position of every utf char
   //into where and now you can easliy get substring by where[from[i]]
   //int* where = (int*)R_alloc(curslen, sizeof(int));
   UChar32 c;
   SEXP e, curs, count;
   //this line can be the first one to replace to improve performance 
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
      //if string is NA, return NA
      if(curs == NA_STRING || curfrom == NA_INTEGER || curto == NA_INTEGER){
         SET_STRING_ELT(e, i, NA_STRING);
         continue;
      }
      //if from or to <0 then count from the end 
      if(curfrom < 0)
         curfrom += curcount + 1;
      if(curto < 0)
         curto += curcount + 1;
      //if from is greater than to or count then return empty string
      if(curfrom > curto || curfrom > curcount){
         SET_STRING_ELT(e, i, mkCharLen("",0));
         continue;
      }
      j = 0; 
      lastk = 0;
      for(k=0; lastk < curslen; ++j){
         if(j==curfrom){
         //lastk is here, bacause without it you dont know if the last 
         //char is one or two byte long so k-1 doesnt work every time
            st=lastk;
            //if substring to the last char copy now, dont waste time
            //if to > count copy till the end-works like str_sub and substr
            if(curto >= curcount){
               SET_STRING_ELT(e,i, mkCharLen(CHAR(curs)+st, curslen-st));
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
   UNPROTECT(1);
   return e;
}


/** 
 * .... 
 * @param s string vector ...
 * @param from integer vector ...
 * @param to integer vector ...
 * @param value string vector ...
 * @return ...
 */


SEXP stri_sub_op(SEXP s, SEXP from, SEXP to, SEXP value)
{
   s = stri_prepare_arg_string(s);
   from = stri_prepare_arg_integer(from);
   to = stri_prepare_arg_integer(to);
   value = stri_prepare_arg_string(value);
   int ns = LENGTH(s);
   int nfrom = LENGTH(from);
   int nto = LENGTH(to);
   int nval = LENGTH(value);
   
   if(ns == 0 || nfrom == 0 || nto == 0 || nval == 0)
      return allocVector(STRSXP,0);
   
   int nmax = stri__recycling_rule(ns, nfrom, nto, nval);
   //idea to improve performance if ns << nmax
   //first - check every element of s and save position of every utf char
   //into where and now you can easliy get substring by where[from[i]]
   //int* where = (int*)R_alloc(curslen, sizeof(int));
   UChar32 c;
   SEXP e, curs, curval, count;
   //this line can be the first one to replace to improve performance 
   count = stri_length(s);
   int curfrom, curto, curslen, curvallen;
   PROTECT(e = allocVector(STRSXP, nmax));
   int j=0,k=0,lastk=0,st=0,curcount=0;
   for (int i = 0; i < nmax; ++i)
   {
      curs = STRING_ELT(s, i % ns);
      curslen = LENGTH(curs);
      curfrom = INTEGER(from)[i % nfrom];
      curto = INTEGER(to)[i % nto];
      curcount = INTEGER(count)[i % ns];
      curval = STRING_ELT(value, i % nval);
      curvallen = LENGTH(curval);
      //if string is NA, return NA
      if(curs == NA_STRING || curfrom == NA_INTEGER || curto == NA_INTEGER
         || curval == NA_STRING){
         SET_STRING_ELT(e, i, NA_STRING);
         continue;
      }
      //if from or to <0 then count from the end 
      if(curfrom < 0)
         curfrom += curcount + 1;
      if(curto < 0)
         curto += curcount + 1;
      //if from is greater than to or count then replace nothing - return
      //string with no change
      if(curfrom > curto || curfrom > curcount){
         SET_STRING_ELT(e, i, curs);
         continue;
      }
      j = 0; 
      lastk = 0;
      for(k=0; lastk < curslen; ++j){
         if(j==curfrom){
         //lastk is here, bacause without it you dont know if the last 
         //char is one or two byte long so k-1 doesnt work every time
            st=lastk;
            //if replace to the last char then copy now, dont waste time
            //if to > count replace the rest of a string
            if(curto >= curcount){
               char* buf = R_alloc(lastk+curvallen, sizeof(char)); 
               char* buf2 = buf;
               memcpy(buf2, CHAR(curs),lastk);
               buf2 += lastk;
               memcpy(buf2, CHAR(curval),curvallen);
               buf2 += curvallen;
               SET_STRING_ELT(e, i, mkCharLen(buf, lastk+curvallen));
               break;
            }
         }
         if(j==curto){
            char* buf = R_alloc(st+curvallen+curslen-curto, sizeof(char)); 
            char* buf2 = buf;
            //copy the beginning of a string
            memcpy(buf2, CHAR(curs),st);
            buf2 += st;
            //now copy the new value in the middle
            memcpy(buf2, CHAR(curval),curvallen);
            buf2 += curvallen;
            //and copy the rest of a string
            memcpy(buf2, CHAR(curs)+curto,curslen-curto);
            buf2 += curslen-curto;
            SET_STRING_ELT(e, i, mkCharLen(buf, st+curvallen+curslen-curto));
            break;
         }
         lastk = k;
         U8_NEXT(CHAR(curs), k, curslen, c);
      }
   }
   UNPROTECT(1);
   return e;
}