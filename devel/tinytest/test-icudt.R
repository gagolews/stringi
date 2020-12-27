library("tinytest")
library("stringi")
library("stringr")

# test whether we have enough ICU data
# further services (like collator) are queried in other tests



expect_true(length(stri_enc_list()) > 0)

# not provided: 'koi7', 'iso-8859-16', 'ANSI_X3.110-1983',  'CP872',
# see e.g.:
# * http://w3techs.com/technologies/overview/character_encoding/all
# * http://en.wikipedia.org/wiki/Character_encoding#Common_character_encodings
encs <- c("cp1250", "utf-8", "utf-16", "utf-32-le", "koi8-r", "koi8-u", "big5",
    "GB18030", "Shift-JIS", "EUC-JP", "gbk", "euc-kr", "GB2312", "windows-874",
    "us-ascii", "tis-620", "ascii", "cp37", "cp930", "cp1047", "ks c 5601", "Big5 HKSCS",
    "windows-949", "ibm850", "iSO-2022-JP", "CP437", "CP737", "CP850", "CP852",
    "CP855", "CP857", "CP858", "CP860", "CP861", "CP862", "CP863", "CP865", "CP866",
    "CP869", stri_c("iso-8859-", (1:15)[-12]), stri_c("windows-", 1250:1258))

for (e in encs) {
    expect_true(is.list(suppressWarnings(stri_enc_info(e))))
}



expect_true(length(stri_locale_list()) > 0)

locales <- c("en_US", "zh_Hans_CN", "ru_RU", "fr_FR", "es_ES", "en_GB", "de_DE",
    "pt_BR", "en_CA", "es_MX", "it_IT", "ja_JP", "pl_PL", "cs_CZ", "sk_SK")

for (l in locales) {
    expect_true(l %in% stri_locale_list())
}

