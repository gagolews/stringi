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

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other locale_management: [`about_locale`](about_locale.md), [`stri_locale_info()`](stri_locale_info.md), [`stri_locale_set()`](stri_locale_set.md)

## Examples




``` r
stri_locale_list()
```

```
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
##  [56] "bez"         "bez_TZ"      "bg"          "bg_BG"       "bgc"        
##  [61] "bgc_IN"      "bho"         "bho_IN"      "blo"         "blo_BJ"     
##  [66] "bm"          "bm_ML"       "bn"          "bn_BD"       "bn_IN"      
##  [71] "bo"          "bo_CN"       "bo_IN"       "br"          "br_FR"      
##  [76] "brx"         "brx_IN"      "bs"          "bs_Cyrl"     "bs_Cyrl_BA" 
##  [81] "bs_Latn"     "bs_Latn_BA"  "ca"          "ca_AD"       "ca_ES"      
##  [86] "ca_FR"       "ca_IT"       "ccp"         "ccp_BD"      "ccp_IN"     
##  [91] "ce"          "ce_RU"       "ceb"         "ceb_PH"      "cgg"        
##  [96] "cgg_UG"      "chr"         "chr_US"      "ckb"         "ckb_IQ"     
## [101] "ckb_IR"      "cs"          "cs_CZ"       "csw"         "csw_CA"     
## [106] "cv"          "cv_RU"       "cy"          "cy_GB"       "da"         
## [111] "da_DK"       "da_GL"       "dav"         "dav_KE"      "de"         
## [116] "de_AT"       "de_BE"       "de_CH"       "de_DE"       "de_IT"      
## [121] "de_LI"       "de_LU"       "dje"         "dje_NE"      "doi"        
## [126] "doi_IN"      "dsb"         "dsb_DE"      "dua"         "dua_CM"     
## [131] "dyo"         "dyo_SN"      "dz"          "dz_BT"       "ebu"        
## [136] "ebu_KE"      "ee"          "ee_GH"       "ee_TG"       "el"         
## [141] "el_CY"       "el_GR"       "en"          "en_001"      "en_150"     
## [146] "en_AE"       "en_AG"       "en_AI"       "en_AS"       "en_AT"      
## [151] "en_AU"       "en_BB"       "en_BE"       "en_BI"       "en_BM"      
## [156] "en_BS"       "en_BW"       "en_BZ"       "en_CA"       "en_CC"      
## [161] "en_CH"       "en_CK"       "en_CM"       "en_CX"       "en_CY"      
## [166] "en_DE"       "en_DG"       "en_DK"       "en_DM"       "en_ER"      
## [171] "en_FI"       "en_FJ"       "en_FK"       "en_FM"       "en_GB"      
## [176] "en_GD"       "en_GG"       "en_GH"       "en_GI"       "en_GM"      
## [181] "en_GU"       "en_GY"       "en_HK"       "en_ID"       "en_IE"      
## [186] "en_IL"       "en_IM"       "en_IN"       "en_IO"       "en_JE"      
## [191] "en_JM"       "en_KE"       "en_KI"       "en_KN"       "en_KY"      
## [196] "en_LC"       "en_LR"       "en_LS"       "en_MG"       "en_MH"      
## [201] "en_MO"       "en_MP"       "en_MS"       "en_MT"       "en_MU"      
## [206] "en_MV"       "en_MW"       "en_MY"       "en_NA"       "en_NF"      
## [211] "en_NG"       "en_NL"       "en_NR"       "en_NU"       "en_NZ"      
## [216] "en_PG"       "en_PH"       "en_PK"       "en_PN"       "en_PR"      
## [221] "en_PW"       "en_RW"       "en_SB"       "en_SC"       "en_SD"      
## [226] "en_SE"       "en_SG"       "en_SH"       "en_SI"       "en_SL"      
## [231] "en_SS"       "en_SX"       "en_SZ"       "en_TC"       "en_TK"      
## [236] "en_TO"       "en_TT"       "en_TV"       "en_TZ"       "en_UG"      
## [241] "en_UM"       "en_US"       "en_US_POSIX" "en_VC"       "en_VG"      
## [246] "en_VI"       "en_VU"       "en_WS"       "en_ZA"       "en_ZM"      
## [251] "en_ZW"       "eo"          "eo_001"      "es"          "es_419"     
## [256] "es_AR"       "es_BO"       "es_BR"       "es_BZ"       "es_CL"      
## [261] "es_CO"       "es_CR"       "es_CU"       "es_DO"       "es_EA"      
## [266] "es_EC"       "es_ES"       "es_GQ"       "es_GT"       "es_HN"      
## [271] "es_IC"       "es_MX"       "es_NI"       "es_PA"       "es_PE"      
## [276] "es_PH"       "es_PR"       "es_PY"       "es_SV"       "es_US"      
## [281] "es_UY"       "es_VE"       "et"          "et_EE"       "eu"         
## [286] "eu_ES"       "ewo"         "ewo_CM"      "fa"          "fa_AF"      
## [291] "fa_IR"       "ff"          "ff_Adlm"     "ff_Adlm_BF"  "ff_Adlm_CM" 
## [296] "ff_Adlm_GH"  "ff_Adlm_GM"  "ff_Adlm_GN"  "ff_Adlm_GW"  "ff_Adlm_LR" 
## [301] "ff_Adlm_MR"  "ff_Adlm_NE"  "ff_Adlm_NG"  "ff_Adlm_SL"  "ff_Adlm_SN" 
## [306] "ff_Latn"     "ff_Latn_BF"  "ff_Latn_CM"  "ff_Latn_GH"  "ff_Latn_GM" 
## [311] "ff_Latn_GN"  "ff_Latn_GW"  "ff_Latn_LR"  "ff_Latn_MR"  "ff_Latn_NE" 
## [316] "ff_Latn_NG"  "ff_Latn_SL"  "ff_Latn_SN"  "fi"          "fi_FI"      
## [321] "fil"         "fil_PH"      "fo"          "fo_DK"       "fo_FO"      
## [326] "fr"          "fr_BE"       "fr_BF"       "fr_BI"       "fr_BJ"      
## [331] "fr_BL"       "fr_CA"       "fr_CD"       "fr_CF"       "fr_CG"      
## [336] "fr_CH"       "fr_CI"       "fr_CM"       "fr_DJ"       "fr_DZ"      
## [341] "fr_FR"       "fr_GA"       "fr_GF"       "fr_GN"       "fr_GP"      
## [346] "fr_GQ"       "fr_HT"       "fr_KM"       "fr_LU"       "fr_MA"      
## [351] "fr_MC"       "fr_MF"       "fr_MG"       "fr_ML"       "fr_MQ"      
## [356] "fr_MR"       "fr_MU"       "fr_NC"       "fr_NE"       "fr_PF"      
## [361] "fr_PM"       "fr_RE"       "fr_RW"       "fr_SC"       "fr_SN"      
## [366] "fr_SY"       "fr_TD"       "fr_TG"       "fr_TN"       "fr_VU"      
## [371] "fr_WF"       "fr_YT"       "fur"         "fur_IT"      "fy"         
## [376] "fy_NL"       "ga"          "ga_GB"       "ga_IE"       "gd"         
## [381] "gd_GB"       "gl"          "gl_ES"       "gsw"         "gsw_CH"     
## [386] "gsw_FR"      "gsw_LI"      "gu"          "gu_IN"       "guz"        
## [391] "guz_KE"      "gv"          "gv_IM"       "ha"          "ha_GH"      
## [396] "ha_NE"       "ha_NG"       "haw"         "haw_US"      "he"         
## [401] "he_IL"       "hi"          "hi_IN"       "hi_Latn"     "hi_Latn_IN" 
## [406] "hr"          "hr_BA"       "hr_HR"       "hsb"         "hsb_DE"     
## [411] "hu"          "hu_HU"       "hy"          "hy_AM"       "ia"         
## [416] "ia_001"      "id"          "id_ID"       "ie"          "ie_EE"      
## [421] "ig"          "ig_NG"       "ii"          "ii_CN"       "is"         
## [426] "is_IS"       "it"          "it_CH"       "it_IT"       "it_SM"      
## [431] "it_VA"       "ja"          "ja_JP"       "jgo"         "jgo_CM"     
## [436] "jmc"         "jmc_TZ"      "jv"          "jv_ID"       "ka"         
## [441] "ka_GE"       "kab"         "kab_DZ"      "kam"         "kam_KE"     
## [446] "kde"         "kde_TZ"      "kea"         "kea_CV"      "kgp"        
## [451] "kgp_BR"      "khq"         "khq_ML"      "ki"          "ki_KE"      
## [456] "kk"          "kk_KZ"       "kkj"         "kkj_CM"      "kl"         
## [461] "kl_GL"       "kln"         "kln_KE"      "km"          "km_KH"      
## [466] "kn"          "kn_IN"       "ko"          "ko_CN"       "ko_KP"      
## [471] "ko_KR"       "kok"         "kok_IN"      "ks"          "ks_Arab"    
## [476] "ks_Arab_IN"  "ks_Deva"     "ks_Deva_IN"  "ksb"         "ksb_TZ"     
## [481] "ksf"         "ksf_CM"      "ksh"         "ksh_DE"      "ku"         
## [486] "ku_TR"       "kw"          "kw_GB"       "kxv"         "kxv_Deva"   
## [491] "kxv_Deva_IN" "kxv_Latn"    "kxv_Latn_IN" "kxv_Orya"    "kxv_Orya_IN"
## [496] "kxv_Telu"    "kxv_Telu_IN" "ky"          "ky_KG"       "lag"        
## [501] "lag_TZ"      "lb"          "lb_LU"       "lg"          "lg_UG"      
## [506] "lij"         "lij_IT"      "lkt"         "lkt_US"      "lmo"        
## [511] "lmo_IT"      "ln"          "ln_AO"       "ln_CD"       "ln_CF"      
## [516] "ln_CG"       "lo"          "lo_LA"       "lrc"         "lrc_IQ"     
## [521] "lrc_IR"      "lt"          "lt_LT"       "lu"          "lu_CD"      
## [526] "luo"         "luo_KE"      "luy"         "luy_KE"      "lv"         
## [531] "lv_LV"       "mai"         "mai_IN"      "mas"         "mas_KE"     
## [536] "mas_TZ"      "mer"         "mer_KE"      "mfe"         "mfe_MU"     
## [541] "mg"          "mg_MG"       "mgh"         "mgh_MZ"      "mgo"        
## [546] "mgo_CM"      "mi"          "mi_NZ"       "mk"          "mk_MK"      
## [551] "ml"          "ml_IN"       "mn"          "mn_MN"       "mni"        
## [556] "mni_Beng"    "mni_Beng_IN" "mr"          "mr_IN"       "ms"         
## [561] "ms_BN"       "ms_ID"       "ms_MY"       "ms_SG"       "mt"         
## [566] "mt_MT"       "mua"         "mua_CM"      "my"          "my_MM"      
## [571] "mzn"         "mzn_IR"      "naq"         "naq_NA"      "nb"         
## [576] "nb_NO"       "nb_SJ"       "nd"          "nd_ZW"       "nds"        
## [581] "nds_DE"      "nds_NL"      "ne"          "ne_IN"       "ne_NP"      
## [586] "nl"          "nl_AW"       "nl_BE"       "nl_BQ"       "nl_CW"      
## [591] "nl_NL"       "nl_SR"       "nl_SX"       "nmg"         "nmg_CM"     
## [596] "nn"          "nn_NO"       "nnh"         "nnh_CM"      "no"         
## [601] "nqo"         "nqo_GN"      "nus"         "nus_SS"      "nyn"        
## [606] "nyn_UG"      "oc"          "oc_ES"       "oc_FR"       "om"         
## [611] "om_ET"       "om_KE"       "or"          "or_IN"       "os"         
## [616] "os_GE"       "os_RU"       "pa"          "pa_Arab"     "pa_Arab_PK" 
## [621] "pa_Guru"     "pa_Guru_IN"  "pcm"         "pcm_NG"      "pl"         
## [626] "pl_PL"       "prg"         "prg_PL"      "ps"          "ps_AF"      
## [631] "ps_PK"       "pt"          "pt_AO"       "pt_BR"       "pt_CH"      
## [636] "pt_CV"       "pt_GQ"       "pt_GW"       "pt_LU"       "pt_MO"      
## [641] "pt_MZ"       "pt_PT"       "pt_ST"       "pt_TL"       "qu"         
## [646] "qu_BO"       "qu_EC"       "qu_PE"       "raj"         "raj_IN"     
## [651] "rm"          "rm_CH"       "rn"          "rn_BI"       "ro"         
## [656] "ro_MD"       "ro_RO"       "rof"         "rof_TZ"      "ru"         
## [661] "ru_BY"       "ru_KG"       "ru_KZ"       "ru_MD"       "ru_RU"      
## [666] "ru_UA"       "rw"          "rw_RW"       "rwk"         "rwk_TZ"     
## [671] "sa"          "sa_IN"       "sah"         "sah_RU"      "saq"        
## [676] "saq_KE"      "sat"         "sat_Olck"    "sat_Olck_IN" "sbp"        
## [681] "sbp_TZ"      "sc"          "sc_IT"       "sd"          "sd_Arab"    
## [686] "sd_Arab_PK"  "sd_Deva"     "sd_Deva_IN"  "se"          "se_FI"      
## [691] "se_NO"       "se_SE"       "seh"         "seh_MZ"      "ses"        
## [696] "ses_ML"      "sg"          "sg_CF"       "shi"         "shi_Latn"   
## [701] "shi_Latn_MA" "shi_Tfng"    "shi_Tfng_MA" "si"          "si_LK"      
## [706] "sk"          "sk_SK"       "sl"          "sl_SI"       "smn"        
## [711] "smn_FI"      "sn"          "sn_ZW"       "so"          "so_DJ"      
## [716] "so_ET"       "so_KE"       "so_SO"       "sq"          "sq_AL"      
## [721] "sq_MK"       "sq_XK"       "sr"          "sr_Cyrl"     "sr_Cyrl_BA" 
## [726] "sr_Cyrl_ME"  "sr_Cyrl_RS"  "sr_Cyrl_XK"  "sr_Latn"     "sr_Latn_BA" 
## [731] "sr_Latn_ME"  "sr_Latn_RS"  "sr_Latn_XK"  "su"          "su_Latn"    
## [736] "su_Latn_ID"  "sv"          "sv_AX"       "sv_FI"       "sv_SE"      
## [741] "sw"          "sw_CD"       "sw_KE"       "sw_TZ"       "sw_UG"      
## [746] "syr"         "syr_IQ"      "syr_SY"      "szl"         "szl_PL"     
## [751] "ta"          "ta_IN"       "ta_LK"       "ta_MY"       "ta_SG"      
## [756] "te"          "te_IN"       "teo"         "teo_KE"      "teo_UG"     
## [761] "tg"          "tg_TJ"       "th"          "th_TH"       "ti"         
## [766] "ti_ER"       "ti_ET"       "tk"          "tk_TM"       "to"         
## [771] "to_TO"       "tok"         "tok_001"     "tr"          "tr_CY"      
## [776] "tr_TR"       "tt"          "tt_RU"       "twq"         "twq_NE"     
## [781] "tzm"         "tzm_MA"      "ug"          "ug_CN"       "uk"         
## [786] "uk_UA"       "ur"          "ur_IN"       "ur_PK"       "uz"         
## [791] "uz_Arab"     "uz_Arab_AF"  "uz_Cyrl"     "uz_Cyrl_UZ"  "uz_Latn"    
## [796] "uz_Latn_UZ"  "vai"         "vai_Latn"    "vai_Latn_LR" "vai_Vaii"   
## [801] "vai_Vaii_LR" "vec"         "vec_IT"      "vi"          "vi_VN"      
## [806] "vmw"         "vmw_MZ"      "vun"         "vun_TZ"      "wae"        
## [811] "wae_CH"      "wo"          "wo_SN"       "xh"          "xh_ZA"      
## [816] "xnr"         "xnr_IN"      "xog"         "xog_UG"      "yav"        
## [821] "yav_CM"      "yi"          "yi_UA"       "yo"          "yo_BJ"      
## [826] "yo_NG"       "yrl"         "yrl_BR"      "yrl_CO"      "yrl_VE"     
## [831] "yue"         "yue_Hans"    "yue_Hans_CN" "yue_Hant"    "yue_Hant_HK"
## [836] "za"          "za_CN"       "zgh"         "zgh_MA"      "zh"         
## [841] "zh_Hans"     "zh_Hans_CN"  "zh_Hans_HK"  "zh_Hans_MO"  "zh_Hans_SG" 
## [846] "zh_Hant"     "zh_Hant_HK"  "zh_Hant_MO"  "zh_Hant_TW"  "zu"         
## [851] "zu_ZA"
```
