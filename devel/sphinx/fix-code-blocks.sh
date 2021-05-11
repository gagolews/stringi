#!/bin/bash

# Copyright (C) 2020-2021, Marek Gagolewski <https://www.gagolewski.com>

set -e

if [ ! -d "${1}" ]; then
    echo "The input directory does not exist or was not provided."
    exit 1
fi


cd "${1}"

for f in *.md; do
    # merge input and output chunks:
    sed -rz --in-place 's/```\n\n```\n//g' "${f}"
    # merge output and input chunks:
    sed -rz --in-place 's/```\n\n```r\n//g' "${f}"
done
