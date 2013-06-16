/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus
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
 * Convert case (TitleCase, lowercase, UPPERCASE, etc.)
 * 
 * 
 *  @param str character vector
 *  @param type internal code of case conversion type 
 *  @param locale single string identifying the locale ("" or NULL for default locale)
 *  @return character vector
 * 
 * 
 * ////  TO DO
 * ////   stri_totitle("pining for the fjords-yes, i'm brian", "en_US")
 * //   UErrorCode err = U_ZERO_ERROR;
 * //   BreakIterator* br = BreakIterator::createWordInstance(loc, err); // should be freed after use
 * ////   if (!U_SUCCESS(err))
 * //   cerr << (err == U_ZERO_ERROR) << endl;
 * //   cerr << (err == U_USING_DEFAULT_WARNING) << endl;
 * //   cerr << (err == U_USING_FALLBACK_WARNING) << endl;
 *
 * 
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException friendly
*/
SEXP stri_casefold(SEXP str, SEXP type, SEXP locale)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   
   STRI__ERROR_HANDLER_BEGIN
   
   if (!isInteger(type) || LENGTH(type) != 1)
      throw StriException(MSG__INCORRECT_INTERNAL_ARG); // this is an internal arg, check manually     
   int _type = INTEGER(type)[0];
   
   const char* qloc = stri__prepare_arg_locale(locale, "locale", true);
   Locale loc = Locale::createFromName(qloc); // this will be freen automatically

   StriContainerUTF16 str_cont(str, LENGTH(str), false); // writable, no recycle
   
   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (!str_cont.isNA(i)) {
         switch (_type) {
            case 1:
               str_cont.getWritable(i).toLower(loc);
               break;
            case 2:
               str_cont.getWritable(i).toUpper(loc);
               break;
            case 3:
               str_cont.getWritable(i).toTitle(NULL, loc); // use default ICU's BreakIterator
               break;
            case 4:
               str_cont.getWritable(i).foldCase(U_FOLD_CASE_DEFAULT);
               break;
            case 5:
               str_cont.getWritable(i).foldCase(U_FOLD_CASE_EXCLUDE_SPECIAL_I);
               break;
            default:
               error("stri_casefold: incorrect case conversion type");
         }
      }
   }
   
   SEXP ret;
   PROTECT(ret = str_cont.toR());
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
