#include "stringi.h"



/* 
   vectorized over s
   if s is NA the result will be NA
   
   TO DO: WHAT IF s is not in UTF-8???
*/
SEXP stri_unicode_normalization(SEXP s, SEXP type)
{
   UErrorCode err = U_ZERO_ERROR;
   const Normalizer2* nfc = NULL;
   int _type = INTEGER(type)[0];
   switch (_type) {
      case 10:
         nfc = Normalizer2::getNFCInstance(err);
         break;
      case 20:
         nfc = Normalizer2::getNFDInstance(err);
         break;
      case 11:
         nfc = Normalizer2::getNFKCInstance(err);
         break;
      case 21:
         nfc = Normalizer2::getNFKDInstance(err);
         break;
      case 12:
         nfc = Normalizer2::getNFKCCasefoldInstance(err);
         break;
      default:
         error("stri_unicode_normalization: incorrect Unicode normalization type");
   }
   if (U_FAILURE(err)) {
      error("ICU4R: could not get Normalizer2 instance");
   }
   
   R_len_t ns = LENGTH(s);
   SEXP e;   
   PROTECT(e = allocVector(STRSXP, ns));
   string y;
   UnicodeString out;
   
   for (int i=0; i<ns; ++i)
   {
      SEXP ss = STRING_ELT(s, i);
      if (ss == NA_STRING)
         SET_STRING_ELT(e, i, NA_STRING);
      else {
         UnicodeString xu = UnicodeString::fromUTF8(StringPiece(CHAR(ss)));
         err = U_ZERO_ERROR;
         nfc->normalize(xu, out, err);
         if (U_FAILURE(err)) {
            error("ICU4R: could not normalize a string with current Normalizer2 instance");
         }
         out.toUTF8String(y);
         SET_STRING_ELT(e, i, mkCharLen(y.c_str(), y.length()));
         if (i < ns-1) y.clear();
      }
   }
   UNPROTECT(1);
   return e;
}

