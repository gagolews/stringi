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
 * .... 
 * @param s ...
 * @param pattern ...
 * @param replacement ...
 * @return ...
 */
SEXP stri_replace_all_fixed(SEXP s, SEXP pat, SEXP rep)
{
   s   = stri_prepare_arg_string(s);
   pat = stri_prepare_arg_string(pat);
   rep = stri_prepare_arg_string(rep);
   int ns   = LENGTH(s);
   int npat = LENGTH(pat);
   int nrep = LENGTH(rep);
   //if any length is 0 then return empty vector
   if (ns==0 || npat==0 || nrep==0)
      return allocVector(STRSXP, 0);
   int nmax = ns;
   if(npat>nmax) nmax=npat;
   if(nrep>nmax) nmax=nrep;
   //if (nmax % ns != 0 || nmax % npat != 0 || nmax % nrep != 0)
   //   warning(MSG__WARN_RECYCLING_RULE);
   int count = 0;
   SEXP e, split, omit, temp, currep;
   PROTECT(e = allocVector(STRSXP,nmax));
   PROTECT(omit = allocVector(LGLSXP,1));
   PROTECT(currep = allocVector(STRSXP,1));
   LOGICAL(omit)[0] = false;
   //if max(ns,npat) % ns || % npat != 0 then inside stri_split we get warn
   split = stri_split_fixed(s,pat,omit);
   int nsplit = LENGTH(split), nm=ns;
   if(npat > nm) nm=npat;
   if((nm%ns==0 && nm%npat==0) && nmax%nm !=0)
      warning(MSG__WARN_RECYCLING_RULE);
   int k=0,curslen,st,add,where;
   for (int i=0; i<nmax; ++i) {
      temp = VECTOR_ELT(split, i % nsplit);
      SET_STRING_ELT(currep,0,STRING_ELT(rep,i % nrep));
      SET_STRING_ELT(e, i, STRING_ELT(stri_flatten(temp,currep),0));
   }
   UNPROTECT(3);
   return e;
}
