/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "stri_stringi.h"




/**
 * Trim characters from a charclass from left AND/OR right side of the string
 *
 * @param str character vector
 * @param pattern character vector
 * @param left from left?
 * @param right from left?
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use StriContainerUTF8 and CharClass
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly & Use StrContainerCharClass
*/
SEXP stri__trim_leftright(SEXP str, SEXP pattern, bool left, bool right)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i) || pattern_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      CharClass pattern_cur = pattern_cont.get(i);
      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t j;
      R_len_t jlast1 = 0;
      R_len_t jlast2 = str_cur_n;
      UChar32 chr;

      if (left) {
         for (j=0; j<str_cur_n; ) {
            U8_NEXT(str_cur_s, j, str_cur_n, chr); // "look ahead"
            if (pattern_cur.test(chr)) {
               break; // break at first occurence
            }
            jlast1 = j;
         }
      }

      if (right && jlast1 < str_cur_n) {
         for (j=str_cur_n; j>0; ) {
            U8_PREV(str_cur_s, 0, j, chr); // "look behind"
            if (pattern_cur.test(chr)) {
               break; // break at first occurence
            }
            jlast2 = j;
         }
      }

      // now jlast is the index, from which we start copying
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cur_s+jlast1, (jlast2-jlast1), CE_UTF8));
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/**
 * Trim characters from a charclass from both sides of the string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use stri__trim_leftright
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
*/
SEXP stri_trim_both(SEXP str, SEXP pattern)
{
   return stri__trim_leftright(str, pattern, true, true);
}




/**
 * Trim characters from a charclass from the left of the string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use stri__trim_leftright
*/
SEXP stri_trim_left(SEXP str, SEXP pattern)
{
   return stri__trim_leftright(str, pattern, true, false);
}


/**
 * Trim characters from a charclass from the right of the string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use stri__trim_leftright
*/
SEXP stri_trim_right(SEXP str, SEXP pattern)
{
   return stri__trim_leftright(str, pattern, false, true);
}




///**
// * Trim consecutive repeating characters from a charclass
// *
// * @param str character vector
// * @param pattern character vector
// * @param leave_first logical vector
// * @return character vector
// *
// * @version 0.1 (Bartek Tartanus)
//*/
//SEXP stri_trim_double(SEXP s, SEXP pattern, SEXP leave_first)
//{
//   s = stri_prepare_arg_string(s, "str"); // prepare string argument
//   R_len_t ns = LENGTH(s);
//   SEXP e,subs, curs, temp, temp2, white, space;
//   PROTECT(e = allocVector(STRSXP, ns));
//   PROTECT(white = allocVector(STRSXP, 1));
//   PROTECT(space = allocVector(STRSXP, 1));
//   SET_STRING_ELT(white,0,mkCharLen("^WHITE_SPACE",12));
//   SET_STRING_ELT(space,0,mkCharLen(" ",1));
//   subs = stri_locate_all_charclass(s, white, ScalarLogical(FALSE));
//   int n;
//   for(int i=0; i < ns; ++i){
//      curs = STRING_ELT(s, i);
//      if(curs == NA_STRING){
//         SET_STRING_ELT(e, i, NA_STRING);
//         continue;
//      }
//      temp = VECTOR_ELT(subs, 0);
//      n = LENGTH(temp)/2;
//      int* fromto = INTEGER(temp);
//      //if from==NA then string contains only white space -> return empty
//      if(fromto[0] == NA_INTEGER){
//         SET_STRING_ELT(e, i, mkCharLen("",0));
//         continue;
//      }
//      temp2 = stri__split_pos(CHAR(curs), fromto, fromto + n,LENGTH(curs),n);
//      SET_STRING_ELT(e, i,STRING_ELT(stri_flatten(temp2, space),0));
//   }
//   UNPROTECT(3);
//   return e;
//}
