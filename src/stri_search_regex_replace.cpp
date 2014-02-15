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
 * Replace all occurences of a regex pattern
 *
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @param replacement replacements
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-21)
 */
SEXP stri_replace_all_regex(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_regex)
{
   return stri__replace_allfirstlast_regex(str, pattern, replacement, opts_regex, 0);
}


/**
 * Replace first occurence of a regex pattern
 *
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @param replacement replacements
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-21)
 */
SEXP stri_replace_first_regex(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_regex)
{
   return stri__replace_allfirstlast_regex(str, pattern, replacement, opts_regex, 1);
}


/**
 * Replace last occurence of a regex pattern
 *
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @param replacement replacements
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-21)
 */
SEXP stri_replace_last_regex(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_regex)
{
   return stri__replace_allfirstlast_regex(str, pattern, replacement, opts_regex, -1);
}


/**
 * Replace occurences of a regex pattern
 *
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @param replacement replacements
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski)  - use StriContainerUTF16's vectorization
 * @version 0.3 (Marek Gagolewski, 2013-06-21) - use StriContainerRegexPattern + more general
 * @version 0.4 (Marek Gagolewski, 2013-07-10) - BUGFIX: wrong behavior on empty str
 */
SEXP stri__replace_allfirstlast_regex(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_regex, int type)
{
   str = stri_prepare_arg_string(str, "str");
   replacement = stri_prepare_arg_string(replacement, "replacement");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));
   StriContainerUTF16 str_cont(str, vectorize_length, false); // writable
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);
   StriContainerUTF16 replacement_cont(replacement, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);,
         /*just skip on empty str*/;)

      if (replacement_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      matcher->reset(str_cont.get(i));

      UErrorCode status = U_ZERO_ERROR;
      if (type == 0) { // all
         str_cont.set(i, matcher->replaceAll(replacement_cont.get(i), status));
      }
      else if (type == 1) { // first
         str_cont.set(i, matcher->replaceFirst(replacement_cont.get(i), status));
      }
      else if (type == -1) { // end
         int start = -1;
         int end = -1;
         while (matcher->find()) { // find last match
            start = matcher->start(status);
            end = matcher->end(status);
            if (U_FAILURE(status)) throw StriException(status);
         }
         if (start >= 0) {
            matcher->find(start, status); // go back
            if (U_FAILURE(status)) throw StriException(status);
            UnicodeString out;
            matcher->appendReplacement(out, replacement_cont.get(i), status);
            out.append(str_cont.get(i), end, str_cont.get(i).length()-end);
            str_cont.set(i, out);
         }
      }
      else {
         throw StriException(MSG__INTERNAL_ERROR);
      }

      if (U_FAILURE(status))
         throw StriException(status);
      SET_STRING_ELT(ret, i, str_cont.toR(i));
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
