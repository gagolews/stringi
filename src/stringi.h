/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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
 
#ifndef __stringi_h
#define __stringi_h

// for DEBUG mode
#undef NDEBUG
// for non-DEBUG mode:
// #define NDEBUG


#include "external.h"
#include "messages.h"
#include "macros.h"
#include "unicoder_base.h"
#include "string8.h"
#include "unicoder8.h"
#include "unicoder16.h"

// ------------------------------------------------------------------------


/** Two \code{R_len_t}s as one :)
 * 
 */
struct R_len_t_x2 {
   R_len_t_x2(R_len_t v1, R_len_t v2) { this->v1 = v1; this->v2 = v2; }
   R_len_t v1;
   R_len_t v2;
};


// ------------------------------------------------------------------------

// @TODO: stri_multisub                                   // ...TODO... [version >0.1]
// @TODO: stri_multisub_replacement                       // ...TODO... [version >0.1]
// @TODO: SEXP stri_enc_fromutf16(SEXP str);              // ...TODO... be careful: BOMs! [version >0.1]
// @TODO: SEXP stri_enc_toutf16(SEXP str);                // ...TODO... -> list with elems of type raw [version >0.1]
// @TODO: stri_enc_detect()                               // ...TODO... [version >0.1]

// ------------------------------------------------------------------------


// casefold.cpp:
SEXP stri_casefold(SEXP str, SEXP type, SEXP locale);               // DONE


// common.cpp
void stri__set_names(SEXP object, R_len_t numnames, ...);           // DONE
R_len_t stri__recycling_rule(bool enableWarning, int n, ...);       // DONE
SEXP    stri__vector_NA_strings(R_len_t howmany);                   // DONE
SEXP    stri__vector_empty_strings(R_len_t howmany);                // DONE
char*   stri__asciiCopyToLowerCase(char* dest, const char* src);    // DONE
char*   stri__asciiCopyToUpperCase(char* dest, const char* src);    // DONE
SEXP    stri__emptyList();                                          // DONE
SEXP    stri__matrix_NA_INTEGER(R_len_t nrow, R_len_t ncol);        // DONE             


// collator.cpp:
UCollator*  stri__ucol_open(SEXP collator_opts);

// compare.cpp:
int stri__compare_codepoints(const char* str1, R_len_t n1, const char* str2, R_len_t n2); // DONE
SEXP stri_compare_codepoints(SEXP e1, SEXP e2);                     // DONE
SEXP stri_compare(SEXP e1, SEXP e2, SEXP collator_opts);            // DONE
SEXP stri_order(SEXP str, SEXP decreasing, SEXP collator_opts);     // DONE


// ICU_settings.cpp:
SEXP stri_info();                                      // DONE


// join.cpp:
SEXP stri_dup(SEXP str, SEXP c);                       // DONE
SEXP stri_flatten(SEXP str, SEXP collapse);            // DONE
SEXP stri_flatten_nosep(SEXP str);                     // DONE
SEXP stri_join(SEXP str, SEXP sep, SEXP collapse);     // DONE
SEXP stri_join2(SEXP e1, SEXP e2);                     // DONE



// length.cpp
R_len_t stri__numbytes_max(SEXP str); // DONE
SEXP stri_numbytes(SEXP str);         // DONE
SEXP stri_length(SEXP str);           // DONE
SEXP stri_isempty(SEXP str);          // DONE
SEXP stri_width(SEXP str);            // ...TODO...



// prepare_arg.cpp:
SEXP        stri_prepare_arg_string(SEXP x, const char* argname);          // DONE
SEXP        stri_prepare_arg_double(SEXP x, const char* argname);          // DONE
SEXP        stri_prepare_arg_integer(SEXP x, const char* argname);         // DONE
SEXP        stri_prepare_arg_logical(SEXP x, const char* argname);         // DONE
SEXP        stri_prepare_arg_raw(SEXP x, const char* argname);             // DONE
SEXP        stri_prepare_arg_string_1(SEXP x, const char* argname);        // DONE
SEXP        stri_prepare_arg_double_1(SEXP x, const char* argname);        // DONE
SEXP        stri_prepare_arg_integer_1(SEXP x, const char* argname);       // DONE
SEXP        stri_prepare_arg_logical_1(SEXP x, const char* argname);       // DONE
bool        stri__prepare_arg_logical_1_notNA(SEXP x, const char* argname); // DONE
const char* stri__prepare_arg_locale(SEXP loc, const char* argname, bool allowdefault); // DONE
const char* stri__prepare_arg_enc(SEXP loc, const char* argname, bool allowdefault);    // DONE



