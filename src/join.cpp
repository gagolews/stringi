#include "stringi.h"



/* vectorized over s1 and s2 

   optimized for s1 longer than s2
   if s1 or s2 is NA then result is NA
   if s1 or s2 is empty, then the result is just s1 or s2
   
   unfortunately, this is slower than paste()...
   
   What if s1 and s2 are of different encodings?
*/
SEXP stri_join2(SEXP s1, SEXP s2)
{
   R_len_t ns1 = LENGTH(s1);
   R_len_t ns2 = LENGTH(s2);
   if (ns1 <= 0) return s2;
   else if (ns2 <= 0) return s1;
   R_len_t nsm = max(ns1, ns2);
   
   R_len_t maxsize = 0;
   for (int i=0; i<ns1; ++i)
   {
      SEXP curs1 = STRING_ELT(s1, i);
      if (curs1 == NA_STRING) continue;
      R_len_t cnsl = LENGTH(curs1);
      
      
      for (int j=i; j<nsm; j+=ns1)
      {
         SEXP curs2 = STRING_ELT(s2, j%ns2);
         if (curs2 == NA_STRING) continue;
         R_len_t cns2 = LENGTH(curs2);
         
         if (cnsl+cns2 > maxsize) maxsize = cnsl+cns2;
      }
   }
   
   SEXP e;
   PROTECT(e = allocVector(STRSXP, nsm));
   char* buf = Calloc(maxsize, char); // to be thread-safe
   for (int i=0; i<ns1; ++i)
   {
      SEXP ss1 = STRING_ELT(s1, i);
      if (ss1 != NA_STRING)
      {
         const char* si1 = CHAR(ss1);
         R_len_t sn1 = LENGTH(ss1);
         memcpy(buf, si1, sn1);
         char* buf2 = buf + sn1;
            
         for (int j=i; j<nsm; j+=ns1)
         {  
            SEXP ss2 = STRING_ELT(s2, j%ns2);
            if (ss2 != NA_STRING)
            {
               const char* si2 = CHAR(ss2);
               R_len_t sn2 = LENGTH(ss2);
               memcpy(buf2, si2, sn2);
               SET_STRING_ELT(e, j, mkCharLen(buf, sn1+sn2));
            }
            else
               SET_STRING_ELT(e, j, NA_STRING);
         }
      }
      else
      {
         for (int j=i; j<nsm; j+=ns1)
            SET_STRING_ELT(e, j, NA_STRING);
      }
   }
   Free(buf);
   UNPROTECT(1);
   return e;
}


/* TO DO: Encoding marking!

   if any of s is NA, the result will be NA_char_
*/
SEXP stri_flatten(SEXP s)
{
   R_len_t ns = LENGTH(s);
   if (ns <= 0) return s;
   
   SEXP e;
   PROTECT(e = allocVector(STRSXP, 1));
   
   R_len_t totalsize = 0;
   for (int i=0; i<ns; ++i)
   {
      SEXP curs = STRING_ELT(s, i);
      if (curs == NA_STRING)
      {
         SET_STRING_ELT(e, 0, NA_STRING);
         UNPROTECT(1);
         return e;
      }
      totalsize += LENGTH(curs);
   }
   
   char* buf = Calloc(totalsize, char); // to be thread-safe
   char* buf2 = buf;
   for (int i=0; i<ns; ++i)
   {
      SEXP ss = STRING_ELT(s, i);
      int ni = LENGTH(ss);
      memcpy(buf2, CHAR(ss), ni);
      buf2 += ni;
   }
   SET_STRING_ELT(e, 0, mkCharLen(buf, totalsize));
   Free(buf);
   UNPROTECT(1);
   return e;
}

