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
 * General statistics for a character vector
 * 
 * @param str a character vector
 * @return integer vector, see R man for details
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_stats_general(SEXP str)
{
   str = stri_prepare_arg_string(str);
   
   enum {
      gsNumLines = 0,
      gsNumLinesNotEmpty = 1,
      gsNumChars = 2,
      gsNumCharsNotWhite = 3,
      gsAll = 4 // always == number of elements
   };

   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, gsAll));
   int* stats = INTEGER(ret);
   for (int i=0; i<gsAll; ++i) stats[i] = 0;

   R_len_t ns = LENGTH(str);
   for (int i=0; i<ns; ++i) {
      SEXP curs = STRING_ELT(str, i);
      if(curs == NA_STRING) continue; // ignore
      
      ++stats[gsNumLines]; // another line
      
   }
   UNPROTECT(1);
   error("TODO: not implemented yet");
   return ret;
}
//WHITE_SPACE



/** 
 * LaTeX, Kile-like statistics for a character vector
 * 
 * We use Kile 2.1.3 LaTeX Word Count algorithm
 * see http://kile.sourceforge.net/team.php
 * 
 * @param str a character vector
 * @return integer vector, see R man for details
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_stats_latex(SEXP str)
{
   str = stri_prepare_arg_string(str);
   
   const int nstats = 6;
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, nstats));
   int* stats = INTEGER(ret);
   for (int i=0; i<nstats; ++i) stats[i] = 0;

   UNPROTECT(1);
   error("TODO: not implemented yet");
   return ret;
}
