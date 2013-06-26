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
 * Replace all occurences of a fixed pattern [with collation]
 * 
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param collator_opts list
 * @return character vector
 */
SEXP stri_replace_all_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP collator_opts)
{
   error("stri_replace_all_fixed TO DO");
   str   = stri_prepare_arg_string(str, "str");
   pattern   = stri_prepare_arg_string(pattern, "pattern");
   replacement   = stri_prepare_arg_string(replacement, "replacement");
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));
   
   // call stri__ucol_open after prepare_arg:
   // if prepare_arg had failed, we would have a mem leak
   UCollator* collator = stri__ucol_open(collator_opts);
   if (!collator)
      return stri__locate_all_fixed_byte(str, pattern);
      
   STRI__ERROR_HANDLER_BEGIN
//   StriContainerUTF16 str_cont(str, vectorize_length, false);
//   StriContainerUTF16 pattern_cont(pat, vectorize_length);
//   StriContainerUTF16 replacement_cont(replacement, vectorize_length);
   
//   for (R_len_t i = pattern_cont.vectorize_init();
//         i != pattern_cont.vectorize_end();
//         i = pattern_cont.vectorize_next(i))
//   {
//      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
//         SET_STRING_ELT(ret, i, NA_STRING);, SET_STRING_ELT(ret, i, NA_STRING);)

/////// TO DO : this does not use collation....
//      str_cont.getWritable(i).findAndReplace(pattern_cont.get(i), replacement_cont.get(i));
//      
//      SET_STRING_ELT(ret, i, ss->toR(i));
//   }
   

   if (collator) { ucol_close(collator); collator=NULL; }
//   UNPROTECT(1);
//   return ret;
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
}





SEXP stri_replace_last_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP collator_opts)
{
   error("TO DO");
}


SEXP stri_replace_first_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP collator_opts)
{
   error("TO DO");  
}


///** 
// * .... 
// * @param s ...
// * @param pattern ...
// * @param replacement ...
// * @return ...
// */
//SEXP stri_replace_first_fixed(SEXP s, SEXP pat, SEXP rep)
//{
//   s   = stri_prepare_arg_string(s, "str");
//   pat = stri_prepare_arg_string(pat, "pattern");
//   rep = stri_prepare_arg_string(rep, "replacement");
//   int ns   = LENGTH(s);
//   int npat = LENGTH(pat);
//   int nrep = LENGTH(rep);
//   if (ns <= 0 || npat <= 0 || nrep <= 0) return allocVector(STRSXP, 0);
//   R_len_t nmax = stri__recycling_rule(true, 3, ns, npat, nrep);
//   
//   SEXP e, split, sexpfalse, temp, currep, inf;
//   PROTECT(e = allocVector(STRSXP,nmax));
//   PROTECT(sexpfalse = allocVector(LGLSXP,1));
//   PROTECT(currep = allocVector(STRSXP,1));
//   PROTECT(inf = allocVector(REALSXP,1));
//   LOGICAL(sexpfalse)[0] = false;
//   REAL(inf)[0] = 2;
//   //if max(ns,npat) % ns || % npat != 0 then inside stri_split we get warn
//   split = stri_split_fixed(s,pat,inf,sexpfalse,sexpfalse);
//   int nsplit = LENGTH(split), nm=ns;
//   if(npat > nm) nm=npat;
//   if((nm%ns==0 && nm%npat==0) && nmax%nm !=0)
//      warning(MSG__WARN_RECYCLING_RULE);
//   for (int i=0; i<nmax; ++i) {
//      temp = VECTOR_ELT(split, i % nsplit);
//      SET_STRING_ELT(currep,0,STRING_ELT(rep,i % nrep));
//      SET_STRING_ELT(e, i, STRING_ELT(stri_flatten(temp,currep),0));
//   }
//   UNPROTECT(4);
//   return e;
//}