// reverse.cpp
SEXP stri_reverse(SEXP s);                                              // DONE




// sub.cpp
SEXP stri_sub(SEXP str, SEXP from, SEXP to, SEXP length);      // DONE
SEXP stri_sub_replacement(SEXP str, SEXP from, SEXP to, SEXP length, SEXP value);    // DONE





// ucnv.cpp:
UConverter* stri__ucnv_open(const char* enc);                              // DONE
bool        stri__ucnv_hasASCIIsubset(UConverter* conv);                   // DONE
bool        stri__ucnv_is1to1Unicode(UConverter* conv);                    // DONE
void        stri__ucnv_getStandards(const char**& standards, R_len_t& cs); // DONE
const char* stri__ucnv_getFriendlyName(const char* canname);               // DONE

SEXP stri_enc_list();                                   // DONE
SEXP stri_enc_info(SEXP enc);                           // DONE
SEXP stri_enc_set(SEXP loc);                            // DONE

SEXP stri_encode(SEXP str, SEXP from, SEXP to, SEXP to_raw);   // DONE

R_len_t stri__enc_fromutf32(int* data, R_len_t ndata, char* buf, R_len_t bufsize); // DONE [internal]
SEXP stri_enc_fromutf32(SEXP str);                      // DONE
SEXP stri_enc_toutf32(SEXP str);                        // DONE
SEXP stri_enc_toutf8(SEXP str, SEXP is_unknown_8bit);   // DONE
SEXP stri_enc_toascii(SEXP str);                        // DONE


SEXP stri_enc_isascii(SEXP str);                          // DONE
SEXP stri_enc_isutf8(SEXP str);                           // DONE






// uloc.cpp:
SEXP stri_locale_info(SEXP loc);                        // DONE
SEXP stri_locale_list();                                // DONE
SEXP stri_locale_set(SEXP loc);                         // DONE


// unicode_normalization.cpp:
const Normalizer2* stri__normalizer_get(SEXP type);     // DONE
SEXP stri_enc_nf(SEXP s, SEXP type);                    // DONE
SEXP stri_enc_isnf(SEXP s, SEXP type);                  // DONE


// wrap.cpp
SEXP stri_wrap_greedy(SEXP count, int width, int spacecost);                // ...TO DO...
SEXP stri_wrap_dynamic(SEXP count, int width, int spacecost);               // ...TO DO...
SEXP stri_wrap(SEXP wordslist, SEXP method, SEXP width, SEXP spacecost);    // ...TO DO...


// justify.cpp
SEXP stri_justify(SEXP str, SEXP width);   // ...TO DO...



// ----------- SEARCH --------------------------------------------

void stri__locate_set_dimnames_list(SEXP list);                       // DONE
void stri__locate_set_dimnames_matrix(SEXP matrix);                   // DONE


SEXP stri_count_fixed_byte(SEXP str, SEXP pattern);                   // DONE
SEXP stri_count_fixed(SEXP str, SEXP pattern, SEXP collator_opts);    // DONE
SEXP stri_detect_fixed_byte(SEXP str, SEXP pattern);                  // DONE
SEXP stri_detect_fixed(SEXP str, SEXP pattern, SEXP collator_opts);   // DONE
SEXP stri_locate_all_fixed(SEXP str, SEXP pattern);                   // ...TO DO...
SEXP stri_locate_first_or_last_fixed(SEXP str, SEXP pattern, SEXP first); // ...TO DO... ----- delete this!!!
//SEXP stri_locate_first_fixed(SEXP str, SEXP pattern); // ...TO DO...
//SEXP stri_locate_last_fixed(SEXP str, SEXP pattern);  // ...TO DO...
//SEXP stri_replace_all_fixed(SEXP str, SEXP pattern, SEXP replacement);   // ...TO DO...
//SEXP stri_replace_first_fixed(SEXP str, SEXP pattern, SEXP replacement); // ...TO DO...
//SEXP stri_replace_last_fixed(SEXP str, SEXP pattern, SEXP replacement);  // ...TO DO...



