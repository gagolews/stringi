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
 * Count the number of recurrences of \code{pattern} in \code{s}
 *
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @param opts_regex list
 *
 * @return integer vector
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF16's vectorization
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 * @version 0.4 (Marek Gagolewski, 2013-06-17) use StriContainerRegexPattern + opts_regex
 */
SEXP stri_count_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   // this will work for vectorize_length == 0:

   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   STRI__ERROR_HANDLER_BEGIN

   StriContainerUTF16 str_cont(str, vectorize_length);
   // MG: tried StriContainerUTF8 + utext_openUTF8 - this was slower
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, vectorize_length));
   int* ret_tab = INTEGER(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont, ret_tab[i] = NA_INTEGER, ret_tab[i] = 0)

      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      matcher->reset(str_cont.get(i));
      int count = 0;
      while ((bool)matcher->find())
         ++count;
      ret_tab[i] = count;
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
