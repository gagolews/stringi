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


/** Check if a string is valid ASCII
 * 
 *  simple check whether charcodes are in [1..127]
 * by using U8_IS_SINGLE
 * 
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or to exact check
 * 
 * @return confidence value or 0/1
 * 
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-08-06) separate func
 */
R_len_t stri__enc_check_ascii(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence) {
   for (R_len_t j=0; j < str_cur_n; ++j) {
      if (!U8_IS_SINGLE(str_cur_s[j])) { // i.e. <= 127
         return 0;
      }
   }
   return (get_confidence?100:1);
}



/** Check if a string is valid UTF-8
 * 
 * checks if a string is probably UTF-8-encoded; 
 * simple check with U8_NEXT
 *
 * 
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or to exact check
 * 
 * @return confidence value or 0/1
 * 
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-08-06) separate func
 */
R_len_t stri__enc_check_utf8(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   UChar32 c;
   for (R_len_t j=0; j < str_cur_n; ) {
      U8_NEXT(str_cur_s, j, str_cur_n, c);
      if (c < 0) { // ICU utf8.h doc for U8_NEXT: c -> output UChar32 variable, set to <0 in case of an error
         return 0; // definitely not valid UTF-8
      }
   }
   return (get_confidence?100:1);
}


/** Check if a string is valid UTF-16BE
 * 
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or to exact check
 * 
 * @return confidence value or 0/1
 * 
 * @version 0.1 (Marek Gagolewski, 2013-08-09)
 */
R_len_t stri__enc_check_utf16be(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   throw StriException("TO DO");
   return 0;
}


/** Check if a string is valid UTF-16LE
 * 
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or to exact check
 * 
 * @return confidence value or 0/1
 * 
 * @version 0.1 (Marek Gagolewski, 2013-08-09)
 */
R_len_t stri__enc_check_utf16le(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   throw StriException("TO DO");
   return 0;
}


/** Check if a string is valid UTF-32BE
 * 
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or to exact check
 * 
 * @return confidence value or 0/1
 * 
 * @version 0.1 (Marek Gagolewski, 2013-08-09)
 */
R_len_t stri__enc_check_utf32be(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   throw StriException("TO DO");
   return 0;
}



/** Check if a string is valid UTF-32LE
 * 
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or to exact check
 * 
 * @return confidence value or 0/1
 * 
 * @version 0.1 (Marek Gagolewski, 2013-08-09)
 */
R_len_t stri__enc_check_utf32le(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   throw StriException("TO DO");
   return 0;
}




/** Which string is in given encoding
 *
 *
 *  @param str character vector or raw vector or list of raw vectors
 *  @param type (single integer, internal)
 *  @return logical vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-08-08) use StriContainerListRaw
 * @version 0.3 (Marek Gagolewski, 2013-08-09) one function for is_*, do dispatch
 */
SEXP stri_enc_isenc(SEXP str, SEXP type)
{
   if (!Rf_isInteger(type) || LENGTH(type) != 1)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG); // this is an internal arg, check manually, error() allowed here
   int _type = INTEGER(type)[0];
   int (*isenc)(const char*, R_len_t, bool) = NULL;
   switch (_type) {
      case 1:  isenc = stri__enc_check_ascii;   break;
      case 2:  isenc = stri__enc_check_utf8;    break;
      case 3:  isenc = stri__enc_check_utf16be; break;
      case 4:  isenc = stri__enc_check_utf16le; break;
      case 5:  isenc = stri__enc_check_utf32be; break;
      case 6:  isenc = stri__enc_check_utf32le; break;
      default: Rf_error(MSG__INCORRECT_INTERNAL_ARG); // error() call allowed here
   }
   

   str = stri_prepare_arg_list_raw(str, "str");
   
   STRI__ERROR_HANDLER_BEGIN
   StriContainerListRaw str_cont(str);
   R_len_t str_length = str_cont.get_n();

   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, str_length));
   int* ret_tab = LOGICAL(ret); // may be faster than LOGICAL(ret)[i] all the time

   for (R_len_t i=0; i < str_length; ++i) {
      if (str_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }
      
      bool get_confidence = false; // TO BE DONE
      ret_tab[i] = isenc(str_cont.get(i).c_str(), str_cont.get(i).length(), get_confidence);
   }

   UNPROTECT(1);
   return ret;
   
   STRI__ERROR_HANDLER_END({ /* no-op on error */ })
}


