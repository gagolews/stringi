#!/bin/bash

cpp=*.cpp
c=*.c

for f in $cpp
do
   echo $f
   g++ -m64 -I/usr/include/R -DNDEBUG -I. -I.. -I../.. -I../unicode -I../common \
   -I../i18n -DU_TOOLUTIL_IMPLEMENTATION -DU_STATIC_IMPLEMENTATION -DU_HAVE_ELF_H \
   -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG \
   -I/usr/local/include   -UNDEBUG -fpic  -O2 -g -pipe  -Wp,-D_FORTIFY_SOURCE=2 \
   -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 \
   -grecord-gcc-switches  -m64 -mtune=generic  -c $f
done

for f in $c
do
   echo $f
   gcc -m64 -I/usr/include/R -DNDEBUG -I. -I.. -I../.. -I../unicode -I../common \
   -I../i18n -DU_TOOLUTIL_IMPLEMENTATION -DU_STATIC_IMPLEMENTATION -DU_HAVE_ELF_H \
   -DU_COMMON_IMPLEMENTATION -DU_I18N_IMPLEMENTATION -DUCONFIG_USE_LOCAL -DNDEBUG \
   -I/usr/local/include   -UNDEBUG -fpic  -O2 -g -pipe  -Wp,-D_FORTIFY_SOURCE=2 \
   -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 \
   -grecord-gcc-switches  -m64 -mtune=generic  -c $f
done

g++ *.o ../i18n/*.o ../common/*.o ../stubdata/*.o -ldl -o pkgtool

