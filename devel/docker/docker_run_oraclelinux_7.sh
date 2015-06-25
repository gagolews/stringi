#!/bin/sh

#Error in iconv(x, "latin1", "ASCII") :   (while R CMD build)
#  unsupported conversion from 'latin1' to 'ASCII'
# --> downgrading glibc helps (!!!)

# tar was not installed
# which was not installed (!)

docker run --rm -ti oraclelinux:7 /bin/bash -c "
yum upgrade --enablerepo=ol7_addons --enablerepo=ol7_optional_latest -y -q              && \
yum install --enablerepo=ol7_addons --enablerepo=ol7_optional_latest -y -q                 \
   libicu-devel R-devel git make tar which texlive-latex-bin texlive                    && \
yum -y -q downgrade glibc glibc-devel glibc-common glibc-utils glibc-headers            && \
`cat stringi_forcesystemicu.sh`                                                            \
"