/** Detect encoding and language
 * 
 * @param str character vector
 * @param filter_angle_brackets logical vector
 * 
 * @return list
 * 
 * @version 0.1 (Marek Gagolewski, 2013-08-03) 
 * @version 0.2 (Marek Gagolewski, 2013-08-08) use StriContainerListRaw + BUGFIX 
 */
SEXP stri_enc_detect(SEXP str, SEXP filter_angle_brackets)
{
   str = stri_prepare_arg_list_raw(str, "str");
   filter_angle_brackets = stri_prepare_arg_logical(filter_angle_brackets, "filter_angle_brackets");
   
   UCharsetDetector* ucsdet = NULL;   
   
   
   STRI__ERROR_HANDLER_BEGIN
   
   UErrorCode status = U_ZERO_ERROR;
   ucsdet = ucsdet_open(&status);
   if (U_FAILURE(status)) throw StriException(status);
   
   StriContainerListRaw str_cont(str);
   R_len_t str_n = str_cont.get_n();
   
   R_len_t vectorize_length = stri__recycling_rule(true, 2, str_n, LENGTH(filter_angle_brackets));
   str_cont.set_nrecycle(vectorize_length); // must be set after container creation
   
   SEXP ret, names, wrong;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));
   
   PROTECT(names = Rf_allocVector(STRSXP, 3));
   SET_STRING_ELT(names, 0, Rf_mkChar("Encoding"));
   SET_STRING_ELT(names, 1, Rf_mkChar("Language"));
   SET_STRING_ELT(names, 2, Rf_mkChar("Confidence"));
   
   PROTECT(wrong = Rf_allocVector(VECSXP, 3));
   SET_VECTOR_ELT(wrong, 0, stri__vector_NA_strings(1));
   SET_VECTOR_ELT(wrong, 1, stri__vector_NA_strings(1));
   SET_VECTOR_ELT(wrong, 2, stri__vector_NA_integers(1));
   Rf_setAttrib(wrong, R_NamesSymbol, names);

   StriContainerLogical filter(filter_angle_brackets, vectorize_length);
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (str_cont.isNA(i) || filter.isNA(i)) {
         SET_VECTOR_ELT(ret, i, wrong);
         continue;
      }
      
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t str_cur_n     = str_cont.get(i).length();
      
      status = U_ZERO_ERROR;
      ucsdet_setText(ucsdet, str_cur_s, str_cur_n, &status);
		if (U_FAILURE(status)) throw StriException(status);
      ucsdet_enableInputFilter(ucsdet, filter.get(i));
      
      status = U_ZERO_ERROR;
      const UCharsetMatch* match = ucsdet_detect(ucsdet, &status);
		if (U_FAILURE(status) || !match) {
         SET_VECTOR_ELT(ret, i, wrong);
         continue;
		}
      
      SEXP val;
      PROTECT(val = Rf_allocVector(VECSXP, 3));
      
      status = U_ZERO_ERROR;
      const char* name = ucsdet_getName(match, &status);
      if (U_FAILURE(status))
         SET_VECTOR_ELT(val, 0, stri__vector_NA_strings(1));
      else
         SET_VECTOR_ELT(val, 0, Rf_mkString(name));
      
      status = U_ZERO_ERROR;
 	   int32_t conf = ucsdet_getConfidence(match, &status);
      if (U_FAILURE(status))
         SET_VECTOR_ELT(val, 2, stri__vector_NA_integers(1));
      else
         SET_VECTOR_ELT(val, 2, Rf_ScalarInteger(conf));
      
      status = U_ZERO_ERROR;
 	   const char* lang = ucsdet_getLanguage(match, &status);
      if (U_FAILURE(status))
         SET_VECTOR_ELT(val, 1, stri__vector_NA_strings(1));
      else
         SET_VECTOR_ELT(val, 1, Rf_mkString(lang));
      
      Rf_setAttrib(val, R_NamesSymbol, names);
      SET_VECTOR_ELT(ret, i, val);
      UNPROTECT(1);
   }
   
   if (ucsdet) {
      ucsdet_close(ucsdet);
      ucsdet = NULL;  
   }
   UNPROTECT(3);
   return ret;

   STRI__ERROR_HANDLER_END(
      if (ucsdet) {
         ucsdet_close(ucsdet);
         ucsdet = NULL;  
      })
}


