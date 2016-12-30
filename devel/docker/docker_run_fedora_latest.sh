#!/bin/sh

# MG: added the `tar` rpm to prevent PDF man build failure

docker run --rm -ti fedora:latest /bin/bash -c "
dnf upgrade -y -q --refresh                                                             && \
dnf install -y -q libicu-devel R-devel git tar                                          && \
`cat stringi_forcesystemicu.sh`                                                            \
"
