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
#include "stri_container_utf8_indexable.h"
#include <deque>
#include <vector>
#include <utility>
#include <unicode/brkiter.h>
#include <unicode/uniset.h>


/** Greedy word wrap algorithm
 *
 * @param wrap_after [out]
 * @param nwords number of "words"
 * @param width_val maximal desired out line width
 * @param counts_orig ith word width original
 * @param counts_trim ith word width trimmed
 * @param add_para_1
 * @param add_para_n
 *
 * @version 0.1-?? (Bartek Tartanus)
 *          original implementation
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-28)
 *          BreakIterator usage mods
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-06)
 *    new args: add_para_1, add_para_n
 */
void stri__wrap_greedy(std::deque<R_len_t>& wrap_after,
   R_len_t nwords, int width_val,
   const std::vector<R_len_t>& counts_orig,
   const std::vector<R_len_t>& counts_trim,
   int add_para_1, int add_para_n)
{
   R_len_t cur_len = add_para_1+counts_orig[0];
   for (R_len_t j = 1; j < nwords; ++j) {
      if (cur_len + counts_trim[j] > width_val) {
         cur_len = add_para_n+counts_orig[j];
         wrap_after.push_back(j-1);
      }
      else {
         cur_len += counts_orig[j];
      }
   }
}


/** Dynamic word wrap algorithm
 * (Knuth's word wrapping algorithm that minimizes raggedness of formatted text)
 *
 * @param wrap_after [out]
 * @param nwords number of "words"
 * @param width_val maximal desired out line width
 * @param exponent_val cost function exponent
 * @param counts_orig ith word width original
 * @param counts_trim ith word width trimmed
 * @param add_para_1
 * @param add_para_a
 *
 * @version 0.1-?? (Bartek Tartanus)
 *          original implementation
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-30)
 *          BreakIterator usage mods
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-06)
 *    new args: add_para_1, add_para_n,
 *    cost of the last line is zero
 */
void stri__wrap_dynamic(std::deque<R_len_t>& wrap_after,
   R_len_t nwords, int width_val, double exponent_val,
   const std::vector<R_len_t>& counts_orig,
   const std::vector<R_len_t>& counts_trim,
   int add_para_1, int add_para_n)
{
#define IDX(i,j) (i)*nwords+(j)
   vector<double> cost(nwords*nwords);
   // where cost[IDX(i,j)] == cost of printing words i..j in a single line, i<=j

   // calculate costs:
   // there is some "punishment" for leaving blanks at the end of each line
   // (number of "blank" codepoints ^ exponent_val)
   for (int i=0; i<nwords; i++) {
      int sum = 0;
      for (int j=i; j<nwords; j++) {
         if (j > i) {
            if (cost[IDX(i,j-1)] < 0.0) { // already Inf
               cost[IDX(i,j)] = -1.0; // Inf
               continue;
            }
            else {
               sum -= counts_trim[j-1];
               sum += counts_orig[j-1];
            }
         }
         sum += counts_trim[j];
         int ct = width_val - sum;
         if (i == 0) ct -= add_para_1;
         else        ct -= add_para_n;

         if (j == nwords-1) { // last line == cost 0
            if (j == i || ct >= 0)
               cost[IDX(i,j)] = 0.0;
            else
               cost[IDX(i,j)] = -1.0/*Inf*/;
         }
         else if (j == i)
            // some words don't fit in a line at all -> cost 0.0
            cost[IDX(i,j)] = (ct < 0) ? 0.0 : pow((double)ct, exponent_val);
         else
            cost[IDX(i,j)] = (ct < 0) ? -1.0/*"Inf"*/ : pow((double)ct, exponent_val);
      }
   }

   vector<double> f(nwords); // f[j] == total cost of  (optimally) printing words 0..j
   vector<bool> where(nwords*nwords, false); // where[IDX(i,j)] == false iff
                                             // we don't wrap after i-th word, i<=j
                                             // when (optimally) printing words 0..j

   for (int j=0; j<nwords; ++j) {
      if (cost[IDX(0,j)] >= 0.0) {
         // no breaking needed: words 0..j fit in one line
         f[j] = cost[IDX(0,j)];
         continue;
      }

      // let i = optimal way of printing of words 0..i + printing i+1..j
      int i = 0;
      while (i <= j) {
         if (cost[IDX(i+1,j)] >= 0.0) break;
         ++i;
      }

      double best_i = f[i] + cost[IDX(i+1,j)];
      for (int k=i+1; k<j; ++k) {
         if (cost[IDX(k+1,j)] < 0.0) continue;
         double best_cur = f[k] + cost[IDX(k+1,j)];
         if (best_cur < best_i) {
            best_i = best_cur;
            i = k;
         }
      }
      for (int k=0; k<i; ++k)
         where[IDX(k,j)] = where[IDX(k,i)];
      where[IDX(i,j)] = true;
      f[j] = best_i;
   }

   //result is in the last row of where...
   for (int k=0; k<nwords; ++k)
      if (where[IDX(k, nwords-1)])
         wrap_after.push_back(k);
}


