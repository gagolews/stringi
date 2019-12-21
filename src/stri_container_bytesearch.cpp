/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2019, Marek Gagolewski and other contributors.
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
#include "stri_container_bytesearch.h"
#include <unicode/usearch.h>


/**
 * Default constructor
 *
 */
StriContainerByteSearch::StriContainerByteSearch()
   : StriContainerUTF8()
{
   this->matcher = NULL;
   this->flags = 0;
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 * @param _nrecycle extend length [vectorization]
 */
StriContainerByteSearch::StriContainerByteSearch(SEXP rstr, R_len_t _nrecycle, uint32_t _flags)
   : StriContainerUTF8(rstr, _nrecycle, true)
{
   this->flags = _flags;
   this->matcher = NULL;

   R_len_t n = get_n();
   for (R_len_t i=0; i<n; ++i) {
      if (!isNA(i) && get(i).length() <= 0) {
         Rf_warning(MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED);
      }
   }
}


/** Copying constructor
 *
 */
StriContainerByteSearch::StriContainerByteSearch(StriContainerByteSearch& container)
   :    StriContainerUTF8((StriContainerUTF8&)container)
{
   this->matcher = NULL;
   this->flags = container.flags;
}


/** Copy operator
 * @param container source
 * @return *this
 */
StriContainerByteSearch& StriContainerByteSearch::operator=(StriContainerByteSearch& container)
{
   this->~StriContainerByteSearch();
   (StriContainerUTF8&) (*this) = (StriContainerUTF8&)container;
   return *this;
}


/** Destructor
 *
 */
StriContainerByteSearch::~StriContainerByteSearch()
{
   if (matcher) {
      delete matcher;
      matcher = NULL;
   }
}


/**
 * @version 0.5-1 (Marek Gagolewski, 2015-02-14)
 */
StriByteSearchMatcher* StriContainerByteSearch::getMatcher(R_len_t i) {
   if (i >= n && matcher && matcher->getPatternStr() == get(i).c_str()) {
      // matcher reuse
   }
   else {
      if (matcher) {
         delete matcher;
         matcher = NULL;
      }

      if (isCaseInsensitive())
         matcher = new StriByteSearchMatcherKMPci(get(i).c_str(), get(i).length(), isOverlap());
      else if (get(i).length() == 1)
         matcher = new StriByteSearchMatcher1(get(i).c_str(), get(i).length(), isOverlap());
      else if (get(i).length() < 16)
         matcher = new StriByteSearchMatcherShort(get(i).c_str(), get(i).length(), isOverlap());
      else
         matcher = new StriByteSearchMatcherKMP(get(i).c_str(), get(i).length(), isOverlap());
   }

   return matcher;
}


/** find first match - case of short pattern
 *
 * @param startPos where to start
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *          special procedure for patternLen <= 4
 *
 * @version 0.2-4 (Marek Gagolewski, 2014-05-15)
 *          BUGFIX: load of misaligned adresses
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-30)
 *          BUGFIX: ret USEARCH_DONE immediately if startPos is too far away
 */
//R_len_t StriContainerByteSearch::findFromPosFwd_short(R_len_t startPos)
//{
//   if (startPos > searchLen-patternLen) { // this check is OK, we do a case-sensitive search
//      searchPos = searchEnd = searchLen;
//      return USEARCH_DONE;
//   }
//
//   if (patternLen == 1) {
//         // else not found
//      unsigned char pat = (unsigned char)patternStr[0];  /* TO DO: why can't this be cached? */
//      for (searchPos = startPos; searchPos<searchLen-1+1; ++searchPos) {
//         if (pat == (unsigned char)searchStr[searchPos]) {
//            searchEnd = searchPos + 1;
//            return searchPos;
//         }
//      }
//   }
//   else if (patternLen == 2) {
//// /* v1: 17.67ms; BUG: loads misaligned addresses... */
////      uint16_t pat = *((uint16_t*)patternStr);
////      for (searchPos = startPos; searchPos<searchLen-2+1; ++searchPos) {
////         if (pat == *((uint16_t*)(searchStr+searchPos))) {
////            return searchPos;
////         }
////      }
//
///* v2: 21.62 ms */
//      // be careful: little vs big endian!
//      uint16_t pat  = ((uint16_t)((unsigned char)patternStr[0]));  /* TO DO: why can't this be cached? */
//               pat <<= 8;
//               pat |= ((uint16_t)((unsigned char)patternStr[1]));
//      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
//      uint16_t cur  = ((uint16_t)(*curstr));
//      ++curstr;
//      for (searchPos = startPos; searchPos<searchLen-2+1; ++searchPos) {
//         cur <<= 8;
//         cur |= (uint16_t)(*curstr);
//         ++curstr;
//         if (pat == cur) {
//            searchEnd = searchPos + 2;
//            return searchPos;
//         }
//      }
//   }
//   else if (patternLen == 3) {
//// /* v1: 25.52ms; BUG: loads misaligned addresses... */
////      uint8_t  pat1 = (uint8_t)patternStr[0];
////      uint16_t pat2 = *((uint16_t*)(patternStr+1));
////      for (searchPos = startPos; searchPos<searchLen-3+1; ++searchPos) {
////         if (pat1 == (uint8_t)searchStr[searchPos]
////             && pat2 == *((uint16_t*)(searchStr+searchPos+1))) {
////            return searchPos;
////         }
////      }
//
///* v2: 25.95 ms */
//      uint32_t pat  = ((uint32_t)((unsigned char)patternStr[0])); /* TO DO: why can't this be cached? */
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[1]));
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[2]));
//
//      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
//      uint32_t cur  = ((uint32_t)(*curstr));
//      ++curstr;
//      cur <<= 8;
//      cur |= (uint32_t)(*curstr);
//      ++curstr;
//
//      uint32_t mask = ~(((unsigned char)0xff)<<24);  /* TO DO: why can't this be cached? */
//
//      for (searchPos = startPos; searchPos<searchLen-3+1; ++searchPos) {
//         cur <<= 8;
//         cur |= (uint32_t)(*curstr);
//         ++curstr;
//         if ((pat&mask) == (cur&mask)) {
//            searchEnd = searchPos + 3;
//            return searchPos;
//         }
//      }
//   }
//   else if (patternLen == 4) {
//// /* v1: 17.71ms; BUG: loads misaligned addresses... */
////      uint32_t pat = *((uint32_t*)patternStr);
////      for (searchPos = startPos; searchPos<searchLen-4+1; ++searchPos) {
////         if (pat == *((uint32_t*)(searchStr+searchPos))) {
////            return searchPos;
////         }
////      }
//
///* v2: 21.68 ms */
//      uint32_t pat  = ((uint32_t)((unsigned char)patternStr[0])); /* TO DO: why can't this be cached? */
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[1]));
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[2]));
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[3]));
//
//      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
//      uint32_t cur  = ((uint32_t)(*curstr));
//      ++curstr;
//      cur <<= 8;
//      cur |= (uint32_t)(*curstr);
//      ++curstr;
//      cur <<= 8;
//      cur |= (uint32_t)(*curstr);
//      ++curstr;
//
//
//      for (searchPos = startPos; searchPos<searchLen-4+1; ++searchPos) {
//         cur <<= 8;
//         cur |= (uint32_t)(*curstr);
//         ++curstr;
//         if (pat == cur) {
//            searchEnd = searchPos + 4;
//            return searchPos;
//         }
//      }
//   }
//   // else not found
//   searchPos = searchEnd = searchLen;
//   return USEARCH_DONE;
//}


