#include "stringi.h"


SEXP stri_getinfo()
{
   const R_len_t infosize = 10;
   SEXP vals;
   SEXP names;
   PROTECT(names = allocVector(STRSXP, infosize));
   SET_STRING_ELT(names, 0, mkChar("Locale.language"));
   SET_STRING_ELT(names, 1, mkChar("Locale.country"));  
   SET_STRING_ELT(names, 2, mkChar("Locale.variant"));   
   SET_STRING_ELT(names, 3, mkChar("Locale.name"));
   SET_STRING_ELT(names, 4, mkChar("Charset.internal"));
   SET_STRING_ELT(names, 5, mkChar("Charset.native.ICU"));
   SET_STRING_ELT(names, 6, mkChar("Charset.native.MIME"));
   SET_STRING_ELT(names, 7, mkChar("Charset.native.IANA"));   
   SET_STRING_ELT(names, 8, mkChar("Charset.native.mincharsize"));
   SET_STRING_ELT(names, 9, mkChar("Charset.native.maxcharsize"));
   
   PROTECT(vals = allocVector(STRSXP, infosize));
   for (int i=0; i<infosize; ++i) 
      SET_STRING_ELT(vals, i, NA_STRING);
      
   Locale loc = Locale::getDefault();
   SET_STRING_ELT(vals, 0, mkChar(loc.getLanguage()));
   SET_STRING_ELT(vals, 1, mkChar(loc.getCountry()));
   SET_STRING_ELT(vals, 2, mkChar(loc.getVariant()));
   SET_STRING_ELT(vals, 3, mkChar(loc.getName()));
   SET_STRING_ELT(vals, 4, mkChar("UTF-8"));
   SET_STRING_ELT(vals, 5, mkChar(ucnv_getDefaultName()));

   UErrorCode err = U_ZERO_ERROR;
   UConverter* uconv = ucnv_open(NULL, &err);
   if (U_FAILURE(err)) { warning("ICU4R: Couldn't open default UConverter"); }
   else {
      SET_STRING_ELT(vals, 8, mkChar(SSTR((int)ucnv_getMinCharSize(uconv)).c_str()));
      SET_STRING_ELT(vals, 9, mkChar(SSTR((int)ucnv_getMaxCharSize(uconv)).c_str()));

      const char* stdname;
      err = U_ZERO_ERROR;
      stdname = ucnv_getStandardName(ucnv_getDefaultName(), "MIME", &err);
      if (U_FAILURE(err)) warning("Couldn't get locale display name");
      else SET_STRING_ELT(vals, 6, mkChar(stdname));
      
      
      err = U_ZERO_ERROR;
      stdname = ucnv_getStandardName(ucnv_getDefaultName(), "IANA", &err);
      if (U_FAILURE(err)) warning("Couldn't get locale display name");
      else SET_STRING_ELT(vals, 7, mkChar(stdname));
      
      
      ucnv_close(uconv);
   }
   setAttrib(vals, R_NamesSymbol, names);
   UNPROTECT(2);
   return vals;
}
