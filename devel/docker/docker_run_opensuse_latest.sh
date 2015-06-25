#!/bin/sh

docker run --rm -ti opensuse:latest /bin/bash -c "
zypper --quiet -n update                                        && \
zypper --quiet -n install libicu-devel R git gcc gcc-c++        && \
`cat stringi_forcesystemicu.sh`                                    \
"
