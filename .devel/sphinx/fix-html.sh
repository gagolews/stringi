#!/bin/bash

# Copyright (C) 2020-2023, Marek Gagolewski <https://www.gagolewski.com/>

set -e

if [ ! -d "${1}" ]; then
    echo "The input directory does not exist or was not provided."
    exit 1
fi


cd "${1}"

for f in *.html; do
    # merge input and output chunks:
    sed -rz --in-place 's/<\/pre><\/div>\n<\/div>\n<div class="highlight-(r|python) notranslate"><div class="highlight"><pre>//g' "${f}"
done
