#!/bin/sh

docker run --rm -ti centos:latest /bin/bash -c "
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm         && \
yum upgrade -y -q                                                                       && \
yum install -y -q libicu-devel R-devel git                                              && \
`cat stringi_forcesystemicu.sh`                                                            \
"
