/** This file is part of the 'stringi' library.
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

SEXP stri_prepare_arg_string(SEXP x)
{
   if (isString(x))
      return x; // return as-is
   if (isFactor(x))
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
		x = eval(call, R_GlobalEnv); // this will mark it's encoding manually
		UNPROTECT(1);
      return x;
   }
   if (isVectorAtomic(x))
      return coerceVector(x,STRSXP);
   if (isSymbol(x))
      return ScalarString(PRINTNAME(x));
      
   error("expected a character vector on input (or something easily coercible to)");
   return x; // avoid compiler warning
}
