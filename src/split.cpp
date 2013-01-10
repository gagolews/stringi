/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus
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
#include <string>
using namespace std;

/** 
 * .... 
 */
SEXP stri_split(SEXP s)
{
   s = stri_prepare_arg_string(s);
   int n = LENGTH(s);
   int* count = (int*)R_alloc(n, sizeof(int)); // this is not needed - it can be a scalar variable
   SEXP e;
   PROTECT(e = allocVector(VECSXP,n));
   SEXP curs,temp;
   int k=0,b=0,st,end,where;
   for (int i=0; i<n; ++i) {
   	curs = STRING_ELT(s, i);
   	k = LENGTH(curs);
   	count[i]=0;
      // const char* string = CHAR(curs);
   	for(int j=0; j<k; ++j){
   		b = (int)CHAR(curs)[j]; // just string[i] - it's fast, no b needed
   		if(b==10) // MG: or b == '\n' ('a' - char, "a" - string (char*): {'a', '\0'})
				count[i]++;
         // MG: what if string[i] == '\n' and string[i-1] == '\n' (i>0) ? 
         // don't increment count in such case (?)
   	}
   	PROTECT(temp = allocVector(STRSXP,count[i]+1));
   	printf("count%d=%d ",i,count[i]);
   	st=0;
   	where=0;
   	for(int j=0; j<k; ++j){ // j<count[i]?
			b = (int)CHAR(curs)[j]; // see above
   			if(b==10){ // '\n'
   				end=j;
   				SET_STRING_ELT(temp,where, curs);//substr(STRING_ELT(curs,0),st,end));
               // MG: http://www.cplusplus.com/reference/cstring/
               
               //given start and end - index in string
               //we can do:
               // SET_STRING_ELT(temp, j, mkCharLen(string+start, end-start+1))
               // string - address of the first character
               // string+start - address of the start-th character
               // definition: mkCharLen(char* address_of_first_char, int howManyCharsToCopy)
               // - it returns a "scalar" string that may be copied into STRSXP (with SET_STRING_ELT)
               // good work - i'm glad it's challenging :)
               
               
   				st=j;
   				++where;
   			}
   	}
   	SET_VECTOR_ELT(e,i,temp);
   	UNPROTECT(1);
   }
   UNPROTECT(1);
   return e;
}
