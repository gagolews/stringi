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
 * @param split ...
 * @param omitempty ...
 * @return ...
 */
SEXP stri_split_fixed(SEXP s, SEXP split, SEXP omitempty)
{
   s = stri_prepare_arg_string(s);
   split = stri_prepare_arg_string(split);
   omitempty = stri_prepare_arg_logical(omitempty);
   int a = LENGTH(s);
   int b = LENGTH(split);
   int c = LENGTH(omitempty);
   int max = a;
   if(b>max) max=b;
   if(c>max) max=c;
   if (max % a != 0 || max % b != 0 || max % c != 0)
      warning(MSG__WARN_RECYCLING_RULE);
   int count = 0;
   SEXP e;
   PROTECT(e = allocVector(VECSXP,max));
   SEXP curs,temp;
   int k=0,curslen,spllen,st,add,where;
   //omitempty is bool, but bool* didn't work, so i changed it into
   //int* and now it's fine
   int* omit = LOGICAL(omitempty);
   for (int i=0; i<max; ++i) {
      count = 0;
   	curs = STRING_ELT(s, i % a);
   	curslen = LENGTH(curs);
      const char* string = CHAR(curs);
      const char* spl = CHAR(STRING_ELT(split, i % b));
      if(curs == NA_STRING || STRING_ELT(split, i % b) == NA_STRING || omit[i%c]==NA_LOGICAL){
         PROTECT(temp = allocVector(STRSXP,1));
         SET_STRING_ELT(temp,0,NA_STRING);
         SET_VECTOR_ELT(e,i,temp);
         UNPROTECT(1);
      }else{
         spllen = LENGTH(STRING_ELT(split,i % b));
      	count=0; //count how long vector is needed
         st=0; add=1;
      	for(int j=0; j<curslen; ++j){
            k=0;
            while(string[j+k]==spl[k] && k<spllen)
               k++;
      		if(k==spllen){
               //printf("j=%d k=%d curslen=%d st=%d\n",j,k,curslen,st);
               if(!omit[i % c] || j > st)
               {
                  //printf("j=%d k=%d curslen=%d st=%d count++\n",j,k,curslen,st);
                  count++;
               }
               st=j+k;
               j=j+k-1;
               if(omit[i % c] && st==curslen)
                  add=0;
      		}
            // MG: what if string[i] == '\n' and string[i-1] == '\n' (i>0) ? 
            // don't increment count in such case (?)
            // BT: IMO we should not remove empty line in this function. 
            // we have stri_trim to do such things...
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
               if(!omit[i % c] || j > st){
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
         if(!omit[i % c] || curslen>st)
            SET_STRING_ELT(temp,where, mkCharLen(string+st, curslen-st));
      	SET_VECTOR_ELT(e,i,temp);
      	UNPROTECT(1);
      }
   }
   UNPROTECT(1);
   return e;
}
