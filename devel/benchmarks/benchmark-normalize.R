benchmark_description <- "NFC, NFD, NFKC, NFKD, NKFC_Casefold"


benchmark_do <- function() {
   library('stringi')

   text    <- stri_enc_toutf8(readLines('devel/benchmarks/pan_tadeusz_15.txt', encoding='UTF-8'))
   nfc     <- stri_enc_nfc(text)
   nfd     <- stri_enc_nfd(text)
   nfkc    <- stri_enc_nfkc(text)
   nfkd    <- stri_enc_nfkd(text)
   nfkc_cf <- stri_enc_nfkc_casefold(text)
   nf_c_f_kc_kf_kccf <- c(nfd, nfd, nfkc, nfkd, nfkc_cf)

   gc(reset=TRUE)
   microbenchmark2(
      stri_enc_nfc(nf_c_f_kc_kf_kccf),
      stri_enc_nfd(nf_c_f_kc_kf_kccf),
      stri_enc_nfkc(nf_c_f_kc_kf_kccf),
      stri_enc_nfkd(nf_c_f_kc_kf_kccf),
      stri_enc_nfkc_casefold(nf_c_f_kc_kf_kccf)
   )
}
