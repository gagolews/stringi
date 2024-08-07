# stri_trans_list: List Available Text Transforms and Transliterators

## Description

Returns a list of available text transform identifiers. Each of them may be used in [`stri_trans_general`](stri_trans_general.md) tasks.

## Usage

``` r
stri_trans_list()
```

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*General Transforms* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/transforms/general/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other transform: [`stri_trans_char()`](stri_trans_char.md), [`stri_trans_general()`](stri_trans_general.md), [`stri_trans_nfc()`](stri_trans_nf.md), [`stri_trans_tolower()`](stri_trans_casemap.md)

## Examples




``` r
stri_trans_list()
```

```
##   [1] "Accents-Any"                         
##   [2] "am_Brai-am_Ethi"                     
##   [3] "am_Ethi-am_Brai"                     
##   [4] "am_Ethi-am_Ethi/Geminate"            
##   [5] "am_Ethi-d0_Morse"                    
##   [6] "am_FONIPA-am"                        
##   [7] "am-am_FONIPA"                        
##   [8] "am-am_Latn/BGN"                      
##   [9] "am-ar"                               
##  [10] "am-chr"                              
##  [11] "am-fa"                               
##  [12] "Amharic-Amharic/Geminate"            
##  [13] "Amharic-Latin/BGN"                   
##  [14] "Any-Accents"                         
##  [15] "Any-am"                              
##  [16] "Any-am_Brai"                         
##  [17] "Any-am_Ethi/Geminate"                
##  [18] "Any-am_FONIPA"                       
##  [19] "Any-am_Latn/BGN"                     
##  [20] "Any-Any"                             
##  [21] "Any-ar"                              
##  [22] "Any-ar_Latn/BGN"                     
##  [23] "Any-Arab"                            
##  [24] "Any-Arabic"                          
##  [25] "Any-Armenian"                        
##  [26] "Any-Armn"                            
##  [27] "Any-az/BGN"                          
##  [28] "Any-be_Latn/BGN"                     
##  [29] "Any-Beng"                            
##  [30] "Any-Bengali"                         
##  [31] "Any-bg_Latn/BGN"                     
##  [32] "Any-blt_FONIPA"                      
##  [33] "Any-Bopo"                            
##  [34] "Any-Bopomofo"                        
##  [35] "Any-Braille/Amharic"                 
##  [36] "Any-byn_Ethi/Tekie_Alibekit"         
##  [37] "Any-byn_Ethi/Xaleget"                
##  [38] "Any-byn_Latn/Tekie_Alibekit"         
##  [39] "Any-byn_Latn/Xaleget"                
##  [40] "Any-CanadianAboriginal"              
##  [41] "Any-Cans"                            
##  [42] "Any-ch_FONIPA"                       
##  [43] "Any-chr"                             
##  [44] "Any-chr_FONIPA"                      
##  [45] "Any-cs_FONIPA"                       
##  [46] "Any-cy_FONIPA"                       
##  [47] "Any-Cyrillic"                        
##  [48] "Any-Cyrl/Gutgarts"                   
##  [49] "Any-Deva"                            
##  [50] "Any-Devanagari"                      
##  [51] "Any-dsb_FONIPA"                      
##  [52] "Any-dv_Latn/BGN"                     
##  [53] "Any-el_Latn/BGN"                     
##  [54] "Any-eo_FONIPA"                       
##  [55] "Any-es_419_FONIPA"                   
##  [56] "Any-es_FONIPA"                       
##  [57] "Any-Ethi/Gutgarts"                   
##  [58] "Any-Ethiopic"                        
##  [59] "Any-Ethiopic/Aethiopica"             
##  [60] "Any-Ethiopic/ALALOC"                 
##  [61] "Any-Ethiopic/Beta_Metsehaf"          
##  [62] "Any-Ethiopic/IES_JES_1964"           
##  [63] "Any-Ethiopic/Lambdin"                
##  [64] "Any-Ethiopic/SERA"                   
##  [65] "Any-Ethiopic/Tekie_Alibekit"         
##  [66] "Any-Ethiopic/Williamson"             
##  [67] "Any-Ethiopic/Xalaget"                
##  [68] "Any-fa"                              
##  [69] "Any-fa_FONIPA"                       
##  [70] "Any-fa_Latn/BGN"                     
##  [71] "Any-FCC"                             
##  [72] "Any-FCD"                             
##  [73] "Any-Geor"                            
##  [74] "Any-Georgian"                        
##  [75] "Any-Greek"                           
##  [76] "Any-Greek/UNGEGN"                    
##  [77] "Any-Grek"                            
##  [78] "Any-Grek/UNGEGN"                     
##  [79] "Any-Gujarati"                        
##  [80] "Any-Gujr"                            
##  [81] "Any-Gurmukhi"                        
##  [82] "Any-Guru"                            
##  [83] "Any-gz_Ethi"                         
##  [84] "Any-ha_NE"                           
##  [85] "Any-Hang"                            
##  [86] "Any-Hangul"                          
##  [87] "Any-Hans"                            
##  [88] "Any-Hant"                            
##  [89] "Any-he_Latn/BGN"                     
##  [90] "Any-Hebr"                            
##  [91] "Any-Hebrew"                          
##  [92] "Any-Hex"                             
##  [93] "Any-Hex/C"                           
##  [94] "Any-Hex/Java"                        
##  [95] "Any-Hex/Perl"                        
##  [96] "Any-Hex/Unicode"                     
##  [97] "Any-Hex/XML"                         
##  [98] "Any-Hex/XML10"                       
##  [99] "Any-Hira"                            
## [100] "Any-Hiragana"                        
## [101] "Any-hy_AREVMDA_FONIPA"               
## [102] "Any-hy_FONIPA"                       
## [103] "Any-hy_Latn/BGN"                     
## [104] "Any-ia_FONIPA"                       
## [105] "Any-Jamo"                            
## [106] "Any-ka_Latn/BGN"                     
## [107] "Any-ka_Latn/BGN_1981"                
## [108] "Any-Kana"                            
## [109] "Any-Kannada"                         
## [110] "Any-Katakana"                        
## [111] "Any-kk_FONIPA"                       
## [112] "Any-kk_Latn/BGN"                     
## [113] "Any-Knda"                            
## [114] "Any-ky_FONIPA"                       
## [115] "Any-ky_Latn/BGN"                     
## [116] "Any-la_FONIPA"                       
## [117] "Any-Latin"                           
## [118] "Any-Latn"                            
## [119] "Any-Lower"                           
## [120] "Any-Malayalam"                       
## [121] "Any-mk_Latn/BGN"                     
## [122] "Any-Mlym"                            
## [123] "Any-mn_Latn/BGN"                     
## [124] "Any-mn_Latn/MNS"                     
## [125] "Any-my"                              
## [126] "Any-my_FONIPA"                       
## [127] "Any-my_Latn"                         
## [128] "Any-Name"                            
## [129] "Any-NFC"                             
## [130] "Any-NFD"                             
## [131] "Any-NFKC"                            
## [132] "Any-NFKD"                            
## [133] "Any-Null"                            
## [134] "Any-nv_FONIPA"                       
## [135] "Any-Oriya"                           
## [136] "Any-Orya"                            
## [137] "Any-pl_FONIPA"                       
## [138] "Any-ps_Latn/BGN"                     
## [139] "Any-Publishing"                      
## [140] "Any-Remove"                          
## [141] "Any-rm_FONIPA_SURSILV"               
## [142] "Any-ro_FONIPA"                       
## [143] "Any-ru"                              
## [144] "Any-ru_Latn/BGN"                     
## [145] "Any-Sarb"                            
## [146] "Any-sat_FONIPA"                      
## [147] "Any-sgw_Ethi/Gurage_2013"            
## [148] "Any-si_FONIPA"                       
## [149] "Any-si_Latn"                         
## [150] "Any-sk_FONIPA"                       
## [151] "Any-sr_Latn/BGN"                     
## [152] "Any-Syrc"                            
## [153] "Any-Syriac"                          
## [154] "Any-ta_FONIPA"                       
## [155] "Any-Tamil"                           
## [156] "Any-Taml"                            
## [157] "Any-Telu"                            
## [158] "Any-Telugu"                          
## [159] "Any-Thaa"                            
## [160] "Any-Thaana"                          
## [161] "Any-Thai"                            
## [162] "Any-Title"                           
## [163] "Any-tk/BGN"                          
## [164] "Any-ug_FONIPA"                       
## [165] "Any-uk_Latn/BGN"                     
## [166] "Any-und_FONIPA"                      
## [167] "Any-und_FONXSAMP"                    
## [168] "Any-Upper"                           
## [169] "Any-ur"                              
## [170] "Any-uz_Cyrl"                         
## [171] "Any-uz_Latn"                         
## [172] "Any-uz/BGN"                          
## [173] "Any-vec_FONIPA"                      
## [174] "Any-xh_FONIPA"                       
## [175] "Any-yo_BJ"                           
## [176] "Any-zh"                              
## [177] "Any-zu_FONIPA"                       
## [178] "ar-ar_Latn/BGN"                      
## [179] "Arab-Latn"                           
## [180] "Arabic-Latin"                        
## [181] "Arabic-Latin/BGN"                    
## [182] "Armenian-Latin"                      
## [183] "Armenian-Latin/BGN"                  
## [184] "Armn-Latn"                           
## [185] "ASCII-Latin"                         
## [186] "az_Cyrl-az/BGN"                      
## [187] "az-Lower"                            
## [188] "az-Title"                            
## [189] "az-Upper"                            
## [190] "Azerbaijani-Latin/BGN"               
## [191] "be-be_Latn/BGN"                      
## [192] "Belarusian-Latin/BGN"                
## [193] "Beng-Arab"                           
## [194] "Beng-Deva"                           
## [195] "Beng-Gujr"                           
## [196] "Beng-Guru"                           
## [197] "Beng-Knda"                           
## [198] "Beng-Latn"                           
## [199] "Beng-Mlym"                           
## [200] "Beng-Orya"                           
## [201] "Beng-Taml"                           
## [202] "Beng-Telu"                           
## [203] "Beng-ur"                             
## [204] "Bengali-Arabic"                      
## [205] "Bengali-Devanagari"                  
## [206] "Bengali-Gujarati"                    
## [207] "Bengali-Gurmukhi"                    
## [208] "Bengali-Kannada"                     
## [209] "Bengali-Latin"                       
## [210] "Bengali-Malayalam"                   
## [211] "Bengali-Oriya"                       
## [212] "Bengali-Tamil"                       
## [213] "Bengali-Telugu"                      
## [214] "bg-bg_Latn/BGN"                      
## [215] "blt-blt_FONIPA"                      
## [216] "Bopo-Latn"                           
## [217] "Bopomofo-Latin"                      
## [218] "Braille-Ethiopic/Amharic"            
## [219] "Bulgarian-Latin/BGN"                 
## [220] "Burmese-Latin"                       
## [221] "byn_Ethi-byn_Latn/Tekie_Alibekit"    
## [222] "byn_Ethi-byn_Latn/Xaleget"           
## [223] "byn_Latn-byn_Ethi/Tekie_Alibekit"    
## [224] "byn_Latn-byn_Ethi/Xaleget"           
## [225] "CanadianAboriginal-Latin"            
## [226] "Cans-Latn"                           
## [227] "ch-am"                               
## [228] "ch-ar"                               
## [229] "ch-ch_FONIPA"                        
## [230] "ch-chr"                              
## [231] "ch-fa"                               
## [232] "chr-chr_FONIPA"                      
## [233] "cs_FONIPA-ja"                        
## [234] "cs_FONIPA-ko"                        
## [235] "cs-am"                               
## [236] "cs-ar"                               
## [237] "cs-chr"                              
## [238] "cs-cs_FONIPA"                        
## [239] "cs-fa"                               
## [240] "cs-ja"                               
## [241] "cs-ko"                               
## [242] "cy-cy_FONIPA"                        
## [243] "Cyrillic-Ethiopic/Gutgarts"          
## [244] "Cyrillic-Latin"                      
## [245] "Cyrl-Ethi/Gutgarts"                  
## [246] "Cyrl-Latn"                           
## [247] "d0_Morse-am_Ethi"                    
## [248] "de-ASCII"                            
## [249] "Deva-Arab"                           
## [250] "Deva-Beng"                           
## [251] "Deva-Gujr"                           
## [252] "Deva-Guru"                           
## [253] "Deva-Knda"                           
## [254] "Deva-Latn"                           
## [255] "Deva-Mlym"                           
## [256] "Deva-Orya"                           
## [257] "Deva-Taml"                           
## [258] "Deva-Telu"                           
## [259] "Deva-ur"                             
## [260] "Devanagari-Arabic"                   
## [261] "Devanagari-Bengali"                  
## [262] "Devanagari-Gujarati"                 
## [263] "Devanagari-Gurmukhi"                 
## [264] "Devanagari-Kannada"                  
## [265] "Devanagari-Latin"                    
## [266] "Devanagari-Malayalam"                
## [267] "Devanagari-Oriya"                    
## [268] "Devanagari-Tamil"                    
## [269] "Devanagari-Telugu"                   
## [270] "Digit-Tone"                          
## [271] "dsb-dsb_FONIPA"                      
## [272] "dv-dv_Latn/BGN"                      
## [273] "el-el_Latn/BGN"                      
## [274] "el-Lower"                            
## [275] "el-Title"                            
## [276] "el-Upper"                            
## [277] "eo-am"                               
## [278] "eo-ar"                               
## [279] "eo-chr"                              
## [280] "eo-eo_FONIPA"                        
## [281] "eo-fa"                               
## [282] "es_419-am"                           
## [283] "es_419-ar"                           
## [284] "es_419-chr"                          
## [285] "es_419-fa"                           
## [286] "es_419-ja"                           
## [287] "es_419-zh"                           
## [288] "es_FONIPA-am"                        
## [289] "es_FONIPA-es_419_FONIPA"             
## [290] "es_FONIPA-ja"                        
## [291] "es_FONIPA-zh"                        
## [292] "es-am"                               
## [293] "es-ar"                               
## [294] "es-chr"                              
## [295] "es-es_FONIPA"                        
## [296] "es-fa"                               
## [297] "es-ja"                               
## [298] "es-zh"                               
## [299] "Ethi-Cyrl/Gutgarts"                  
## [300] "Ethi-Latn"                           
## [301] "Ethi-Latn/Aethiopi"                  
## [302] "Ethi-Latn/Aethiopi_Geminate"         
## [303] "Ethi-Latn/ALALOC"                    
## [304] "Ethi-Latn/ALALOC_Geminate"           
## [305] "Ethi-Latn/Beta_Metsehaf"             
## [306] "Ethi-Latn/Beta_Metsehaf_Geminate"    
## [307] "Ethi-Latn/ES3842"                    
## [308] "Ethi-Latn/IES_JES_1964"              
## [309] "Ethi-Latn/IES_JES_1964_Geminate"     
## [310] "Ethi-Latn/Lambdin"                   
## [311] "Ethi-Latn/SERA"                      
## [312] "Ethi-Latn/Williamson"                
## [313] "Ethi-sgw_Ethi/Gurage_2013"           
## [314] "Ethiopic-Braille/Amharic"            
## [315] "Ethiopic-Cyrillic/Gutgarts"          
## [316] "Ethiopic-Ethiopic/Gurage"            
## [317] "Ethiopic-Latin"                      
## [318] "Ethiopic-Latin/Aethiopica"           
## [319] "Ethiopic-Latin/Aethiopica_Geminate"  
## [320] "Ethiopic-Latin/ALALOC"               
## [321] "Ethiopic-Latin/ALALOC_Geminate"      
## [322] "Ethiopic-Latin/Beta_Metsehaf"        
## [323] "Ethiopic-Latin/BetaMetsehaf_Geminate"
## [324] "Ethiopic-Latin/ES3842"               
## [325] "Ethiopic-Latin/IES_JES_1964"         
## [326] "Ethiopic-Latin/IES_JES_1964_Geminate"
## [327] "Ethiopic-Latin/Lambdin"              
## [328] "Ethiopic-Latin/SERA"                 
## [329] "Ethiopic-Latin/Tekie_Alibekit"       
## [330] "Ethiopic-Latin/Williamson"           
## [331] "Ethiopic-Latin/Xaleget"              
## [332] "fa-fa_FONIPA"                        
## [333] "fa-fa_Latn/BGN"                      
## [334] "Fullwidth-Halfwidth"                 
## [335] "Geez-Ethiopic"                       
## [336] "Geez-Musnad"                         
## [337] "Geor-Latn"                           
## [338] "Georgian-Latin"                      
## [339] "Georgian-Latin/BGN"                  
## [340] "Greek-Latin"                         
## [341] "Greek-Latin/BGN"                     
## [342] "Greek-Latin/UNGEGN"                  
## [343] "Grek-Latn"                           
## [344] "Grek-Latn/UNGEGN"                    
## [345] "Gujarati-Arabic"                     
## [346] "Gujarati-Bengali"                    
## [347] "Gujarati-Devanagari"                 
## [348] "Gujarati-Gurmukhi"                   
## [349] "Gujarati-Kannada"                    
## [350] "Gujarati-Latin"                      
## [351] "Gujarati-Malayalam"                  
## [352] "Gujarati-Oriya"                      
## [353] "Gujarati-Tamil"                      
## [354] "Gujarati-Telugu"                     
## [355] "Gujr-Arab"                           
## [356] "Gujr-Beng"                           
## [357] "Gujr-Deva"                           
## [358] "Gujr-Guru"                           
## [359] "Gujr-Knda"                           
## [360] "Gujr-Latn"                           
## [361] "Gujr-Mlym"                           
## [362] "Gujr-Orya"                           
## [363] "Gujr-Taml"                           
## [364] "Gujr-Telu"                           
## [365] "Gujr-ur"                             
## [366] "Gurage-Ethiopic"                     
## [367] "Gurmukhi-Arabic"                     
## [368] "Gurmukhi-Bengali"                    
## [369] "Gurmukhi-Devanagari"                 
## [370] "Gurmukhi-Gujarati"                   
## [371] "Gurmukhi-Kannada"                    
## [372] "Gurmukhi-Latin"                      
## [373] "Gurmukhi-Malayalam"                  
## [374] "Gurmukhi-Oriya"                      
## [375] "Gurmukhi-Tamil"                      
## [376] "Gurmukhi-Telugu"                     
## [377] "Guru-Arab"                           
## [378] "Guru-Beng"                           
## [379] "Guru-Deva"                           
## [380] "Guru-Gujr"                           
## [381] "Guru-Knda"                           
## [382] "Guru-Latn"                           
## [383] "Guru-Mlym"                           
## [384] "Guru-Orya"                           
## [385] "Guru-Taml"                           
## [386] "Guru-Telu"                           
## [387] "Guru-ur"                             
## [388] "gz_Ethi-Sarb"                        
## [389] "ha-ha_NE"                            
## [390] "Halfwidth-Fullwidth"                 
## [391] "Han-Latin"                           
## [392] "Han-Latin/Names"                     
## [393] "Hang-Latn"                           
## [394] "Hangul-Latin"                        
## [395] "Hani-Latn"                           
## [396] "Hans-Hant"                           
## [397] "Hant-Hans"                           
## [398] "he-he_Latn/BGN"                      
## [399] "Hebr-Latn"                           
## [400] "Hebrew-Latin"                        
## [401] "Hebrew-Latin/BGN"                    
## [402] "Hex-Any"                             
## [403] "Hex-Any/C"                           
## [404] "Hex-Any/Java"                        
## [405] "Hex-Any/Perl"                        
## [406] "Hex-Any/Unicode"                     
## [407] "Hex-Any/XML"                         
## [408] "Hex-Any/XML10"                       
## [409] "Hira-Kana"                           
## [410] "Hira-Latn"                           
## [411] "Hiragana-Katakana"                   
## [412] "Hiragana-Latin"                      
## [413] "hy_AREVMDA-am"                       
## [414] "hy_AREVMDA-ar"                       
## [415] "hy_AREVMDA-chr"                      
## [416] "hy_AREVMDA-fa"                       
## [417] "hy_AREVMDA-hy_AREVMDA_FONIPA"        
## [418] "hy-am"                               
## [419] "hy-ar"                               
## [420] "hy-chr"                              
## [421] "hy-fa"                               
## [422] "hy-hy_FONIPA"                        
## [423] "hy-hy_Latn/BGN"                      
## [424] "ia-am"                               
## [425] "ia-ar"                               
## [426] "ia-chr"                              
## [427] "ia-fa"                               
## [428] "ia-ia_FONIPA"                        
## [429] "IPA-XSampa"                          
## [430] "it-am"                               
## [431] "it-ja"                               
## [432] "ja_Hrkt-ja_Latn/BGN"                 
## [433] "ja_Latn-ko"                          
## [434] "ja_Latn-ru"                          
## [435] "Jamo-Latin"                          
## [436] "Jamo-Latn"                           
## [437] "ka-ka_Latn/BGN"                      
## [438] "ka-ka_Latn/BGN_1981"                 
## [439] "Kana-Hira"                           
## [440] "Kana-Latn"                           
## [441] "Kannada-Arabic"                      
## [442] "Kannada-Bengali"                     
## [443] "Kannada-Devanagari"                  
## [444] "Kannada-Gujarati"                    
## [445] "Kannada-Gurmukhi"                    
## [446] "Kannada-Latin"                       
## [447] "Kannada-Malayalam"                   
## [448] "Kannada-Oriya"                       
## [449] "Kannada-Tamil"                       
## [450] "Kannada-Telugu"                      
## [451] "Katakana-Hiragana"                   
## [452] "Katakana-Latin"                      
## [453] "Katakana-Latin/BGN"                  
## [454] "Kazakh-Latin/BGN"                    
## [455] "Kirghiz-Latin/BGN"                   
## [456] "kk-am"                               
## [457] "kk-ar"                               
## [458] "kk-chr"                              
## [459] "kk-fa"                               
## [460] "kk-kk_FONIPA"                        
## [461] "kk-kk_Latn/BGN"                      
## [462] "Knda-Arab"                           
## [463] "Knda-Beng"                           
## [464] "Knda-Deva"                           
## [465] "Knda-Gujr"                           
## [466] "Knda-Guru"                           
## [467] "Knda-Latn"                           
## [468] "Knda-Mlym"                           
## [469] "Knda-Orya"                           
## [470] "Knda-Taml"                           
## [471] "Knda-Telu"                           
## [472] "Knda-ur"                             
## [473] "ko-ko_Latn/BGN"                      
## [474] "Korean-Latin/BGN"                    
## [475] "ky-am"                               
## [476] "ky-ar"                               
## [477] "ky-chr"                              
## [478] "ky-fa"                               
## [479] "ky-ky_FONIPA"                        
## [480] "ky-ky_Latn/BGN"                      
## [481] "la-la_FONIPA"                        
## [482] "Latin-Arabic"                        
## [483] "Latin-Armenian"                      
## [484] "Latin-ASCII"                         
## [485] "Latin-Bengali"                       
## [486] "Latin-Bopomofo"                      
## [487] "Latin-CanadianAboriginal"            
## [488] "Latin-Cyrillic"                      
## [489] "Latin-Devanagari"                    
## [490] "Latin-Ethiopic"                      
## [491] "Latin-Ethiopic/Aethiopica"           
## [492] "Latin-Ethiopic/ALALOC"               
## [493] "Latin-Ethiopic/Beta_Metsehaf"        
## [494] "Latin-Ethiopic/IES_JES_1964"         
## [495] "Latin-Ethiopic/Lambdin"              
## [496] "Latin-Ethiopic/SERA"                 
## [497] "Latin-Ethiopic/Tekie_Alibekit"       
## [498] "Latin-Ethiopic/Williamson"           
## [499] "Latin-Ethiopic/Xalaget"              
## [500] "Latin-Georgian"                      
## [501] "Latin-Greek"                         
## [502] "Latin-Greek/UNGEGN"                  
## [503] "Latin-Gujarati"                      
## [504] "Latin-Gurmukhi"                      
## [505] "Latin-Hangul"                        
## [506] "Latin-Hebrew"                        
## [507] "Latin-Hiragana"                      
## [508] "Latin-Jamo"                          
## [509] "Latin-Kannada"                       
## [510] "Latin-Katakana"                      
## [511] "Latin-Malayalam"                     
## [512] "Latin-NumericPinyin"                 
## [513] "Latin-Oriya"                         
## [514] "Latin-Russian/BGN"                   
## [515] "Latin-Syriac"                        
## [516] "Latin-Tamil"                         
## [517] "Latin-Telugu"                        
## [518] "Latin-Thaana"                        
## [519] "Latin-Thai"                          
## [520] "Latn-Arab"                           
## [521] "Latn-Armn"                           
## [522] "Latn-Beng"                           
## [523] "Latn-Bopo"                           
## [524] "Latn-Cans"                           
## [525] "Latn-Cyrl"                           
## [526] "Latn-Deva"                           
## [527] "Latn-Ethi"                           
## [528] "Latn-Ethi/Aethiopi"                  
## [529] "Latn-Ethi/ALALOC"                    
## [530] "Latn-Ethi/Beta_Metsehaf"             
## [531] "Latn-Ethi/IES_JES_1964"              
## [532] "Latn-Ethi/Lambdin"                   
## [533] "Latn-Ethi/SERA"                      
## [534] "Latn-Ethi/Williamson"                
## [535] "Latn-Geor"                           
## [536] "Latn-Grek"                           
## [537] "Latn-Grek/UNGEGN"                    
## [538] "Latn-Gujr"                           
## [539] "Latn-Guru"                           
## [540] "Latn-Hang"                           
## [541] "Latn-Hebr"                           
## [542] "Latn-Hira"                           
## [543] "Latn-Jamo"                           
## [544] "Latn-Kana"                           
## [545] "Latn-Knda"                           
## [546] "Latn-Mlym"                           
## [547] "Latn-Orya"                           
## [548] "Latn-Syrc"                           
## [549] "Latn-Taml"                           
## [550] "Latn-Telu"                           
## [551] "Latn-Thaa"                           
## [552] "Latn-Thai"                           
## [553] "lt-Lower"                            
## [554] "lt-Title"                            
## [555] "lt-Upper"                            
## [556] "Macedonian-Latin/BGN"                
## [557] "Malayalam-Arabic"                    
## [558] "Malayalam-Bengali"                   
## [559] "Malayalam-Devanagari"                
## [560] "Malayalam-Gujarati"                  
## [561] "Malayalam-Gurmukhi"                  
## [562] "Malayalam-Kannada"                   
## [563] "Malayalam-Latin"                     
## [564] "Malayalam-Oriya"                     
## [565] "Malayalam-Tamil"                     
## [566] "Malayalam-Telugu"                    
## [567] "Maldivian-Latin/BGN"                 
## [568] "mk-mk_Latn/BGN"                      
## [569] "Mlym-Arab"                           
## [570] "Mlym-Beng"                           
## [571] "Mlym-Deva"                           
## [572] "Mlym-Gujr"                           
## [573] "Mlym-Guru"                           
## [574] "Mlym-Knda"                           
## [575] "Mlym-Latn"                           
## [576] "Mlym-Orya"                           
## [577] "Mlym-Taml"                           
## [578] "Mlym-Telu"                           
## [579] "Mlym-ur"                             
## [580] "mn-mn_Latn/BGN"                      
## [581] "mn-mn_Latn/MNS"                      
## [582] "Mongolian-Latin/BGN"                 
## [583] "my-am"                               
## [584] "my-ar"                               
## [585] "my-chr"                              
## [586] "my-fa"                               
## [587] "my-my_FONIPA"                        
## [588] "my-my_Latn"                          
## [589] "my-Zawgyi"                           
## [590] "Myanmar-Latin"                       
## [591] "Name-Any"                            
## [592] "nl-Title"                            
## [593] "NumericPinyin-Latin"                 
## [594] "NumericPinyin-Pinyin"                
## [595] "nv-nv_FONIPA"                        
## [596] "Oriya-Arabic"                        
## [597] "Oriya-Bengali"                       
## [598] "Oriya-Devanagari"                    
## [599] "Oriya-Gujarati"                      
## [600] "Oriya-Gurmukhi"                      
## [601] "Oriya-Kannada"                       
## [602] "Oriya-Latin"                         
## [603] "Oriya-Malayalam"                     
## [604] "Oriya-Tamil"                         
## [605] "Oriya-Telugu"                        
## [606] "Orya-Arab"                           
## [607] "Orya-Beng"                           
## [608] "Orya-Deva"                           
## [609] "Orya-Gujr"                           
## [610] "Orya-Guru"                           
## [611] "Orya-Knda"                           
## [612] "Orya-Latn"                           
## [613] "Orya-Mlym"                           
## [614] "Orya-Taml"                           
## [615] "Orya-Telu"                           
## [616] "Orya-ur"                             
## [617] "Pashto-Latin/BGN"                    
## [618] "Persian-Latin/BGN"                   
## [619] "Pinyin-NumericPinyin"                
## [620] "pl_FONIPA-ja"                        
## [621] "pl-am"                               
## [622] "pl-ar"                               
## [623] "pl-chr"                              
## [624] "pl-fa"                               
## [625] "pl-ja"                               
## [626] "pl-pl_FONIPA"                        
## [627] "ps-ps_Latn/BGN"                      
## [628] "Publishing-Any"                      
## [629] "rm_SURSILV-am"                       
## [630] "rm_SURSILV-ar"                       
## [631] "rm_SURSILV-chr"                      
## [632] "rm_SURSILV-fa"                       
## [633] "rm_SURSILV-rm_FONIPA_SURSILV"        
## [634] "ro_FONIPA-ja"                        
## [635] "ro-am"                               
## [636] "ro-ar"                               
## [637] "ro-chr"                              
## [638] "ro-fa"                               
## [639] "ro-ja"                               
## [640] "ro-ro_FONIPA"                        
## [641] "ru_Latn-ru/BGN"                      
## [642] "ru-ja"                               
## [643] "ru-ru_Latn/BGN"                      
## [644] "ru-zh"                               
## [645] "Russian-Latin/BGN"                   
## [646] "Sarb-gz_Ethi"                        
## [647] "sat_Olck-sat_FONIPA"                 
## [648] "sat-am"                              
## [649] "sat-ar"                              
## [650] "sat-chr"                             
## [651] "sat-fa"                              
## [652] "Serbian-Latin/BGN"                   
## [653] "sgw_Ethi-Ethi/Gurage_2013"           
## [654] "si-am"                               
## [655] "si-ar"                               
## [656] "si-chr"                              
## [657] "si-fa"                               
## [658] "si-si_FONIPA"                        
## [659] "si-si_Latn"                          
## [660] "Simplified-Traditional"              
## [661] "sk_FONIPA-ja"                        
## [662] "sk-am"                               
## [663] "sk-ar"                               
## [664] "sk-chr"                              
## [665] "sk-fa"                               
## [666] "sk-ja"                               
## [667] "sk-sk_FONIPA"                        
## [668] "sr-sr_Latn/BGN"                      
## [669] "Syrc-Latn"                           
## [670] "Syriac-Latin"                        
## [671] "ta-ta_FONIPA"                        
## [672] "Tamil-Arabic"                        
## [673] "Tamil-Bengali"                       
## [674] "Tamil-Devanagari"                    
## [675] "Tamil-Gujarati"                      
## [676] "Tamil-Gurmukhi"                      
## [677] "Tamil-Kannada"                       
## [678] "Tamil-Latin"                         
## [679] "Tamil-Malayalam"                     
## [680] "Tamil-Oriya"                         
## [681] "Tamil-Telugu"                        
## [682] "Taml-Arab"                           
## [683] "Taml-Beng"                           
## [684] "Taml-Deva"                           
## [685] "Taml-Gujr"                           
## [686] "Taml-Guru"                           
## [687] "Taml-Knda"                           
## [688] "Taml-Latn"                           
## [689] "Taml-Mlym"                           
## [690] "Taml-Orya"                           
## [691] "Taml-Telu"                           
## [692] "Taml-ur"                             
## [693] "Telu-Arab"                           
## [694] "Telu-Beng"                           
## [695] "Telu-Deva"                           
## [696] "Telu-Gujr"                           
## [697] "Telu-Guru"                           
## [698] "Telu-Knda"                           
## [699] "Telu-Latn"                           
## [700] "Telu-Mlym"                           
## [701] "Telu-Orya"                           
## [702] "Telu-Taml"                           
## [703] "Telu-ur"                             
## [704] "Telugu-Arabic"                       
## [705] "Telugu-Bengali"                      
## [706] "Telugu-Devanagari"                   
## [707] "Telugu-Gujarati"                     
## [708] "Telugu-Gurmukhi"                     
## [709] "Telugu-Kannada"                      
## [710] "Telugu-Latin"                        
## [711] "Telugu-Malayalam"                    
## [712] "Telugu-Oriya"                        
## [713] "Telugu-Tamil"                        
## [714] "Thaa-Latn"                           
## [715] "Thaana-Latin"                        
## [716] "Thai-Latin"                          
## [717] "Thai-Latn"                           
## [718] "tk_Cyrl-tk/BGN"                      
## [719] "tlh-am"                              
## [720] "tlh-ar"                              
## [721] "tlh-chr"                             
## [722] "tlh-fa"                              
## [723] "tlh-tlh_FONIPA"                      
## [724] "Tone-Digit"                          
## [725] "tr-Lower"                            
## [726] "tr-Title"                            
## [727] "tr-Upper"                            
## [728] "Traditional-Simplified"              
## [729] "Turkmen-Latin/BGN"                   
## [730] "ug-ug_FONIPA"                        
## [731] "uk-uk_Latn/BGN"                      
## [732] "Ukrainian-Latin/BGN"                 
## [733] "und_FONIPA-ar"                       
## [734] "und_FONIPA-chr"                      
## [735] "und_FONIPA-fa"                       
## [736] "und_FONIPA-und_FONXSAMP"             
## [737] "und_FONXSAMP-und_FONIPA"             
## [738] "uz_Cyrl-uz_Latn"                     
## [739] "uz_Cyrl-uz/BGN"                      
## [740] "uz_Latn-uz_Cyrl"                     
## [741] "Uzbek-Latin/BGN"                     
## [742] "vec-vec_FONIPA"                      
## [743] "xh-am"                               
## [744] "xh-ar"                               
## [745] "xh-chr"                              
## [746] "xh-fa"                               
## [747] "xh-xh_FONIPA"                        
## [748] "XSampa-IPA"                          
## [749] "yo-yo_BJ"                            
## [750] "Zawgyi-my"                           
## [751] "zh_Latn_PINYIN-ru"                   
## [752] "zu-am"                               
## [753] "zu-ar"                               
## [754] "zu-chr"                              
## [755] "zu-fa"                               
## [756] "zu-zu_FONIPA"
```
