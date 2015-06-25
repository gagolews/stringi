#!/bin/sh

docker run --rm -ti centos:latest /bin/bash -c "
rpm -Uvh http://mirror.onet.pl/pub/mirrors/fedora/linux/epel/7/x86_64/e/epel-release-7-5.noarch.rpm && \
yum upgrade -y -q                                                                       && \
yum install -y -q libicu-devel R-devel git                                              && \
`cat stringi_forcesystemicu.sh`                                                            \
"
