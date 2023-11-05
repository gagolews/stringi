options(digits=7)
options(width=120)
require("knitr")
require("stringi")
require("stringr")
require("microbenchmark")


# hook_inline <- knit_hooks$get('inline')
#  knit_hooks$set(inline = function(x) {
#       if (is.character(x)) highr::hi_html(x) else hook_inline(x)
#     })

opts_chunk$set(
   keep.source=TRUE,
   out.width='4.5in',
   fig.width=6,
   fig.height=6/sqrt(2),
   fig.path='figures-knitr/conversion/',
   cache.path='cache-knitr/conversion/',
   cache=TRUE,
   tidy=FALSE,
   fig.align='center',
   size='small'
)
