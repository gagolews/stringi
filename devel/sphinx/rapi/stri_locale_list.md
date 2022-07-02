# stri_locale_list: List Available Locales

## Description

Creates a character vector with all available locale identifies.

## Usage

``` r
stri_locale_list()
```

## Details

Note that some of the services may be unavailable in some locales. Querying for locale-specific services is always performed during the resource request.

See [stringi-locale](about_locale.md) for more information.

## Value

Returns a character vector with locale identifiers that are known to <span class="pkg">ICU</span>.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi: [10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other locale_management: [`about_locale`](about_locale.md), [`stri_locale_info()`](stri_locale_info.md), [`stri_locale_set()`](stri_locale_set.md)

## Examples




```r
stri_locale_list()
##   [1] "af"          "af_NA"       "af_ZA"       "agq"         "agq_CM"     
##   [6] "ak"          "ak_GH"       "am"          "am_ET"       "ar"         
##  [11] "ar_001"      "ar_AE"       "ar_BH"       "ar_DJ"       "ar_DZ"      
##  [16] "ar_EG"       "ar_EH"       "ar_ER"       "ar_IL"       "ar_IQ"      
##  [21] "ar_JO"       "ar_KM"       "ar_KW"       "ar_LB"       "ar_LY"      
##  [26] "ar_MA"       "ar_MR"       "ar_OM"       "ar_PS"       "ar_QA"      
##  [31] "ar_SA"       "ar_SD"       "ar_SO"       "ar_SS"       "ar_SY"      
##  [36] "ar_TD"       "ar_TN"       "ar_YE"       "as"          "as_IN"      
##  [41] "asa"         "asa_TZ"      "ast"         "ast_ES"      "az"         
##  [46] "az_Cyrl"     "az_Cyrl_AZ"  "az_Latn"     "az_Latn_AZ"  "bas"        
##  [51] "bas_CM"      "be"          "be_BY"       "bem"         "bem_ZM"     
##  [56] "bez"         "bez_TZ"      "bg"          "bg_BG"       "bm"         
##  [61] "bm_ML"       "bn"          "bn_BD"       "bn_IN"       "bo"         
##  [66] "bo_CN"       "bo_IN"       "br"          "br_FR"       "brx"        
##  [71] "brx_IN"      "bs"          "bs_Cyrl"     "bs_Cyrl_BA"  "bs_Latn"    
##  [76] "bs_Latn_BA"  "ca"          "ca_AD"       "ca_ES"       "ca_FR"      
##  [81] "ca_IT"       "ccp"         "ccp_BD"      "ccp_IN"      "ce"         
##  [86] "ce_RU"       "ceb"         "ceb_PH"      "cgg"         "cgg_UG"     
##  [91] "chr"         "chr_US"      "ckb"         "ckb_IQ"      "ckb_IR"     
##  [96] "cs"          "cs_CZ"       "cy"          "cy_GB"       "da"         
## [101] "da_DK"       "da_GL"       "dav"         "dav_KE"      "de"         
## [106] "de_AT"       "de_BE"       "de_CH"       "de_DE"       "de_IT"      
## [111] "de_LI"       "de_LU"       "dje"         "dje_NE"      "doi"        
## [116] "doi_IN"      "dsb"         "dsb_DE"      "dua"         "dua_CM"     
## [121] "dyo"         "dyo_SN"      "dz"          "dz_BT"       "ebu"        
## [126] "ebu_KE"      "ee"          "ee_GH"       "ee_TG"       "el"         
## [131] "el_CY"       "el_GR"       "en"          "en_001"      "en_150"     
## [136] "en_AE"       "en_AG"       "en_AI"       "en_AS"       "en_AT"      
## [141] "en_AU"       "en_BB"       "en_BE"       "en_BI"       "en_BM"      
## [146] "en_BS"       "en_BW"       "en_BZ"       "en_CA"       "en_CC"      
## [151] "en_CH"       "en_CK"       "en_CM"       "en_CX"       "en_CY"      
## [156] "en_DE"       "en_DG"       "en_DK"       "en_DM"       "en_ER"      
## [161] "en_FI"       "en_FJ"       "en_FK"       "en_FM"       "en_GB"      
## [166] "en_GD"       "en_GG"       "en_GH"       "en_GI"       "en_GM"      
## [171] "en_GU"       "en_GY"       "en_HK"       "en_IE"       "en_IL"      
## [176] "en_IM"       "en_IN"       "en_IO"       "en_JE"       "en_JM"      
## [181] "en_KE"       "en_KI"       "en_KN"       "en_KY"       "en_LC"      
## [186] "en_LR"       "en_LS"       "en_MG"       "en_MH"       "en_MO"      
## [191] "en_MP"       "en_MS"       "en_MT"       "en_MU"       "en_MW"      
## [196] "en_MY"       "en_NA"       "en_NF"       "en_NG"       "en_NL"      
## [201] "en_NR"       "en_NU"       "en_NZ"       "en_PG"       "en_PH"      
## [206] "en_PK"       "en_PN"       "en_PR"       "en_PW"       "en_RW"      
## [211] "en_SB"       "en_SC"       "en_SD"       "en_SE"       "en_SG"      
## [216] "en_SH"       "en_SI"       "en_SL"       "en_SS"       "en_SX"      
## [221] "en_SZ"       "en_TC"       "en_TK"       "en_TO"       "en_TT"      
## [226] "en_TV"       "en_TZ"       "en_UG"       "en_UM"       "en_US"      
## [231] "en_US_POSIX" "en_VC"       "en_VG"       "en_VI"       "en_VU"      
## [236] "en_WS"       "en_ZA"       "en_ZM"       "en_ZW"       "eo"         
## [241] "eo_001"      "es"          "es_419"      "es_AR"       "es_BO"      
## [246] "es_BR"       "es_BZ"       "es_CL"       "es_CO"       "es_CR"      
## [251] "es_CU"       "es_DO"       "es_EA"       "es_EC"       "es_ES"      
## [256] "es_GQ"       "es_GT"       "es_HN"       "es_IC"       "es_MX"      
## [261] "es_NI"       "es_PA"       "es_PE"       "es_PH"       "es_PR"      
## [266] "es_PY"       "es_SV"       "es_US"       "es_UY"       "es_VE"      
## [271] "et"          "et_EE"       "eu"          "eu_ES"       "ewo"        
## [276] "ewo_CM"      "fa"          "fa_AF"       "fa_IR"       "ff"         
## [281] "ff_Adlm"     "ff_Adlm_BF"  "ff_Adlm_CM"  "ff_Adlm_GH"  "ff_Adlm_GM" 
## [286] "ff_Adlm_GN"  "ff_Adlm_GW"  "ff_Adlm_LR"  "ff_Adlm_MR"  "ff_Adlm_NE" 
## [291] "ff_Adlm_NG"  "ff_Adlm_SL"  "ff_Adlm_SN"  "ff_Latn"     "ff_Latn_BF" 
## [296] "ff_Latn_CM"  "ff_Latn_GH"  "ff_Latn_GM"  "ff_Latn_GN"  "ff_Latn_GW" 
## [301] "ff_Latn_LR"  "ff_Latn_MR"  "ff_Latn_NE"  "ff_Latn_NG"  "ff_Latn_SL" 
## [306] "ff_Latn_SN"  "fi"          "fi_FI"       "fil"         "fil_PH"     
## [311] "fo"          "fo_DK"       "fo_FO"       "fr"          "fr_BE"      
## [316] "fr_BF"       "fr_BI"       "fr_BJ"       "fr_BL"       "fr_CA"      
## [321] "fr_CD"       "fr_CF"       "fr_CG"       "fr_CH"       "fr_CI"      
## [326] "fr_CM"       "fr_DJ"       "fr_DZ"       "fr_FR"       "fr_GA"      
## [331] "fr_GF"       "fr_GN"       "fr_GP"       "fr_GQ"       "fr_HT"      
## [336] "fr_KM"       "fr_LU"       "fr_MA"       "fr_MC"       "fr_MF"      
## [341] "fr_MG"       "fr_ML"       "fr_MQ"       "fr_MR"       "fr_MU"      
## [346] "fr_NC"       "fr_NE"       "fr_PF"       "fr_PM"       "fr_RE"      
## [351] "fr_RW"       "fr_SC"       "fr_SN"       "fr_SY"       "fr_TD"      
## [356] "fr_TG"       "fr_TN"       "fr_VU"       "fr_WF"       "fr_YT"      
## [361] "fur"         "fur_IT"      "fy"          "fy_NL"       "ga"         
## [366] "ga_GB"       "ga_IE"       "gd"          "gd_GB"       "gl"         
## [371] "gl_ES"       "gsw"         "gsw_CH"      "gsw_FR"      "gsw_LI"     
## [376] "gu"          "gu_IN"       "guz"         "guz_KE"      "gv"         
## [381] "gv_IM"       "ha"          "ha_GH"       "ha_NE"       "ha_NG"      
## [386] "haw"         "haw_US"      "he"          "he_IL"       "hi"         
## [391] "hi_IN"       "hr"          "hr_BA"       "hr_HR"       "hsb"        
## [396] "hsb_DE"      "hu"          "hu_HU"       "hy"          "hy_AM"      
## [401] "ia"          "ia_001"      "id"          "id_ID"       "ig"         
## [406] "ig_NG"       "ii"          "ii_CN"       "is"          "is_IS"      
## [411] "it"          "it_CH"       "it_IT"       "it_SM"       "it_VA"      
## [416] "ja"          "ja_JP"       "jgo"         "jgo_CM"      "jmc"        
## [421] "jmc_TZ"      "jv"          "jv_ID"       "ka"          "ka_GE"      
## [426] "kab"         "kab_DZ"      "kam"         "kam_KE"      "kde"        
## [431] "kde_TZ"      "kea"         "kea_CV"      "khq"         "khq_ML"     
## [436] "ki"          "ki_KE"       "kk"          "kk_KZ"       "kkj"        
## [441] "kkj_CM"      "kl"          "kl_GL"       "kln"         "kln_KE"     
## [446] "km"          "km_KH"       "kn"          "kn_IN"       "ko"         
## [451] "ko_KP"       "ko_KR"       "kok"         "kok_IN"      "ks"         
## [456] "ks_Arab"     "ks_Arab_IN"  "ksb"         "ksb_TZ"      "ksf"        
## [461] "ksf_CM"      "ksh"         "ksh_DE"      "ku"          "ku_TR"      
## [466] "kw"          "kw_GB"       "ky"          "ky_KG"       "lag"        
## [471] "lag_TZ"      "lb"          "lb_LU"       "lg"          "lg_UG"      
## [476] "lkt"         "lkt_US"      "ln"          "ln_AO"       "ln_CD"      
## [481] "ln_CF"       "ln_CG"       "lo"          "lo_LA"       "lrc"        
## [486] "lrc_IQ"      "lrc_IR"      "lt"          "lt_LT"       "lu"         
## [491] "lu_CD"       "luo"         "luo_KE"      "luy"         "luy_KE"     
## [496] "lv"          "lv_LV"       "mai"         "mai_IN"      "mas"        
## [501] "mas_KE"      "mas_TZ"      "mer"         "mer_KE"      "mfe"        
## [506] "mfe_MU"      "mg"          "mg_MG"       "mgh"         "mgh_MZ"     
## [511] "mgo"         "mgo_CM"      "mi"          "mi_NZ"       "mk"         
## [516] "mk_MK"       "ml"          "ml_IN"       "mn"          "mn_MN"      
## [521] "mni"         "mni_Beng"    "mni_Beng_IN" "mr"          "mr_IN"      
## [526] "ms"          "ms_BN"       "ms_ID"       "ms_MY"       "ms_SG"      
## [531] "mt"          "mt_MT"       "mua"         "mua_CM"      "my"         
## [536] "my_MM"       "mzn"         "mzn_IR"      "naq"         "naq_NA"     
## [541] "nb"          "nb_NO"       "nb_SJ"       "nd"          "nd_ZW"      
## [546] "ne"          "ne_IN"       "ne_NP"       "nl"          "nl_AW"      
## [551] "nl_BE"       "nl_BQ"       "nl_CW"       "nl_NL"       "nl_SR"      
## [556] "nl_SX"       "nmg"         "nmg_CM"      "nn"          "nn_NO"      
## [561] "nnh"         "nnh_CM"      "no"          "nus"         "nus_SS"     
## [566] "nyn"         "nyn_UG"      "om"          "om_ET"       "om_KE"      
## [571] "or"          "or_IN"       "os"          "os_GE"       "os_RU"      
## [576] "pa"          "pa_Arab"     "pa_Arab_PK"  "pa_Guru"     "pa_Guru_IN" 
## [581] "pcm"         "pcm_NG"      "pl"          "pl_PL"       "ps"         
## [586] "ps_AF"       "ps_PK"       "pt"          "pt_AO"       "pt_BR"      
## [591] "pt_CH"       "pt_CV"       "pt_GQ"       "pt_GW"       "pt_LU"      
## [596] "pt_MO"       "pt_MZ"       "pt_PT"       "pt_ST"       "pt_TL"      
## [601] "qu"          "qu_BO"       "qu_EC"       "qu_PE"       "rm"         
## [606] "rm_CH"       "rn"          "rn_BI"       "ro"          "ro_MD"      
## [611] "ro_RO"       "rof"         "rof_TZ"      "ru"          "ru_BY"      
## [616] "ru_KG"       "ru_KZ"       "ru_MD"       "ru_RU"       "ru_UA"      
## [621] "rw"          "rw_RW"       "rwk"         "rwk_TZ"      "sa"         
## [626] "sa_IN"       "sah"         "sah_RU"      "saq"         "saq_KE"     
## [631] "sat"         "sat_Olck"    "sat_Olck_IN" "sbp"         "sbp_TZ"     
## [636] "sd"          "sd_Arab"     "sd_Arab_PK"  "sd_Deva"     "sd_Deva_IN" 
## [641] "se"          "se_FI"       "se_NO"       "se_SE"       "seh"        
## [646] "seh_MZ"      "ses"         "ses_ML"      "sg"          "sg_CF"      
## [651] "shi"         "shi_Latn"    "shi_Latn_MA" "shi_Tfng"    "shi_Tfng_MA"
## [656] "si"          "si_LK"       "sk"          "sk_SK"       "sl"         
## [661] "sl_SI"       "smn"         "smn_FI"      "sn"          "sn_ZW"      
## [666] "so"          "so_DJ"       "so_ET"       "so_KE"       "so_SO"      
## [671] "sq"          "sq_AL"       "sq_MK"       "sq_XK"       "sr"         
## [676] "sr_Cyrl"     "sr_Cyrl_BA"  "sr_Cyrl_ME"  "sr_Cyrl_RS"  "sr_Cyrl_XK" 
## [681] "sr_Latn"     "sr_Latn_BA"  "sr_Latn_ME"  "sr_Latn_RS"  "sr_Latn_XK" 
## [686] "su"          "su_Latn"     "su_Latn_ID"  "sv"          "sv_AX"      
## [691] "sv_FI"       "sv_SE"       "sw"          "sw_CD"       "sw_KE"      
## [696] "sw_TZ"       "sw_UG"       "ta"          "ta_IN"       "ta_LK"      
## [701] "ta_MY"       "ta_SG"       "te"          "te_IN"       "teo"        
## [706] "teo_KE"      "teo_UG"      "tg"          "tg_TJ"       "th"         
## [711] "th_TH"       "ti"          "ti_ER"       "ti_ET"       "tk"         
## [716] "tk_TM"       "to"          "to_TO"       "tr"          "tr_CY"      
## [721] "tr_TR"       "tt"          "tt_RU"       "twq"         "twq_NE"     
## [726] "tzm"         "tzm_MA"      "ug"          "ug_CN"       "uk"         
## [731] "uk_UA"       "ur"          "ur_IN"       "ur_PK"       "uz"         
## [736] "uz_Arab"     "uz_Arab_AF"  "uz_Cyrl"     "uz_Cyrl_UZ"  "uz_Latn"    
## [741] "uz_Latn_UZ"  "vai"         "vai_Latn"    "vai_Latn_LR" "vai_Vaii"   
## [746] "vai_Vaii_LR" "vi"          "vi_VN"       "vun"         "vun_TZ"     
## [751] "wae"         "wae_CH"      "wo"          "wo_SN"       "xh"         
## [756] "xh_ZA"       "xog"         "xog_UG"      "yav"         "yav_CM"     
## [761] "yi"          "yi_001"      "yo"          "yo_BJ"       "yo_NG"      
## [766] "yue"         "yue_Hans"    "yue_Hans_CN" "yue_Hant"    "yue_Hant_HK"
## [771] "zgh"         "zgh_MA"      "zh"          "zh_Hans"     "zh_Hans_CN" 
## [776] "zh_Hans_HK"  "zh_Hans_MO"  "zh_Hans_SG"  "zh_Hant"     "zh_Hant_HK" 
## [781] "zh_Hant_MO"  "zh_Hant_TW"  "zu"          "zu_ZA"
```
