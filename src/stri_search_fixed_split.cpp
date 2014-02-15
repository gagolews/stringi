/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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


#include "stri_stringi.h"



/**
 * Split a string into parts [byte compare]
 *
 * The pattern matches identify delimiters that separate the input into fields.
 * The input data between the matches becomes the fields themselves.
 *
 * @param str character vector
 * @param pattern character vector
 * @param n_max integer vector
 * @param omit_empty logical vector
 *
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-25) StriException friendly, use StriContainerUTF8
 * @version 0.3 (Marek Gagolewski, 2013-07-10) - BUGFIX: wrong behavior on empty str
 */
SEXP stri__split_fixed_byte(SEXP str, SEXP pattern, SEXP n_max, SEXP omit_empty)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   n_max = stri_prepare_arg_integer(n_max, "n_max");
   omit_empty = stri_prepare_arg_logical(omit_empty, "omit_empty");

   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = stri__recycling_rule(true, 4, LENGTH(str), LENGTH(pattern), LENGTH(n_max), LENGTH(omit_empty));
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length);
   StriContainerInteger   n_max_cont(n_max, vectorize_length);
   StriContainerLogical   omit_empty_cont(omit_empty, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (n_max_cont.isNA(i) || omit_empty_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }
      int  n_max_cur        = n_max_cont.get(i);
      int  omit_empty_cur   = omit_empty_cont.get(i);

      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));,
         SET_VECTOR_ELT(ret, i, stri__vector_empty_strings((omit_empty_cur || n_max_cur == 0)?0:1));)

      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();

      if (n_max_cur < 0)
         n_max_cur = INT_MAX;
      else if (n_max_cur == 0) {
         SET_VECTOR_ELT(ret, i, Rf_allocVector(STRSXP, 0));
         continue;
      }

      pattern_cont.setupMatcher(i, str_cur_s, str_cur_n);
      R_len_t k;
      deque<R_len_t_x2> fields; // byte based-indices
      fields.push_back(R_len_t_x2(0,0));

      for (k=1; k < n_max_cur && USEARCH_DONE != pattern_cont.findNext(); ) {
         R_len_t s1 = (R_len_t)pattern_cont.getMatchedStart();
         R_len_t s2 = (R_len_t)pattern_cont.getMatchedLength() + s1;

         if (omit_empty_cur && fields.back().v1 == s1)
            fields.back().v1 = s2; // don't start new field
         else {
            fields.back().v2 = s1;
            fields.push_back(R_len_t_x2(s2, s2)); // start new field here
            ++k; // another field
         }
      }
      fields.back().v2 = str_cur_n;
      if (omit_empty_cur && fields.back().v1 == fields.back().v2)
         fields.pop_back();

      SEXP ans;
      PROTECT(ans = Rf_allocVector(STRSXP, fields.size()));

      deque<R_len_t_x2>::iterator iter = fields.begin();
      for (k = 0; iter != fields.end(); ++iter, ++k) {
         R_len_t_x2 curoccur = *iter;
         SET_STRING_ELT(ans, k, Rf_mkCharLenCE(str_cur_s+curoccur.v1, curoccur.v2-curoccur.v1, CE_UTF8));
      }

      SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(1);
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(; /* nothing interesting on error */)
}




/**
 * Split a string into parts [search with collation]
 *
 * The pattern matches identify delimiters that separate the input into fields.
 * The input data between the matches becomes the fields themselves.
 *
 * @param str character vector
 * @param pattern character vector
 * @param n_max integer vector
 * @param omit_empty logical vector
 * @param collator_opts passed to stri__ucol_open(),
 * if \code{NA}, then \code{stri_detect_fixed_byte} is called
 * @return list of character vectors
 *
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-25) StriException friendly, use StriContainerUTF16
 * @version 0.3 (Marek Gagolewski, 2013-07-10) - BUGFIX: wrong behavior on empty str
 */