/** Detect encoding
 * 
 * @param str character vector
 * @param encodings character vector
 * @param characters character vector
 * 
 * @return list
 * 
 * @version 0.1 (2013-08-07) Marek Gagolewski
 */
SEXP stri_enc_detect2(SEXP str, SEXP encodings, SEXP characters)
{
   Rf_error("TO DO");
   return R_NilValue;
}


// i18n/csrucode.cpp

//CharsetRecog_Unicode::~CharsetRecog_Unicode()
//{
//    // nothing to do
//}
//
//CharsetRecog_UTF_16_BE::~CharsetRecog_UTF_16_BE()
//{
//    // nothing to do
//}
//
//const char *CharsetRecog_UTF_16_BE::getName() const
//{
//    return "UTF-16BE";
//}
//
//UBool CharsetRecog_UTF_16_BE::match(InputText* textIn, CharsetMatch *results) const
//{
//    const uint8_t *input = textIn->fRawInput;
//    int32_t confidence = 0;
//
//    if (input[0] == 0xFE && input[1] == 0xFF) {
//        confidence = 100;
//    }
//
//    // TODO: Do some statastics to check for unsigned UTF-16BE
//    results->set(textIn, this, confidence);
//    return (confidence > 0);
//}
//
//CharsetRecog_UTF_16_LE::~CharsetRecog_UTF_16_LE()
//{
//    // nothing to do
//}
//
//const char *CharsetRecog_UTF_16_LE::getName() const
//{
//    return "UTF-16LE";
//}
//
//UBool CharsetRecog_UTF_16_LE::match(InputText* textIn, CharsetMatch *results) const
//{
//    const uint8_t *input = textIn->fRawInput;
//    int32_t confidence = 0;
//
//    if (input[0] == 0xFF && input[1] == 0xFE && (input[2] != 0x00 || input[3] != 0x00)) {
//        confidence = 100;
//    }
//
//    // TODO: Do some statastics to check for unsigned UTF-16LE
//    results->set(textIn, this, confidence);
//    return (confidence > 0);
//}
//
//CharsetRecog_UTF_32::~CharsetRecog_UTF_32()
//{
//    // nothing to do
//}
//
//UBool CharsetRecog_UTF_32::match(InputText* textIn, CharsetMatch *results) const
//{
//    const uint8_t *input = textIn->fRawInput;
//    int32_t limit = (textIn->fRawLength / 4) * 4;
//    int32_t numValid = 0;
//    int32_t numInvalid = 0;
//    bool hasBOM = FALSE;
//    int32_t confidence = 0;
//
//    if (getChar(input, 0) == 0x0000FEFFUL) {
//        hasBOM = TRUE;
//    }
//
//    for(int32_t i = 0; i < limit; i += 4) {
//        int32_t ch = getChar(input, i);
//
//        if (ch < 0 || ch >= 0x10FFFF || (ch >= 0xD800 && ch <= 0xDFFF)) {
//            numInvalid += 1;
//        } else {
//            numValid += 1;
//        }
//    }
//
//
//    // Cook up some sort of confidence score, based on presense of a BOM
//    //    and the existence of valid and/or invalid multi-byte sequences.
//    if (hasBOM && numInvalid==0) {
//        confidence = 100;
//    } else if (hasBOM && numValid > numInvalid*10) {
//        confidence = 80;
//    } else if (numValid > 3 && numInvalid == 0) {
//        confidence = 100;            
//    } else if (numValid > 0 && numInvalid == 0) {
//        confidence = 80;
//    } else if (numValid > numInvalid*10) {
//        // Probably corruput UTF-32BE data.  Valid sequences aren't likely by chance.
//        confidence = 25;
//    }
//
//    results->set(textIn, this, confidence);
//    return (confidence > 0);
//}
//
//CharsetRecog_UTF_32_BE::~CharsetRecog_UTF_32_BE()
//{
//    // nothing to do
//}
//
//const char *CharsetRecog_UTF_32_BE::getName() const
//{
//    return "UTF-32BE";
//}
//
//int32_t CharsetRecog_UTF_32_BE::getChar(const uint8_t *input, int32_t index) const
//{
//    return input[index + 0] << 24 | input[index + 1] << 16 |
//           input[index + 2] <<  8 | input[index + 3];
//} 
//
//CharsetRecog_UTF_32_LE::~CharsetRecog_UTF_32_LE()
//{
//    // nothing to do
//}
//
//const char *CharsetRecog_UTF_32_LE::getName() const
//{
//    return "UTF-32LE";
//}
//
//int32_t CharsetRecog_UTF_32_LE::getChar(const uint8_t *input, int32_t index) const
//{
//    return input[index + 3] << 24 | input[index + 2] << 16 |
//           input[index + 1] <<  8 | input[index + 0];
//}


