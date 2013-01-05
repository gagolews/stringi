#include "stringi.h"






static const R_CallMethodDef cCallMethods[] = {
   {"stri_trim", (DL_FUNC)&stri_trim, 1},
   {"stri_dup", (DL_FUNC)&stri_dup, 2},
   {"stri_join2", (DL_FUNC)&stri_join2, 2},
   {"stri_flatten", (DL_FUNC)&stri_flatten, 1},
   {"stri_unicode_normalization", (DL_FUNC)&stri_unicode_normalization, 2},
   {"stri_casefold", (DL_FUNC)&stri_casefold, 2},
   {"stri_getinfo", (DL_FUNC)&stri_getinfo, 0},
   {"stri_prepare_arg_string", (DL_FUNC)&stri_prepare_arg_string, 1},
   {"stri_casecompare", (DL_FUNC)&stri_casecompare, 2},
   {NULL, NULL, 0}
};


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


extern "C" void  R_unload_stringi(DllInfo *info)
{
#ifndef NDEBUG
   cerr << "DEBUG: Dynamic library 'stringi' unloaded." << endl;
#endif
}

