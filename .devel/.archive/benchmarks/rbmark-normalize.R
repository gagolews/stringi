benchmark_description <- "NFC, NFD, NFKC, NFKD, NKFC_Casefold (UTF-8 strings)"


benchmark_do <- function() {
   library('stringi')

   text    <- stri_enc_toutf8(readLines('devel/benchmarks/pan_tadeusz_15.txt', encoding='UTF-8'))
   nfc     <- stri_trans_nfc(text)
   nfd     <- stri_trans_nfd(text)
   nfkc    <- stri_trans_nfkc(text)
   nfkd    <- stri_trans_nfkd(text)
   nfkc_cf <- stri_trans_nfkc_casefold(text)
   nf_c_f_kc_kf_kccf <- c(nfd, nfd, nfkc, nfkd, nfkc_cf)

   gc(reset=TRUE)
   benchmark2(
      stri_trans_nfc(nf_c_f_kc_kf_kccf),
      stri_trans_nfd(nf_c_f_kc_kf_kccf),
      stri_trans_nfkc(nf_c_f_kc_kf_kccf),
      stri_trans_nfkd(nf_c_f_kc_kf_kccf),
      stri_trans_nfkc_casefold(nf_c_f_kc_kf_kccf),
      replications=25L
   )
}
