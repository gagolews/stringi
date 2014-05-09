/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#include "stri_stringi.h"
#include "stri_container_utf16.h"
#include "stri_container_usearch.h"
#include "stri_string8buf.h"
#include <deque>
using namespace std;


/**
 * Replace all/first/last occurences of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param opts_collator list
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          StriException friendly & Use StriContainers
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-07-10)
 *          BUGFIX: wrong behavior on empty str
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          new fun: stri__replace_allfirstlast_coll (opts_collator == NA not allowed)
 */
SEXP stri__replace_allfirstlast_coll(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_collator, int type)
{
   str = stri_prepare_arg_string(str, "str");
   replacement = stri_prepare_arg_string(replacement, "replacement");
   pattern = stri_prepare_arg_string(pattern, "pattern");

   UCollator* collator = NULL;
   collator = stri__ucol_open(opts_collator);

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
      deque< pair<R_len_t, R_len_t> > occurences;

      if (type >= 0) { // first or all
         int start = (int)usearch_first(matcher, &status);
         if (U_FAILURE(status)) throw StriException(status);

         if (start == USEARCH_DONE) // no match
            continue; // no change in str_cont[i] at all

         while (start != USEARCH_DONE) {
            R_len_t mlen = usearch_getMatchedLength(matcher);
            remUChars += mlen;
            occurences.push_back(pair<R_len_t, R_len_t>(start, start+mlen));
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
         occurences.push_back(pair<R_len_t, R_len_t>(start, start+mlen));
      }

      R_len_t replacement_cur_n = replacement_cont.get(i).length();
      R_len_t noccurences = (R_len_t)occurences.size();
      UnicodeString ans(str_cont.get(i).length()-remUChars+noccurences*replacement_cur_n, (UChar)0xfffd, 0);
      R_len_t jlast = 0;
      R_len_t anslast = 0;
      deque< pair<R_len_t, R_len_t> >::iterator iter = occurences.begin();
      for (; iter != occurences.end(); ++iter) {
         pair<R_len_t, R_len_t> match = *iter;
         ans.replace(anslast, match.first-jlast, str_cont.get(i), jlast, match.first-jlast);
         anslast += match.first-jlast;
         jlast = match.second;
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
 * @param opts_collator list
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          use stri__replace_allfirstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          new fun: stri_replace_all_coll (opts_collator == NA not allowed)
 */
SEXP stri_replace_all_coll(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_collator)
{
   return stri__replace_allfirstlast_coll(str, pattern, replacement, opts_collator, 0);
}


/**
 * Replace last occurence of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param opts_collator list
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          use stri__replace_allfirstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          new fun: stri_replace_last_coll (opts_collator == NA not allowed)
 */
SEXP stri_replace_last_coll(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_collator)
{
   return stri__replace_allfirstlast_coll(str, pattern, replacement, opts_collator, -1);
}


/**
 * Replace first occurence of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param opts_collator list
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          use stri__replace_allfirstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          new fun: stri_replace_first_coll (opts_collator == NA not allowed)
 */
SEXP stri_replace_first_coll(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_collator)
{
   return stri__replace_allfirstlast_coll(str, pattern, replacement, opts_collator, 1);
}
