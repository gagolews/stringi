# Copyright (C) 2020-2023, Marek Gagolewski <https://www.gagolewski.com/>

options(encoding="UTF-8")
set.seed(666)
options(width=74)
options(digits=5)
options(stringsAsFactors=FALSE)  # default in R 4.0
options(max.print=99)
options(useFancyQuotes=FALSE)
#reticulate::use_python("/home/gagolews/.virtualenvs/python3-default/bin/python3")
options(warnPartialMatchArgs=TRUE)
options(warnPartialMatchAttr=TRUE)
options(warnPartialMatchDollar=TRUE)

################################################################################

library("knitr")
library("stringi")

# knit_engines$set(python = reticulate::eng_python)

#opts_chunk$set(engine = 'python')

opts_chunk$set(
    dev="pdf",
    fig.width=5.9375,    # /1.25 = (textwidth=4.75)
    out.width=5.9375,
    fig.height=3.4635,  # fig.width/(12/7)
    dpi=240,            # *1.5 = 300
    dev.args=list(pointsize=12.5),  # pointsize=12.5/1.25 == main size=10pt
    #dev=c("CairoPDF", "CairoSVG"),
    error=FALSE,
    fig.show="hold",
    results="markup",
    fig.lp='fig:',
    autodep=FALSE,
    cache=FALSE,
    comment="##",
    cache.comments=TRUE
    #python.reticulate=FALSE
)

# opts_chunk$set(
#    #engine.opts=list(python="-c"),
#     engine.path=list(python="/usr/bin/python3")
# )


# slightly transparent -> enable pdftocairo optimisations
# TODO: are they needed?
palette(c("#000000f0", "#DF536Bf0", "#61D04Ff0", "#2297E6f0",
    "#28E2E5f0", "#CD0BBCf0", "#F5C710f0", "#999999f0"))

# Fix figure chunks:
# strangely enough, placing this in Rmd2md-patch.R breaks chunk generation

hook_plot_md_pandoc_new <- function(x, options)
{
    if (options$fig.show == "animate")
        return(hook_plot_html(x, options))
    file <- stringi::stri_replace_first_regex(x, "\\.(pdf|png|jpg|svg|svgz)", ".*")
    base <- knitr::opts_knit$get("base.url") %n% ""
    cap <- .img.cap(options)

    sprintf("(fig:%s)=\n```{figure} %s\n%s\n```", options[["label"]], file, cap)
}

environment(hook_plot_md_pandoc_new) <- environment(knitr:::hook_plot_md_pandoc)
unlockBinding("hook_plot_md_pandoc", getNamespace("knitr"))
assign("hook_plot_md_pandoc", hook_plot_md_pandoc_new, getNamespace("knitr"))
knitr::knit_hooks$set(plot=knitr:::hook_plot_md_pandoc)
rm("hook_plot_md_pandoc_new")


################################################################################

# Wrap error, message, and warning lines:

msg_sanitize_new <- function(message, type)
{
    paste0(stringx::strwrap(
        message,
        exdent=4,
        width=getOption("width")
    ), collapse="\n")
}

environment(msg_sanitize_new) <- environment(knitr:::msg_sanitize)
unlockBinding("msg_sanitize", getNamespace("knitr"))
assign("msg_sanitize", msg_sanitize_new, getNamespace("knitr"))
rm("msg_sanitize_new")



Cairo::CairoFonts(
    regular="Alegreya Sans:style=Regular",
    italic="Alegreya Sans:style=Italic",
    bold="Alegreya Sans:style=Medium",
    bolditalic="Alegreya Sans:style=Medium Italic",
    symbol="TeX Gyre Pagella:style=Regular"
)
