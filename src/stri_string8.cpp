/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2021, Marek Gagolewski <https://www.gagolewski.com>
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


#include "stri_string8.h"



void String8::initialize(const char* str, R_len_t n, bool memalloc, bool killbom, bool isASCII)
{
#ifndef NDEBUG
    if (!isNA())
        throw StriException("string8::!isNA() in initialize()");
#endif
    if (killbom && n >= 3 &&
            (uint8_t)(str[0]) == UTF8_BOM_BYTE1 &&
            (uint8_t)(str[1]) == UTF8_BOM_BYTE2 &&
            (uint8_t)(str[2]) == UTF8_BOM_BYTE3) {
        // has BOM - get rid of it
        this->m_memalloc = true; // ignore memalloc val
        this->m_n = n-3;
        this->m_isASCII = isASCII;
        this->m_str = new char[this->m_n+1];
        STRI_ASSERT(this->m_str);
        if (!this->m_str)
            throw StriException(MSG__MEM_ALLOC_ERROR_WITH_SIZE, this->m_n+1);
        memcpy(this->m_str, str+3, (size_t)this->m_n);
        this->m_str[this->m_n] = '\0';
    }
    else {
        this->m_memalloc = memalloc;
        this->m_n = n;
        this->m_isASCII = isASCII;
        if (memalloc) {
            this->m_str = new char[this->m_n+1];
            STRI_ASSERT(this->m_str);
            if (!this->m_str)
                throw StriException(MSG__MEM_ALLOC_ERROR_WITH_SIZE, this->m_n+1);
            // memcpy may be very fast in some libc implementations
            memcpy(this->m_str, str, (size_t)this->m_n);
            this->m_str[this->m_n] = '\0';
        }
        else {
            this->m_str = (char*)(str); // we know what we're doing
            // str is zero-terminated
        }
    }
}



/** copy constructor */
String8::String8(const String8& s)
{
    this->m_memalloc = s.m_memalloc;
    this->m_n = s.m_n;
    this->m_isASCII = s.m_isASCII;
    if (s.m_memalloc) {
        this->m_str = new char[this->m_n+1];
        STRI_ASSERT(this->m_str);
        if (!this->m_str)
            throw StriException(MSG__MEM_ALLOC_ERROR_WITH_SIZE, this->m_n+1);
        memcpy(this->m_str, s.m_str, (size_t)this->m_n);
        this->m_str[this->m_n] = '\0';
    }
    else {
        this->m_str = s.m_str;
    }
}

/** copy */
String8& String8::operator=(const String8& s)
{
    if (this->m_str && this->m_memalloc)
        delete [] this->m_str;

    this->m_memalloc = s.m_memalloc;
    this->m_n = s.m_n;
    this->m_isASCII = s.m_isASCII;
    if (s.m_memalloc) {
        this->m_str = new char[this->m_n+1];
        STRI_ASSERT(this->m_str);
        if (!this->m_str)
            throw StriException(MSG__MEM_ALLOC_ERROR_WITH_SIZE, this->m_n+1);
        memcpy(this->m_str, s.m_str, (size_t)this->m_n);
        this->m_str[this->m_n] = '\0';
    }
    else {
        this->m_str = s.m_str;
    }

    return *this;
}



bool String8::endsWith(R_len_t byteindex, const char* patternStr, R_len_t patternLen, bool caseInsensitive) const
{
    if (caseInsensitive) {
        R_len_t k = patternLen;
        UChar32 c1;
        UChar32 c2;
        while (k > 0) {
            if (byteindex <= 0) return false;
            U8_PREV(m_str, 0, byteindex, c1);
            U8_PREV(patternStr, 0, k, c2);
            if (u_toupper(c1) != u_toupper(c2))
                return false;
        }
        return true;
    }
    else {
        if (byteindex-patternLen < 0) return false;

        for (R_len_t k=0; k < patternLen; ++k)
            if (m_str[byteindex-k-1] != patternStr[patternLen-k-1])
                return false;

        return true; // found
    }
}



bool String8::startsWith(R_len_t byteindex, const char* patternStr, R_len_t patternLen, bool caseInsensitive) const
{
    if (caseInsensitive) {
        R_len_t k = 0;
        UChar32 c1;
        UChar32 c2;

        while (k < patternLen) {
            if (byteindex >= m_n) return false;
            U8_NEXT(m_str,      byteindex, m_n,        c1);
            U8_NEXT(patternStr, k,         patternLen, c2);
            if (u_toupper(c1) != u_toupper(c2))
                return false;
        }
        return true;
    }
    else {
        if (byteindex+patternLen > m_n) return false;

        for (R_len_t k=0; k < patternLen; ++k)
            if (m_str[byteindex+k] != patternStr[k])
                return false;

        return true; // found
    }
}


void String8::replaceAllAtPos(R_len_t buf_size,
                        const char* replacement_cur_s, R_len_t replacement_cur_n,
                        std::deque< std::pair<R_len_t, R_len_t> >& occurrences)
{
#ifndef NDEBUG
    if (isNA()) throw StriException("String8::isNA() in replaceAllAtPos()");
#endif
    char* old_str = this->m_str;
    int old_n = this->m_n;
    bool old_memalloc = this->m_memalloc;
    this->m_str = new char[buf_size+1];
    this->m_n = buf_size;
    this->m_memalloc = true;
    this->m_isASCII = true; /* TO DO */

    R_len_t buf_used = 0;
    R_len_t jlast = 0;

    std::deque< std::pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
    for (; iter != occurrences.end(); ++iter) {
        pair<R_len_t, R_len_t> match = *iter;
        memcpy(m_str+buf_used, old_str+jlast, (size_t)(match.first-jlast));
        buf_used += match.first-jlast;
#ifndef NDEBUG
        if (buf_used > buf_size)
            throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif

        jlast = match.second;
        memcpy(m_str+buf_used, replacement_cur_s, (size_t)(replacement_cur_n));
        buf_used += replacement_cur_n;
#ifndef NDEBUG
        if (buf_used > buf_size)
            throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif
    }

    memcpy(m_str+buf_used, old_str+jlast, (size_t)(old_n-jlast));
    buf_used += (old_n-jlast);
#ifndef NDEBUG
    if (buf_used > buf_size)
        throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif

#ifndef NDEBUG
    if (buf_used != this->m_n)
        throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif
    this->m_str[this->m_n] = '\0';

    if (old_str && old_memalloc)
        delete [] old_str;
}
