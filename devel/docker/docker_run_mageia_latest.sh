#!/bin/sh

docker run --rm -ti mageia:latest /bin/bash -c "
urpmi.update -a                              &\
urpmi --auto-select --auto                   &\
urpmi libicu-devel R git make gcc-c++ --auto &\
`cat stringi_forcesystemicu.sh`               \
"
