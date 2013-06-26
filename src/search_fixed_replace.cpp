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
   str = stri_prepare_arg_string(str, "str");
   replacement = stri_prepare_arg_string(replacement, "replacement");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   
   // call stri__ucol_open after prepare_arg:
   // if prepare_arg had failed, we would have a mem leak
   UCollator* collator = stri__ucol_open(collator_opts);
//   if (!collator)
//      return stri__replace_all_fixed_byte(str, pattern, replacement);
   
   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));
   StriContainerUTF16 str_cont(str, vectorize_length, false); // writable
   StriContainerUStringSearch pattern_cont(pattern, vectorize_length, collator);  // collator is not owned by pattern_cont
   StriContainerUTF16 replacement_cont(replacement, vectorize_length);
   
   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         str_cont.setNA(i);,
         str_cont.setNA(i);)
         
      if (replacement_cont.isNA(i)) {
         str_cont.setNA(i);
         continue;
      }

      UStringSearch *matcher = pattern_cont.getMatcher(i, str_cont.get(i));
      usearch_reset(matcher);
      
      UErrorCode status = U_ZERO_ERROR;
      int start = (int)usearch_first(matcher, &status);
      if (U_FAILURE(status)) throw StriException(status);
      
      if (start == USEARCH_DONE) { // no match
         continue; // no change in str_cont[i] at all
      }
      
      R_len_t remUChars = 0;
      deque<R_len_t_x2> occurences;
      while (start != USEARCH_DONE) {
         R_len_t mlen = usearch_getMatchedLength(matcher);
         remUChars += mlen;
         occurences.push_back(R_len_t_x2(start, start+mlen));
         start = usearch_next(matcher, &status);
         if (U_FAILURE(status)) throw StriException(status);      
      }
   
      R_len_t replacement_cur_n = replacement_cont.get(i).length();
      R_len_t noccurences = occurences.size();
      UnicodeString ans(str_cont.get(i).length()-remUChars+noccurences*replacement_cur_n, (UChar)0xfffd, 0);
      R_len_t jlast = 0;
      R_len_t anslast = 0;
      deque<R_len_t_x2>::iterator iter = occurences.begin();
      for (; iter != occurences.end(); ++iter) {
         R_len_t_x2 match = *iter;
         ans.replace(anslast, match.v1-jlast, str_cont.get(i), jlast, match.v1-jlast);
         anslast += match.v1-jlast;
         jlast = match.v2;
         ans.replace(anslast, replacement_cur_n, replacement_cont.get(i));
         anslast += replacement_cur_n;
      }
      ans.replace(anslast, str_cont.get(i).length()-jlast, str_cont.get(i), jlast, str_cont.get(i).length()-jlast);      
      str_cont.getWritable(i) = ans;
   }
   
   if (collator) { ucol_close(collator); collator=NULL; }
   return str_cont.toR();
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
   
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


