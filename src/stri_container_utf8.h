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


#ifndef __stri_container_utf8_h
#define __stri_container_utf8_h





/**
 * A class to handle conversion between R character vectors and UTF-8 string vectors
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) Improved performance for Native enc->UTF-8 (through u_strToUTF8)
 * @version 0.3 (Marek Gagolewski, 2013-06-01) Now NAs are marked as NULLs in str
 * @version 0.4 (Marek Gagolewski, 2013-06-01) UChar32_to_UTF8_index_back, UChar32_to_UTF8_index_fwd added
 */
class StriContainerUTF8 : public StriContainerBase {

   private:

      String8** str;  ///< data - \code{string}s


      // the following are used in UChar32_to_UTF8_index_back
      // and UChar32_to_UTF8_index_fwd to speed up computations
      // on the same strings
      R_len_t last_ind_fwd_codepoint;
      R_len_t last_ind_fwd_utf8;
      const char* last_ind_fwd_str;
      R_len_t last_ind_back_codepoint;
      R_len_t last_ind_back_utf8;
      const char* last_ind_back_str;


   public:

      StriContainerUTF8();
      StriContainerUTF8(SEXP rstr, R_len_t nrecycle, bool shallowrecycle=true);
      StriContainerUTF8(StriContainerUTF8& container);
      ~StriContainerUTF8();
      StriContainerUTF8& operator=(StriContainerUTF8& container);
      SEXP toR(R_len_t i) const;
      SEXP toR() const;


      /** check if the vectorized ith element is NA
       * @param i index
       * @return true if is NA
       */
      inline bool isNA(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerUTF8::isNA(): INDEX OUT OF BOUNDS");
#endif
         return (str[i%n] == NULL);
      }


      /** get the vectorized ith element
       * @param i index
       * @return string, read only
       */
      const String8& get(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerUTF8::get(): INDEX OUT OF BOUNDS");
         if (str[i%n] == NULL)
            throw StriException("StriContainerUTF8::get(): isNA");
#endif
         return (*(str[i%n]));
      }


      void UTF8_to_UChar32_index(R_len_t i, int* i1, int* i2, const int ni, int adj1, int adj2);
      R_len_t UChar32_to_UTF8_index_back(R_len_t i, R_len_t wh);
      R_len_t UChar32_to_UTF8_index_fwd(R_len_t i, R_len_t wh);
};

#endif
