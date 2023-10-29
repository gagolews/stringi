// [[Rcpp::depends(stringi)]]
#include <Rcpp.h>
#include <stringi.h>
#include <stringi.cpp>

// [[Rcpp::export]]
Rcpp::CharacterVector test_dup(Rcpp::CharacterVector x, Rcpp::IntegerVector i) {
   return stri_dup(x, i);
}
