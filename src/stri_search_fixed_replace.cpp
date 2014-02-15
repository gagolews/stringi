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
 * Replace all/first/last occurences of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param collator_opts list
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-26) StriException friendly & Use StriContainers
 * @version 0.3 (Marek Gagolewski, 2013-07-10) - BUGFIX: wrong behavior on empty str
 */
SEXP stri__replace_allfirstlast_fixed_byte(SEXP str, SEXP pattern, SEXP replacement, int type)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerUTF8 replacement_cont(replacement, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length);


   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   String8 buf(0); // @TODO: calculate buf len a priori?

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);,
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(NULL, 0, CE_UTF8));)

      if (replacement_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      pattern_cont.setupMatcher(i, str_cont.get(i).c_str(), str_cont.get(i).length());

      R_len_t start;
      if (type >= 0) { // first or all
         start = pattern_cont.findFirst();
      } else {
         start = pattern_cont.findLast();
      }

      if (start == USEARCH_DONE) {
         SET_STRING_ELT(ret, i, str_cont.toR(i));
         continue;
      }

      R_len_t len = pattern_cont.getMatchedLength();
      R_len_t sumbytes = len;
      deque<R_len_t_x2> occurences;
      occurences.push_back(R_len_t_x2(start, start+len));

      while (type == 0 && USEARCH_DONE != pattern_cont.findNext()) { // all
         start = pattern_cont.getMatchedStart();
         len = pattern_cont.getMatchedLength();
         occurences.push_back(R_len_t_x2(start, start+len));
         sumbytes += len;
      }

      R_len_t str_cur_n     = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t     replacement_cur_n = replacement_cont.get(i).length();
      const char* replacement_cur_s = replacement_cont.get(i).c_str();
      R_len_t buf_need =
         str_cur_n+replacement_cur_n*(R_len_t)occurences.size()-sumbytes;
      buf.resize(buf_need);

      R_len_t jlast = 0;
      char* curbuf = buf.data();
      deque<R_len_t_x2>::iterator iter = occurences.begin();
      for (; iter != occurences.end(); ++iter) {
         R_len_t_x2 match = *iter;
         memcpy(curbuf, str_cur_s+jlast, (size_t)match.v1-jlast);
         curbuf += match.v1-jlast;
         jlast = match.v2;
         memcpy(curbuf, replacement_cur_s, (size_t)replacement_cur_n);
         curbuf += replacement_cur_n;
      }
      memcpy(curbuf, str_cur_s+jlast, (size_t)str_cur_n-jlast);
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), buf_need, CE_UTF8));
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}

/**
 * Replace all/first/last occurences of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param collator_opts list
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-26) StriException friendly & Use StriContainers
 * @version 0.3 (Marek Gagolewski, 2013-07-10) - BUGFIX: wrong behavior on empty str
 */
SEXP stri__replace_allfirstlast_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP collator_opts, int type)
{
   str = stri_prepare_arg_string(str, "str");
   replacement = stri_prepare_arg_string(replacement, "replacement");
   pattern = stri_prepare_arg_string(pattern, "pattern");

   // call stri__ucol_open after prepare_arg:
   // if prepare_arg had failed, we would have a mem leak
   UCollator* collator = stri__ucol_open(collator_opts);
   if (!collator)
      return stri__replace_allfirstlast_fixed_byte(str, pattern, replacement, type);

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
         /*just skip on empty str*/;)

      if (replacement_cont.isNA(i)) {
         str_cont.setNA(i);
         continue;
      }

      UStringSearch *matcher = pattern_cont.getMatcher(i, str_cont.get(i));
      usearch_reset(matcher);

      UErrorCode status = U_ZERO_ERROR;
      R_len_t remUChars = 0;
      deque<R_len_t_x2> occurences;

      if (type >= 0) { // first or all
         int start = (int)usearch_first(matcher, &status);
         if (U_FAILURE(status)) throw StriException(status);

         if (start == USEARCH_DONE) // no match
            continue; // no change in str_cont[i] at all

         while (start != USEARCH_DONE) {
            R_len_t mlen = usearch_getMatchedLength(matcher);
            remUChars += mlen;
            occurences.push_back(R_len_t_x2(start, start+mlen));
            if (type > 0) break; // break if first and not all
            start = usearch_next(matcher, &status);
            if (U_FAILURE(status)) throw StriException(status);
         }
      }
      else { // if last
         int start = (int)usearch_last(matcher, &status);
         if (U_FAILURE(status)) throw StriException(status);
         if (start == USEARCH_DONE) // no match
            continue; // no change in str_cont[i] at all
         R_len_t mlen = usearch_getMatchedLength(matcher);
         remUChars += mlen;
         occurences.push_back(R_len_t_x2(start, start+mlen));
      }

      R_len_t replacement_cur_n = replacement_cont.get(i).length();
      R_len_t noccurences = (R_len_t)occurences.size();
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
}



/**
 * Replace all occurences of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param collator_opts list
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-26) use stri__replace_allfirstlast_fixed
 */
SEXP stri_replace_all_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP collator_opts)
{
   return stri__replace_allfirstlast_fixed(str, pattern, replacement, collator_opts, 0);
}


/**
 * Replace last occurence of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param collator_opts list
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-26) use stri__replace_allfirstlast_fixed
 */
SEXP stri_replace_last_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP collator_opts)
{
   return stri__replace_allfirstlast_fixed(str, pattern, replacement, collator_opts, -1);
}


/**
 * Replace first occurence of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param collator_opts list
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-26) use stri__replace_allfirstlast_fixed
 */
SEXP stri_replace_first_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP collator_opts)
{
   return stri__replace_allfirstlast_fixed(str, pattern, replacement, collator_opts, 1);
}
