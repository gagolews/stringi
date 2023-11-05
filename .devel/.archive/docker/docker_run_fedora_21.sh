#!/bin/sh

docker run --rm -ti fedora:21 /bin/bash -c "
yum upgrade -y -q                                                                       && \
yum install -y -q libicu-devel R-devel git                                              && \
`cat stringi_forcesystemicu.sh`                                                            \
"
