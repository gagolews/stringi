#!/bin/bash

# Copyright (C) 2020-2023, Marek Gagolewski <https://www.gagolewski.com/>

set -e

if [ ! -f "${1}" ]; then
    echo "The input file does not exist or was not provided."
    exit 1
fi

basename="${1/%.Rmd/}"
tmpdir="${1/%.Rmd/}"
knitrfile="tmp-md-${1}"
outfile="${1/%.Rmd/.md}"

echo "Rmd2md ${1} → ${outfile}..."

rm -f "${knitrfile}"
rm -f "${outfile}"

#mkdir -p "cache"

touch "${knitrfile}"

echo "\`\`\`{r __rinit__,echo=FALSE,warning=FALSE,message=FALSE,results='hide'}" >> "${knitrfile}"
cat options.R >> "${knitrfile}"
echo "\`\`\`" >> "${knitrfile}"
echo "" >> "${knitrfile}"

# echo "\`\`\`{python __pyinit__,echo=FALSE,warning=FALSE,message=FALSE,results='hide'}" >> "${knitrfile}"
# cat options.py >> "${knitrfile}"
# echo "\`\`\`" >> "${knitrfile}"
# echo "" >> "${knitrfile}"

cat "${1}" >> "${knitrfile}"

# remove HTML comments <!-- ... -->  (in a brute force way; beware)
perl -0pi -e 's/(?s)<!--.*?-->\n?//g' "${knitrfile}"

Rscript -e "\
    library('knitr');                              \
    source('Rmd2md-patch.R');               \
    opts_knit\$set(
        progress=FALSE,                    \
        verbose=TRUE,                      \
        unnamed.chunk.label='${basename}'  \
    );  \
    opts_chunk\$set(                               \
        cache.path='${tmpdir}-cache/',     \
        fig.path='${tmpdir}-figures/'      \
    );                                             \
    knit('${knitrfile}', '${outfile}')
"

rm -f "${knitrfile}"


if [ -d "${tmpdir}-figures" ]
then
    for f in ${tmpdir}-figures/*.pdf
    do
        if [ "$f" -nt "${f/.pdf/.png}" ]
        then
            echo "Converting ${f} to png...."
            convert -density 96 "$f" "${f/.pdf/.png}"
        fi
    done
fi

# move #> comments inside code blocks outside
Rscript -e "\
    source('extract-code-comments.R'); \
    extract_code_comments('${outfile}')
"

# convert paths: sphinx/chapter/ → ./
sed -ri -e's/sphinx\/chapter\///g' "${outfile}"

# {chapref}`ref` → {numref}`Chapter %s <ref>`
sed -ri -e's/\{numref\}`chap:([^`]+)`/{numref}`Chapter %s <chap:\1>`/g' "${outfile}"

# {help}`topic` → {command}`help`{code}`("topic")`
sed -ri -e's/\{help\}`([^`]+)`/{command}`help`{code}`("\1")`/g' "${outfile}"

# horizontal lines are bigskips
sed -i -e 's/^\-\-\-$/```{raw} latex\n\\bigskip\n```\n\n```{raw} html\n<div style="margin-top: 1em"><\/div>\n```\n/g' "${outfile}"

# merge input and output chunks:
sed -rz --in-place 's/(\s)```\n\n+```\n/\1/g' "${outfile}"
# merge output and input chunks:
sed -rz --in-place 's/(\s)```\n\n+```r\n/\1/g' "${outfile}"
sed -rz --in-place 's/(\s)```\n\n+```python\n/\1/g' "${outfile}"

echo "Rmd2md ${1} → ${outfile} DONE."
