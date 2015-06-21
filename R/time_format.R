## This file is part of the 'stringi' package for R.
## Copyright (C) 2013-2015, Marek Gagolewski and Bartek Tartanus
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice,
## this list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
## this list of conditions and the following disclaimer in the documentation
## and/or other materials provided with the distribution.
##
## 3. Neither the name of the copyright holder nor the names of its
## contributors may be used to endorse or promote products derived from
## this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
## BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
## FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
## OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
## WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
## OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
## EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#' @title
#' [DRAFT API] Date and Time Formatting and Parsing
#'
#' @description
#' These functions convert a given date/time object
#' to a character vector or conversely.
#'
#' @details
#' Vectorized over \code{time} or \code{str}.
#'
#' By default, \code{stri_datetime_format} (unlike \code{format.POSIXst})
#' formats a date/time object using the current default time zone.
#' This is for the sake of compatibility with the \code{\link{strftime}} function.
#'
#' \code{format} may be one of \code{DT_STYLE} or \code{DT_relative_STYLE},
#' where \code{DT} is equal to \code{date}, \code{time}, or \code{datetime},
#' and \code{STYLE} is equal to \code{full}, \code{long}, \code{medium}, or \code{short}.
#' This gives a locale-dependent date and/or time format.
#' Note that currently \pkg{ICU} does not support \code{relative} \code{time} formats,
#' so this flag is currently ignored in such a context.
#'
#' Otherwise, \code{format} is a pattern:
#' a string, where specific sequences of characters are replaced
#' with date and time data from a calendar when formatting or used
#' to generate data for a calendar when parsing.
#' For example, \code{y} stands for the year. Characters
#' may be used multiple times. For instance, if \code{y} is used for the year,
#' \code{yy} might produce \code{99}, whereas \code{yyyy} produces \code{1999}.
#' For most numerical fields, the number of characters specifies
#' the field width. For example, if \code{h} is the hour, \code{h} might
#' produce \code{5}, but \code{hh} produces \code{05}.
#' For some characters, the count specifies whether an abbreviated
#' or full form should be used, but may have other choices, as given below.
#'
#' Two single quotes represent a literal single quote, either
#' inside or outside single quotes. Text within single quotes
#' is not interpreted in any way (except for two adjacent single quotes).
#' Otherwise all ASCII letter from \code{a} to \code{z} and \code{A} to \code{Z}
#' are reserved as syntax characters, and require quoting if
#' they are to represent literal characters. In addition, certain
#' ASCII punctuation characters may become variable in the future
#' (eg \code{:} being interpreted as the time separator and \code{/}
#' as a date separator, and replaced by respective
#' locale-sensitive characters in display).
#'
#' \tabular{llll}{
#' \bold{Symbol} \tab \bold{Meaning} \tab \bold{Example(s)} \tab \bold{Output} \cr
#' G \tab era designator \tab G, GG, or GGG \tab AD \cr
#'  \tab  \tab GGGG \tab Anno Domini \cr
#'  \tab  \tab GGGGG \tab A \cr
#' y \tab year \tab yy \tab 96 \cr
#'  \tab  \tab y or yyyy \tab 1996 \cr
# Y \tab year of "Week of Year" \tab Y \tab 1997 \cr
#' u \tab extended year \tab u \tab 4601 \cr
#' U \tab cyclic year name, as in Chinese lunar calendar \tab U \tab \cr
#' r \tab related Gregorian year \tab r \tab 1996 \cr
#' Q \tab quarter \tab Q or QQ \tab 02 \cr
#'  \tab  \tab QQQ \tab Q2 \cr
#'  \tab  \tab QQQQ \tab 2nd quarter \cr
#'  \tab  \tab QQQQQ \tab 2 \cr
#' q \tab Stand Alone quarter \tab q or qq \tab 02 \cr
#'  \tab  \tab qqq \tab Q2 \cr
#'  \tab  \tab qqqq \tab 2nd quarter \cr
#'  \tab  \tab qqqqq \tab 2 \cr
#' M \tab month in year \tab M or MM \tab 09 \cr
#'  \tab  \tab MMM \tab Sep \cr
#'  \tab  \tab MMMM \tab September \cr
#'  \tab  \tab MMMMM \tab S \cr
#' L \tab Stand Alone month in year \tab L or LL \tab 09 \cr
#'  \tab  \tab LLL \tab Sep \cr
#'  \tab  \tab LLLL \tab September \cr
#'  \tab  \tab LLLLL \tab S \cr
#' w \tab week of year \tab w or ww \tab 27 \cr
#' W \tab week of month \tab W \tab 2 \cr
#' d \tab day in month \tab d \tab 2 \cr
#'  \tab  \tab dd \tab 02 \cr
#' D \tab day of year \tab D \tab 189 \cr
#' F \tab day of week in month \tab F \tab 2 (2nd Wed in July) \cr
#' g \tab modified Julian day \tab g \tab 2451334 \cr
#' E \tab day of week \tab E, EE, or EEE \tab Tue \cr
#'  \tab  \tab EEEE \tab Tuesday \cr
#'  \tab  \tab EEEEE \tab T \cr
#'  \tab  \tab EEEEEE \tab Tu \cr
#' e \tab local day of week \tab e or ee \tab 2 \cr
#'  \tab  example: if Monday is 1st day, Tuesday is 2nd )  \tab eee \tab Tue \cr
#'  \tab  \tab eeee \tab Tuesday \cr
#'  \tab  \tab eeeee \tab T \cr
#'  \tab  \tab eeeeee \tab Tu \cr
#' c \tab Stand Alone local day of week \tab c or cc \tab 2 \cr
#'  \tab  \tab ccc \tab Tue \cr
#'  \tab  \tab cccc \tab Tuesday \cr
#'  \tab  \tab ccccc \tab T \cr
#'  \tab  \tab cccccc \tab Tu \cr
#' a \tab am/pm marker \tab a \tab pm \cr
#' h \tab hour in am/pm (1~12) \tab h \tab 7 \cr
#'  \tab  \tab hh \tab 07 \cr
#' H \tab hour in day (0~23) \tab H \tab 0 \cr
#'  \tab  \tab HH \tab 00 \cr
#' k \tab hour in day (1~24) \tab k \tab 24 \cr
#'  \tab  \tab kk \tab 24 \cr
#' K \tab hour in am/pm (0~11) \tab K \tab 0 \cr
#'  \tab  \tab KK \tab 00 \cr
#' m \tab minute in hour \tab m \tab 4 \cr
#'  \tab  \tab mm \tab 04 \cr
#' s \tab second in minute \tab s \tab 5 \cr
#'  \tab  \tab ss \tab 05 \cr
#' S \tab fractional second - truncates (like other time fields)  \tab S \tab 2 \cr
#'  \tab to the count of letters when formatting. Appends  \tab SS \tab 23 \cr
#'  \tab zeros if more than 3 letters specified. Truncates at  \tab SSS \tab 235 \cr
#'  \tab three significant digits when parsing.  \tab SSSS \tab 2350 \cr
#' A \tab milliseconds in day \tab A \tab 61201235 \cr
#' z \tab Time Zone: specific non-location \tab z, zz, or zzz \tab PDT \cr
#'  \tab  \tab zzzz \tab Pacific Daylight Time \cr
#' Z \tab Time Zone: ISO8601 basic hms? / RFC 822 \tab Z, ZZ, or ZZZ \tab -0800 \cr
#'  \tab Time Zone: long localized GMT (=OOOO) \tab ZZZZ \tab GMT-08:00 \cr
#'  \tab Time Zone: ISO8601 extended hms? (=XXXXX) \tab ZZZZZ \tab -08:00, -07:52:58, Z \cr
#' O \tab Time Zone: short localized GMT \tab O \tab GMT-8 \cr
#'  \tab Time Zone: long localized GMT (=ZZZZ) \tab OOOO \tab GMT-08:00 \cr
#' v \tab Time Zone: generic non-location \tab v \tab PT \cr
#'  \tab (falls back first to VVVV) \tab vvvv \tab Pacific Time or Los Angeles Time \cr
#' V \tab Time Zone: short time zone ID \tab V \tab uslax \cr
#'  \tab Time Zone: long time zone ID \tab VV \tab America/Los_Angeles \cr
#'  \tab Time Zone: time zone exemplar city \tab VVV \tab Los Angeles \cr
#'  \tab Time Zone: generic location (falls back to OOOO) \tab VVVV \tab Los Angeles Time \cr
#' X \tab Time Zone: ISO8601 basic hm?, with Z for 0 \tab X \tab -08, +0530, Z \cr
#'  \tab Time Zone: ISO8601 basic hm, with Z \tab XX \tab -0800, Z \cr
#'  \tab Time Zone: ISO8601 extended hm, with Z \tab XXX \tab -08:00, Z \cr
#'  \tab Time Zone: ISO8601 basic hms?, with Z \tab XXXX \tab -0800, -075258, Z \cr
#'  \tab Time Zone: ISO8601 extended hms?, with Z \tab XXXXX \tab -08:00, -07:52:58, Z \cr
#' x \tab Time Zone: ISO8601 basic hm?, without Z for 0 \tab x \tab -08, +0530 \cr
#'  \tab Time Zone: ISO8601 basic hm, without Z \tab xx \tab -0800 \cr
#'  \tab Time Zone: ISO8601 extended hm, without Z \tab xxx \tab -08:00 \cr
#'  \tab Time Zone: ISO8601 basic hms?, without Z \tab xxxx \tab -0800, -075258 \cr
#'  \tab Time Zone: ISO8601 extended hms?, without Z \tab xxxxx \tab -08:00, -07:52:58 \cr
#' ' \tab escape for text \tab ' \tab (nothing) \cr
#' ' ' \tab two single quotes produce one \tab ' ' \tab '
#' }
#'
#' Note that any characters in the pattern that are not in the ranges
#' of \code{[a-z]} and \code{[A-Z]} will be treated as quoted text.
#' For instance, characters like \code{:}, \code{.}, \code{ } (a space),
#' \code{#} and \code{@@} will appear in the resulting time text
#' even they are not enclosed within single quotes. The single quote is used
#' to ``escape'' letters. Two single quotes in a row,
#' inside or outside a quoted sequence, represent a ``real'' single quote.
#'
#' Here are some examples:
#'
#' \tabular{ll}{
#' \bold{Exemplary Pattern} \tab  \bold{Result} \cr
#' yyyy.MM.dd 'at' HH:mm:ss zzz \tab 2015.12.31 at 23:59:59 GMT+1 \cr
#' EEE, MMM d, ''yy \tab czw., gru 31, '15 \cr
#' h:mm a \tab 11:59 PM \cr
#' hh 'o''clock' a, zzzz \tab 11 o'clock PM, GMT+01:00 \cr
#' K:mm a, z \tab 11:59 PM, GMT+1 \cr
#' yyyyy.MMMM.dd GGG hh:mm aaa \tab 2015.grudnia.31 n.e. 11:59 PM \cr
#' uuuu-MM-dd'T'HH:mm:ssZ \tab 2015-12-31T23:59:59+0100 (the ISO 8601 guideline) \cr
#' }
#'
#' @param time an object of class \code{\link{POSIXct}} or an object coercible to
#' @param format single string, see Details; see also \code{\link{stri_datetime_fstr}}
#' @param str character vector
#' @param tz  \code{NULL} or \code{""} for the default time zone
#' or a single string with a timezone identifier,
#' see \code{\link{stri_timezone_list}}
#' @param lenient single logical value; should date/time parsing be lenient?
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier; a non-Gregorian calendar
#' may be specified by setting the \code{@@calendar=name} keyword
#' @param ... Further arguments to be passed from or to other methods.
#'
#' @return
#' \code{stri_datetime_format} returns a character vector.
#'
#' \code{stri_datetime_parse} returns an object of class \code{\link{POSIXct}}.
#'
#' @references
#' \emph{Formatting Dates and Times} - ICU User Guide,
#' \url{http://userguide.icu-project.org/formatparse/datetime}
#'
#'
#' @examples
#' stri_datetime_parse(c("2015-02-28", "2015-02-29"), "yyyy-MM-dd")
#' stri_datetime_parse(c("2015-02-28", "2015-02-29"), "yyyy-MM-dd", lenient=TRUE)
#' stri_datetime_parse("19 lipca 2015", "date_long", locale="pl_PL")
#' stri_datetime_format(stri_datetime_now(), "datetime_relative_medium")
#'
#' @rdname stri_datetime_format
#' @family datetime
#' @export
stri_datetime_format <- function(time, format="uuuu-MM-dd HH:mm:ss", tz=NULL, locale=NULL) {
   .Call(C_stri_datetime_format, time, format, tz, locale)
}


