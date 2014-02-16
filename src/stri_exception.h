/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
