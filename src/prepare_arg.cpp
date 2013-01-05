#include "stringi.h"

SEXP stri_prepare_arg_string(SEXP x)
{
   if (isString(x))
      return x;
   if (isFactor(x))
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
		x = eval(call, R_GlobalEnv);
		UNPROTECT(1);
      return x;
   }
   if (isVectorAtomic(x))
      return coerceVector(x,STRSXP);
   if (isSymbol(x))
      return ScalarString(PRINTNAME(x));
      
   error("expected a character vector on input (or something easily coercible to)");
   return x; // avoid compiler warning
}
