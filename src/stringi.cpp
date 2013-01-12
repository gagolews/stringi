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





/**
 * List of functions available in R via .Call()
 * 
 * \code{\{"method_name", (DL_FUNC)pointer, number_of_args\}}
 */
static const R_CallMethodDef cCallMethods[] = {
   
   {"stri_casecompare",             (DL_FUNC)&stri_casecompare,            2},
   {"stri_casefold",                (DL_FUNC)&stri_casefold,               2},
   {"stri_dup",                     (DL_FUNC)&stri_dup,                    2},
   {"stri_enclist",                 (DL_FUNC)&stri_enclist,                0},
   {"stri_encinfo",                 (DL_FUNC)&stri_encinfo,                1},
   {"stri_encode",                  (DL_FUNC)&stri_encode,                 3},
   {"stri_flatten",                 (DL_FUNC)&stri_flatten,                1},
   {"stri_info",                    (DL_FUNC)&stri_info,                   0},
   {"stri_join2",                   (DL_FUNC)&stri_join2,                  2},
   {"stri_localeinfo",              (DL_FUNC)&stri_localeinfo,             1},
   {"stri_localelist",              (DL_FUNC)&stri_localelist,             0},
   {"stri_numbytes",                (DL_FUNC)&stri_numbytes,               1},
   {"stri_prepare_arg_string",      (DL_FUNC)&stri_prepare_arg_string,     1},
   {"stri_prepare_arg_integer",     (DL_FUNC)&stri_prepare_arg_integer,    1},
   {"stri_split_fixed",					(DL_FUNC)&stri_split_fixed,				2},
   {"stri_trim",                    (DL_FUNC)&stri_trim,                   1},
   {"stri_unicode_normalization",   (DL_FUNC)&stri_unicode_normalization,  2},
   {"stri_wrap_greedy",             (DL_FUNC)&stri_wrap_greedy,            3},
   {"stri_wrap_dynamic",            (DL_FUNC)&stri_wrap_dynamic,           3},
   
   // the list must be NULL-terminated:
   {NULL,                           NULL,                                  0}

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

