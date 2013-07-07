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
 * ////   if (U_FAILURE(err))
 * //   cerr << (err == U_ZERO_ERROR) << endl;
 * //   cerr << (err == U_USING_DEFAULT_WARNING) << endl;
 * //   cerr << (err == U_USING_FALLBACK_WARNING) << endl;
 *
 * 
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF16
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
*/
SEXP stri_trans_case(SEXP str, SEXP type, SEXP locale)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   const char* qloc = stri__prepare_arg_locale(locale, "locale", true);
   BreakIterator* briter = NULL;
   
   STRI__ERROR_HANDLER_BEGIN
   
   if (!Rf_isInteger(type) || LENGTH(type) != 1)
      throw StriException(MSG__INCORRECT_INTERNAL_ARG); // this is an internal arg, check manually     
   int _type = INTEGER(type)[0];
   
   
   Locale loc = Locale::createFromName(qloc); // this will be freed automatically
   StriContainerUTF16 str_cont(str, LENGTH(str), false); // writable, no recycle
   
   if (_type == 6) {
      UErrorCode status = U_ZERO_ERROR;
      briter = BreakIterator::createWordInstance(loc, status);
      if (U_FAILURE(status)) throw StriException(status);
   }
   
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
            case 6:
               str_cont.getWritable(i).toTitle(briter, loc); // how to get it working properly with English text???
               break;
            default:
               throw StriException("stri_trans_case: incorrect case conversion type");
         }
      }
   }
   
   if (briter) { delete briter; briter = NULL; }
   SEXP ret;
   PROTECT(ret = str_cont.toR());
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(
      if (briter) delete briter;
   )
}
