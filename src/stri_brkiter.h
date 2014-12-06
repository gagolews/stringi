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


#ifndef __stri_brkiter_h
#define __stri_brkiter_h

#include <deque>
#include <utility>
#include <vector>
#include <unicode/brkiter.h>
#include <unicode/uloc.h>
#include <unicode/locid.h>


/**
 * A class to manage a break iterator's options
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 */
class StriBrkIterOptions {
   protected:

      const char* locale; // R_alloc'd
      UBreakIteratorType type;
      int32_t* skip_rules; // R_alloc'd
      R_len_t  skip_size; // number of elements in skip_rules


   private:

      void setEmptyOpts() {
         locale = NULL;
         type = UBRK_COUNT;
         skip_rules = NULL;
         skip_size = 0;
      }

      void setType(SEXP opts_brkiter, const char* default_type);
      void setLocale(SEXP opts_brkiter);
      void setSkipRuleStatus(SEXP opts_brkiter);


   public:


      StriBrkIterOptions() {
         setEmptyOpts();
      }

      StriBrkIterOptions(SEXP opts_brkiter, const char* default_type) {
         setEmptyOpts();
         setLocale(opts_brkiter);
         setSkipRuleStatus(opts_brkiter);
         setType(opts_brkiter, default_type);
      }
};


/**
 * A class to manage a break iterator
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-30)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 * separate class
 */
class StriUBreakIterator : public StriBrkIterOptions {
   private:

      UBreakIterator* uiterator;

      void open() {
#ifndef NDEBUG
         if (uiterator) throw StriException("!NDEBUG: StriUBreakIterator::open()");
#endif
         UErrorCode status = U_ZERO_ERROR;
         switch (type) {
            case UBRK_CHARACTER: // character [this is not documented]
               uiterator = ubrk_open(UBRK_CHARACTER, locale, NULL, 0, &status);
               break;
            case UBRK_LINE: // line_break [this is not documented]
               uiterator = ubrk_open(UBRK_LINE, locale, NULL, 0, &status);
               break;
            case UBRK_SENTENCE: // sentence
               uiterator = ubrk_open(UBRK_SENTENCE, locale, NULL, 0, &status);
               break;
            case UBRK_WORD: // word
               uiterator = ubrk_open(UBRK_WORD, locale, NULL, 0, &status);
               break;
            case UBRK_COUNT:
            default:
               throw StriException(MSG__INTERNAL_ERROR);
         }
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }


   public:

      StriUBreakIterator()
         : StriBrkIterOptions() {
         uiterator = NULL;
      }

      StriUBreakIterator(const StriBrkIterOptions& bropt)
         : StriBrkIterOptions(bropt) {
         uiterator = NULL;
      }

      StriUBreakIterator& operator=(const StriBrkIterOptions& bropt) {
         this->~StriUBreakIterator();
         (StriBrkIterOptions&) (*this) = (StriBrkIterOptions&)bropt;
         uiterator = NULL;
         return *this;
      }

      ~StriUBreakIterator() {
         if (uiterator) {
            ubrk_close(uiterator);
            uiterator = NULL;
         }
      }

      void free(bool dealloc=true) {
         if (uiterator && dealloc) {
            ubrk_close(uiterator);
         }
         uiterator = NULL;
      }


      UBreakIterator* getIterator() {
         if (!uiterator) open();
         return uiterator;
      }


      const char* getLocale() {
         return locale;
      }
};


/**
 * A class to manage a break iterator
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-30)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 * separate class
 */
class StriRuleBasedBreakIterator : public StriBrkIterOptions {
   private:

      RuleBasedBreakIterator* rbiterator;
      UText* searchText;
      R_len_t searchPos; // may be BreakIterator::DONE
      const char* searchStr; // owned by caller
      R_len_t searchLen; // in bytes

      void setEmptyOpts() {
         rbiterator = NULL;
         searchText = NULL;
         searchPos = BreakIterator::DONE;
         searchStr = NULL;
         searchLen = 0;
      }

      void open() {
         UErrorCode status = U_ZERO_ERROR;
         Locale loc = Locale::createFromName(locale);
         switch (type) {
            case UBRK_CHARACTER: // character
               rbiterator = (RuleBasedBreakIterator*)BreakIterator::createCharacterInstance(loc, status);
               break;
            case UBRK_LINE: // line_break
               rbiterator = (RuleBasedBreakIterator*)BreakIterator::createLineInstance(loc, status);
               break;
            case UBRK_SENTENCE: // sentence
               rbiterator = (RuleBasedBreakIterator*)BreakIterator::createSentenceInstance(loc, status);
               break;
            case UBRK_WORD: // word
               rbiterator = (RuleBasedBreakIterator*)BreakIterator::createWordInstance(loc, status);
               break;
            case UBRK_COUNT:
            default:
               throw StriException(MSG__INTERNAL_ERROR);
         }
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }

      bool ignoreBoundary();

   public:

      StriRuleBasedBreakIterator()
         : StriBrkIterOptions() {
         setEmptyOpts();
      }

      StriRuleBasedBreakIterator(const StriBrkIterOptions& bropt)
         : StriBrkIterOptions(bropt) {
         setEmptyOpts();
      }

      StriRuleBasedBreakIterator& operator=(const StriBrkIterOptions& bropt) {
         this->~StriRuleBasedBreakIterator();
         (StriBrkIterOptions&) (*this) = (StriBrkIterOptions&)bropt;
         setEmptyOpts();
         return *this;
      }

      ~StriRuleBasedBreakIterator() {
         if (rbiterator) {
            delete rbiterator;
            rbiterator = NULL;
         }

         if (searchText) {
            utext_close(searchText);
            searchText = NULL;
         }
      }

      void setupMatcher(const char* searchStr, R_len_t searchLen);

      void first();
      bool next();
      bool next(std::pair<R_len_t, R_len_t>& bdr);

      void last();
      bool previous(std::pair<R_len_t, R_len_t>& bdr);
};

#endif
