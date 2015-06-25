#!/bin/sh

# MG: I had to add tar rpm because otherwise string PDF man cannot be built

docker run --rm -ti fedora:latest /bin/bash -c "
dnf upgrade -y -q                                                                       && \
dnf install -y -q libicu-devel R-devel git tar                                          && \
`cat stringi_forcesystemicu.sh`                                                            \
"
