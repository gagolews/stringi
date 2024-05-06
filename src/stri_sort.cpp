/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2024, Marek Gagolewski <https://www.gagolewski.com/>
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
#include "stri_container_utf16.h"
#include "stri_string8buf.h"
#include <unicode/ucol.h>
#include <unicode/sortkey.h>
#include <vector>
#include <deque>
#include <algorithm>
#include <set>


# define STRI_SORTRANKORDER_SORT  1
# define STRI_SORTRANKORDER_RANK  2
# define STRI_SORTRANKORDER_ORDER 3

/** help struct for stri_order **/
struct StriSortComparer {
    StriContainerUTF8* cont;
    bool decreasing;
    UCollator* col;

    StriSortComparer(StriContainerUTF8* _cont, UCollator* _col, bool _decreasing)
    {
        this->cont = _cont;
        this->col = _col;
        this->decreasing = _decreasing;
    }

    bool operator() (int a, int b) const
    {
//      if (col) {
        UErrorCode status = U_ZERO_ERROR;
        int ret = (int)ucol_strcollUTF8(col,
            cont->get(a).c_str(), cont->get(a).length(),
            cont->get(b).c_str(), cont->get(b).length(), &status);
        STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
        return (decreasing)?(ret > 0):(ret < 0);
//      }
//      else {
//         int ret = stri__cmp_codepoints(
//            cont->get(a).c_str(), cont->get(a).length(),
//            cont->get(b).c_str(), cont->get(b).length()
//         );
//         return (decreasing)?(ret > 0):(ret < 0);
//      }
    }
};


/** Sort, rank, or generate an ordering permutation
 *
 * @param str character vector
 * @param decreasing single logical value
 * @param na_last single logical value
 * @param opts_collator passed to stri__ucol_open()
 * @param _type internal, 2 for order, 1 for sort, 3 for rank
 * @return integer vector (permutation/ranks) or character vector
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *                 make StriException friendly
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-27)
 *                 Use UTF16 as ucol_strcollUTF8 is DRAFT as of ICU 4.8
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-20)
 *          using ucol_strcollUTF8 again, as we now require ICU >= 50;
 *          performance difference only observed for sorted vectors
 *          (UTF-8: gain, 8bit: loss);
 *          single function for cmp with and witout collation;
 *          new param: na_last
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-07)
 *          opts_collator == NA no longer allowed
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.6-1 (Marek Gagolewski, 2015-07-05)
 *    use stri_order, stri_sort
 *
 * @version 1.6.1 (Marek Gagolewski, 2021-04-30)
 *    rank
 */
