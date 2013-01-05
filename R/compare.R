#' Compare two character vectors case-insensitively
#' 
#' This uses full Unicode character folding.
#' 
#' @param e1 character vector
#' @param e2 character vector
#' @export
"%==%" <- function(e1, e2) {
   stop("not yet implemented")
#    .Call("stri_casecompare", 
#          stri_prepare_arg_string(e1), stri_prepare_arg_string(e2), PACKAGE="ICU")
}

# COLLATION OPTIONS
# TO DO %<%
# TO DO %<=%
# TO DO %>=%
# TO DO %>%
# TO DO %==%
# TO DO %!=%
# TO DO stri_order (STL? + ICU COLLATE)
# TO DO stri_sort on stri_order??
# TO DO stri_rank on stri_order??