SEXP stri_split_fixed(SEXP str, SEXP pattern, SEXP n_max, SEXP omit_empty, SEXP collator_opts)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   n_max = stri_prepare_arg_integer(n_max, "n_max");
   omit_empty = stri_prepare_arg_logical(omit_empty, "omit_empty");

   // call stri__ucol_open after prepare_arg:
   // if prepare_arg had failed, we would have a mem leak
   UCollator* collator = stri__ucol_open(collator_opts);
   if (!collator)
      return stri__split_fixed_byte(str, pattern, n_max, omit_empty);

   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = stri__recycling_rule(true, 4, LENGTH(str), LENGTH(pattern), LENGTH(n_max), LENGTH(omit_empty));
   StriContainerUTF16 str_cont(str, vectorize_length);
   StriContainerUStringSearch pattern_cont(pattern, vectorize_length, collator);  // collator is not owned by pattern_cont
   StriContainerInteger   n_max_cont(n_max, vectorize_length);
   StriContainerLogical   omit_empty_cont(omit_empty, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (n_max_cont.isNA(i) || omit_empty_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }

      int  n_max_cur        = n_max_cont.get(i);
      int  omit_empty_cur   = omit_empty_cont.get(i);

      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));,
         SET_VECTOR_ELT(ret, i, stri__vector_empty_strings((omit_empty_cur || n_max_cur == 0)?0:1));)

      UStringSearch *matcher = pattern_cont.getMatcher(i, str_cont.get(i));
      usearch_reset(matcher);



      if (n_max_cur < 0)
         n_max_cur = INT_MAX;
      else if (n_max_cur == 0) {
         SET_VECTOR_ELT(ret, i, Rf_allocVector(STRSXP, 0));
         continue;
      }

      R_len_t k;
      deque<R_len_t_x2> fields; // byte based-indices
      fields.push_back(R_len_t_x2(0,0));
      UErrorCode status = U_ZERO_ERROR;

      for (k=1; k < n_max_cur && USEARCH_DONE != usearch_next(matcher, &status) && !U_FAILURE(status); ) {
         R_len_t s1 = (R_len_t)usearch_getMatchedStart(matcher);
         R_len_t s2 = (R_len_t)usearch_getMatchedLength(matcher) + s1;

         if (omit_empty_cur && fields.back().v1 == s1)
            fields.back().v1 = s2; // don't start new field
         else {
            fields.back().v2 = s1;
            fields.push_back(R_len_t_x2(s2, s2)); // start new field here
            ++k; // another field
         }
      }
      if (U_FAILURE(status)) throw StriException(status);
      fields.back().v2 = str_cont.get(i).length();
      if (omit_empty_cur && fields.back().v1 == fields.back().v2)
         fields.pop_back();

      R_len_t noccurences = (R_len_t)fields.size();
      StriContainerUTF16 out_cont(noccurences);
      deque<R_len_t_x2>::iterator iter = fields.begin();
      for (k = 0; iter != fields.end(); ++iter, ++k) {
         R_len_t_x2 curoccur = *iter;
         // this is a little bit slow, but anyway faster than the string USearch!
         out_cont.getWritable(k).setTo(str_cont.get(i), curoccur.v1, curoccur.v2-curoccur.v1);
      }
      SET_VECTOR_ELT(ret, i, out_cont.toR());
   }

   if (collator) { ucol_close(collator); collator=NULL; }
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
}