SEXP stri_order_rank_or_sort(SEXP str, SEXP decreasing, SEXP na_last,
                        SEXP opts_collator, int _type)
{
    bool decr = stri__prepare_arg_logical_1_notNA(decreasing, "decreasing");
    PROTECT(na_last   = stri__prepare_arg_logical_1(na_last, "na_last"));
    PROTECT(str       = stri__prepare_arg_string(str, "str")); // prepare string argument
    int na_last_int   = INTEGER(na_last)[0];

    // type is an internal arg -- check manually
    if (_type < 1 || _type > 3)
        Rf_error(MSG__INCORRECT_INTERNAL_ARG);

    if (
            _type == STRI_SORTRANKORDER_RANK &&
                (decr || na_last_int == NA_LOGICAL || !na_last_int)
    ) {
        // decreasing and na_last is ignored for rank
        Rf_error(MSG__INCORRECT_INTERNAL_ARG);
    }

    // call stri__ucol_open after prepare_arg:
    // if prepare_arg had failed, we would have a mem leak
    UCollator* col = NULL;
    col = stri__ucol_open(opts_collator);


    STRI__ERROR_HANDLER_BEGIN(2)

    R_len_t vectorize_length = LENGTH(str);
    StriContainerUTF8 str_cont(str, vectorize_length);



    deque<int> NA_pos;
    vector<int> order(vectorize_length);

    R_len_t k = 0;
    for (R_len_t i=0; i<vectorize_length; ++i) {
        if (!str_cont.isNA(i))
            order[k++] = i;
        else if (na_last_int != NA_LOGICAL)
            NA_pos.push_back(i);
    }
    order.resize(k); // this should be faster than creating a separate deque (not tested)


    // TO DO: collation-based cmp: think of using sort keys...
    // however,  it's  very fast already now.

    StriSortComparer comp(&str_cont, col, decr);
    std::stable_sort(order.begin(), order.end(), comp);


    SEXP ret;
    if (_type == STRI_SORTRANKORDER_SORT) {
        // sort
        STRI__PROTECT(ret = Rf_allocVector(STRSXP, k+NA_pos.size()));
        R_len_t j = 0;
        if (na_last_int != NA_LOGICAL && !na_last_int) {
            // put NAs first
            for (std::deque<int>::iterator it=NA_pos.begin(); it!=NA_pos.end(); ++it, ++j)
                SET_STRING_ELT(ret, j, NA_STRING);
        }

        for (std::vector<int>::iterator it=order.begin(); it!=order.end(); ++it, ++j)
            SET_STRING_ELT(ret, j, str_cont.toR(*it));

        if (na_last_int != NA_LOGICAL && na_last_int) {
            // put NAs last
            for (std::deque<int>::iterator it=NA_pos.begin(); it!=NA_pos.end(); ++it, ++j)
                SET_STRING_ELT(ret, j, NA_STRING);
        }
    }
    else if (_type == STRI_SORTRANKORDER_ORDER) {
        STRI__PROTECT(ret = Rf_allocVector(INTSXP, k+NA_pos.size()));
        int* ret_tab = INTEGER(ret);

        R_len_t j = 0;
        if (na_last_int != NA_LOGICAL && !na_last_int) {
            // put NAs first
            for (std::deque<int>::iterator it=NA_pos.begin(); it!=NA_pos.end(); ++it, ++j)
                ret_tab[j] = (*it)+1; // 1-based indices
        }

        for (std::vector<int>::iterator it=order.begin(); it!=order.end(); ++it, ++j)
            ret_tab[j] = (*it)+1; // 1-based indices

        if (na_last_int != NA_LOGICAL && na_last_int) {
            // put NAs last
            for (std::deque<int>::iterator it=NA_pos.begin(); it!=NA_pos.end(); ++it, ++j)
                ret_tab[j] = (*it)+1; // 1-based indices
        }
    }
    else {       // (_type == STRI_SORTRANKORDER_RANK)
        // NAs are always preserved, order is increasing
        STRI__PROTECT(ret = Rf_allocVector(INTSXP, vectorize_length));
        int* ret_tab = INTEGER(ret);
        for (R_len_t i=0; i<vectorize_length; ++i)
            ret_tab[i] = NA_INTEGER;

        R_len_t j_first = 1;   // 1-based indices
        R_len_t j_min = 1;
        int last_idx = 0, cur_idx;
        for (std::vector<int>::iterator it=order.begin(); it!=order.end(); ++it) {
            cur_idx = *it;

            if (j_first > 1) {
                UErrorCode status = U_ZERO_ERROR;
                if (
                    0 != (int)ucol_strcollUTF8(
                        col,
                        str_cont.get(last_idx).c_str(),
                        str_cont.get(last_idx).length(),
                        str_cont.get(cur_idx).c_str(),
                        str_cont.get(cur_idx).length(), &status
                    )
                ) {
                    j_min = j_first;
                }
                // else reuse j_min == a tie.
                STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
            }


            ret_tab[cur_idx] = j_min;
            last_idx = cur_idx;
            j_first++;
        }
    }

    if (col) {
        ucol_close(col);
        col = NULL;
    }

    STRI__UNPROTECT_ALL
    return ret;

    STRI__ERROR_HANDLER_END({
        if (col) {
            ucol_close(col);
            col = NULL;
        }
    })
}




/** Sort a character vector
 *
 * @param str character vector
 * @param decreasing single logical value
 * @param na_last single logical value
 * @param opts_collator passed to stri__ucol_open()
 * @return charcter vector
 *
 * @version 0.6-1 (Marek Gagolewski, 2015-07-05)
 *    Call stri_order_rank_or_sort
 */
SEXP stri_sort(SEXP str, SEXP decreasing, SEXP na_last, SEXP opts_collator)
{
    return stri_order_rank_or_sort(str, decreasing, na_last, opts_collator, STRI_SORTRANKORDER_SORT);
}



/** Return an ordering permutation
 *
 * @param str character vector
 * @param decreasing single logical value
 * @param na_last single logical value
 * @param opts_collator passed to stri__ucol_open()
 * @return integer vector (permutation)
 *
 * @version 0.6-1 (Marek Gagolewski, 2015-07-05)
 *    Call stri_order_rank_or_sort
 */
SEXP stri_order(SEXP str, SEXP decreasing, SEXP na_last, SEXP opts_collator)
{
    return stri_order_rank_or_sort(str, decreasing, na_last, opts_collator, STRI_SORTRANKORDER_ORDER);
}


/** Rank strings
 *
 * @param str character vector
 * @param opts_collator passed to stri__ucol_open()
 * @return integer vector (ranks)
 *
 * @version 1.6.1 (Marek Gagolewski, 2021-04-29)
 */
