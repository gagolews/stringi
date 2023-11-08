/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2023, Marek Gagolewski <https://www.gagolewski.com/>
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


#ifndef __stri_string8_h
#define __stri_string8_h

#include "stri_stringi.h"
#include <deque>


/**
 * A class to represent a (TODO: read-only?) UTF-8 string.
 *
 * It can mark string as missing (NA), count the number of Unicode code points,
 * remove BOMs
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-13)
 *          added resize() method and m_size field
 *
 * @version 0.1-24 (Marek Gagolewski, 2014-03-11)
 *          Fixed array over-runs detected with valgrind
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-15)
 *          m_str == NULL now denotes a missing value,
 *          isNA(), initialize() methods added
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-23)
 *          initialize() now can kill UTF8 BOMs.
 *          separated String8buf
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-20)
 *          new method: countCodePoints()
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
 *          BUGFIX?: Added explicit zero bytes at the end of each array;
 *          new methods: replaceAllAtPos(), setNA()
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-02-14)
 *          new field: m_isASCII
 */
class String8  {

private:

    char* m_str;      ///< character data in UTF-8, NULL denotes NA
    R_len_t m_n;      ///< string length (in bytes), not including NUL
    bool m_memalloc;  ///< should the memory be freed at the end?
    bool m_isASCII;   ///< ASCII or UTF-8?  TODO: is it used anywhere?


public:

    /** default constructor
     *
     */
    String8() {
        this->m_str = NULL; // a missing value
        this->m_n = 0;
        this->m_memalloc = false;
        this->m_isASCII = false;
    }


    /** used to set data (construct already created,
     * but NA-initialized object)
     *
     * @param str character buffer
     * @param n buffer length (not including NUL)
     * @param memalloc should a deep copy of the buffer be done?
     * @param killbom whether to detect and delete UTF-8 BOMs
     * @param isASCII
     */
    void initialize(const char* str, R_len_t n, bool memalloc, bool killbom, bool isASCII);


    /** constructor
     * @param str character buffer
     * @param n buffer length (not including NUL)
     * @param memalloc should a deep copy of the buffer be done?
     * @param killbom whether to detect and delete UTF-8 BOMs
     * @param isASCII
     */
    String8(const char* str, R_len_t n, bool memalloc, bool killbom, bool isASCII)
    {
        this->m_str = NULL; // a missing value
        initialize(str, n, memalloc, killbom, isASCII);
    }


    /** destructor */
    ~String8()
    {
        if (this->m_str && this->m_memalloc) {
            delete [] this->m_str;
        }
        this->m_str = NULL;
    }


    /** destructor */
    inline void setNA()
    {
        if (this->m_str) {
            if (this->m_memalloc) {
                delete [] this->m_str;
            }
            this->m_str = NULL;
        }
    }


    /** copy constructor */
    String8(const String8& s);

    /** copy */
    String8& operator=(const String8& s);

    /** does this String8 represent a missing value? */
    inline bool isNA() const {
        return !this->m_str;
    }

    /** is this String8 in ASCII? */
    inline bool isASCII() const {
        return this->m_isASCII;
    }

    /** is this String8 in UTF-8? */
    inline bool isUTF8() const {
        return !this->m_isASCII;
    }

    /** Misleading name: did we allocate mem in String8
     *  or is this string a shallow copy of some "external" resource?
     */
    inline bool isReadOnly() const {
        return !this->m_memalloc;
    }

    /** return the char buffer */
    inline const char* c_str() const
    {
#ifndef NDEBUG
        if (isNA())
            throw StriException("String8::isNA() in c_str()");
#endif
        return this->m_str;
    }

    /** string length in bytes */
    inline R_len_t length() const
    {
#ifndef NDEBUG
        if (isNA())
            throw StriException("String8::isNA() in length()");
#endif
        return this->m_n;
    }


    /** The number of Unicode code points */
    inline R_len_t countCodePoints() const
    {
#ifndef NDEBUG
        if (isNA())
            throw StriException("String8::isNA() in countCodePoints()");
#endif
        if (m_isASCII)
            return m_n;
        else
            return stri__length_string(m_str, m_n);
    }


    /**
     *
     * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
     *
     * @version 0.5-1 (Marek Gagolewski, 2015-02-14)
     *    moved from StriContainerByteSearch to String8
     */
    bool endsWith(
        R_len_t byteindex, const char* patternStr, R_len_t patternLen,
        bool caseInsensitive
    ) const;


    /**
     *
     * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
     *
     * @version 0.5-1 (Marek Gagolewski, 2015-02-14)
     * moved from StriContainerByteSearch to String8
     */
    bool startsWith(
        R_len_t byteindex, const char* patternStr, R_len_t patternLen,
        bool caseInsensitive
    ) const;


    /** Replace substrings with a given replacement string
     *
     *
     * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
     */
    void replaceAllAtPos(
        R_len_t buf_size,
        const char* replacement_cur_s, R_len_t replacement_cur_n,
        std::deque< std::pair<R_len_t, R_len_t> >& occurrences
    );

};

#endif
