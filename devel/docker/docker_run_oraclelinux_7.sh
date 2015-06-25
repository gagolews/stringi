#!/bin/sh

#Error in iconv(x, "latin1", "ASCII") :   (while R CMD build)
#  unsupported conversion from 'latin1' to 'ASCII'

#locale -a
# C
# POSIX

#iconv -l
#  10646-1:1993, 10646-1:1993/UCS4, ANSI_X3.4-1968, ANSI_X3.4-1986, ANSI_X3.4,
#  ASCII, CP367, CSASCII, CSUCS4, IBM367, ISO-10646, ISO-10646/UCS2,
#  ISO-10646/UCS4, ISO-10646/UTF-8, ISO-10646/UTF8, ISO-IR-6, ISO-IR-193,
#  ISO646-US, ISO_646.IRV:1991, OSF00010020, OSF00010100, OSF00010101,
#  OSF00010102, OSF00010104, OSF00010105, OSF00010106, OSF05010001, UCS-2,
#  UCS-2BE, UCS-2LE, UCS-4, UCS-4BE, UCS-4LE, UCS2, UCS4, UNICODEBIG,
#  UNICODELITTLE, US-ASCII, US, UTF-8, UTF8, WCHAR_T

echo "locale, iconv problems in oraclelinux, giving up"
exit

docker run --rm -ti oraclelinux:7 /bin/bash -c "
yum upgrade -y -q                                                                       && \
yum install -y -q libicu-devel R-devel git                                                 \
   --enablerepo=ol7_addons --enablerepo=ol7_optional_latest                             && \
`cat stringi_forcesystemicu.sh`                                                            \
"