#' @export
#' @rdname stri_datetime_format
#' @aliases stri_datetime_format
stri_datetime_parse <- function(str, format="uuuu-MM-dd HH:mm:ss", lenient=FALSE, tz=NULL, locale=NULL) {
   .Call(C_stri_datetime_parse, str, format, lenient, tz, locale)
}


#' @title
#' [DRAFT API] Convert \code{strptime}-style Format Strings
#'
#' @description
#' A function to convert \code{\link{strptime}}/\code{\link{strftime}}-style
#' format strings to \pkg{ICU} format strings that may be used
#' in \code{\link{stri_datetime_parse}} and \code{\link{stri_datetime_format}}
#' functions.
#'
#' @details
#' For more details on conversion specifiers please refer to
#' the manual page of \code{\link{strptime}}. Most of the formatters
#' of the form \code{\%x}, where \code{x} is a letter, are supported.
#' Moreover, each \code{\%\%} is replaced with \code{\%}.
#'
#' Warnings are given in case of \code{\%x}, \code{\%X}, \code{\%u}, \code{\%w},
#' \code{\%g}, \code{\%G}, \code{\%c}, \code{\%U} and \code{\%W}
#' as in such circumstances either \pkg{ICU} does not
#' support requested functionality using format-strings API
#' or there are some inconsistencies between base R and \pkg{ICU}.
#'
#' @param x character vector consisting of date/time format strings
#' @return Returns a character vector.
#'
#' @examples
#' stri_datetime_fstr("%Y-%m-%d %H:%M:%S")
#'
#' @family datetime
#' @export
stri_datetime_fstr <- function(x) {
   # %U, %W -> %V + warn
   # %x, %X -> warn
   # %u, %w -> warn

   # problematic entities:
   warn <- c('%U', '%V', '%x', '%X', '%u', '%w', '%r', '%g', '%G', '%c')
   search <- c('%U', '%W', '%g', '%G')
   needle <- c('ww', 'ww', 'yy', 'Y')

   search <- c(search, '%a',  '%A',   '%b',  '%B')
   needle <- c(needle, 'ccc', 'cccc', 'LLL', 'LLLL')

   search <- c(search, '%c',                       '%d', '%D')
   needle <- c(needle, 'eee LLL d HH:mm:ss yyyy',  'dd', 'MM/dd/yy')

   search <- c(search, '%e', '%F',          '%h',  '%H')
   needle <- c(needle, 'd',  'yyyy-MM-dd',  'MMM', 'HH')

   search <- c(search, '%I', '%j', '%m', '%M', '%n', '%p')
   needle <- c(needle, 'hh', 'D',  'MM', 'mm', '\n', 'a')

   search <- c(search, '%r',       '%R',    '%S', '%t', '%T',       '%u')
   needle <- c(needle, 'hh:mm:ss', 'HH:mm', 'ss', '\t', 'HH:mm:ss', 'c')

   search <- c(search, '%V', '%w', '%x',       '%X',       "%y", "%Y",   "%z", "%Z")
   needle <- c(needle, 'ww', 'c',  'yy/MM/dd', 'HH:mm:ss', "yy", "yyyy", "Z",  "z")

   x <- stri_replace_all_fixed(x, "'", "\\'")
   x <- stri_replace_all_fixed(x, "%%", "%!") # well, that's not very elegant...
   x <- stri_replace_all_regex(x,
      "(?:(?<=[%][A-Za-z])|^(?![%][A-Za-z]))(.+?)(?:(?<![%][A-Za-z])$|(?=[%][A-Za-z]))",
      "'$1'")
   if (any(stri_detect_regex(x, stri_flatten(warn, collapse="|"))))
      warning(sprintf("Formatters %s might not be 100%% compatible with ICU",
         stri_flatten(warn, collapse=', ')))
   x <- stri_replace_all_fixed(x, search, needle, vectorize_all=FALSE)
   if (any(stri_detect_regex(x, "%[A-Za-z]"))) {
      warning("Unsupported date/time format specifier. Ignoring")
      x <- stri_replace_all_regex(x, "%[A-Za-z]", "%?") # unsupported formatter
   }
   x <- stri_replace_all_fixed(x, "%!", "%") # well, that's not very elegant...
   x
}


# ?DateTimeClasses

# seq.POSIXst

# rep.POSIXst

# diff.POSIXt

# cut

# round

# trunc

# time + z
# z + time
# time - z
# time1 lop time2

# #' @rdname stri_datetime_format
# #' @export
# #' @param usetz single logical value; should the time zone be appended
# #' to the output?
# format.POSIXst <- function(x, format="uuuu-MM-dd HH:mm:ss", tz=attr(x, "tzone"), usetz=FALSE, ...) {
#    if (identical(usetz, TRUE)) format <- stri_paste(format, " z") # this is not too intelligent
#    stri_datetime_format(x, format=format, tz=tz) # ignore ... arg purposedly
# }
