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
   {"stri_flatten",                 (DL_FUNC)&stri_flatten,                1},
   {"stri_getinfo",                 (DL_FUNC)&stri_getinfo,                0},
   {"stri_join2",                   (DL_FUNC)&stri_join2,                  2},
   {"stri_numbytes",                (DL_FUNC)&stri_numbytes,               1},
   {"stri_prepare_arg_string",      (DL_FUNC)&stri_prepare_arg_string,     1},
   {"stri_prepare_arg_integer",     (DL_FUNC)&stri_prepare_arg_integer,    1},
   {"stri_trim",                    (DL_FUNC)&stri_trim,                   1},
   {"stri_ucnv_enclist",            (DL_FUNC)&stri_ucnv_enclist,           0},
   {"stri_ucnv_encinfo",            (DL_FUNC)&stri_ucnv_encinfo,           1},
   {"stri_ucnv_encode",             (DL_FUNC)&stri_ucnv_encode,            3},
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

//   cerr << "DEBUG: ICU4R start locale=\"" << uloc_getDefault() << "\"" << endl;
//   cerr << "DEBUG: ICU4R changing default locale manually..." << endl;
//   UErrorCode err = U_ZERO_ERROR;
//   uloc_setDefault("de_DE", &err);
//   if (U_FAILURE(err)) warning("ICU4R: Couldn't set default locale");
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

