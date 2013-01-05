#include "stringi.h"


/* 
   vectorized over s
   if s is NA the result will be NA
   
   TO DO: Encoding marking!
   TO DO: USE C API (no UnicodeString....)
*/
SEXP stri_trim(SEXP s)
{
   R_len_t ns = LENGTH(s);
   SEXP e;
   PROTECT(e = allocVector(STRSXP, ns));
   string y;
   for (int i=0; i<ns; ++i)
   {
      SEXP ss = STRING_ELT(s, i);
      if (ss == NA_STRING)
         SET_STRING_ELT(e, i, NA_STRING);
      else {
         UnicodeString xu = UnicodeString::fromUTF8(StringPiece(CHAR(ss)));
         xu.trim();
         xu.toUTF8String(y);
         SET_STRING_ELT(e, i, mkCharLen(y.c_str(), y.length()));
         if (i < ns-1) y.clear();
      }
   }
   UNPROTECT(1);
   return e;
}
