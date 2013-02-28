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
 
 
#ifndef __messages_h
#define __messages_h

/// inccorect uchar class id, see stri_char_getpropertyid and stri_char_getcategoryid
#define MSG__INCORRECT_UCHAR_CLASS_ID \
   "incorrect class identifier"

/// warning when applying recycling rule to not fully recycled args
#define MSG__WARN_RECYCLING_RULE \
   "longer object length is not a multiple of shorter object length"

#define MSG__INCORRECT_INTERNAL_ARG \
   "incorrect argument"

#define MSG__EXPECTED_CHARACTER \
   "incorrect argument: character vector expected"

#define MSG__EXPECTED_DOUBLE \
   "incorrect argument: double vector expected"

#define MSG__EXPECTED_INTEGER \
   "incorrect argument: integer vector expected"
   
#define MSG__EXPECTED_LOGICAL \
   "incorrect argument: logical vector expected"

#define MSG__LOCALE_ERROR_SET \
   "could not set locale"

#define MSG__LOCALE_INCORRECT_ID \
   "incorrect locale identifier"

#define MSG__LOCALE_ATTEMPT_SET_GE1 \
   "only one locale specifier supported. taking first"
   
#endif