// i18n/csrutf8.cpp

//UBool CharsetRecog_UTF8::match(InputText* input, CharsetMatch *results) const {
//    bool hasBOM = FALSE;
//    int32_t numValid = 0;
//    int32_t numInvalid = 0;
//    const uint8_t *inputBytes = input->fRawInput;
//    int32_t i;
//    int32_t trailBytes = 0;
//    int32_t confidence;
//
//    if (input->fRawLength >= 3 && 
//        inputBytes[0] == 0xEF && inputBytes[1] == 0xBB && inputBytes[2] == 0xBF) {
//            hasBOM = TRUE;
//    }
//
//    // Scan for multi-byte sequences
//    for (i=0; i < input->fRawLength; i += 1) {
//        int32_t b = inputBytes[i];
//
//        if ((b & 0x80) == 0) {
//            continue;   // ASCII
//        }
//
//        // Hi bit on char found.  Figure out how long the sequence should be
//        if ((b & 0x0E0) == 0x0C0) {
//            trailBytes = 1;
//        } else if ((b & 0x0F0) == 0x0E0) {
//            trailBytes = 2;
//        } else if ((b & 0x0F8) == 0xF0) {
//            trailBytes = 3;
//        } else {
//            numInvalid += 1;
//
//            if (numInvalid > 5) {
//                break;
//            }
//
//            trailBytes = 0;
//        }
//
//        // Verify that we've got the right number of trail bytes in the sequence
//        for (;;) {
//            i += 1;
//
//            if (i >= input->fRawLength) {
//                break;
//            }
//
//            b = inputBytes[i];
//
//            if ((b & 0xC0) != 0x080) {
//                numInvalid += 1;
//                break;
//            }
//
//            if (--trailBytes == 0) {
//                numValid += 1;
//                break;
//            }
//        }
//
//    }
//
//    // Cook up some sort of confidence score, based on presense of a BOM
//    //    and the existence of valid and/or invalid multi-byte sequences.
//    confidence = 0;
//    if (hasBOM && numInvalid == 0) {
//        confidence = 100;
//    } else if (hasBOM && numValid > numInvalid*10) {
//        confidence = 80;
//    } else if (numValid > 3 && numInvalid == 0) {
//        confidence = 100;
//    } else if (numValid > 0 && numInvalid == 0) {
//        confidence = 80;
//    } else if (numValid == 0 && numInvalid == 0) {
//        // Plain ASCII.
//        confidence = 10;
//    } else if (numValid > numInvalid*10) {
//        // Probably corruput utf-8 data.  Valid sequences aren't likely by chance.
//        confidence = 25;
//    }
//
//    results->set(input, this, confidence);
//    return (confidence > 0);
//}


