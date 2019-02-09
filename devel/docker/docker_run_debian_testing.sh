#!/bin/sh

docker run --rm -ti debian:testing /bin/bash -c "
apt-get -y -qq update                                                                   && \
apt-get -y -qq upgrade                                                                  && \
apt-get install -y -qq locales                                                          && \
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen                                             && \
locale-gen en_US.utf8                                                                   && \
/usr/sbin/update-locale LANG=en_US.UTF-8                                                && \
echo 'deb http://http.debian.net/debian sid main'                                          \
   > /etc/apt/sources.list.d/debian-unstable.list                                       && \
echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default                    && \
apt-get -y -qq update                                                                   && \
apt-get -y -qq upgrade                                                                  && \
apt-get -y -qq install git libicu-dev g++ r-base-dev pkg-config                         && \
`cat stringi_forcesystemicu.sh`                                                            \
"