struct StriWrapLineStart {
   std::string str;
   R_len_t nbytes;
   R_len_t count;

   StriWrapLineStart(const String8& s, R_len_t v) :
      str(s.c_str()) {
      nbytes  = s.length()+v;
      count   = s.countCodePoints()+v;
      str.append(std::string(v, ' '));
   }
};


/** Word wrap text
 *
 * @param str character vector
 * @param width single integer
 * @param cost_exponent single double
 * @param indent single integer
 * @param exdent single integer
 * @param prefix single string
 * @param initial single string
 * @param locale locale identifier or NULL for default locale
 *
 * @return list
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-27)
 *          single function for wrap_greedy and wrap_dynamic
 *          (dispatch inside);
 *          use BreakIterator
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-06)
 *    new args: indent, exdent, prefix, initial
 */
SEXP stri_wrap(SEXP str, SEXP width, SEXP cost_exponent,
   SEXP indent, SEXP exdent, SEXP prefix, SEXP initial, SEXP locale)
{
   double exponent_val = stri__prepare_arg_double_1_notNA(cost_exponent, "cost_exponent");

   int width_val = stri__prepare_arg_integer_1_notNA(width, "width");
   if (width_val <= 0) Rf_error(MSG__EXPECTED_POSITIVE, "width");

   int indent_val = stri__prepare_arg_integer_1_notNA(indent, "indent");
   if (indent_val < 0) Rf_error(MSG__EXPECTED_POSITIVE, "indent");

   int exdent_val = stri__prepare_arg_integer_1_notNA(exdent, "exdent");
   if (exdent_val < 0) Rf_error(MSG__EXPECTED_POSITIVE, "exdent");


   const char* qloc = stri__prepare_arg_locale(locale, "locale", true); /* this is R_alloc'ed */
   Locale loc = Locale::createFromName(qloc);
   PROTECT(str     = stri_prepare_arg_string(str, "str"));
   PROTECT(prefix  = stri_prepare_arg_string_1(prefix, "prefix"));
   PROTECT(initial = stri_prepare_arg_string_1(initial, "initial"));

   BreakIterator* briter = NULL;
   UText* str_text = NULL;

   STRI__ERROR_HANDLER_BEGIN(3)
   UErrorCode status = U_ZERO_ERROR;
   briter = BreakIterator::createLineInstance(loc, status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   R_len_t str_length = LENGTH(str);
   StriContainerUTF8_indexable str_cont(str, str_length);
   StriContainerUTF8 prefix_cont(prefix, 1);
   StriContainerUTF8 initial_cont(initial, 1);


   // prepare indent/exdent/prefix/initial stuff:
   // 1st line, 1st para (i==0, u==0): initial+indent
   // nth line, 1st para (i==0, u> 0): prefix +exdent
   // 1st line, nth para (i> 0, u==0): prefix +indent
   // nth line, nth para (i> 0, u> 0): prefix +exdent
   StriWrapLineStart ii(initial_cont.get(0), indent_val);
   StriWrapLineStart pi(prefix_cont.get(0), indent_val);
   StriWrapLineStart pe(prefix_cont.get(0), exdent_val);


   status = U_ZERO_ERROR;
   //Unicode Newline Guidelines - Unicode Technical Report #13
   UnicodeSet uset_linebreaks(UnicodeString::fromUTF8("[\\u000A-\\u000D\\u0085\\u2028\\u2029]"), status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   uset_linebreaks.freeze();

   status = U_ZERO_ERROR;
   UnicodeSet uset_whitespaces(UnicodeString::fromUTF8("\\p{White_space}"), status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   uset_whitespaces.freeze();

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, str_length));
   for (R_len_t i = 0; i < str_length; ++i)
   {
      if (str_cont.isNA(i) || prefix_cont.isNA(0) || initial_cont.isNA(0)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }

      status = U_ZERO_ERROR;
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t str_cur_n = str_cont.get(i).length();
      str_text = utext_openUTF8(str_text, str_cur_s, str_cont.get(i).length(), &status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      status = U_ZERO_ERROR;
      briter->setText(str_text, status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      // all right, first let's generate a list of places at which we may do line breaks
      deque< R_len_t > occurrences_list; // this could be an R_len_t queue
      R_len_t match = briter->first();
      while (match != BreakIterator::DONE) {
         occurrences_list.push_back(match);
         match = briter->next();
      }

      R_len_t noccurrences = (R_len_t)occurrences_list.size(); // number of boundaries
      if (noccurrences <= 1) { // no match (1 boundary == 0)
         SET_VECTOR_ELT(ret, i, str_cont.toR(i));
         continue;
      }

      // the number of "words" is:
      R_len_t nwords = noccurrences - 1;

      // convert occurrences_list to a vector
      // in order to obtain end positions (in a string) of each "words",
      // noting that occurrences_list.at(0) == 0
#ifndef NDEBUG
      if (occurrences_list.at(0) != 0)
         throw StriException("NDEBUG: stri_wrap: (occurrences_list.at(0) != 0)");
#endif

      std::vector<R_len_t> end_pos_orig(nwords);
      deque<R_len_t>::iterator iter = ++(occurrences_list.begin());
      for (R_len_t j = 0; iter != occurrences_list.end(); ++iter, ++j) {
         end_pos_orig[j] = (*iter); // this is a UTF-8 index
      }


      // now:
      // we'll get the number of code points in each "word"
      std::vector<R_len_t> counts_orig(nwords);
      // we'll get the number of code points without trailing whitespaces
      std::vector<R_len_t> counts_trim(nwords);
      // we'll get the end positions without trailing whitespaces
      std::vector<R_len_t> end_pos_trim(nwords);
      // detect line endings (fail on a match)

      UChar32 c = 0;
      R_len_t j = 0;
      R_len_t cur_block = 0;
      R_len_t cur_count_orig = 0;
      R_len_t cur_count_trim = 0;
      R_len_t cur_end_pos_trim = 0;
      while (j < str_cur_n) {
         U8_NEXT(str_cur_s, j, str_cur_n, c);
         if (c < 0) // invalid utf-8 sequence
            throw StriException(MSG__INVALID_UTF8);

         if (uset_linebreaks.contains(c))
            throw StriException(MSG__NEWLINE_FOUND);

         ++cur_count_orig;
         if (uset_whitespaces.contains(c)) {
            ++cur_count_trim;
         }
         else {
            cur_count_trim = 0;
            cur_end_pos_trim = j;
         }

         if (j >= str_cur_n || end_pos_orig[cur_block] <= j) {
            // we'll start a new block in a moment
            counts_orig[cur_block] = cur_count_orig;
            counts_trim[cur_block] = cur_count_orig-cur_count_trim;
            end_pos_trim[cur_block] = cur_end_pos_trim;
            cur_block++;
            cur_count_orig = 0;
            cur_count_trim = 0;
            cur_end_pos_trim = j;
         }
      }

      // do wrap
      std::deque<R_len_t> wrap_after; // wrap line after which word in {0..nwords-1}?
      if (exponent_val <= 0.0) {
         stri__wrap_greedy(wrap_after, nwords, width_val,
            counts_orig, counts_trim, (i==0)?ii.count:pi.count, pe.count);
      }
      else {
         stri__wrap_dynamic(wrap_after, nwords, width_val, exponent_val,
            counts_orig, counts_trim, (i==0)?ii.count:pi.count, pe.count);
      }

      // wrap_after.size() line breaks => wrap_after.size()+1 lines
      R_len_t nlines = (R_len_t)wrap_after.size()+1;
      R_len_t last_pos = 0;
      SEXP ans;
      STRI__PROTECT(ans = Rf_allocVector(STRSXP, nlines));
      deque<R_len_t>::iterator iter_wrap = wrap_after.begin();
      for (R_len_t u = 0; iter_wrap != wrap_after.end(); ++iter_wrap, ++u) {
         R_len_t wrap_after_cur = *iter_wrap;
         R_len_t cur_pos = end_pos_trim[wrap_after_cur];

         std::string cs;
         if (i == 0 && u == 0)     cs = ii.str;
         else if (i > 0 && u == 0) cs = pi.str;
         else                      cs = pe.str;
         cs.append(str_cur_s+last_pos, cur_pos-last_pos);
         SET_STRING_ELT(ans, u, Rf_mkCharLenCE(cs.c_str(), cs.size(), CE_UTF8));

         last_pos = end_pos_orig[wrap_after_cur];
      }

      // last line goes here:
      std::string cs;
      if (i == 0 && nlines-1 == 0)     cs = ii.str;
      else if (i > 0 && nlines-1 == 0) cs = pi.str;
      else                             cs = pe.str;
      cs.append(str_cur_s+last_pos, end_pos_trim[nwords-1]-last_pos);
      SET_STRING_ELT(ans, nlines-1, Rf_mkCharLenCE(cs.c_str(), cs.size(), CE_UTF8));

      SET_VECTOR_ELT(ret, i, ans);
      STRI__UNPROTECT(1);
   }

   if (briter) { delete briter; briter = NULL; }
   if (str_text) { utext_close(str_text); str_text = NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      if (briter) { delete briter; briter = NULL; }
      if (str_text) { utext_close(str_text); str_text = NULL; }
   })
}
