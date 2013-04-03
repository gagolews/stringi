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
 * @param s character vector
 * @param class character vector
 * @return list
 */
SEXP stri_split_class(SEXP s, SEXP c)
{
   s = stri_prepare_arg_string(s);
   c = stri_prepare_arg_string(c);
   
   R_len_t ns = LENGTH(s);
   R_len_t nc = LENGTH(c);
   R_len_t nmax = stri__recycling_rule(ns, nc);
   
   SEXP ret, from, curs;
   PROTECT(ret = allocVector(VECSXP,nmax));
   PROTECT(from = allocVector(VECSXP,nc));
   error("Not finished - stri_locate_all_class with merge is needed");
   from = stri_locate_all_class(s, c);
   
   for (int i=0; i<nmax; ++i) {
      const char* string = CHAR(STRING_ELT(s, i % ns));
      int* f = INTEGER(VECTOR_ELT(from, i % nc));
      //SET_VECTOR_ELT(ret, i, stri__split_pos(string, f, f+LENGTH(f)/2,LENGTH(string),LENGTH(f)/2));
   }
   
   UNPROTECT(2);
   return ret;
}


/** 
 * .... 
 * @param s ...
 * @param split ...
 * @param omitempty ...
 * @return ...
 */
SEXP stri_split_fixed(SEXP s, SEXP split, SEXP n, SEXP omitempty, SEXP exact)
{
   s = stri_prepare_arg_string(s);
   split = stri_prepare_arg_string(split);
   n = stri_prepare_arg_double(n);
   omitempty = stri_prepare_arg_logical(omitempty);
   exact = stri_prepare_arg_logical(exact);
   int a = LENGTH(s);
   int b = LENGTH(split);
   int c = LENGTH(n);
   int d = LENGTH(omitempty);
   int e = LENGTH(exact);
   
   int nmax = stri__recycling_rule(a, b, c, d, e);
   
   int count = 0;
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP,nmax));
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
      // REAL(n)[i] == NA_REAL is wrong way of testing. ISNA() must be used
      if(curs == NA_STRING || STRING_ELT(split, i % b) == NA_STRING
         || ISNA(REAL(n)[i % c]) || omit[i%d]==NA_LOGICAL){
         PROTECT(temp = allocVector(STRSXP,1));
         SET_STRING_ELT(temp,0,NA_STRING);
         SET_VECTOR_ELT(ret,i,temp);
         UNPROTECT(1);
         continue;
      }
      //here n can't be NA
      if(REAL(n)[i % c]==R_PosInf){
         curn = -1;
      }else if(REAL(n)[i % c] <= 0){
         PROTECT(temp = allocVector(STRSXP,0));
         SET_VECTOR_ELT(ret,i,temp);
         UNPROTECT(1);
         continue;
      }else
         curn = REAL(n)[i % c];
      //if curn == 1 then we need to return the whole string in one piece
      if(curn == 1){
         PROTECT(temp = allocVector(STRSXP,1));
         SET_STRING_ELT(temp,0,curs);
         SET_VECTOR_ELT(ret,i,temp);
         UNPROTECT(1);
         continue;
      }
      spllen = LENGTH(STRING_ELT(split,i % b));
      //curn > 1 means that curn is not infinity (in such case curn 
      //is set to -1) or negative (empty vector is returned and this part
      //of code is skipped).
      //exact==TRUE then return vector of exact length
      if(curn > 1 && LOGICAL(exact)[i % e]){
         count = curn;
         add = 0;
      }else{ //otherwise count how long vector is needed
         count=0;
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
               if(count+add==curn)
                  break;
            }
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
   			st=j+k;
            j=j+k-1; //if match, then there is no need to check next k el.
            if(where+1 == curn){
               break;
            }
   		}
   	}
      //with this line, stri_split will return vector equal to str_split
      //stri_split("ala","a")==strsplit("ala","a")==c("","l")
      //without if(...) line we get
      //stri_split("ala","a")==str_split("ala","a")==c("","l","")
      if(where+1==curn || !omit[i % d] || curslen>st)
         SET_STRING_ELT(temp,where, mkCharLen(string+st, curslen-st));
   	SET_VECTOR_ELT(ret,i,temp);
   	UNPROTECT(1);
   }
   UNPROTECT(1);
   return ret;
}
