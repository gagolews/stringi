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
#include "stri_container_utf8.h"

/**
 * General statistics for a character vector
 *
 * @param str a character vector
 * @return integer vector, see R man for details
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-09)
 *                Use StriContainerUTF8
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *                make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-01)
 *                detect invalid UTF-8 byte streams
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_stats_general(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   R_len_t str_length = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN(1)
   StriContainerUTF8 str_cont(str, str_length);

   enum {
      gsNumLines = 0,
      gsNumLinesNonEmpty = 1,
      gsNumChars = 2,
      gsNumCharsNonWhite = 3,
      gsAll = 4 // always == number of elements
   };

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(INTSXP, gsAll));
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
         if (c < 0)
            throw StriException(MSG__INVALID_UTF8);
         // @TODO: follow Unicode Newline Guidelines - Unicode Technical Report #13
         else if (c == (UChar32)'\n' || c == (UChar32)'\r') {
            throw StriException(MSG__NEWLINE_FOUND);
         }
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
   STRI__UNPROTECT_ALL
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
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-09)
 *          Use StriContainerUTF8
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-01)
 *                detect invalid UTF-8 byte streams
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_stats_latex(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   R_len_t str_length = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN(1)
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
   STRI__PROTECT(ret = Rf_allocVector(INTSXP, lsAll));
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

         if (c < 0)
            throw StriException(MSG__INVALID_UTF8);
         // @TODO: follow Unicode Newline Guidelines - Unicode Technical Report #13
         else if (c == (UChar32)'\n' || c == (UChar32)'\r') {
            throw StriException(MSG__NEWLINE_FOUND);
         }

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
                     // only start a new word if first character is a letter
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
                  } // we don't count \end as a new environment, this can give wrong results in selections
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
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
