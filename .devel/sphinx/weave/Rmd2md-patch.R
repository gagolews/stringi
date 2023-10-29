# Copyright (C) 2020-2023, Marek Gagolewski <https://www.gagolewski.com/>

# I only want ```{r...``` and ```{python...``` to be recognised as
# chunks to-be processed by knitr so that they can be placed within
# MyST's nested admonitions

all_patterns_new <- knitr:::all_patterns
all_patterns_new$md$chunk.begin <- "^[\t >]*```\\s*\\{((r|python)( *[ ,].*)?)\\}\\s*$"
all_patterns_new$md$chunk.end <- "^[\t >]*```\\s*$"
unlockBinding("all_patterns", getNamespace("knitr"))
assign("all_patterns", all_patterns_new, getNamespace("knitr"))