SEXP stri_detect_regex(SEXP str, SEXP pattern);                            // DONE
SEXP stri_count_regex(SEXP str, SEXP pattern);                             // DONE
SEXP stri_locate_all_regex(SEXP str, SEXP pattern);                        // DONE
SEXP stri_locate_first_regex(SEXP str, SEXP pattern);                      // DONE
//SEXP stri_locate_last_regex(SEXP str, SEXP pattern);                     // ...TO DO...
SEXP stri_replace_all_regex(SEXP str, SEXP pattern, SEXP replacement);     // DONE
//SEXP stri_replace_first_regex(SEXP str, SEXP pattern, SEXP replacement); // ...TO DO...
//SEXP stri_replace_last_regex(SEXP str, SEXP pattern, SEXP replacement);  // ...TO DO...




bool stri__detect_class1(const char* s, int n, int32_t* cls);                  // ...TO DO: rewrite completely & rename to *charclass
SEXP stri_detect_class(SEXP s, SEXP c);                                        // ...TO DO: rewrite completely & rename to *charclass
void stri__locate_all_class1(const char* s, int n, int32_t* c,                 // ...TO DO: rewrite completely & rename to *charclass
   int* start, int* end, int& o);                                              // ...TO DO: rewrite completely & rename to *charclass
void stri__locate_first_and_last_class1(const char* s, int n, int32_t* cls,    // ...TO DO: rewrite completely & rename to *charclass
   int& first, int& last);                                                     // ...TO DO: rewrite completely & rename to *charclass
SEXP stri_locate_all_class(SEXP str, SEXP c);                                  // ...TO DO: rewrite completely & rename to *charclass
SEXP stri_locate_first_or_last_class(SEXP str, SEXP c, SEXP first);            // ...TO DO: rewrite completely & rename to *charclass



// uchar.cpp:
// void stri__UChar16_to_UChar32_index(const UChar* str, const int nstr, int* i1, const int ni);    
void stri__UChar16_to_UChar32_index(const UChar* str, const int nstr,  
   int* i1, int* i2, const int ni, int adj1=0, int adj2=0);                    // ...DONE, but move somewhere else TO DO: ->StriContainerUTF16
void stri__uchar_charType(const char* s, int n, int* codes);                   // ...TO DO: rewrite completely
SEXP stri_charcategories();                                                    // ...TO DO: rewrite completely
SEXP stri_chartype(SEXP str);                                                  // ...TO DO: rewrite completely
SEXP stri_char_getcategoryid(SEXP x);                                          // ...TO DO: rewrite completely
SEXP stri_char_getpropertyid(SEXP x);                                          // ...TO DO: rewrite completely

// split.cpp
SEXP stri_split_class(SEXP str, SEXP c);   // ...TO DO...
SEXP stri_split_fixed(SEXP str, SEXP split, SEXP n, SEXP omitempty, SEXP exact);   // ...TO DO...
SEXP stri_split_pos(SEXP str, SEXP from, SEXP to);   // ...TO DO...
SEXP stri__split_pos(const char* s, int* from, int* to, int ns, int n);   // ...TO DO...



// trim.cpp:
void stri__locate_trim1(const char* s, int n, int& first, int& last);   // ...TO DO...
SEXP stri_trim(SEXP str);   // ...TO DO...
SEXP stri_ltrim(SEXP str);   // ...TO DO...
SEXP stri_rtrim(SEXP str);   // ...TO DO...
SEXP stri_trim_all(SEXP str);   // ...TO DO...
SEXP stri_pad(SEXP str, SEXP width, SEXP side, SEXP pad);   // ...TO DO...





// stats.cpp
SEXP stri_stats_general(SEXP str);   // ...TO DO...
SEXP stri_stats_latex(SEXP str);   // ...TO DO...


// test.cpp /* internal, but in namespace: for testing */
SEXP stri_test_Rmark(SEXP str);               // DONE
SEXP stri_test_UnicodeContainer16(SEXP str);  // DONE
SEXP stri_test_UnicodeContainer8(SEXP str);   // DONE
SEXP stri_test_returnasis(SEXP x);            // DONE

// ------------------------------------------------------------------------



#endif