SEXP stri_rank(SEXP str, SEXP opts_collator)
{
    return stri_order_rank_or_sort(str,
        Rf_ScalarLogical(FALSE)/*decreasing*/,
        Rf_ScalarLogical(TRUE)/*na_last*/,
        opts_collator, STRI_SORTRANKORDER_RANK);
}


/** Get unique elements from a character vector
 *
 * @param str character vector
 * @param opts_collator passed to stri__ucol_open()
 * @return character vector
 *
 * @version 0.2-1 (Bartek Tartanus, 2014-04-17)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-17)
 *          using std::deque
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-07)
 *          opts_collator == NA no longer allowed
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_unique(SEXP str, SEXP opts_collator)
{
    PROTECT(str = stri__prepare_arg_string(str, "str")); // prepare string argument

    // call stri__ucol_open after prepare_arg:
    // if prepare_arg had failed, we would have a mem leak
    UCollator* col = NULL;
    col = stri__ucol_open(opts_collator);

    STRI__ERROR_HANDLER_BEGIN(1)

    R_len_t vectorize_length = LENGTH(str);
    StriContainerUTF8 str_cont(str, vectorize_length);

    StriSortComparer comp(&str_cont, col, true);
    set<int,StriSortComparer> uniqueset(comp);

    bool was_na = false;
    deque<SEXP> temp;
    for (R_len_t i=0; i<vectorize_length; ++i) {
        if (str_cont.isNA(i)) {
            if (!was_na) {
                was_na = true;
                temp.push_back(NA_STRING);
            }
        }
        else {
            pair<set<int,StriSortComparer>::iterator,bool> result = uniqueset.insert(i);
            if (result.second) {
                temp.push_back(str_cont.toR(i));
            }
        }
    }

    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(STRSXP, temp.size()));
    R_len_t i = 0;
    for (deque<SEXP>::iterator it = temp.begin(); it != temp.end(); it++) {
        SET_STRING_ELT(ret, i++, *it);
    }

    if (col) {
        ucol_close(col);
        col = NULL;
    }

    STRI__UNPROTECT_ALL
    return ret;

    STRI__ERROR_HANDLER_END({
        if (col) {
            ucol_close(col);
            col = NULL;
        }
    })
}


/** Determine duplicated elements
 *
 * @param str character vector
 * @param fromLast logical value
 * @param opts_collator passed to stri__ucol_open()
 * @return logical vector
 *
 * @version 0.2-1 (Bartek Tartanus, 2014-04-17)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-07)
 *          opts_collator == NA no longer allowed
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_duplicated(SEXP str, SEXP fromLast, SEXP opts_collator)
{
    PROTECT(str = stri__prepare_arg_string(str, "str")); // prepare string argument
    bool fromLastBool = stri__prepare_arg_logical_1_notNA(fromLast, "fromLast");

    // call stri__ucol_open after prepare_arg:
    // if prepare_arg had failed, we would have a mem leak
    UCollator* col = NULL;
    col = stri__ucol_open(opts_collator);

    STRI__ERROR_HANDLER_BEGIN(1)

    R_len_t vectorize_length = LENGTH(str);
    StriContainerUTF8 str_cont(str, vectorize_length);

    StriSortComparer comp(&str_cont, col, true);
    set<int,StriSortComparer> uniqueset(comp);

    bool was_na = false;
    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
    int* ret_tab = LOGICAL(ret);

    if (fromLastBool) {
        for (R_len_t i=vectorize_length-1; i>=0; --i) {
            if (str_cont.isNA(i)) {
                ret_tab[i] = was_na;
                if (!was_na)
                    was_na = true;
            }
            else {
                pair<set<int,StriSortComparer>::iterator,bool> result = uniqueset.insert(i);
                ret_tab[i] = !result.second;
            }
        }
    }
    else {
        for (R_len_t i=0; i<vectorize_length; ++i) {
            if (str_cont.isNA(i)) {
                ret_tab[i] = was_na;
                if (!was_na)
                    was_na = true;
            }
            else {
                pair<set<int,StriSortComparer>::iterator,bool> result = uniqueset.insert(i);
                ret_tab[i] = !result.second;
            }
        }
    }


    if (col) {
        ucol_close(col);
        col = NULL;
    }

    STRI__UNPROTECT_ALL
    return ret;

    STRI__ERROR_HANDLER_END({
        if (col) {
            ucol_close(col);
            col = NULL;
        }
    })
}


/** Determine first duplicated elements
 *
 * @param str character vector
 * @param fromLast logical value
 * @param opts_collator passed to stri__ucol_open()
 * @return integer vector
 *
 * @version 0.2-1 (Bartek Tartanus, 2014-04-17)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-07)
 *          opts_collator == NA no longer allowed
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_duplicated_any(SEXP str, SEXP fromLast, SEXP opts_collator)
{
    PROTECT(str = stri__prepare_arg_string(str, "str")); // prepare string argument
    bool fromLastBool = stri__prepare_arg_logical_1_notNA(fromLast, "fromLast");

    // call stri__ucol_open after prepare_arg:
    // if prepare_arg had failed, we would have a mem leak
    UCollator* col = NULL;
    col = stri__ucol_open(opts_collator);

    STRI__ERROR_HANDLER_BEGIN(1)

    R_len_t vectorize_length = LENGTH(str);
    StriContainerUTF8 str_cont(str, vectorize_length);

    StriSortComparer comp(&str_cont, col, true);
    set<int,StriSortComparer> uniqueset(comp);

    bool was_na = false;
    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(INTSXP, 1));
    int* ret_tab = INTEGER(ret);
    ret_tab[0] = 0;

    if (fromLastBool) {
        for (R_len_t i=vectorize_length-1; i>=0; --i) {
            if (str_cont.isNA(i)) {
                if (!was_na)
                    was_na = true;
                else {
                    ret_tab[0] = i+1;
                    break;
                }
            }
            else {
                pair<set<int,StriSortComparer>::iterator,bool> result = uniqueset.insert(i);
                if (!result.second) {
                    ret_tab[0] = i+1;
                    break;
                }
            }
        }
    }
    else {
        for (R_len_t i=0; i<vectorize_length; ++i) {
            if (str_cont.isNA(i)) {
                if (!was_na)
                    was_na = true;
                else {
                    ret_tab[0] = i+1;
                    break;
                }
            }
            else {
                pair<set<int,StriSortComparer>::iterator,bool> result = uniqueset.insert(i);
                if (!result.second) {
                    ret_tab[0] = i+1;
                    break;
                }
            }
        }
    }


    if (col) {
        ucol_close(col);
        col = NULL;
    }

    STRI__UNPROTECT_ALL
    return ret;

    STRI__ERROR_HANDLER_END({
        if (col) {
            ucol_close(col);
            col = NULL;
        }
    })
}


/** Compute a character sort key
 *
 * @param str character vector
 * @param opts_collator passed to stri__ucol_open()
 * @return character vector
 *
 * @version 1.4.7 (Davis Vaughan, 2020-07-15)
 * @version 1.6.1 (Marek Gagolewski, 2021-04-29)
 *          output `bytes`-encoded strings
 */
