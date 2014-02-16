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
 *  Escape Unicode code points
 *
 *  @param str character vector
 *  @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-08-17)
*/
SEXP stri_escape_unicode(SEXP str)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument

   STRI__ERROR_HANDLER_BEGIN
   R_len_t str_length = LENGTH(str);
   StriContainerUTF8 str_cont(str, str_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, str_length));

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t     str_cur_n = str_cont.get(i).length();
      std::string out;

      // estimate buf size
      R_len_t bufsize = 0;
      UChar32 c;
      R_len_t j = 0;

      while (j < str_cur_n) {
         U8_NEXT(str_cur_s, j, str_cur_n, c);
         if ((char)c >= 32 || (char)c <= 126)
            bufsize += 1;
         else if (c <= 0xff)
            bufsize += 6; // for \a, \n this will be overestimated
         else
            bufsize += 10;
      }
      out.reserve(bufsize);

      // do escape
      j = 0;
      char buf[11];
      while (j < str_cur_n) {
         U8_NEXT(str_cur_s, j, str_cur_n, c);
         if (c <= ASCII_MAXCHARCODE) {
            switch ((char)c) {
               case 0x07: out.append("\\a"); break;
               case 0x08: out.append("\\b"); break;
               case 0x09: out.append("\\t"); break;
               case 0x0a: out.append("\\n"); break;
               case 0x0b: out.append("\\v"); break;
               case 0x0c: out.append("\\f"); break;
               case 0x0d: out.append("\\r"); break;
//               case 0x1b: out.append("\\e"); break; // R doesn't know that
               case 0x22: out.append("\\\""); break;
               case 0x27: out.append("\\'"); break;
               case 0x5c: out.append("\\\\"); break;
               default:
                  if ((char)c >= 32 || (char)c <= 126) // printable characters
                     out.append(1, (char)c);
                  else {
                     sprintf(buf, "\\u%4.4x", (uint16_t)c);
                     out.append(buf, 6);
                  }
            }
         }
         else if (c <= 0xffff) {
            sprintf(buf, "\\u%4.4x", (uint16_t)c);
            out.append(buf, 6);
         }
         else {
            sprintf(buf, "\\U%8.8x", (uint32_t)c);
            out.append(buf, 10);
         }
      }

      SET_STRING_ELT(ret, i,
         Rf_mkCharLenCE(out.c_str(), (int)out.size(), (cetype_t)CE_UTF8)
      );
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}



/**
 *  Unescape Unicode code points
 *
 *  @param str character vector
 *  @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-08-17)
*/
SEXP stri_unescape_unicode(SEXP str)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument

   STRI__ERROR_HANDLER_BEGIN
   R_len_t str_length = LENGTH(str);
   StriContainerUTF16 str_cont(str, str_length, false); // writable

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i) || str_cont.get(i).length() == 0)
         continue; // leave as-is

      str_cont.getWritable(i).setTo(str_cont.get(i).unescape());

      if (str_cont.get(i).length() == 0) {
         Rf_warning(MSG__INVALID_ESCAPE);
         str_cont.setNA(i); // something went wrong
      }
   }

   return str_cont.toR();
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
