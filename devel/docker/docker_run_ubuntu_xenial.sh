#!/bin/sh

docker run --rm -ti ubuntu:xenial /bin/bash -c "
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen                                             && \
locale-gen en_US.utf8                                                                   && \
/usr/sbin/update-locale LANG=en_US.UTF-8                                                && \
echo 'deb http://cran.rstudio.com/bin/linux/ubuntu/ xenial/' >> /etc/apt/sources.list   && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9               && \
apt-get -y -qq update                                                                   && \
apt-get -y -qq install git libicu-dev g++ r-base-dev pkg-config texlive                 && \
`cat stringi_forcesystemicu.sh`                                                            \
"
