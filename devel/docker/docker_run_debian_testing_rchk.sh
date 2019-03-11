#!/bin/sh

# see https://github.com/kalibera/rchk

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
apt-get -y -qq install git libicu-dev g++ pkg-config                                    && \
echo 'deb-src http://http.debian.net/debian sid main' >> /etc/apt/sources.list.d/debian-unstable.list && \
echo 'deb-src http://deb.debian.org/debian testing main non-free contrib' >> /etc/apt/sources.list && \
apt-get -y -qq update                                                                   && \
apt-get -y -qq build-dep r-base-dev                                                     && \
apt-get -y -qq install llvm clang clang-7 llvm-7-dev llvm-7 libllvm7 libc++-dev libc++abi-dev && \
apt-get -y -qq install python-pip && \
pip install wllvm && \
git clone https://github.com/kalibera/rchk.git && \
cd rchk/src ; env LLVM=/usr/lib/llvm-7 make ; cd .. && \
echo 'export WLLVM=/usr/local/bin/wllvm' > scripts/config.inc && \
echo 'export LLVM=/usr/lib/llvm-7' >> scripts/config.inc && \
echo 'export RCHK=/rchk' >> scripts/config.inc && \



`cat stringi_forcesystemicu.sh`                                                            \
"
