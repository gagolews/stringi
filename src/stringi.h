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
#include "unicoder.h"


// ------------------------------------------------------------------------


// common.cpp
R_len_t stri__recycling_rule(R_len_t ns1, R_len_t ns2, bool disableWarning=false);              // DONE
R_len_t stri__recycling_rule(R_len_t ns1, R_len_t ns2, R_len_t ns3, bool disableWarning=false); // DONE
R_len_t stri__recycling_rule(R_len_t ns1, R_len_t ns2, R_len_t ns3, R_len_t ns4, bool disableWarning=false); // DONE
SEXP    stri__vector_NA_strings(R_len_t howmany);                   // DONE
SEXP    stri__vector_empty_strings(R_len_t howmany);                // DONE
char*   stri__asciiCopyToLowerCase(char* dest, const char* src);    // DONE
char*   stri__asciiCopyToUpperCase(char* dest, const char* src);    // DONE
SEXP    stri__emptyList();                                          // DONE


// casefold.cpp:
SEXP stri_casefold(SEXP s, SEXP type);


// compare.cpp:
SEXP stri_casecompare(SEXP x, SEXP y);


// count.cpp
SEXP stri_count_fixed(SEXP s, SEXP pattern);
SEXP stri_count_regex(SEXP s, SEXP pattern);

//detect.cpp
SEXP stri_detect_fixed(SEXP str, SEXP pattern);
SEXP stri_detect_regex(SEXP str, SEXP pattern);

// dup.cpp:
SEXP stri_dup(SEXP s, SEXP c);


// ICU_settings.cpp:
SEXP stri_info();                        // DONE

// join.cpp:
SEXP stri_flatten(SEXP s, SEXP sep);
SEXP stri_join(SEXP s);
SEXP stri_join2(SEXP s1, SEXP s2);

// justify.cpp
SEXP stri_justify(SEXP s, SEXP width);


// length.cpp
R_len_t stri__numbytes_max(SEXP s); // DONE
SEXP stri_numbytes(SEXP s);         // DONE
SEXP stri_length(SEXP s);           // DONE
SEXP stri_isempty(SEXP s);          // DONE
SEXP stri_width(SEXP s);            // ...TODO...

// locate.cpp
SEXP stri_locate_all_class(SEXP s, SEXP c);
SEXP stri_locate_all_fixed(SEXP s, SEXP p);
SEXP stri_locate_all_regex(SEXP s, SEXP p);
SEXP stri_locate_first_or_last_class(SEXP s, SEXP c, SEXP first);
SEXP stri_locate_first_or_last_fixed(SEXP s, SEXP p, SEXP first);
SEXP stri_locate_first_regex(SEXP s, SEXP p);

void stri__locate_all_class1(const char* s, int n, int32_t* c,
   int* start, int* end, int& o);
void stri__locate_first_and_last_class1(const char* s, int n, int32_t* cls,
   int& first, int& last);
   
// prepare_arg.cpp:
SEXP        stri_prepare_arg_string(SEXP x);                            // DONE
SEXP        stri_prepare_arg_double(SEXP x);                            // DONE
SEXP        stri_prepare_arg_integer(SEXP x);                           // DONE
SEXP        stri_prepare_arg_logical(SEXP x);                           // DONE
const char* stri__prepare_arg_locale(SEXP loc, bool allowdefault=true); // DONE
const char* stri__prepare_arg_enc(SEXP loc, bool allowdefault=true);    // DONE

// replace.cpp
SEXP stri_replace_first_fixed(SEXP s, SEXP pat, SEXP rep);
SEXP stri_replace_all_fixed(SEXP s, SEXP pat, SEXP rep);
SEXP stri_replace_all_regex(SEXP s, SEXP p, SEXP r);

// reverse.cpp
SEXP stri_reverse(SEXP s);


// split.cpp
SEXP stri_split_fixed(SEXP s, SEXP split, SEXP n, SEXP omitempty, SEXP exact);
SEXP stri_split_pos(SEXP s, SEXP from, SEXP to);
SEXP stri__split_pos(const char* s, int* from, int* to, int ns, int n);

// sub.cpp
SEXP stri_sub(SEXP s, SEXP from, SEXP to);
SEXP stri_sub_op(SEXP s, SEXP from, SEXP to, SEXP value);


// trim.cpp:
SEXP stri_trim(SEXP s);
SEXP stri_ltrim(SEXP s);
SEXP stri_rtrim(SEXP s);
SEXP stri_trim_all(SEXP s);
SEXP stri_pad(SEXP s, SEXP width, SEXP side, SEXP pad);


// uchar.cpp:
void stri__uchar_charType(const char* s, int n, int* codes);
SEXP stri_charcategories();
SEXP stri_chartype(SEXP s);
SEXP stri_char_getcategoryid(SEXP x);
SEXP stri_char_getpropertyid(SEXP x);


// ucnv.cpp:
UConverter* stri__ucnv_open(const char* enc);                              // DONE
bool        stri__ucnv_hasASCIIsubset(UConverter* conv);                   // DONE
bool        stri__ucnv_is1to1Unicode(UConverter* conv);                    // DONE
void        stri__ucnv_getStandards(const char**& standards, R_len_t& cs); // DONE
const char* stri__ucnv_getFriendlyName(const char* canname);               // DONE
SEXP stri_enc_Rmark(SEXP s); /* internal, but in namespace: for testing */ // DONE

SEXP stri_enc_list();                                   // DONE
SEXP stri_enc_info(SEXP enc);                           // DONE
SEXP stri_enc_set(SEXP loc);                            // DONE

SEXP stri_enc_isascii(SEXP s);                          // DONE
SEXP stri_enc_isutf8(SEXP s);                           // DONE
// @TODO: stri_enc_detect()                             // ...TODO...


SEXP stri_encode(SEXP s, SEXP from, SEXP to);           // ...
// @TODO: stri_encode_native2utf8()                     // ...TODO...
// @TODO: stri_encode_unknown2utf8()                    // ...TODO...


// uloc.cpp:
SEXP stri_locale_info(SEXP loc);                        // DONE
SEXP stri_locale_list();                                // DONE
SEXP stri_locale_set(SEXP loc);                         // DONE


// unicode_normalization.cpp:
SEXP stri_unicode_normalization(SEXP s, SEXP type);


// wrap.cpp
SEXP stri_wrap_greedy(SEXP count, int width, int spacecost);
SEXP stri_wrap_dynamic(SEXP count, int width, int spacecost);
SEXP stri_wrap(SEXP wordslist,SEXP method,SEXP width,SEXP spacecost);




// ------------------------------------------------------------------------



#endif
