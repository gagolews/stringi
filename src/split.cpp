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

SEXP stri_split_pos(SEXP s, SEXP from, SEXP to)
{
   s = STRING_ELT(stri_prepare_arg_string(s),0);
   from = stri_prepare_arg_integer(from);
   to = stri_prepare_arg_integer(to);
   if(s == NA_STRING)
      return NA_STRING;
   int ns = LENGTH(s);
   int nfrom = LENGTH(from);
   if(nfrom!=LENGTH(to))
      error("'from' and 'to' lengths differ");
   UChar32 c;
   SEXP e;
   PROTECT(e = allocVector(STRSXP,nfrom));
   int j=0,lasti=0,k=0,st=0,i=0;
   for (i = 0; lasti < ns; ++j)
   {
      //printf("i=%d c=%c k=%d j=%d \n",i,c,k,j);
      if(j==INTEGER(from)[k]){
         //lasti is here, bacause without it you dont know if the last char
         //is one or two byte long so i-1 doesnt work every time
         st=lasti;
      }
      if(j==INTEGER(to)[k]){
         SET_STRING_ELT(e,k, mkCharLen(CHAR(s)+st, i-st));
         k++;
      }
      lasti = i;
      U8_NEXT(CHAR(s), i, ns, c);
   }
   if(INTEGER(to)[nfrom] > j)
      SET_STRING_ELT(e,k, mkCharLen(CHAR(s)+st, ns-st));
   UNPROTECT(1);
   return e;
}


/** 
 * This function is implemented only for stri_trim_all
 * @param s ...
 * @param from integer vector ...
 * @param to integer vector ...
 * @param ns length of s
 * @param n length of from and tos
 * @return ...
 */

SEXP stri__split_pos(const char* s, int* from, int* to, int ns, int n)
{
   UChar32 c;
   SEXP e;
   PROTECT(e = allocVector(STRSXP,n));
   int j=0,lasti=0,k=0,st=0,i=0;
   for (i = 0; lasti < ns; ++j)
   {
      if(j==from[k])
         //lasti is here, bacause without it you dont know if the last char
         //is one or two byte long so i-1 doesnt work every time
         st=lasti;
      if(j==to[k]){
         SET_STRING_ELT(e,k, mkCharLen(s+st, i-st));
         k++;
      }
      lasti = i;
      U8_NEXT(s, i, ns, c);
   }
   UNPROTECT(1);
   return e;
}


/** 
 * .... 
 * @param s ...
 * @param split ...
 * @param omitempty ...
 * @return ...
 */
SEXP stri_split_fixed(SEXP s, SEXP split, SEXP n, SEXP omitempty)
{
   s = stri_prepare_arg_string(s);
   split = stri_prepare_arg_string(split);
   n = stri_prepare_arg_double(n);
   omitempty = stri_prepare_arg_logical(omitempty);
   int a = LENGTH(s);
   int b = LENGTH(split);
   int c = LENGTH(n);
   int d = LENGTH(omitempty);
   //if any length is 0 then return empty list
   if (a==0 || b==0 || c==0 || d==0)
      return allocVector(VECSXP, 0);
   int nmax = a;
   if(b>nmax) nmax=b;
   if(c>nmax) nmax=c;
   if(d>nmax) nmax=d;
   if (nmax % a != 0 || nmax % b != 0 || nmax % c != 0 || nmax % d != 0)
      warning(MSG__WARN_RECYCLING_RULE);
   int count = 0;
   SEXP e;
   PROTECT(e = allocVector(VECSXP,nmax));
   SEXP curs,temp;
   int k=0,curslen,spllen,st,add,where,curn;
   //omitempty is bool, but bool* didn't work, so i changed it into
   //int* and now it's fine
   int* omit = LOGICAL(omitempty);
   for (int i=0; i<nmax; ++i) {
      count = 0;
      curs = STRING_ELT(s, i % a);
      curslen = LENGTH(curs);
      const char* string = CHAR(curs);
      const char* spl = CHAR(STRING_ELT(split, i % b));
      if(curs == NA_STRING || STRING_ELT(split, i % b) == NA_STRING
         || REAL(n)[i % c]==NA_REAL || omit[i%d]==NA_LOGICAL){
         PROTECT(temp = allocVector(STRSXP,1));
         SET_STRING_ELT(temp,0,NA_STRING);
         SET_VECTOR_ELT(e,i,temp);
         UNPROTECT(1);
         continue;
      }
      //here n can't be NA
      if(REAL(n)[i % c]==R_PosInf){
         curn = -1;
      }else if(REAL(n)[i % c] <= 0){
         PROTECT(temp = allocVector(STRSXP,0));
         SET_VECTOR_ELT(e,i,temp);
         UNPROTECT(1);
         continue;
      }else
         curn = REAL(n)[i % c];
      spllen = LENGTH(STRING_ELT(split,i % b));
      count=0; //count how long vector is needed
      st=0; add=1;
      for(int j=0; j<curslen; ++j){
         k=0;
         while(string[j+k]==spl[k] && k<spllen)
            k++;
         if(k==spllen){
            if(!omit[i % d] || j > st)
               count++;
            st=j+k;
            j=j+k-1;
            if(omit[i % d] && st==curslen)
               add=0;
            //if(count+add==REAL(n[i % c]))
      	}
      }
      PROTECT(temp = allocVector(STRSXP,count+add));
      st=0;
      where=0;
      for(int j=0; j<curslen; ++j){
   		string = CHAR(curs); 
         k=0;
         while(string[j+k]==spl[k] && k<spllen)
            k++;
      	if(k==spllen){
            if(!omit[i % d] || j > st){
               SET_STRING_ELT(temp,where, mkCharLen(string+st, j-st));
               ++where;
            }
            // MG: http://www.cplusplus.com/reference/cstring/
            //given start and end - index in string
            //we can do:
            // SET_STRING_ELT(temp, j, mkCharLen(string+start, end-start+1))
            // string - address of the first character
            // string+start - address of the start-th character
            // definition: mkCharLen(char* address_of_first_char, int howManyCharsToCopy)
            // - it returns a "scalar" string that may be copied into STRSXP (with SET_STRING_ELT)
            // good work - i'm glad it's challenging :)
   			st=j+k;
            j=j+k-1; //if match, then there is no need to check next k el.
   		}
   	}
      //with this line, stri_split will return vector equal to str_split
      //stri_split("ala","a")==strsplit("ala","a")==c("","l")
      //without if(...) line we get
      //stri_split("ala","a")==str_split("ala","a")==c("","l","")
      if(!omit[i % d] || curslen>st)
         SET_STRING_ELT(temp,where, mkCharLen(string+st, curslen-st));
   	SET_VECTOR_ELT(e,i,temp);
   	UNPROTECT(1);
   }
   UNPROTECT(1);
   return e;
}
