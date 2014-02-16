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
 * General statistics for a character vector
 *
 * @param str a character vector
 * @return integer vector, see R man for details
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski, 2013-06-09) Use StriContainerUTF8
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_stats_general(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_length = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, str_length);

   enum {
      gsNumLines = 0,
      gsNumLinesNonEmpty = 1,
      gsNumChars = 2,
      gsNumCharsNonWhite = 3,
      gsAll = 4 // always == number of elements
   };

   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, gsAll));
   int* stats = INTEGER(ret);
   for (int i=0; i<gsAll; ++i)
      stats[i] = 0;

   for (R_len_t i=0; i<str_length; ++i) {
      if (str_cont.isNA(i)) continue; // ignore

      ++stats[gsNumLines]; // another line
      R_len_t     cn = str_cont.get(i).length();
      const char* cs = str_cont.get(i).c_str();
      UChar32 c;
      bool AnyNonWhite = false;

      for (int j=0; j<cn; ) {
         U8_NEXT(cs, j, cn, c);
         if (c == (UChar32)'\n' || c == (UChar32)'\r')
            throw StriException(MSG__NEWLINE_FOUND);
         ++stats[gsNumChars]; // another character [code point]
         // we test for UCHAR_WHITE_SPACE binary property
         if (!u_hasBinaryProperty(c, UCHAR_WHITE_SPACE)) {
            AnyNonWhite = true;
            ++stats[gsNumCharsNonWhite];
         }
      }

      if (AnyNonWhite)
         ++stats[gsNumLinesNonEmpty]; // we have a non-empty line here
   }

   stri__set_names(ret, gsAll, "Lines", "LinesNEmpty", "Chars", "CharsNWhite");
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}




/**
 * LaTeX, Kile-like statistics for a character vector
 *
 * We use a modified LaTeX Word Count algorithm.
 * Original version from Kile 2.1.3, see http://kile.sourceforge.net/team.php
 *
 * @param str a character vector
 * @return integer vector, see R man for details
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski, 2013-06-09) Use StriContainerUTF8
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_stats_latex(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_length = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, str_length);

   // We use a modified Kile 2.1.3 LaTeX Word Count algorithm;
   // see http://kile.sourceforge.net/team.php
   enum State {
      stStandard = 0, stComment = 1, stControlSequence = 3,
      stControlSymbol = 4, stCommand = 5, stEnvironment = 6
   };

   enum {
      lsCharsWord = 0,
      lsCharsCmdEnvir = 1,
      lsCharsWhite = 2,
      lsWords = 3,
      lsCmd = 4,
      lsEnvir = 5,
      lsAll = 6
   };

   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, lsAll));
   int* stats = INTEGER(ret);
   for (int i=0; i<lsAll; ++i) stats[i] = 0;

   for (R_len_t i=0; i<str_length; ++i) {
      if (str_cont.isNA(i)) continue; // ignore

      R_len_t     cn = str_cont.get(i).length();
      const char* cs = str_cont.get(i).c_str();
      UChar32 c;

      int state = stStandard;
      bool word = false; // we are not in a word currently
      for (int j=0; j<cn; ) {
         U8_NEXT(cs, j, cn, c);

         if (c == (UChar32)'\n')
            throw StriException(MSG__NEWLINE_FOUND);

         UBool isLetter = u_isUAlphabetic(c); // u_hasBinaryProperty(c, UCHAR_ALPHABETIC)
         UBool isNumber = u_isdigit(c); // U_DECIMAL_DIGIT_NUMBER    Nd

         switch(state) {
            case stStandard:
               if (c == (UChar32)'\\') {
                  state = stControlSequence;
                  ++stats[lsCharsCmdEnvir];

                  if (j < cn) {
                     // Look Ahead:
                     UChar32 cnext;
                     int jnext = j;
                     U8_NEXT(cs, jnext, cn, cnext);
                     UBool isPunctNext = u_ispunct(cnext);

                     if (!isPunctNext || cnext == (UChar32)'~' || cnext == (UChar32)'^') {
                        // this is to avoid counting words like K\"ahler as two words
                        word = false;
                     }
                  }
               }
               else if (c == (UChar32)'%') {
                  state = stComment;
               }
               else {
                  if (isLetter || isNumber) {
                     // only start new word if first character is a letter
                     // (42test is still counted as a word, but 42.2 not)
                     if (isLetter && !word) {
                        word = true;
                        ++stats[lsWords];
                     }
                     ++stats[lsCharsWord];
                  }
                  else {
                     ++stats[lsCharsWhite];
                     word = false;
                  }
              }
              break; // stStandard

            case stControlSequence:
              if (isLetter) {
                  // "\begin{[a-zA-z]+}" is an environment, and you can't define a command like \begin
                  if (c == (UChar32)'b' && !strncmp(cs+j, "egin", 4) /* plain ASCII compare - it's OK */) {
                     ++stats[lsEnvir];
                     state = stEnvironment;
                     stats[lsCharsCmdEnvir] +=5;
                     j += 4;
                  }
                  else if (c == (UChar32)'e' && !strncmp(cs+j, "nd", 2) /* plain ASCII compare - it's OK */) {
                     stats[lsCharsCmdEnvir] +=3;
                     state = stEnvironment;
                     j += 2;
                  } // we don't count \end as new environment, this can give wrong results in selections
                  else {
                     ++stats[lsCmd];
                     ++stats[lsCharsCmdEnvir];
                     state = stCommand;
                  }
               }
               else {
                  // MG: This will also prevent counting \% as a comment (it's a percent sign)
                  ++stats[lsCmd];
                  ++stats[lsCharsCmdEnvir];
                  state = stStandard;
               }
               break;

            case stCommand :
               if(isLetter) {
                  ++stats[lsCharsCmdEnvir];
               }
               else if(c == (UChar32)'\\') {
                  ++stats[lsCharsCmdEnvir];
                  state = stControlSequence;
               }
               else if(c == (UChar32)'%') {
                  state = stComment;
               }
               else {
                  ++stats[lsCharsWhite];
                  state = stStandard;
               }
            break;

            case stEnvironment :
               if(c == (UChar32)'}') { // until we find a closing } we have an environment
                  ++stats[lsCharsCmdEnvir];
                  state = stStandard;
               }
               else if(c == (UChar32)'%') {
                  state = stComment;
               }
               else {
                  ++stats[lsCharsCmdEnvir];
               }
            break;

            case stComment:
               // ignore until the end - any newline will be detected
               // and the error will be thrown
            break;

            default:
               throw StriException("DEBUG: stri_stats_latex() - this shouldn't happen :-(");
         }
     }
   }

   stri__set_names(ret, lsAll, "CharsWord", "CharsCmdEnvir", "CharsWhite",
      "Words", "Cmds", "Envirs");
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
