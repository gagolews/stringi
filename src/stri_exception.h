/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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

#ifndef __stri_exception_h
#define __stri_exception_h


#define STRI__ERROR_HANDLER_BEGIN try {

#define STRI__ERROR_HANDLER_END(cleanup) \
   } \
   catch (StriException e) { \
      cleanup; \
      e.throwRerror(); \
      return R_NilValue; /* to avoid compiler warning */ \
   }



#define StriException_BUFSIZE 1024


/**
 * Class representing exceptions
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-16)
 */
class StriException {

private:

   char* msg; ///< message to be passed to error(); allocated by R_alloc -> freed automatically

public:

   StriException(const char* format, ...) {
      msg = R_alloc(StriException_BUFSIZE, (int)sizeof(char));
      va_list args;
      va_start(args, format);
      vsprintf(msg, format, args);
      va_end(args);
   }

   StriException(UErrorCode status) {
      msg = R_alloc(StriException_BUFSIZE, (int)sizeof(char));
      sprintf(msg, MSG__ICU_ERROR, getICUerrorName(status), u_errorName(status));
   }


   void throwRerror() {
      Rf_error(msg);
   }

   static const char* getICUerrorName(UErrorCode status);

};

#endif
