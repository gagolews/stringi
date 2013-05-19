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
 * Detect if a pattern occurs in a string [string search with collation]
 * @param str character vector
 * @param pattern character vector
 * @return logical vector
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF16 & ICU Collation
 */
//SEXP stri_detect_fixed(SEXP str, SEXP pattern) // v0.2 - ongoing.....
//{
//   //   const char* qloc = stri__prepare_arg_locale(locale, "locale", true);
//   Locale loc = Locale::createFromName("pl_PL"/*qloc*/);
//   
//   str = stri_prepare_arg_string(str, "str");
//   pattern = stri_prepare_arg_string(pattern, "pattern");
//   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
//   
//   SEXP ret;
//   PROTECT(ret = allocVector(LGLSXP, nmax));
// 
//   StriContainerUTF16* ss = new StriContainerUTF16(str, nmax);
//   StriContainerUTF16* pp = new StriContainerUTF16(pattern, nmax);
//   UErrorCode err = U_ZERO_ERROR;
//   
////   const UnicodeString* last_str = NULL;
////   const UnicodeString* last_pat = NULL;
////   err = U_ZERO_ERROR;
////   StringSearch *matcher = NULL;
////   
////   if (!U_SUCCESS(err))
////      error(MSG__STRSEARCH_FAILED);
////   
////   for (R_len_t i = pp->vectorize_init();
////         i != pp->vectorize_end();
////         i = pp->vectorize_next(i))
////   {
////      if (pp->isNA(i) || ss->isNA(i)) {
////         LOGICAL(ret)[i] = NA_LOGICAL;
////      }
////      else {
////         const UnicodeString* cur_str = &(ss->get(i));
////         const UnicodeString* cur_pat = &(pp->get(i));
////         
//////         if (!matcher) {
//////            err = U_ZERO_ERROR;
//////            last_pat = cur_pat;
//////            last_str = cur_str;
//////            matcher = new StringSearch(*last_pat, *last_str, loc, NULL, err);
//////            if (!U_SUCCESS(err))
//////               error(MSG__STRSEARCH_FAILED);
//////            matcher->getCollator()->setAttribute(UCOL_STRENGTH, UCOL_IDENTICAL, err);
//////            if (!U_SUCCESS(err))
//////               error(MSG__STRSEARCH_FAILED);
//////         }
//////   
//////         if (cur_pat != last_pat) {
//////            last_pat = cur_pat;
//////            err = U_ZERO_ERROR;
//////            matcher->setPattern(*last_pat, err);
//////            if (!U_SUCCESS(err))
//////               error(MSG__STRSEARCH_FAILED);
//////         }
//////   
//////         if (cur_str != last_str) {
//////            last_str = cur_str;
//////            err = U_ZERO_ERROR;
//////            matcher->setText(*last_str, err);
//////            if (!U_SUCCESS(err))
//////               error(MSG__STRSEARCH_FAILED);
//////         }
//////         
//////         matcher->reset();
//////         err = U_ZERO_ERROR;
//////         int found = ((int)matcher->first(err) != USEARCH_DONE);
////         
////         if (!U_SUCCESS(err))
////            error(MSG__STRSEARCH_FAILED);
////            
////         LOGICAL(ret)[i] = 0;
////         
////      }
////   }
//   
//   delete ss;
//   delete pp;
////   if (matcher) delete matcher;
//   UNPROTECT(1);
//   return ret;
//}




SEXP stri_detect_fixed(SEXP s, SEXP pattern) // Old version (0.1)
{
   s = stri_prepare_arg_string(s, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   int ns = LENGTH(s);
   int np = LENGTH(pattern);
   if (ns <= 0 || np <= 0) return allocVector(LGLSXP, 0);
   int nmax = stri__recycling_rule(true, 2, ns, np);
   
   SEXP e;
   PROTECT(e = allocVector(LGLSXP, nmax));
   SEXP curs,curpat;
   int k=0,curslen,curpatlen;
   
   for (int i=0; i<nmax; ++i) {
      curs = STRING_ELT(s, i % ns);
      curpat = STRING_ELT(pattern, i % np);
      
      if(curs == NA_STRING || curpat == NA_STRING){
         LOGICAL(e)[i] = NA_LOGICAL;
         continue;
      }
      
      curslen = LENGTH(curs);
      curpatlen = LENGTH(curpat);
      const char* string = CHAR(curs);
      const char* spat = CHAR(curpat);
      
      LOGICAL(e)[i] = false;
      for(int j=0; j<curslen; ++j){
         k=0;
         while(string[j+k]==spat[k] && k<curpatlen)
            k++;
   		if(k==curpatlen){
            LOGICAL(e)[i] = true;
            //if match then skip and check next element of s
            break;
   		}
   	}
   }
   UNPROTECT(1);
   return e;
}

