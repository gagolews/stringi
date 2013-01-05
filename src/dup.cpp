#include "stringi.h"


/* The function is vectorized over s and c
   if s is NA or c is NA the result will be NA
   if c<0 the result will be NA
   if c==0 the result will be an empty string
   if s or c is an empty vector then the result is an empty vector
*/
SEXP stri_dup(SEXP s, SEXP c)
{
   R_len_t ns = LENGTH(s);
   R_len_t nc = LENGTH(c);
   if (ns <= 0 || nc <= 0)
      return allocVector(STRSXP, 0);
   
   R_len_t nm = max(ns, nc);
      
   int* cc = INTEGER(c);
   
   R_len_t maxsize = 0;
   for (int i=0; i<ns; ++i)
   {
      SEXP curs = STRING_ELT(s, i);
      if (curs == NA_STRING) continue;
      R_len_t cursl = LENGTH(curs);
      
      
      for (int j=i; j<nm; j+=ns)
      {
         R_len_t curc = cc[j%nc];
         if (curc == NA_INTEGER) continue;
         // don't care if curc <= 0 (won't change)
         
         if (cursl*curc > maxsize) maxsize = cursl*curc;
      }
   }
   
   SEXP e;
   PROTECT(e = allocVector(STRSXP, nm));
   char* buf = Calloc(maxsize, char); // thread-safe
   for (int i=0; i<ns; ++i)
   {
      SEXP ss = STRING_ELT(s, i);
      if (ss != NA_STRING)
      {
         const char* si = CHAR(ss);
         R_len_t ni = LENGTH(ss);
         
         // if last ci <= currect ci, the buffer will be reused
         char* buf2 = buf;
         int k = 0;
         for (int j=i; j<nm; j+=ns)
         {  
            int ci = cc[j%nc];
            if (ci != NA_INTEGER && ci >= 0)
            {
               if (k > ci) { 
                  buf2=buf2-(k-ci)*ni;
                  k=ci;
               } // don't reuse previous
               else {
                  for (; k<ci; ++k) {
                     memcpy(buf2, si, ni);
                     buf2 += ni;
                  }
               }
               SET_STRING_ELT(e, j, mkCharLen(buf, ci*ni));
            }
            else
               SET_STRING_ELT(e, j, NA_STRING);
         }
      }
      else
      {
         for (int j=i; j<nm; j+=ns)
            SET_STRING_ELT(e, j, NA_STRING);
      }
   }
   UNPROTECT(1);
   Free(buf);
   return e;
}
