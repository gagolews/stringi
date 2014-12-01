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


#ifndef __stri_ucnv_h
#define __stri_ucnv_h


#include <unicode/ucnv.h>
#include <string>
#include <vector>

/**
 * A class to manage an encoding converter
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 */
class StriUcnv  {

   private:

      UConverter* m_ucnv; // converter
      const char* m_name; // encoding, owned by caller
      int m_isutf8;
      int m_is8bit;

      static void STRI__UCNV_FROM_U_CALLBACK_SUBSTITUTE_WARN (
                  const void* context,
                  UConverterFromUnicodeArgs* fromArgs,
                  const UChar* codeUnits,
                  int32_t length,
                  UChar32 codePoint,
                  UConverterCallbackReason reason,
                  UErrorCode* err);

      static void STRI__UCNV_TO_U_CALLBACK_SUBSTITUTE_WARN (
                 const void* context,
                 UConverterToUnicodeArgs* toArgs,
                 const char* codeUnits,
                 int32_t length,
                 UConverterCallbackReason reason,
                 UErrorCode* err);

      void openConverter(bool register_callbacks);

   public:


      StriUcnv(const char* name=NULL) {
         m_name = name;
         m_ucnv = NULL; // lazy
         m_isutf8 = NA_LOGICAL;
         m_is8bit = NA_LOGICAL;
      }

      ~StriUcnv()
      {
         if (m_ucnv)
            ucnv_close(m_ucnv);
         m_ucnv = NULL;
      }


      StriUcnv(const StriUcnv& obj) {
         m_name = obj.m_name;
         m_ucnv = NULL;
         m_isutf8 = NA_LOGICAL;
         m_is8bit = NA_LOGICAL;
      }


      StriUcnv& operator=(const StriUcnv& obj) {
         this->~StriUcnv();
         m_name = obj.m_name;
         m_ucnv = NULL;
         m_isutf8 = NA_LOGICAL;
         m_is8bit = NA_LOGICAL;
         return *this;
      }


      bool isUTF8() {
         if (m_isutf8 != NA_LOGICAL) return m_isutf8;

         openConverter(false);
         UErrorCode status = U_ZERO_ERROR;
         // get "offical" encoder name
         const char* ucnv_name = ucnv_getName(m_ucnv, &status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
         m_isutf8 = !strcmp(ucnv_name, "UTF-8");
         return m_isutf8;
      }


      bool is8bit() {
         if (m_is8bit != NA_LOGICAL) return m_is8bit;

         openConverter(false);
         m_is8bit = (ucnv_getMaxCharSize(m_ucnv) == 1);
         return m_is8bit;
      }


      UConverter* getConverter(bool register_callbacks=false);

      bool hasASCIIsubset();
      bool is1to1Unicode();

      static vector<const char*> getStandards();
      static const char* getFriendlyName(const char* canname);


//      /** restores default ICU's substitute callbacks
//       */
//      void setCallBackSubstitute() {
//         openConverter();
//
//         UErrorCode status = U_ZERO_ERROR;
//         ucnv_setFromUCallBack(m_ucnv, UCNV_FROM_U_CALLBACK_SUBSTITUTE, NULL, NULL, NULL, &status);
//         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
//
//         status = U_ZERO_ERROR;
//         ucnv_setToUCallBack(m_ucnv, UCNV_TO_U_CALLBACK_SUBSTITUTE,   NULL, NULL, NULL, &status);
//         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
//      }

      /**
       * get R's cetype_t corresponding to this converter
       */
      cetype_t getCE() {
         openConverter(false);
         UErrorCode status = U_ZERO_ERROR;
         const char* ucnv_name = ucnv_getName(m_ucnv, &status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

         if (!strcmp(ucnv_name, "US-ASCII")) {
            m_is8bit = true;
            m_isutf8 = true;
            return CE_UTF8;
         }
         else if (!strcmp(ucnv_name, "UTF-8")) {
            m_isutf8 = true;
            m_is8bit = false;
            return CE_UTF8;
         }
         else if (!strcmp(ucnv_name, "ISO-8859-1")) {
            m_is8bit = true;
            m_isutf8 = false;
            return CE_LATIN1;
         }
         else if (!strcmp(ucnv_name, ucnv_getDefaultName()))
            return CE_NATIVE;

         return CE_BYTES;
      }
};

#endif