/** find last match - case of short pattern
 *
 * @param startPos where to start
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *
 * @version 0.2-4 (Marek Gagolewski, 2014-05-15)
 *          BUGFIX: load of misaligned adresses
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-30)
 *          BUGFIX: ret USEARCH_DONE immediately if startPos indicates no match
 *
 */
//R_len_t StriContainerByteSearch::findFromPosBack_short(R_len_t startPos)
//{
//   if (startPos+1 < patternLen) { // check OK, case-sensitive search
//      searchPos = searchEnd = searchLen;
//      return USEARCH_DONE;
//   }
//
//   if (patternLen == 1) {
//      unsigned char pat = (unsigned char)patternStr[0];
//      for (searchPos = startPos-0; searchPos>=0; --searchPos) {
//         if (pat == (unsigned char)searchStr[searchPos]) {
//            searchEnd = searchPos + 1;
//            return searchPos;
//         }
//      }
//   }
//   else if (patternLen == 2) {
//      // be careful: little vs big endian!
//      uint16_t pat  = ((uint16_t)((unsigned char)patternStr[1]));
//               pat <<= 8;
//               pat |= ((uint16_t)((unsigned char)patternStr[0]));
//
//      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
//      uint16_t cur  = ((uint16_t)(*curstr));
//      --curstr;
//      for (searchPos = startPos-1; searchPos>=0; --searchPos) {
//         cur <<= 8;
//         cur |= (uint16_t)(*curstr);
//         --curstr;
//         if (pat == cur) {
//            searchEnd = searchPos + 2;
//            return searchPos;
//         }
//      }
//   }
//   else if (patternLen == 3) {
//      uint32_t pat  = ((uint32_t)((unsigned char)patternStr[2]));
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[1]));
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[0]));
//
//      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
//      uint32_t cur  = ((uint32_t)(*curstr));
//      --curstr;
//      cur <<= 8;
//      cur |= (uint32_t)(*curstr);
//      --curstr;
//
//      uint32_t mask = ~(((unsigned char)0xff)<<24);
//
//      for (searchPos = startPos-2; searchPos>=0; --searchPos) {
//         cur <<= 8;
//         cur |= (uint32_t)(*curstr);
//         --curstr;
//         if ((pat&mask) == (cur&mask)) {
//            searchEnd = searchPos + 3;
//            return searchPos;
//         }
//      }
//   }
//   else if (patternLen == 4) {
//      uint32_t pat  = ((uint32_t)((unsigned char)patternStr[3])); /* TO DO: can't this be cached? */
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[2]));
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[1]));
//               pat <<= 8;
//               pat |= ((uint32_t)((unsigned char)patternStr[0]));
//
//      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
//      uint32_t cur  = ((uint32_t)(*curstr));
//      --curstr;
//      cur <<= 8;
//      cur |= (uint32_t)(*curstr);
//      --curstr;
//      cur <<= 8;
//      cur |= (uint32_t)(*curstr);
//      --curstr;
//
//
//      for (searchPos = startPos-3; searchPos>=0; --searchPos) {
//         cur <<= 8;
//         cur |= (uint32_t)(*curstr);
//         --curstr;
//         if (pat == cur) {
//            searchEnd = searchPos + 4;
//            return searchPos;
//         }
//      }
//   }
//   // else not found
//   searchPos = searchEnd = searchLen;
//   return USEARCH_DONE;
//}


