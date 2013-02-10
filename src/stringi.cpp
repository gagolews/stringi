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
 
#include "stringi.h"





/**
 * List of functions available in R via .Call()
 * 
 * \code{\{"method_name", (DL_FUNC)pointer, number_of_args\}}
 */
static const R_CallMethodDef cCallMethods[] = {
   
   {"stri_casecompare",                (DL_FUNC)&stri_casecompare,                2},
   {"stri_casefold",                   (DL_FUNC)&stri_casefold,                   2},
   {"stri_charcategories",             (DL_FUNC)&stri_charcategories,             0},
   {"stri_chartype",                   (DL_FUNC)&stri_chartype,                   1},
   {"stri_char_getcategoryid",         (DL_FUNC)&stri_char_getcategoryid,         1},
   {"stri_char_getpropertyid",         (DL_FUNC)&stri_char_getpropertyid,         1},
   {"stri_dup",                        (DL_FUNC)&stri_dup,                        2},
   {"stri_enclist",                    (DL_FUNC)&stri_enclist,                    0},
   {"stri_encinfo",                    (DL_FUNC)&stri_encinfo,                    1},
   {"stri_encset",                     (DL_FUNC)&stri_encset,                     1},
   {"stri_encode",                     (DL_FUNC)&stri_encode,                     3},
   {"stri_flatten",                    (DL_FUNC)&stri_flatten,                    2},
   {"stri_info",                       (DL_FUNC)&stri_info,                       0},
   {"stri_join",                       (DL_FUNC)&stri_join,                       1},
   {"stri_join2",                      (DL_FUNC)&stri_join2,                      2},
   {"stri_length",                     (DL_FUNC)&stri_length,                     1},
   {"stri_localeinfo",                 (DL_FUNC)&stri_localeinfo,                 1},
   {"stri_localelist",                 (DL_FUNC)&stri_localelist,                 0},
   {"stri_localeset",                  (DL_FUNC)&stri_localeset,                  1},
   {"stri_locate_all_class",           (DL_FUNC)&stri_locate_all_class,           2},
   {"stri_locate_first_or_last_class", (DL_FUNC)&stri_locate_first_or_last_class, 3},
   {"stri_numbytes",                   (DL_FUNC)&stri_numbytes,                   1},
   {"stri_pad",                        (DL_FUNC)&stri_pad,                        4},
   {"stri_prepare_arg_string",         (DL_FUNC)&stri_prepare_arg_string,         1},
   {"stri_prepare_arg_integer",        (DL_FUNC)&stri_prepare_arg_integer,        1},
   {"stri_prepare_arg_logical",        (DL_FUNC)&stri_prepare_arg_logical,        1},
   {"stri_split_fixed",		   			(DL_FUNC)&stri_split_fixed,		    	    3},
   {"stri_split_pos",   	   			(DL_FUNC)&stri_split_pos,  		    	    3},
   {"stri_trim",                       (DL_FUNC)&stri_trim,                       1},
   {"stri_unicode_normalization",      (DL_FUNC)&stri_unicode_normalization,      2},
   {"stri_wrap",                       (DL_FUNC)&stri_wrap,                       4},
   {"stri_wrap_greedy",                (DL_FUNC)&stri_wrap_greedy,                3},
   {"stri_wrap_dynamic",               (DL_FUNC)&stri_wrap_dynamic,               3},
   
   // the list must be NULL-terminated:
   {NULL,                           NULL,                                         0}

};



/**
 * Library initialization.
 * 
 * R calls this automatically on lib load/attach.
 */
extern "C" void R_init_stringi(DllInfo *dll)
{
   R_registerRoutines(dll, NULL, cCallMethods, NULL, NULL);
   R_useDynamicSymbols(dll, Rboolean(FALSE));
   
#ifndef NDEBUG
   cerr << "DEBUG: Dynamic library 'stringi' loaded." << endl;
#endif
}




///**
// * ... not needed ...
// */
//extern "C" void  R_unload_stringi(DllInfo *info)
//{
//#ifndef NDEBUG
//   cerr << "DEBUG: Dynamic library 'stringi' unloaded." << endl;
//#endif
//}