SEXP stri_sort_key(SEXP str, SEXP opts_collator) {
    PROTECT(str = stri__prepare_arg_string(str, "str"));

    // call stri__ucol_open after prepare_arg:
    // if prepare_arg had failed, we would have a mem leak
    UCollator* col = stri__ucol_open(opts_collator);

    STRI__ERROR_HANDLER_BEGIN(1)

    R_len_t length = LENGTH(str);
    StriContainerUTF16 str_cont(str, length);

    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(STRSXP, length));

//    UErrorCode status = U_ZERO_ERROR;

    // Allocate temporary buffer to hold the current sort key
    size_t key_buffer_size = 16384;
    String8buf key_buffer(key_buffer_size);
    uint8_t* p_key_buffer_u8 = (uint8_t*) key_buffer.data();

    for (R_len_t i = 0; i < length; ++i) {
        if (str_cont.isNA(i)) {
            SET_STRING_ELT(ret, i, NA_STRING);
            continue;
        }

        const UnicodeString* p_str_cur_data = &(str_cont.get(i));
        const UChar* p_str_cur = p_str_cur_data->getBuffer();
        const int str_cur_length = p_str_cur_data->length();

        int32_t key_size = ucol_getSortKey(col, p_str_cur, str_cur_length, p_key_buffer_u8, key_buffer_size);

        // Reallocate a larger buffer and retry as required
        if ((size_t)key_size > key_buffer_size) {
            const int32_t key_padding = 100;
            key_buffer_size = key_size + key_padding;

            key_buffer.resize(key_buffer_size, false);
            p_key_buffer_u8 = (uint8_t*) key_buffer.data();

            // Try again
            key_size = ucol_getSortKey(col, p_str_cur, str_cur_length, p_key_buffer_u8, key_buffer_size);
        }

        // `key_size` includes null terminator,
        // which we don't want to copy into the R CHARSXP
        R_len_t key_char_size = key_size - 1;

        SET_STRING_ELT(ret, i, Rf_mkCharLenCE(key_buffer.data(), key_char_size, CE_BYTES));
    }

    if (col) {
        ucol_close(col);
        col = NULL;
    }

    STRI__UNPROTECT_ALL
    return ret;

    STRI__ERROR_HANDLER_END({
        if (col) {
            ucol_close(col);
            col = NULL;
        }
    })
}
