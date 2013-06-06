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
 * Replace all occurences of a character class
 * 
 * @param str character vector; strings to search in
 * @param pattern character vector; charclasses to search for
 * @param replacement character vector; strings to replace with
 * 
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski) 
 */
SEXP stri_replace_all_charclass(SEXP str, SEXP pattern, SEXP replacement)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));


   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
 
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* rr = new StriContainerUTF8(replacement, nmax);
 
 
 
   error("TO DO");
 
 
   delete ss;
   delete rr;
   UNPROTECT(1);
   return ret;
}



/** 
 * Replace first occurence of a character class
 * 
 * @param str character vector; strings to search in
 * @param pattern character vector; charclasses to search for
 * @param replacement character vector; strings to replace with
 * 
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski) 
 */
SEXP stri_replace_first_charclass(SEXP str, SEXP pattern, SEXP replacement)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));


   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
 
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* rr = new StriContainerUTF8(replacement, nmax);
 
 
 
   error("TO DO");
 
 
   delete ss;
   delete rr;
   UNPROTECT(1);
   return ret;
}



/** 
 * Replace last occurence of a character class
 * 
 * @param str character vector; strings to search in
 * @param pattern character vector; charclasses to search for
 * @param replacement character vector; strings to replace with
 * 
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski) 
 */
SEXP stri_replace_last_charclass(SEXP str, SEXP pattern, SEXP replacement)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));


   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
 
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* rr = new StriContainerUTF8(replacement, nmax);
 
 
 
   error("TO DO");
 
 
   delete ss;
   delete rr;
   UNPROTECT(1);
   return ret;
}