//   s = stri_prepare_arg_string(s, "str");
//   split = stri_prepare_arg_string(split, "split");
//   n = stri_prepare_arg_double(n, "n");
//   omitempty = stri_prepare_arg_logical(omitempty, "omitempty"); // TODO: prepare...logical_1?
//   exact = stri_prepare_arg_logical(exact, "exact"); // TODO: logical_1?
//   int a = LENGTH(s);
//   int b = LENGTH(split);
//   int c = LENGTH(n);
//   int d = LENGTH(omitempty);
//   int e = LENGTH(exact);
//
//   int nmax = stri__recycling_rule(true, 5, a, b, c, d, e);
//
//   int count = 0;
//   SEXP ret;
//   PROTECT(ret = allocVector(VECSXP,nmax));
//   SEXP curs,temp;
//   int k=0,curslen,spllen,st,add,where,curn;
//   //omitempty is bool, but bool* didn't work, so i changed it into
//   //int* and now it's fine
//   int* omit = LOGICAL(omitempty);
//   for (int i=0; i<nmax; ++i) {
//      count = 0;
//      curs = STRING_ELT(s, i % a);
//      curslen = LENGTH(curs);
//      const char* string = CHAR(curs);
//      const char* spl = CHAR(STRING_ELT(split, i % b));
//      // REAL(n)[i] == NA_REAL is wrong way of testing. ISNA() must be used
//      if(curs == NA_STRING || STRING_ELT(split, i % b) == NA_STRING
//         || ISNA(REAL(n)[i % c]) || omit[i%d]==NA_LOGICAL){
//         PROTECT(temp = allocVector(STRSXP,1));
//         SET_STRING_ELT(temp,0,NA_STRING);
//         SET_VECTOR_ELT(ret,i,temp);
//         UNPROTECT(1);
//         continue;
//      }
//      //here n can't be NA
//      if(REAL(n)[i % c]==R_PosInf){
//         curn = -1;
//      }else if(REAL(n)[i % c] <= 0){
//         PROTECT(temp = allocVector(STRSXP,0));
//         SET_VECTOR_ELT(ret,i,temp);
//         UNPROTECT(1);
//         continue;
//      }else
//         curn = REAL(n)[i % c];
//      //if curn == 1 then we need to return the whole string in one piece
//      if(curn == 1){
//         PROTECT(temp = allocVector(STRSXP,1));
//         SET_STRING_ELT(temp,0,curs);
//         SET_VECTOR_ELT(ret,i,temp);
//         UNPROTECT(1);
//         continue;
//      }
//      spllen = LENGTH(STRING_ELT(split,i % b));
//      //curn > 1 means that curn is not infinity (in such case curn
//      //is set to -1) or negative (empty vector is returned and this part
//      //of code is skipped).
//      //exact==TRUE then return vector of exact length
//      if(curn > 1 && LOGICAL(exact)[i % e]){
//         count = curn;
//         add = 0;
//      }else{ //otherwise count how long vector is needed
//         count=0;
//         st=0; add=1;
//         for(int j=0; j<curslen; ++j){
//            k=0;
//            while(string[j+k]==spl[k] && k<spllen)
//               k++;
//            if(k==spllen){
//               if(!omit[i % d] || j > st)
//                  count++;
//               st=j+k;
//               j=j+k-1;
//               if(omit[i % d] && st==curslen)
//                  add=0;
//               if(count+add==curn)
//                  break;
//            }
//         }
//      }
//      PROTECT(temp = allocVector(STRSXP,count+add));
//      st=0;
//      where=0;
//      for(int j=0; j<curslen; ++j){
//      	string = CHAR(curs);
//         k=0;
//         while(string[j+k]==spl[k] && k<spllen)
//            k++;
//      	if(k==spllen){
//            if(!omit[i % d] || j > st){
//               SET_STRING_ELT(temp,where, mkCharLen(string+st, j-st));
//               ++where;
//            }
//   			st=j+k;
//            j=j+k-1; //if match, then there is no need to check next k el.
//            if(where+1 == curn){
//               break;
//            }
//   		}
//   	}
//      //with this line, stri_split will return vector equal to str_split
//      //stri_split("ala","a")==strsplit("ala","a")==c("","l")
//      //without if(...) line we get
//      //stri_split("ala","a")==str_split("ala","a")==c("","l","")
//      if(where+1==curn || !omit[i % d] || curslen>st)
//         SET_STRING_ELT(temp,where, mkCharLen(string+st, curslen-st));
//   	SET_VECTOR_ELT(ret,i,temp);
//   	UNPROTECT(1);
//   }
//   UNPROTECT(1);
//   return ret;