/** Read settings flags from a list
 *
 * may call Rf_error
 *
 * @param opts_fixed list
 * @param allow_overlap
 * @return flags
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-08)
 *    add `overlap` option
 *
 * @version 1.1.6 (Marek Gagolewski, 2017-11-10)
 *    PROTECT STRING_ELT(names, i)
 */
uint32_t StriContainerByteSearch::getByteSearchFlags(SEXP opts_fixed, bool allow_overlap)
{
   uint32_t flags = 0;
   if (!isNull(opts_fixed) && !Rf_isVectorList(opts_fixed))
      Rf_error(MSG__ARG_EXPECTED_LIST, "opts_fixed"); // error() call allowed here

   R_len_t narg = isNull(opts_fixed)?0:LENGTH(opts_fixed);

   if (narg > 0) {

      SEXP names = PROTECT(Rf_getAttrib(opts_fixed, R_NamesSymbol));
      if (names == R_NilValue || LENGTH(names) != narg)
         Rf_error(MSG__FIXED_CONFIG_FAILED); // error() call allowed here

      for (R_len_t i=0; i<narg; ++i) {
         if (STRING_ELT(names, i) == NA_STRING)
            Rf_error(MSG__FIXED_CONFIG_FAILED); // error() call allowed here

         SEXP tmp_arg;
         PROTECT(tmp_arg = STRING_ELT(names, i));
         const char* curname = stri__copy_string_Ralloc(tmp_arg, "curname");  /* this is R_alloc'ed */
         UNPROTECT(1);

         PROTECT(tmp_arg = VECTOR_ELT(opts_fixed, i));
         if  (!strcmp(curname, "case_insensitive")) {
            bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "case_insensitive");
            if (val) flags |= BYTESEARCH_CASE_INSENSITIVE;
         } else if  (!strcmp(curname, "overlap") && allow_overlap) {
            bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "overlap");
            if (val) flags |= BYTESEARCH_OVERLAP;
         } else {
            Rf_warning(MSG__INCORRECT_FIXED_OPTION, curname);
         }
         UNPROTECT(1);
      }
      UNPROTECT(1); /* names */
   }

   return flags;
}
