# stri_timezone_list: List Available Time Zone Identifiers

## Description

Returns a list of available time zone identifiers.

## Usage

``` r
stri_timezone_list(region = NA_character_, offset = NA_integer_)
```

## Arguments

|  |  |
|----|----|
| `region` | single string; a ISO 3166 two-letter country code or UN M.49 three-digit area code; `NA` for all regions |
| `offset` | single numeric value; a given raw offset from GMT, in hours; `NA` for all offsets |

## Details

If `offset` and `region` are `NA` (the default), then all time zones are returned. Otherwise, only time zone identifiers with a given raw offset from GMT and/or time zones corresponding to a given region are provided. Note that the effect of daylight savings time is ignored.

A time zone represents an offset applied to the Greenwich Mean Time (GMT) to obtain local time (Universal Coordinated Time, or UTC, is similar, but not precisely identical, to GMT; in <span class="pkg">ICU</span> the two terms are used interchangeably since <span class="pkg">ICU</span> does not concern itself with either leap seconds or historical behavior). The offset might vary throughout the year, if daylight savings time (DST) is used, or might be the same all year long. Typically, regions closer to the equator do not use DST. If DST is in use, then specific rules define the point where the offset changes and the amount by which it changes.

If DST is observed, then three additional bits of information are needed:

1.  The precise date and time during the year when DST begins. In the first half of the year it is in the northern hemisphere, and in the second half of the year it is in the southern hemisphere.

2.  The precise date and time during the year when DST ends. In the first half of the year it is in the southern hemisphere, and in the second half of the year it is in the northern hemisphere.

3.  The amount by which the GMT offset changes when DST is in effect. This is almost always one hour.

## Value

Returns a character vector.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*TimeZone* class -- ICU API Documentation, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1TimeZone.html>

*ICU TimeZone classes* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/datetime/timezone/>

*Date/Time Services* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/datetime/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other datetime: [`stri_datetime_add()`](stri_datetime_add.md), [`stri_datetime_create()`](stri_datetime_create.md), [`stri_datetime_fields()`](stri_datetime_fields.md), [`stri_datetime_format()`](stri_datetime_format.md), [`stri_datetime_fstr()`](stri_datetime_fstr.md), [`stri_datetime_now()`](stri_datetime_now.md), [`stri_datetime_symbols()`](stri_datetime_symbols.md), [`stri_timezone_get()`](stri_timezone_set.md), [`stri_timezone_info()`](stri_timezone_info.md)

Other timezone: [`stri_timezone_get()`](stri_timezone_set.md), [`stri_timezone_info()`](stri_timezone_info.md)

## Examples




``` r
stri_timezone_list()
```

```
##   [1] "ACT"                              "AET"                             
##   [3] "Africa/Abidjan"                   "Africa/Accra"                    
##   [5] "Africa/Addis_Ababa"               "Africa/Algiers"                  
##   [7] "Africa/Asmara"                    "Africa/Asmera"                   
##   [9] "Africa/Bamako"                    "Africa/Bangui"                   
##  [11] "Africa/Banjul"                    "Africa/Bissau"                   
##  [13] "Africa/Blantyre"                  "Africa/Brazzaville"              
##  [15] "Africa/Bujumbura"                 "Africa/Cairo"                    
##  [17] "Africa/Casablanca"                "Africa/Ceuta"                    
##  [19] "Africa/Conakry"                   "Africa/Dakar"                    
##  [21] "Africa/Dar_es_Salaam"             "Africa/Djibouti"                 
##  [23] "Africa/Douala"                    "Africa/El_Aaiun"                 
##  [25] "Africa/Freetown"                  "Africa/Gaborone"                 
##  [27] "Africa/Harare"                    "Africa/Johannesburg"             
##  [29] "Africa/Juba"                      "Africa/Kampala"                  
##  [31] "Africa/Khartoum"                  "Africa/Kigali"                   
##  [33] "Africa/Kinshasa"                  "Africa/Lagos"                    
##  [35] "Africa/Libreville"                "Africa/Lome"                     
##  [37] "Africa/Luanda"                    "Africa/Lubumbashi"               
##  [39] "Africa/Lusaka"                    "Africa/Malabo"                   
##  [41] "Africa/Maputo"                    "Africa/Maseru"                   
##  [43] "Africa/Mbabane"                   "Africa/Mogadishu"                
##  [45] "Africa/Monrovia"                  "Africa/Nairobi"                  
##  [47] "Africa/Ndjamena"                  "Africa/Niamey"                   
##  [49] "Africa/Nouakchott"                "Africa/Ouagadougou"              
##  [51] "Africa/Porto-Novo"                "Africa/Sao_Tome"                 
##  [53] "Africa/Timbuktu"                  "Africa/Tripoli"                  
##  [55] "Africa/Tunis"                     "Africa/Windhoek"                 
##  [57] "AGT"                              "America/Adak"                    
##  [59] "America/Anchorage"                "America/Anguilla"                
##  [61] "America/Antigua"                  "America/Araguaina"               
##  [63] "America/Argentina/Buenos_Aires"   "America/Argentina/Catamarca"     
##  [65] "America/Argentina/ComodRivadavia" "America/Argentina/Cordoba"       
##  [67] "America/Argentina/Jujuy"          "America/Argentina/La_Rioja"      
##  [69] "America/Argentina/Mendoza"        "America/Argentina/Rio_Gallegos"  
##  [71] "America/Argentina/Salta"          "America/Argentina/San_Juan"      
##  [73] "America/Argentina/San_Luis"       "America/Argentina/Tucuman"       
##  [75] "America/Argentina/Ushuaia"        "America/Aruba"                   
##  [77] "America/Asuncion"                 "America/Atikokan"                
##  [79] "America/Atka"                     "America/Bahia"                   
##  [81] "America/Bahia_Banderas"           "America/Barbados"                
##  [83] "America/Belem"                    "America/Belize"                  
##  [85] "America/Blanc-Sablon"             "America/Boa_Vista"               
##  [87] "America/Bogota"                   "America/Boise"                   
##  [89] "America/Buenos_Aires"             "America/Cambridge_Bay"           
##  [91] "America/Campo_Grande"             "America/Cancun"                  
##  [93] "America/Caracas"                  "America/Catamarca"               
##  [95] "America/Cayenne"                  "America/Cayman"                  
##  [97] "America/Chicago"                  "America/Chihuahua"               
##  [99] "America/Ciudad_Juarez"            "America/Coral_Harbour"           
## [101] "America/Cordoba"                  "America/Costa_Rica"              
## [103] "America/Creston"                  "America/Cuiaba"                  
## [105] "America/Curacao"                  "America/Danmarkshavn"            
## [107] "America/Dawson"                   "America/Dawson_Creek"            
## [109] "America/Denver"                   "America/Detroit"                 
## [111] "America/Dominica"                 "America/Edmonton"                
## [113] "America/Eirunepe"                 "America/El_Salvador"             
## [115] "America/Ensenada"                 "America/Fort_Nelson"             
## [117] "America/Fort_Wayne"               "America/Fortaleza"               
## [119] "America/Glace_Bay"                "America/Godthab"                 
## [121] "America/Goose_Bay"                "America/Grand_Turk"              
## [123] "America/Grenada"                  "America/Guadeloupe"              
## [125] "America/Guatemala"                "America/Guayaquil"               
## [127] "America/Guyana"                   "America/Halifax"                 
## [129] "America/Havana"                   "America/Hermosillo"              
## [131] "America/Indiana/Indianapolis"     "America/Indiana/Knox"            
## [133] "America/Indiana/Marengo"          "America/Indiana/Petersburg"      
## [135] "America/Indiana/Tell_City"        "America/Indiana/Vevay"           
## [137] "America/Indiana/Vincennes"        "America/Indiana/Winamac"         
## [139] "America/Indianapolis"             "America/Inuvik"                  
## [141] "America/Iqaluit"                  "America/Jamaica"                 
## [143] "America/Jujuy"                    "America/Juneau"                  
## [145] "America/Kentucky/Louisville"      "America/Kentucky/Monticello"     
## [147] "America/Knox_IN"                  "America/Kralendijk"              
## [149] "America/La_Paz"                   "America/Lima"                    
## [151] "America/Los_Angeles"              "America/Louisville"              
## [153] "America/Lower_Princes"            "America/Maceio"                  
## [155] "America/Managua"                  "America/Manaus"                  
## [157] "America/Marigot"                  "America/Martinique"              
## [159] "America/Matamoros"                "America/Mazatlan"                
## [161] "America/Mendoza"                  "America/Menominee"               
## [163] "America/Merida"                   "America/Metlakatla"              
## [165] "America/Mexico_City"              "America/Miquelon"                
## [167] "America/Moncton"                  "America/Monterrey"               
## [169] "America/Montevideo"               "America/Montreal"                
## [171] "America/Montserrat"               "America/Nassau"                  
## [173] "America/New_York"                 "America/Nipigon"                 
## [175] "America/Nome"                     "America/Noronha"                 
## [177] "America/North_Dakota/Beulah"      "America/North_Dakota/Center"     
## [179] "America/North_Dakota/New_Salem"   "America/Nuuk"                    
## [181] "America/Ojinaga"                  "America/Panama"                  
## [183] "America/Pangnirtung"              "America/Paramaribo"              
## [185] "America/Phoenix"                  "America/Port_of_Spain"           
## [187] "America/Port-au-Prince"           "America/Porto_Acre"              
## [189] "America/Porto_Velho"              "America/Puerto_Rico"             
## [191] "America/Punta_Arenas"             "America/Rainy_River"             
## [193] "America/Rankin_Inlet"             "America/Recife"                  
## [195] "America/Regina"                   "America/Resolute"                
## [197] "America/Rio_Branco"               "America/Rosario"                 
## [199] "America/Santa_Isabel"             "America/Santarem"                
## [201] "America/Santiago"                 "America/Santo_Domingo"           
## [203] "America/Sao_Paulo"                "America/Scoresbysund"            
## [205] "America/Shiprock"                 "America/Sitka"                   
## [207] "America/St_Barthelemy"            "America/St_Johns"                
## [209] "America/St_Kitts"                 "America/St_Lucia"                
## [211] "America/St_Thomas"                "America/St_Vincent"              
## [213] "America/Swift_Current"            "America/Tegucigalpa"             
## [215] "America/Thule"                    "America/Thunder_Bay"             
## [217] "America/Tijuana"                  "America/Toronto"                 
## [219] "America/Tortola"                  "America/Vancouver"               
## [221] "America/Virgin"                   "America/Whitehorse"              
## [223] "America/Winnipeg"                 "America/Yakutat"                 
## [225] "America/Yellowknife"              "Antarctica/Casey"                
## [227] "Antarctica/Davis"                 "Antarctica/DumontDUrville"       
## [229] "Antarctica/Macquarie"             "Antarctica/Mawson"               
## [231] "Antarctica/McMurdo"               "Antarctica/Palmer"               
## [233] "Antarctica/Rothera"               "Antarctica/South_Pole"           
## [235] "Antarctica/Syowa"                 "Antarctica/Troll"                
## [237] "Antarctica/Vostok"                "Arctic/Longyearbyen"             
## [239] "ART"                              "Asia/Aden"                       
## [241] "Asia/Almaty"                      "Asia/Amman"                      
## [243] "Asia/Anadyr"                      "Asia/Aqtau"                      
## [245] "Asia/Aqtobe"                      "Asia/Ashgabat"                   
## [247] "Asia/Ashkhabad"                   "Asia/Atyrau"                     
## [249] "Asia/Baghdad"                     "Asia/Bahrain"                    
## [251] "Asia/Baku"                        "Asia/Bangkok"                    
## [253] "Asia/Barnaul"                     "Asia/Beirut"                     
## [255] "Asia/Bishkek"                     "Asia/Brunei"                     
## [257] "Asia/Calcutta"                    "Asia/Chita"                      
## [259] "Asia/Choibalsan"                  "Asia/Chongqing"                  
## [261] "Asia/Chungking"                   "Asia/Colombo"                    
## [263] "Asia/Dacca"                       "Asia/Damascus"                   
## [265] "Asia/Dhaka"                       "Asia/Dili"                       
## [267] "Asia/Dubai"                       "Asia/Dushanbe"                   
## [269] "Asia/Famagusta"                   "Asia/Gaza"                       
## [271] "Asia/Harbin"                      "Asia/Hebron"                     
## [273] "Asia/Ho_Chi_Minh"                 "Asia/Hong_Kong"                  
## [275] "Asia/Hovd"                        "Asia/Irkutsk"                    
## [277] "Asia/Istanbul"                    "Asia/Jakarta"                    
## [279] "Asia/Jayapura"                    "Asia/Jerusalem"                  
## [281] "Asia/Kabul"                       "Asia/Kamchatka"                  
## [283] "Asia/Karachi"                     "Asia/Kashgar"                    
## [285] "Asia/Kathmandu"                   "Asia/Katmandu"                   
## [287] "Asia/Khandyga"                    "Asia/Kolkata"                    
## [289] "Asia/Krasnoyarsk"                 "Asia/Kuala_Lumpur"               
## [291] "Asia/Kuching"                     "Asia/Kuwait"                     
## [293] "Asia/Macao"                       "Asia/Macau"                      
## [295] "Asia/Magadan"                     "Asia/Makassar"                   
## [297] "Asia/Manila"                      "Asia/Muscat"                     
## [299] "Asia/Nicosia"                     "Asia/Novokuznetsk"               
## [301] "Asia/Novosibirsk"                 "Asia/Omsk"                       
## [303] "Asia/Oral"                        "Asia/Phnom_Penh"                 
## [305] "Asia/Pontianak"                   "Asia/Pyongyang"                  
## [307] "Asia/Qatar"                       "Asia/Qostanay"                   
## [309] "Asia/Qyzylorda"                   "Asia/Rangoon"                    
## [311] "Asia/Riyadh"                      "Asia/Saigon"                     
## [313] "Asia/Sakhalin"                    "Asia/Samarkand"                  
## [315] "Asia/Seoul"                       "Asia/Shanghai"                   
## [317] "Asia/Singapore"                   "Asia/Srednekolymsk"              
## [319] "Asia/Taipei"                      "Asia/Tashkent"                   
## [321] "Asia/Tbilisi"                     "Asia/Tehran"                     
## [323] "Asia/Tel_Aviv"                    "Asia/Thimbu"                     
## [325] "Asia/Thimphu"                     "Asia/Tokyo"                      
## [327] "Asia/Tomsk"                       "Asia/Ujung_Pandang"              
## [329] "Asia/Ulaanbaatar"                 "Asia/Ulan_Bator"                 
## [331] "Asia/Urumqi"                      "Asia/Ust-Nera"                   
## [333] "Asia/Vientiane"                   "Asia/Vladivostok"                
## [335] "Asia/Yakutsk"                     "Asia/Yangon"                     
## [337] "Asia/Yekaterinburg"               "Asia/Yerevan"                    
## [339] "AST"                              "Atlantic/Azores"                 
## [341] "Atlantic/Bermuda"                 "Atlantic/Canary"                 
## [343] "Atlantic/Cape_Verde"              "Atlantic/Faeroe"                 
## [345] "Atlantic/Faroe"                   "Atlantic/Jan_Mayen"              
## [347] "Atlantic/Madeira"                 "Atlantic/Reykjavik"              
## [349] "Atlantic/South_Georgia"           "Atlantic/St_Helena"              
## [351] "Atlantic/Stanley"                 "Australia/ACT"                   
## [353] "Australia/Adelaide"               "Australia/Brisbane"              
## [355] "Australia/Broken_Hill"            "Australia/Canberra"              
## [357] "Australia/Currie"                 "Australia/Darwin"                
## [359] "Australia/Eucla"                  "Australia/Hobart"                
## [361] "Australia/LHI"                    "Australia/Lindeman"              
## [363] "Australia/Lord_Howe"              "Australia/Melbourne"             
## [365] "Australia/North"                  "Australia/NSW"                   
## [367] "Australia/Perth"                  "Australia/Queensland"            
## [369] "Australia/South"                  "Australia/Sydney"                
## [371] "Australia/Tasmania"               "Australia/Victoria"              
## [373] "Australia/West"                   "Australia/Yancowinna"            
## [375] "BET"                              "Brazil/Acre"                     
## [377] "Brazil/DeNoronha"                 "Brazil/East"                     
## [379] "Brazil/West"                      "BST"                             
## [381] "Canada/Atlantic"                  "Canada/Central"                  
## [383] "Canada/East-Saskatchewan"         "Canada/Eastern"                  
## [385] "Canada/Mountain"                  "Canada/Newfoundland"             
## [387] "Canada/Pacific"                   "Canada/Saskatchewan"             
## [389] "Canada/Yukon"                     "CAT"                             
## [391] "CET"                              "Chile/Continental"               
## [393] "Chile/EasterIsland"               "CNT"                             
## [395] "CST"                              "CST6CDT"                         
## [397] "CTT"                              "Cuba"                            
## [399] "EAT"                              "ECT"                             
## [401] "EET"                              "Egypt"                           
## [403] "Eire"                             "EST"                             
## [405] "EST5EDT"                          "Etc/GMT"                         
## [407] "Etc/GMT-0"                        "Etc/GMT-1"                       
## [409] "Etc/GMT-2"                        "Etc/GMT-3"                       
## [411] "Etc/GMT-4"                        "Etc/GMT-5"                       
## [413] "Etc/GMT-6"                        "Etc/GMT-7"                       
## [415] "Etc/GMT-8"                        "Etc/GMT-9"                       
## [417] "Etc/GMT-10"                       "Etc/GMT-11"                      
## [419] "Etc/GMT-12"                       "Etc/GMT-13"                      
## [421] "Etc/GMT-14"                       "Etc/GMT+0"                       
## [423] "Etc/GMT+1"                        "Etc/GMT+2"                       
## [425] "Etc/GMT+3"                        "Etc/GMT+4"                       
## [427] "Etc/GMT+5"                        "Etc/GMT+6"                       
## [429] "Etc/GMT+7"                        "Etc/GMT+8"                       
## [431] "Etc/GMT+9"                        "Etc/GMT+10"                      
## [433] "Etc/GMT+11"                       "Etc/GMT+12"                      
## [435] "Etc/GMT0"                         "Etc/Greenwich"                   
## [437] "Etc/UCT"                          "Etc/Universal"                   
## [439] "Etc/UTC"                          "Etc/Zulu"                        
## [441] "Europe/Amsterdam"                 "Europe/Andorra"                  
## [443] "Europe/Astrakhan"                 "Europe/Athens"                   
## [445] "Europe/Belfast"                   "Europe/Belgrade"                 
## [447] "Europe/Berlin"                    "Europe/Bratislava"               
## [449] "Europe/Brussels"                  "Europe/Bucharest"                
## [451] "Europe/Budapest"                  "Europe/Busingen"                 
## [453] "Europe/Chisinau"                  "Europe/Copenhagen"               
## [455] "Europe/Dublin"                    "Europe/Gibraltar"                
## [457] "Europe/Guernsey"                  "Europe/Helsinki"                 
## [459] "Europe/Isle_of_Man"               "Europe/Istanbul"                 
## [461] "Europe/Jersey"                    "Europe/Kaliningrad"              
## [463] "Europe/Kiev"                      "Europe/Kirov"                    
## [465] "Europe/Kyiv"                      "Europe/Lisbon"                   
## [467] "Europe/Ljubljana"                 "Europe/London"                   
## [469] "Europe/Luxembourg"                "Europe/Madrid"                   
## [471] "Europe/Malta"                     "Europe/Mariehamn"                
## [473] "Europe/Minsk"                     "Europe/Monaco"                   
## [475] "Europe/Moscow"                    "Europe/Nicosia"                  
## [477] "Europe/Oslo"                      "Europe/Paris"                    
## [479] "Europe/Podgorica"                 "Europe/Prague"                   
## [481] "Europe/Riga"                      "Europe/Rome"                     
## [483] "Europe/Samara"                    "Europe/San_Marino"               
## [485] "Europe/Sarajevo"                  "Europe/Saratov"                  
## [487] "Europe/Simferopol"                "Europe/Skopje"                   
## [489] "Europe/Sofia"                     "Europe/Stockholm"                
## [491] "Europe/Tallinn"                   "Europe/Tirane"                   
## [493] "Europe/Tiraspol"                  "Europe/Ulyanovsk"                
## [495] "Europe/Uzhgorod"                  "Europe/Vaduz"                    
## [497] "Europe/Vatican"                   "Europe/Vienna"                   
## [499] "Europe/Vilnius"                   "Europe/Volgograd"                
## [501] "Europe/Warsaw"                    "Europe/Zagreb"                   
## [503] "Europe/Zaporozhye"                "Europe/Zurich"                   
## [505] "Factory"                          "GB"                              
## [507] "GB-Eire"                          "GMT"                             
## [509] "GMT-0"                            "GMT+0"                           
## [511] "GMT0"                             "Greenwich"                       
## [513] "Hongkong"                         "HST"                             
## [515] "Iceland"                          "IET"                             
## [517] "Indian/Antananarivo"              "Indian/Chagos"                   
## [519] "Indian/Christmas"                 "Indian/Cocos"                    
## [521] "Indian/Comoro"                    "Indian/Kerguelen"                
## [523] "Indian/Mahe"                      "Indian/Maldives"                 
## [525] "Indian/Mauritius"                 "Indian/Mayotte"                  
## [527] "Indian/Reunion"                   "Iran"                            
## [529] "Israel"                           "IST"                             
## [531] "Jamaica"                          "Japan"                           
## [533] "JST"                              "Kwajalein"                       
## [535] "Libya"                            "MET"                             
## [537] "Mexico/BajaNorte"                 "Mexico/BajaSur"                  
## [539] "Mexico/General"                   "MIT"                             
## [541] "MST"                              "MST7MDT"                         
## [543] "Navajo"                           "NET"                             
## [545] "NST"                              "NZ"                              
## [547] "NZ-CHAT"                          "Pacific/Apia"                    
## [549] "Pacific/Auckland"                 "Pacific/Bougainville"            
## [551] "Pacific/Chatham"                  "Pacific/Chuuk"                   
## [553] "Pacific/Easter"                   "Pacific/Efate"                   
## [555] "Pacific/Enderbury"                "Pacific/Fakaofo"                 
## [557] "Pacific/Fiji"                     "Pacific/Funafuti"                
## [559] "Pacific/Galapagos"                "Pacific/Gambier"                 
## [561] "Pacific/Guadalcanal"              "Pacific/Guam"                    
## [563] "Pacific/Honolulu"                 "Pacific/Johnston"                
## [565] "Pacific/Kanton"                   "Pacific/Kiritimati"              
## [567] "Pacific/Kosrae"                   "Pacific/Kwajalein"               
## [569] "Pacific/Majuro"                   "Pacific/Marquesas"               
## [571] "Pacific/Midway"                   "Pacific/Nauru"                   
## [573] "Pacific/Niue"                     "Pacific/Norfolk"                 
## [575] "Pacific/Noumea"                   "Pacific/Pago_Pago"               
## [577] "Pacific/Palau"                    "Pacific/Pitcairn"                
## [579] "Pacific/Pohnpei"                  "Pacific/Ponape"                  
## [581] "Pacific/Port_Moresby"             "Pacific/Rarotonga"               
## [583] "Pacific/Saipan"                   "Pacific/Samoa"                   
## [585] "Pacific/Tahiti"                   "Pacific/Tarawa"                  
## [587] "Pacific/Tongatapu"                "Pacific/Truk"                    
## [589] "Pacific/Wake"                     "Pacific/Wallis"                  
## [591] "Pacific/Yap"                      "PLT"                             
## [593] "PNT"                              "Poland"                          
## [595] "Portugal"                         "PRC"                             
## [597] "PRT"                              "PST"                             
## [599] "PST8PDT"                          "ROC"                             
## [601] "ROK"                              "Singapore"                       
## [603] "SST"                              "SystemV/AST4"                    
## [605] "SystemV/AST4ADT"                  "SystemV/CST6"                    
## [607] "SystemV/CST6CDT"                  "SystemV/EST5"                    
## [609] "SystemV/EST5EDT"                  "SystemV/HST10"                   
## [611] "SystemV/MST7"                     "SystemV/MST7MDT"                 
## [613] "SystemV/PST8"                     "SystemV/PST8PDT"                 
## [615] "SystemV/YST9"                     "SystemV/YST9YDT"                 
## [617] "Turkey"                           "UCT"                             
## [619] "Universal"                        "US/Alaska"                       
## [621] "US/Aleutian"                      "US/Arizona"                      
## [623] "US/Central"                       "US/East-Indiana"                 
## [625] "US/Eastern"                       "US/Hawaii"                       
## [627] "US/Indiana-Starke"                "US/Michigan"                     
## [629] "US/Mountain"                      "US/Pacific"                      
## [631] "US/Pacific-New"                   "US/Samoa"                        
## [633] "UTC"                              "VST"                             
## [635] "W-SU"                             "WET"                             
## [637] "Zulu"
```

``` r
stri_timezone_list(offset=1)
```

```
##  [1] "Africa/Algiers"      "Africa/Bangui"       "Africa/Brazzaville" 
##  [4] "Africa/Ceuta"        "Africa/Douala"       "Africa/Kinshasa"    
##  [7] "Africa/Lagos"        "Africa/Libreville"   "Africa/Luanda"      
## [10] "Africa/Malabo"       "Africa/Ndjamena"     "Africa/Niamey"      
## [13] "Africa/Porto-Novo"   "Africa/Tunis"        "Arctic/Longyearbyen"
## [16] "Atlantic/Jan_Mayen"  "CET"                 "ECT"                
## [19] "Etc/GMT-1"           "Europe/Amsterdam"    "Europe/Andorra"     
## [22] "Europe/Belgrade"     "Europe/Berlin"       "Europe/Bratislava"  
## [25] "Europe/Brussels"     "Europe/Budapest"     "Europe/Busingen"    
## [28] "Europe/Copenhagen"   "Europe/Gibraltar"    "Europe/Ljubljana"   
## [31] "Europe/Luxembourg"   "Europe/Madrid"       "Europe/Malta"       
## [34] "Europe/Monaco"       "Europe/Oslo"         "Europe/Paris"       
## [37] "Europe/Podgorica"    "Europe/Prague"       "Europe/Rome"        
## [40] "Europe/San_Marino"   "Europe/Sarajevo"     "Europe/Skopje"      
## [43] "Europe/Stockholm"    "Europe/Tirane"       "Europe/Vaduz"       
## [46] "Europe/Vatican"      "Europe/Vienna"       "Europe/Warsaw"      
## [49] "Europe/Zagreb"       "Europe/Zurich"       "MET"                
## [52] "Poland"
```

``` r
stri_timezone_list(offset=5.5)
```

```
## [1] "Asia/Calcutta" "Asia/Colombo"  "Asia/Kolkata"  "IST"
```

``` r
stri_timezone_list(offset=5.75)
```

```
## [1] "Asia/Kathmandu" "Asia/Katmandu"
```

``` r
stri_timezone_list(region='PL')
```

```
## [1] "Europe/Warsaw" "Poland"
```

``` r
stri_timezone_list(region='US', offset=-10)
```

```
## [1] "America/Adak"     "America/Atka"     "Pacific/Honolulu" "US/Aleutian"     
## [5] "US/Hawaii"
```

``` r
# Fetch information on all time zones
do.call(rbind.data.frame,
   lapply(stri_timezone_list(), function(tz) stri_timezone_info(tz)))
```

```
##                                   ID                                     Name
## 1                                ACT         Australian Central Standard Time
## 2                                AET         Australian Eastern Standard Time
## 3                     Africa/Abidjan                      Greenwich Mean Time
## 4                       Africa/Accra                      Greenwich Mean Time
## 5                 Africa/Addis_Ababa                      Eastern Africa Time
## 6                     Africa/Algiers           Central European Standard Time
## 7                      Africa/Asmara                      Eastern Africa Time
## 8                      Africa/Asmera                      Eastern Africa Time
## 9                      Africa/Bamako                      Greenwich Mean Time
## 10                     Africa/Bangui                West Africa Standard Time
## 11                     Africa/Banjul                      Greenwich Mean Time
## 12                     Africa/Bissau                      Greenwich Mean Time
## 13                   Africa/Blantyre                      Central Africa Time
## 14                Africa/Brazzaville                West Africa Standard Time
## 15                  Africa/Bujumbura                      Central Africa Time
## 16                      Africa/Cairo           Eastern European Standard Time
## 17                 Africa/Casablanca                                      GMT
## 18                      Africa/Ceuta           Central European Standard Time
## 19                    Africa/Conakry                      Greenwich Mean Time
## 20                      Africa/Dakar                      Greenwich Mean Time
## 21              Africa/Dar_es_Salaam                      Eastern Africa Time
## 22                   Africa/Djibouti                      Eastern Africa Time
## 23                     Africa/Douala                West Africa Standard Time
## 24                   Africa/El_Aaiun                                      GMT
## 25                   Africa/Freetown                      Greenwich Mean Time
## 26                   Africa/Gaborone                      Central Africa Time
## 27                     Africa/Harare                      Central Africa Time
## 28               Africa/Johannesburg               South Africa Standard Time
## 29                       Africa/Juba                      Central Africa Time
## 30                    Africa/Kampala                      Eastern Africa Time
## 31                   Africa/Khartoum                      Central Africa Time
## 32                     Africa/Kigali                      Central Africa Time
## 33                   Africa/Kinshasa                West Africa Standard Time
## 34                      Africa/Lagos                West Africa Standard Time
## 35                 Africa/Libreville                West Africa Standard Time
## 36                       Africa/Lome                      Greenwich Mean Time
## 37                     Africa/Luanda                West Africa Standard Time
## 38                 Africa/Lubumbashi                      Central Africa Time
## 39                     Africa/Lusaka                      Central Africa Time
## 40                     Africa/Malabo                West Africa Standard Time
## 41                     Africa/Maputo                      Central Africa Time
## 42                     Africa/Maseru               South Africa Standard Time
## 43                    Africa/Mbabane               South Africa Standard Time
## 44                  Africa/Mogadishu                      Eastern Africa Time
## 45                   Africa/Monrovia                      Greenwich Mean Time
## 46                    Africa/Nairobi                      Eastern Africa Time
## 47                   Africa/Ndjamena                West Africa Standard Time
## 48                     Africa/Niamey                West Africa Standard Time
## 49                 Africa/Nouakchott                      Greenwich Mean Time
## 50                Africa/Ouagadougou                      Greenwich Mean Time
## 51                 Africa/Porto-Novo                West Africa Standard Time
## 52                   Africa/Sao_Tome                      Greenwich Mean Time
## 53                   Africa/Timbuktu                      Greenwich Mean Time
## 54                    Africa/Tripoli           Eastern European Standard Time
## 55                      Africa/Tunis           Central European Standard Time
## 56                   Africa/Windhoek                      Central Africa Time
## 57                               AGT                  Argentina Standard Time
## 58                      America/Adak            Hawaii-Aleutian Standard Time
## 59                 America/Anchorage                     Alaska Standard Time
## 60                  America/Anguilla                   Atlantic Standard Time
## 61                   America/Antigua                   Atlantic Standard Time
## 62                 America/Araguaina                   Brasilia Standard Time
## 63    America/Argentina/Buenos_Aires                  Argentina Standard Time
## 64       America/Argentina/Catamarca                  Argentina Standard Time
## 65  America/Argentina/ComodRivadavia                  Argentina Standard Time
## 66         America/Argentina/Cordoba                  Argentina Standard Time
## 67           America/Argentina/Jujuy                  Argentina Standard Time
## 68        America/Argentina/La_Rioja                  Argentina Standard Time
## 69         America/Argentina/Mendoza                  Argentina Standard Time
## 70    America/Argentina/Rio_Gallegos                  Argentina Standard Time
## 71           America/Argentina/Salta                  Argentina Standard Time
## 72        America/Argentina/San_Juan                  Argentina Standard Time
## 73        America/Argentina/San_Luis                  Argentina Standard Time
## 74         America/Argentina/Tucuman                  Argentina Standard Time
## 75         America/Argentina/Ushuaia                  Argentina Standard Time
## 76                     America/Aruba                   Atlantic Standard Time
## 77                  America/Asuncion                   Paraguay Standard Time
## 78                  America/Atikokan                    Eastern Standard Time
## 79                      America/Atka            Hawaii-Aleutian Standard Time
## 80                     America/Bahia                   Brasilia Standard Time
## 81            America/Bahia_Banderas                    Central Standard Time
## 82                  America/Barbados                   Atlantic Standard Time
## 83                     America/Belem                   Brasilia Standard Time
## 84                    America/Belize                    Central Standard Time
## 85              America/Blanc-Sablon                   Atlantic Standard Time
## 86                 America/Boa_Vista                     Amazon Standard Time
## 87                    America/Bogota                   Colombia Standard Time
## 88                     America/Boise                   Mountain Standard Time
## 89              America/Buenos_Aires                  Argentina Standard Time
## 90             America/Cambridge_Bay                   Mountain Standard Time
## 91              America/Campo_Grande                     Amazon Standard Time
## 92                    America/Cancun                    Eastern Standard Time
## 93                   America/Caracas                           Venezuela Time
## 94                 America/Catamarca                  Argentina Standard Time
## 95                   America/Cayenne                       French Guiana Time
## 96                    America/Cayman                    Eastern Standard Time
## 97                   America/Chicago                    Central Standard Time
## 98                 America/Chihuahua                    Central Standard Time
## 99             America/Ciudad_Juarez                   Mountain Standard Time
## 100            America/Coral_Harbour                    Eastern Standard Time
## 101                  America/Cordoba                  Argentina Standard Time
## 102               America/Costa_Rica                    Central Standard Time
## 103                  America/Creston                   Mountain Standard Time
## 104                   America/Cuiaba                     Amazon Standard Time
## 105                  America/Curacao                   Atlantic Standard Time
## 106             America/Danmarkshavn                      Greenwich Mean Time
## 107                   America/Dawson                               Yukon Time
## 108             America/Dawson_Creek                   Mountain Standard Time
## 109                   America/Denver                   Mountain Standard Time
## 110                  America/Detroit                    Eastern Standard Time
## 111                 America/Dominica                   Atlantic Standard Time
## 112                 America/Edmonton                   Mountain Standard Time
## 113                 America/Eirunepe                       Acre Standard Time
## 114              America/El_Salvador                    Central Standard Time
## 115                 America/Ensenada                    Pacific Standard Time
## 116              America/Fort_Nelson                   Mountain Standard Time
## 117               America/Fort_Wayne                    Eastern Standard Time
## 118                America/Fortaleza                   Brasilia Standard Time
## 119                America/Glace_Bay                   Atlantic Standard Time
## 120                  America/Godthab             West Greenland Standard Time
## 121                America/Goose_Bay                   Atlantic Standard Time
## 122               America/Grand_Turk                    Eastern Standard Time
## 123                  America/Grenada                   Atlantic Standard Time
## 124               America/Guadeloupe                   Atlantic Standard Time
## 125                America/Guatemala                    Central Standard Time
## 126                America/Guayaquil                             Ecuador Time
## 127                   America/Guyana                              Guyana Time
## 128                  America/Halifax                   Atlantic Standard Time
## 129                   America/Havana                       Cuba Standard Time
## 130               America/Hermosillo            Mexican Pacific Standard Time
## 131     America/Indiana/Indianapolis                    Eastern Standard Time
## 132             America/Indiana/Knox                    Central Standard Time
## 133          America/Indiana/Marengo                    Eastern Standard Time
## 134       America/Indiana/Petersburg                    Eastern Standard Time
## 135        America/Indiana/Tell_City                    Central Standard Time
## 136            America/Indiana/Vevay                    Eastern Standard Time
## 137        America/Indiana/Vincennes                    Eastern Standard Time
## 138          America/Indiana/Winamac                    Eastern Standard Time
## 139             America/Indianapolis                    Eastern Standard Time
## 140                   America/Inuvik                   Mountain Standard Time
## 141                  America/Iqaluit                    Eastern Standard Time
## 142                  America/Jamaica                    Eastern Standard Time
## 143                    America/Jujuy                  Argentina Standard Time
## 144                   America/Juneau                     Alaska Standard Time
## 145      America/Kentucky/Louisville                    Eastern Standard Time
## 146      America/Kentucky/Monticello                    Eastern Standard Time
## 147                  America/Knox_IN                    Central Standard Time
## 148               America/Kralendijk                   Atlantic Standard Time
## 149                   America/La_Paz                             Bolivia Time
## 150                     America/Lima                       Peru Standard Time
## 151              America/Los_Angeles                    Pacific Standard Time
## 152               America/Louisville                    Eastern Standard Time
## 153            America/Lower_Princes                   Atlantic Standard Time
## 154                   America/Maceio                   Brasilia Standard Time
## 155                  America/Managua                    Central Standard Time
## 156                   America/Manaus                     Amazon Standard Time
## 157                  America/Marigot                   Atlantic Standard Time
## 158               America/Martinique                   Atlantic Standard Time
## 159                America/Matamoros                    Central Standard Time
## 160                 America/Mazatlan            Mexican Pacific Standard Time
## 161                  America/Mendoza                  Argentina Standard Time
## 162                America/Menominee                    Central Standard Time
## 163                   America/Merida                    Central Standard Time
## 164               America/Metlakatla                     Alaska Standard Time
## 165              America/Mexico_City                    Central Standard Time
## 166                 America/Miquelon       St Pierre & Miquelon Standard Time
## 167                  America/Moncton                   Atlantic Standard Time
## 168                America/Monterrey                    Central Standard Time
## 169               America/Montevideo                    Uruguay Standard Time
## 170                 America/Montreal                    Eastern Standard Time
## 171               America/Montserrat                   Atlantic Standard Time
## 172                   America/Nassau                    Eastern Standard Time
## 173                 America/New_York                    Eastern Standard Time
## 174                  America/Nipigon                    Eastern Standard Time
## 175                     America/Nome                     Alaska Standard Time
## 176                  America/Noronha        Fernando de Noronha Standard Time
## 177      America/North_Dakota/Beulah                    Central Standard Time
## 178      America/North_Dakota/Center                    Central Standard Time
## 179   America/North_Dakota/New_Salem                    Central Standard Time
## 180                     America/Nuuk             West Greenland Standard Time
## 181                  America/Ojinaga                    Central Standard Time
## 182                   America/Panama                    Eastern Standard Time
## 183              America/Pangnirtung                    Eastern Standard Time
## 184               America/Paramaribo                            Suriname Time
## 185                  America/Phoenix                   Mountain Standard Time
## 186            America/Port_of_Spain                   Atlantic Standard Time
## 187           America/Port-au-Prince                    Eastern Standard Time
## 188               America/Porto_Acre                       Acre Standard Time
## 189              America/Porto_Velho                     Amazon Standard Time
## 190              America/Puerto_Rico                   Atlantic Standard Time
## 191             America/Punta_Arenas                                GMT-03:00
## 192              America/Rainy_River                    Central Standard Time
## 193             America/Rankin_Inlet                    Central Standard Time
## 194                   America/Recife                   Brasilia Standard Time
## 195                   America/Regina                    Central Standard Time
## 196                 America/Resolute                    Central Standard Time
## 197               America/Rio_Branco                       Acre Standard Time
## 198                  America/Rosario                  Argentina Standard Time
## 199             America/Santa_Isabel                    Pacific Standard Time
## 200                 America/Santarem                   Brasilia Standard Time
## 201                 America/Santiago                      Chile Standard Time
## 202            America/Santo_Domingo                   Atlantic Standard Time
## 203                America/Sao_Paulo                   Brasilia Standard Time
## 204             America/Scoresbysund             East Greenland Standard Time
## 205                 America/Shiprock                   Mountain Standard Time
## 206                    America/Sitka                     Alaska Standard Time
## 207            America/St_Barthelemy                   Atlantic Standard Time
## 208                 America/St_Johns               Newfoundland Standard Time
## 209                 America/St_Kitts                   Atlantic Standard Time
## 210                 America/St_Lucia                   Atlantic Standard Time
## 211                America/St_Thomas                   Atlantic Standard Time
## 212               America/St_Vincent                   Atlantic Standard Time
## 213            America/Swift_Current                    Central Standard Time
## 214              America/Tegucigalpa                    Central Standard Time
## 215                    America/Thule                   Atlantic Standard Time
## 216              America/Thunder_Bay                    Eastern Standard Time
## 217                  America/Tijuana                    Pacific Standard Time
## 218                  America/Toronto                    Eastern Standard Time
## 219                  America/Tortola                   Atlantic Standard Time
## 220                America/Vancouver                    Pacific Standard Time
## 221                   America/Virgin                   Atlantic Standard Time
## 222               America/Whitehorse                               Yukon Time
## 223                 America/Winnipeg                    Central Standard Time
## 224                  America/Yakutat                     Alaska Standard Time
## 225              America/Yellowknife                   Mountain Standard Time
## 226                 Antarctica/Casey                               Casey Time
## 227                 Antarctica/Davis                               Davis Time
## 228        Antarctica/DumontDUrville                    Dumont-d’Urville Time
## 229             Antarctica/Macquarie         Australian Eastern Standard Time
## 230                Antarctica/Mawson                              Mawson Time
## 231               Antarctica/McMurdo                New Zealand Standard Time
## 232                Antarctica/Palmer                                GMT-03:00
## 233               Antarctica/Rothera                             Rothera Time
## 234            Antarctica/South_Pole                New Zealand Standard Time
## 235                 Antarctica/Syowa                               Syowa Time
## 236                 Antarctica/Troll                      Greenwich Mean Time
## 237                Antarctica/Vostok                              Vostok Time
## 238              Arctic/Longyearbyen           Central European Standard Time
## 239                              ART           Eastern European Standard Time
## 240                        Asia/Aden                     Arabia Standard Time
## 241                      Asia/Almaty                     East Kazakhstan Time
## 242                       Asia/Amman                                GMT+03:00
## 243                      Asia/Anadyr                     Anadyr Standard Time
## 244                       Asia/Aqtau                     West Kazakhstan Time
## 245                      Asia/Aqtobe                     West Kazakhstan Time
## 246                    Asia/Ashgabat               Turkmenistan Standard Time
## 247                   Asia/Ashkhabad               Turkmenistan Standard Time
## 248                      Asia/Atyrau                     West Kazakhstan Time
## 249                     Asia/Baghdad                     Arabia Standard Time
## 250                     Asia/Bahrain                     Arabia Standard Time
## 251                        Asia/Baku                 Azerbaijan Standard Time
## 252                     Asia/Bangkok                           Indochina Time
## 253                     Asia/Barnaul                                GMT+07:00
## 254                      Asia/Beirut           Eastern European Standard Time
## 255                     Asia/Bishkek                          Kyrgyzstan Time
## 256                      Asia/Brunei                   Brunei Darussalam Time
## 257                    Asia/Calcutta                      India Standard Time
## 258                       Asia/Chita                    Yakutsk Standard Time
## 259                  Asia/Choibalsan                Ulaanbaatar Standard Time
## 260                   Asia/Chongqing                      China Standard Time
## 261                   Asia/Chungking                      China Standard Time
## 262                     Asia/Colombo                      India Standard Time
## 263                       Asia/Dacca                 Bangladesh Standard Time
## 264                    Asia/Damascus                                GMT+03:00
## 265                       Asia/Dhaka                 Bangladesh Standard Time
## 266                        Asia/Dili                          East Timor Time
## 267                       Asia/Dubai                       Gulf Standard Time
## 268                    Asia/Dushanbe                          Tajikistan Time
## 269                   Asia/Famagusta                                GMT+02:00
## 270                        Asia/Gaza           Eastern European Standard Time
## 271                      Asia/Harbin                      China Standard Time
## 272                      Asia/Hebron           Eastern European Standard Time
## 273                 Asia/Ho_Chi_Minh                           Indochina Time
## 274                   Asia/Hong_Kong                  Hong Kong Standard Time
## 275                        Asia/Hovd                       Hovd Standard Time
## 276                     Asia/Irkutsk                    Irkutsk Standard Time
## 277                    Asia/Istanbul                                GMT+03:00
## 278                     Asia/Jakarta                   Western Indonesia Time
## 279                    Asia/Jayapura                   Eastern Indonesia Time
## 280                   Asia/Jerusalem                     Israel Standard Time
## 281                       Asia/Kabul                         Afghanistan Time
## 282                   Asia/Kamchatka   Petropavlovsk-Kamchatski Standard Time
## 283                     Asia/Karachi                   Pakistan Standard Time
## 284                     Asia/Kashgar                                GMT+06:00
## 285                   Asia/Kathmandu                               Nepal Time
## 286                    Asia/Katmandu                               Nepal Time
## 287                    Asia/Khandyga                    Yakutsk Standard Time
## 288                     Asia/Kolkata                      India Standard Time
## 289                 Asia/Krasnoyarsk                Krasnoyarsk Standard Time
## 290                Asia/Kuala_Lumpur                            Malaysia Time
## 291                     Asia/Kuching                            Malaysia Time
## 292                      Asia/Kuwait                     Arabia Standard Time
## 293                       Asia/Macao                      China Standard Time
## 294                       Asia/Macau                      China Standard Time
## 295                     Asia/Magadan                    Magadan Standard Time
## 296                    Asia/Makassar                   Central Indonesia Time
## 297                      Asia/Manila                 Philippine Standard Time
## 298                      Asia/Muscat                       Gulf Standard Time
## 299                     Asia/Nicosia           Eastern European Standard Time
## 300                Asia/Novokuznetsk                Krasnoyarsk Standard Time
## 301                 Asia/Novosibirsk                Novosibirsk Standard Time
## 302                        Asia/Omsk                       Omsk Standard Time
## 303                        Asia/Oral                     West Kazakhstan Time
## 304                  Asia/Phnom_Penh                           Indochina Time
## 305                   Asia/Pontianak                   Western Indonesia Time
## 306                   Asia/Pyongyang                     Korean Standard Time
## 307                       Asia/Qatar                     Arabia Standard Time
## 308                    Asia/Qostanay                     East Kazakhstan Time
## 309                   Asia/Qyzylorda                     West Kazakhstan Time
## 310                     Asia/Rangoon                             Myanmar Time
## 311                      Asia/Riyadh                     Arabia Standard Time
## 312                      Asia/Saigon                           Indochina Time
## 313                    Asia/Sakhalin                   Sakhalin Standard Time
## 314                   Asia/Samarkand                 Uzbekistan Standard Time
## 315                       Asia/Seoul                     Korean Standard Time
## 316                    Asia/Shanghai                      China Standard Time
## 317                   Asia/Singapore                  Singapore Standard Time
## 318               Asia/Srednekolymsk                                GMT+11:00
## 319                      Asia/Taipei                     Taipei Standard Time
## 320                    Asia/Tashkent                 Uzbekistan Standard Time
## 321                     Asia/Tbilisi                    Georgia Standard Time
## 322                      Asia/Tehran                       Iran Standard Time
## 323                    Asia/Tel_Aviv                     Israel Standard Time
## 324                      Asia/Thimbu                              Bhutan Time
## 325                     Asia/Thimphu                              Bhutan Time
## 326                       Asia/Tokyo                      Japan Standard Time
## 327                       Asia/Tomsk                                GMT+07:00
## 328               Asia/Ujung_Pandang                   Central Indonesia Time
## 329                 Asia/Ulaanbaatar                Ulaanbaatar Standard Time
## 330                  Asia/Ulan_Bator                Ulaanbaatar Standard Time
## 331                      Asia/Urumqi                                GMT+06:00
## 332                    Asia/Ust-Nera                Vladivostok Standard Time
## 333                   Asia/Vientiane                           Indochina Time
## 334                 Asia/Vladivostok                Vladivostok Standard Time
## 335                     Asia/Yakutsk                    Yakutsk Standard Time
## 336                      Asia/Yangon                             Myanmar Time
## 337               Asia/Yekaterinburg              Yekaterinburg Standard Time
## 338                     Asia/Yerevan                    Armenia Standard Time
## 339                              AST                     Alaska Standard Time
## 340                  Atlantic/Azores                     Azores Standard Time
## 341                 Atlantic/Bermuda                   Atlantic Standard Time
## 342                  Atlantic/Canary           Western European Standard Time
## 343              Atlantic/Cape_Verde                 Cape Verde Standard Time
## 344                  Atlantic/Faeroe           Western European Standard Time
## 345                   Atlantic/Faroe           Western European Standard Time
## 346               Atlantic/Jan_Mayen           Central European Standard Time
## 347                 Atlantic/Madeira           Western European Standard Time
## 348               Atlantic/Reykjavik                      Greenwich Mean Time
## 349           Atlantic/South_Georgia                       South Georgia Time
## 350               Atlantic/St_Helena                      Greenwich Mean Time
## 351                 Atlantic/Stanley           Falkland Islands Standard Time
## 352                    Australia/ACT         Australian Eastern Standard Time
## 353               Australia/Adelaide         Australian Central Standard Time
## 354               Australia/Brisbane         Australian Eastern Standard Time
## 355            Australia/Broken_Hill         Australian Central Standard Time
## 356               Australia/Canberra         Australian Eastern Standard Time
## 357                 Australia/Currie         Australian Eastern Standard Time
## 358                 Australia/Darwin         Australian Central Standard Time
## 359                  Australia/Eucla Australian Central Western Standard Time
## 360                 Australia/Hobart         Australian Eastern Standard Time
## 361                    Australia/LHI                  Lord Howe Standard Time
## 362               Australia/Lindeman         Australian Eastern Standard Time
## 363              Australia/Lord_Howe                  Lord Howe Standard Time
## 364              Australia/Melbourne         Australian Eastern Standard Time
## 365                  Australia/North         Australian Central Standard Time
## 366                    Australia/NSW         Australian Eastern Standard Time
## 367                  Australia/Perth         Australian Western Standard Time
## 368             Australia/Queensland         Australian Eastern Standard Time
## 369                  Australia/South         Australian Central Standard Time
## 370                 Australia/Sydney         Australian Eastern Standard Time
## 371               Australia/Tasmania         Australian Eastern Standard Time
## 372               Australia/Victoria         Australian Eastern Standard Time
## 373                   Australia/West         Australian Western Standard Time
## 374             Australia/Yancowinna         Australian Central Standard Time
## 375                              BET                   Brasilia Standard Time
## 376                      Brazil/Acre                       Acre Standard Time
## 377                 Brazil/DeNoronha        Fernando de Noronha Standard Time
## 378                      Brazil/East                   Brasilia Standard Time
## 379                      Brazil/West                     Amazon Standard Time
## 380                              BST                 Bangladesh Standard Time
## 381                  Canada/Atlantic                   Atlantic Standard Time
## 382                   Canada/Central                    Central Standard Time
## 383         Canada/East-Saskatchewan                    Central Standard Time
## 384                   Canada/Eastern                    Eastern Standard Time
## 385                  Canada/Mountain                   Mountain Standard Time
## 386              Canada/Newfoundland               Newfoundland Standard Time
## 387                   Canada/Pacific                    Pacific Standard Time
## 388              Canada/Saskatchewan                    Central Standard Time
## 389                     Canada/Yukon                               Yukon Time
## 390                              CAT                      Central Africa Time
## 391                              CET                                GMT+01:00
## 392                Chile/Continental                      Chile Standard Time
## 393               Chile/EasterIsland              Easter Island Standard Time
## 394                              CNT               Newfoundland Standard Time
## 395                              CST                    Central Standard Time
## 396                          CST6CDT                    Central Standard Time
## 397                              CTT                      China Standard Time
## 398                             Cuba                       Cuba Standard Time
## 399                              EAT                      Eastern Africa Time
## 400                              ECT           Central European Standard Time
## 401                              EET                                GMT+02:00
## 402                            Egypt           Eastern European Standard Time
## 403                             Eire                      Greenwich Mean Time
## 404                              EST                                GMT-05:00
## 405                          EST5EDT                    Eastern Standard Time
## 406                          Etc/GMT                      Greenwich Mean Time
## 407                        Etc/GMT-0                      Greenwich Mean Time
## 408                        Etc/GMT-1                                GMT+01:00
## 409                        Etc/GMT-2                                GMT+02:00
## 410                        Etc/GMT-3                                GMT+03:00
## 411                        Etc/GMT-4                                GMT+04:00
## 412                        Etc/GMT-5                                GMT+05:00
## 413                        Etc/GMT-6                                GMT+06:00
## 414                        Etc/GMT-7                                GMT+07:00
## 415                        Etc/GMT-8                                GMT+08:00
## 416                        Etc/GMT-9                                GMT+09:00
## 417                       Etc/GMT-10                                GMT+10:00
## 418                       Etc/GMT-11                                GMT+11:00
## 419                       Etc/GMT-12                                GMT+12:00
## 420                       Etc/GMT-13                                GMT+13:00
## 421                       Etc/GMT-14                                GMT+14:00
## 422                        Etc/GMT+0                      Greenwich Mean Time
## 423                        Etc/GMT+1                                GMT-01:00
## 424                        Etc/GMT+2                                GMT-02:00
## 425                        Etc/GMT+3                                GMT-03:00
## 426                        Etc/GMT+4                                GMT-04:00
## 427                        Etc/GMT+5                                GMT-05:00
## 428                        Etc/GMT+6                                GMT-06:00
## 429                        Etc/GMT+7                                GMT-07:00
## 430                        Etc/GMT+8                                GMT-08:00
## 431                        Etc/GMT+9                                GMT-09:00
## 432                       Etc/GMT+10                                GMT-10:00
## 433                       Etc/GMT+11                                GMT-11:00
## 434                       Etc/GMT+12                                GMT-12:00
## 435                         Etc/GMT0                      Greenwich Mean Time
## 436                    Etc/Greenwich                      Greenwich Mean Time
## 437                          Etc/UCT               Coordinated Universal Time
## 438                    Etc/Universal               Coordinated Universal Time
## 439                          Etc/UTC               Coordinated Universal Time
## 440                         Etc/Zulu               Coordinated Universal Time
## 441                 Europe/Amsterdam           Central European Standard Time
## 442                   Europe/Andorra           Central European Standard Time
## 443                 Europe/Astrakhan                                GMT+04:00
## 444                    Europe/Athens           Eastern European Standard Time
## 445                   Europe/Belfast                      Greenwich Mean Time
## 446                  Europe/Belgrade           Central European Standard Time
## 447                    Europe/Berlin           Central European Standard Time
## 448                Europe/Bratislava           Central European Standard Time
## 449                  Europe/Brussels           Central European Standard Time
## 450                 Europe/Bucharest           Eastern European Standard Time
## 451                  Europe/Budapest           Central European Standard Time
## 452                  Europe/Busingen           Central European Standard Time
## 453                  Europe/Chisinau           Eastern European Standard Time
## 454                Europe/Copenhagen           Central European Standard Time
## 455                    Europe/Dublin                      Greenwich Mean Time
## 456                 Europe/Gibraltar           Central European Standard Time
## 457                  Europe/Guernsey                      Greenwich Mean Time
## 458                  Europe/Helsinki           Eastern European Standard Time
## 459               Europe/Isle_of_Man                      Greenwich Mean Time
## 460                  Europe/Istanbul                                GMT+03:00
## 461                    Europe/Jersey                      Greenwich Mean Time
## 462               Europe/Kaliningrad           Eastern European Standard Time
## 463                      Europe/Kiev           Eastern European Standard Time
## 464                     Europe/Kirov                                GMT+03:00
## 465                      Europe/Kyiv           Eastern European Standard Time
## 466                    Europe/Lisbon           Western European Standard Time
## 467                 Europe/Ljubljana           Central European Standard Time
## 468                    Europe/London                      Greenwich Mean Time
## 469                Europe/Luxembourg           Central European Standard Time
## 470                    Europe/Madrid           Central European Standard Time
## 471                     Europe/Malta           Central European Standard Time
## 472                 Europe/Mariehamn           Eastern European Standard Time
## 473                     Europe/Minsk                     Moscow Standard Time
## 474                    Europe/Monaco           Central European Standard Time
## 475                    Europe/Moscow                     Moscow Standard Time
## 476                   Europe/Nicosia           Eastern European Standard Time
## 477                      Europe/Oslo           Central European Standard Time
## 478                     Europe/Paris           Central European Standard Time
## 479                 Europe/Podgorica           Central European Standard Time
## 480                    Europe/Prague           Central European Standard Time
## 481                      Europe/Riga           Eastern European Standard Time
## 482                      Europe/Rome           Central European Standard Time
## 483                    Europe/Samara                     Samara Standard Time
## 484                Europe/San_Marino           Central European Standard Time
## 485                  Europe/Sarajevo           Central European Standard Time
## 486                   Europe/Saratov                                GMT+04:00
## 487                Europe/Simferopol                     Moscow Standard Time
## 488                    Europe/Skopje           Central European Standard Time
## 489                     Europe/Sofia           Eastern European Standard Time
## 490                 Europe/Stockholm           Central European Standard Time
## 491                   Europe/Tallinn           Eastern European Standard Time
## 492                    Europe/Tirane           Central European Standard Time
## 493                  Europe/Tiraspol           Eastern European Standard Time
## 494                 Europe/Ulyanovsk                                GMT+04:00
## 495                  Europe/Uzhgorod           Eastern European Standard Time
## 496                     Europe/Vaduz           Central European Standard Time
## 497                   Europe/Vatican           Central European Standard Time
## 498                    Europe/Vienna           Central European Standard Time
## 499                   Europe/Vilnius           Eastern European Standard Time
## 500                 Europe/Volgograd                  Volgograd Standard Time
## 501                    Europe/Warsaw           Central European Standard Time
## 502                    Europe/Zagreb           Central European Standard Time
## 503                Europe/Zaporozhye           Eastern European Standard Time
## 504                    Europe/Zurich           Central European Standard Time
## 505                          Factory                                      GMT
## 506                               GB                      Greenwich Mean Time
## 507                          GB-Eire                      Greenwich Mean Time
## 508                              GMT                      Greenwich Mean Time
## 509                            GMT-0                      Greenwich Mean Time
## 510                            GMT+0                      Greenwich Mean Time
## 511                             GMT0                      Greenwich Mean Time
## 512                        Greenwich                      Greenwich Mean Time
## 513                         Hongkong                  Hong Kong Standard Time
## 514                              HST                                GMT-10:00
## 515                          Iceland                      Greenwich Mean Time
## 516                              IET                    Eastern Standard Time
## 517              Indian/Antananarivo                      Eastern Africa Time
## 518                    Indian/Chagos                        Indian Ocean Time
## 519                 Indian/Christmas                    Christmas Island Time
## 520                     Indian/Cocos                       Cocos Islands Time
## 521                    Indian/Comoro                      Eastern Africa Time
## 522                 Indian/Kerguelen         French Southern & Antarctic Time
## 523                      Indian/Mahe                          Seychelles Time
## 524                  Indian/Maldives                            Maldives Time
## 525                 Indian/Mauritius                  Mauritius Standard Time
## 526                   Indian/Mayotte                      Eastern Africa Time
## 527                   Indian/Reunion                             Réunion Time
## 528                             Iran                       Iran Standard Time
## 529                           Israel                     Israel Standard Time
## 530                              IST                      India Standard Time
## 531                          Jamaica                    Eastern Standard Time
## 532                            Japan                      Japan Standard Time
## 533                              JST                      Japan Standard Time
## 534                        Kwajalein                    Marshall Islands Time
## 535                            Libya           Eastern European Standard Time
## 536                              MET                                GMT+01:00
## 537                 Mexico/BajaNorte                    Pacific Standard Time
## 538                   Mexico/BajaSur            Mexican Pacific Standard Time
## 539                   Mexico/General                    Central Standard Time
## 540                              MIT                       Apia Standard Time
## 541                              MST                                GMT-07:00
## 542                          MST7MDT                   Mountain Standard Time
## 543                           Navajo                   Mountain Standard Time
## 544                              NET                    Armenia Standard Time
## 545                              NST                New Zealand Standard Time
## 546                               NZ                New Zealand Standard Time
## 547                          NZ-CHAT                    Chatham Standard Time
## 548                     Pacific/Apia                       Apia Standard Time
## 549                 Pacific/Auckland                New Zealand Standard Time
## 550             Pacific/Bougainville                                GMT+11:00
## 551                  Pacific/Chatham                    Chatham Standard Time
## 552                    Pacific/Chuuk                               Chuuk Time
## 553                   Pacific/Easter              Easter Island Standard Time
## 554                    Pacific/Efate                    Vanuatu Standard Time
## 555                Pacific/Enderbury                     Phoenix Islands Time
## 556                  Pacific/Fakaofo                             Tokelau Time
## 557                     Pacific/Fiji                       Fiji Standard Time
## 558                 Pacific/Funafuti                              Tuvalu Time
## 559                Pacific/Galapagos                           Galapagos Time
## 560                  Pacific/Gambier                             Gambier Time
## 561              Pacific/Guadalcanal                     Solomon Islands Time
## 562                     Pacific/Guam                   Chamorro Standard Time
## 563                 Pacific/Honolulu            Hawaii-Aleutian Standard Time
## 564                 Pacific/Johnston            Hawaii-Aleutian Standard Time
## 565                   Pacific/Kanton                     Phoenix Islands Time
## 566               Pacific/Kiritimati                        Line Islands Time
## 567                   Pacific/Kosrae                              Kosrae Time
## 568                Pacific/Kwajalein                    Marshall Islands Time
## 569                   Pacific/Majuro                    Marshall Islands Time
## 570                Pacific/Marquesas                           Marquesas Time
## 571                   Pacific/Midway                      Samoa Standard Time
## 572                    Pacific/Nauru                               Nauru Time
## 573                     Pacific/Niue                                Niue Time
## 574                  Pacific/Norfolk             Norfolk Island Standard Time
## 575                   Pacific/Noumea              New Caledonia Standard Time
## 576                Pacific/Pago_Pago                      Samoa Standard Time
## 577                    Pacific/Palau                               Palau Time
## 578                 Pacific/Pitcairn                            Pitcairn Time
## 579                  Pacific/Pohnpei                              Ponape Time
## 580                   Pacific/Ponape                              Ponape Time
## 581             Pacific/Port_Moresby                    Papua New Guinea Time
## 582                Pacific/Rarotonga                Cook Island Standard Time
## 583                   Pacific/Saipan                   Chamorro Standard Time
## 584                    Pacific/Samoa                      Samoa Standard Time
## 585                   Pacific/Tahiti                              Tahiti Time
## 586                   Pacific/Tarawa                     Gilbert Islands Time
## 587                Pacific/Tongatapu                      Tonga Standard Time
## 588                     Pacific/Truk                               Chuuk Time
## 589                     Pacific/Wake                         Wake Island Time
## 590                   Pacific/Wallis                     Wallis & Futuna Time
## 591                      Pacific/Yap                               Chuuk Time
## 592                              PLT                   Pakistan Standard Time
## 593                              PNT                   Mountain Standard Time
## 594                           Poland           Central European Standard Time
## 595                         Portugal           Western European Standard Time
## 596                              PRC                      China Standard Time
## 597                              PRT                   Atlantic Standard Time
## 598                              PST                    Pacific Standard Time
## 599                          PST8PDT                    Pacific Standard Time
## 600                              ROC                     Taipei Standard Time
## 601                              ROK                     Korean Standard Time
## 602                        Singapore                  Singapore Standard Time
## 603                              SST                     Solomon Islands Time
## 604                     SystemV/AST4                                GMT-04:00
## 605                  SystemV/AST4ADT                                GMT-04:00
## 606                     SystemV/CST6                                GMT-06:00
## 607                  SystemV/CST6CDT                                GMT-06:00
## 608                     SystemV/EST5                                GMT-05:00
## 609                  SystemV/EST5EDT                                GMT-05:00
## 610                    SystemV/HST10                                GMT-10:00
## 611                     SystemV/MST7                                GMT-07:00
## 612                  SystemV/MST7MDT                                GMT-07:00
## 613                     SystemV/PST8                                GMT-08:00
## 614                  SystemV/PST8PDT                                GMT-08:00
## 615                     SystemV/YST9                                GMT-09:00
## 616                  SystemV/YST9YDT                                GMT-09:00
## 617                           Turkey                                GMT+03:00
## 618                              UCT               Coordinated Universal Time
## 619                        Universal               Coordinated Universal Time
## 620                        US/Alaska                     Alaska Standard Time
## 621                      US/Aleutian            Hawaii-Aleutian Standard Time
## 622                       US/Arizona                   Mountain Standard Time
## 623                       US/Central                    Central Standard Time
## 624                  US/East-Indiana                    Eastern Standard Time
## 625                       US/Eastern                    Eastern Standard Time
## 626                        US/Hawaii            Hawaii-Aleutian Standard Time
## 627                US/Indiana-Starke                    Central Standard Time
## 628                      US/Michigan                    Eastern Standard Time
## 629                      US/Mountain                   Mountain Standard Time
## 630                       US/Pacific                    Pacific Standard Time
## 631                   US/Pacific-New                    Pacific Standard Time
## 632                         US/Samoa                      Samoa Standard Time
## 633                              UTC               Coordinated Universal Time
## 634                              VST                           Indochina Time
## 635                             W-SU                     Moscow Standard Time
## 636                              WET                                      GMT
## 637                             Zulu               Coordinated Universal Time
##                          Name.Daylight                    Name.Windows
## 1                                 <NA>       AUS Central Standard Time
## 2     Australian Eastern Daylight Time       AUS Eastern Standard Time
## 3                                 <NA>         Greenwich Standard Time
## 4                                 <NA>         Greenwich Standard Time
## 5                                 <NA>         E. Africa Standard Time
## 6                                 <NA> W. Central Africa Standard Time
## 7                                 <NA>         E. Africa Standard Time
## 8                                 <NA>         E. Africa Standard Time
## 9                                 <NA>         Greenwich Standard Time
## 10                                <NA> W. Central Africa Standard Time
## 11                                <NA>         Greenwich Standard Time
## 12                                <NA>         Greenwich Standard Time
## 13                                <NA>      South Africa Standard Time
## 14                                <NA> W. Central Africa Standard Time
## 15                                <NA>      South Africa Standard Time
## 16        Eastern European Summer Time             Egypt Standard Time
## 17                           GMT+01:00           Morocco Standard Time
## 18        Central European Summer Time           Romance Standard Time
## 19                                <NA>         Greenwich Standard Time
## 20                                <NA>         Greenwich Standard Time
## 21                                <NA>         E. Africa Standard Time
## 22                                <NA>         E. Africa Standard Time
## 23                                <NA> W. Central Africa Standard Time
## 24                           GMT+01:00           Morocco Standard Time
## 25                                <NA>         Greenwich Standard Time
## 26                                <NA>      South Africa Standard Time
## 27                                <NA>      South Africa Standard Time
## 28                                <NA>      South Africa Standard Time
## 29                                <NA>       South Sudan Standard Time
## 30                                <NA>         E. Africa Standard Time
## 31                                <NA>             Sudan Standard Time
## 32                                <NA>      South Africa Standard Time
## 33                                <NA> W. Central Africa Standard Time
## 34                                <NA> W. Central Africa Standard Time
## 35                                <NA> W. Central Africa Standard Time
## 36                                <NA>         Greenwich Standard Time
## 37                                <NA> W. Central Africa Standard Time
## 38                                <NA>      South Africa Standard Time
## 39                                <NA>      South Africa Standard Time
## 40                                <NA> W. Central Africa Standard Time
## 41                                <NA>      South Africa Standard Time
## 42                                <NA>      South Africa Standard Time
## 43                                <NA>      South Africa Standard Time
## 44                                <NA>         E. Africa Standard Time
## 45                                <NA>         Greenwich Standard Time
## 46                                <NA>         E. Africa Standard Time
## 47                                <NA> W. Central Africa Standard Time
## 48                                <NA> W. Central Africa Standard Time
## 49                                <NA>         Greenwich Standard Time
## 50                                <NA>         Greenwich Standard Time
## 51                                <NA> W. Central Africa Standard Time
## 52                                <NA>          Sao Tome Standard Time
## 53                                <NA>         Greenwich Standard Time
## 54                                <NA>             Libya Standard Time
## 55                                <NA> W. Central Africa Standard Time
## 56                                <NA>           Namibia Standard Time
## 57                                <NA>         Argentina Standard Time
## 58       Hawaii-Aleutian Daylight Time          Aleutian Standard Time
## 59                Alaska Daylight Time           Alaskan Standard Time
## 60                                <NA>        SA Western Standard Time
## 61                                <NA>        SA Western Standard Time
## 62                                <NA>         Tocantins Standard Time
## 63                                <NA>         Argentina Standard Time
## 64                                <NA>         Argentina Standard Time
## 65                                <NA>         Argentina Standard Time
## 66                                <NA>         Argentina Standard Time
## 67                                <NA>         Argentina Standard Time
## 68                                <NA>         Argentina Standard Time
## 69                                <NA>         Argentina Standard Time
## 70                                <NA>         Argentina Standard Time
## 71                                <NA>         Argentina Standard Time
## 72                                <NA>         Argentina Standard Time
## 73                                <NA>         Argentina Standard Time
## 74                                <NA>         Argentina Standard Time
## 75                                <NA>         Argentina Standard Time
## 76                                <NA>        SA Western Standard Time
## 77                Paraguay Summer Time          Paraguay Standard Time
## 78                                <NA>        SA Pacific Standard Time
## 79       Hawaii-Aleutian Daylight Time          Aleutian Standard Time
## 80                                <NA>             Bahia Standard Time
## 81                                <NA>  Central Standard Time (Mexico)
## 82                                <NA>        SA Western Standard Time
## 83                                <NA>        SA Eastern Standard Time
## 84                                <NA>   Central America Standard Time
## 85                                <NA>        SA Western Standard Time
## 86                                <NA>        SA Western Standard Time
## 87                                <NA>        SA Pacific Standard Time
## 88              Mountain Daylight Time          Mountain Standard Time
## 89                                <NA>         Argentina Standard Time
## 90              Mountain Daylight Time          Mountain Standard Time
## 91                                <NA> Central Brazilian Standard Time
## 92                                <NA>  Eastern Standard Time (Mexico)
## 93                                <NA>         Venezuela Standard Time
## 94                                <NA>         Argentina Standard Time
## 95                                <NA>        SA Eastern Standard Time
## 96                                <NA>        SA Pacific Standard Time
## 97               Central Daylight Time           Central Standard Time
## 98                                <NA>  Central Standard Time (Mexico)
## 99              Mountain Daylight Time          Mountain Standard Time
## 100                               <NA>        SA Pacific Standard Time
## 101                               <NA>         Argentina Standard Time
## 102                               <NA>   Central America Standard Time
## 103                               <NA>       US Mountain Standard Time
## 104                               <NA> Central Brazilian Standard Time
## 105                               <NA>        SA Western Standard Time
## 106                               <NA>         Greenwich Standard Time
## 107                               <NA>             Yukon Standard Time
## 108                               <NA>       US Mountain Standard Time
## 109             Mountain Daylight Time          Mountain Standard Time
## 110              Eastern Daylight Time           Eastern Standard Time
## 111                               <NA>        SA Western Standard Time
## 112             Mountain Daylight Time          Mountain Standard Time
## 113                               <NA>        SA Pacific Standard Time
## 114                               <NA>   Central America Standard Time
## 115              Pacific Daylight Time  Pacific Standard Time (Mexico)
## 116                               <NA>       US Mountain Standard Time
## 117              Eastern Daylight Time        US Eastern Standard Time
## 118                               <NA>        SA Eastern Standard Time
## 119             Atlantic Daylight Time          Atlantic Standard Time
## 120         West Greenland Summer Time         Greenland Standard Time
## 121             Atlantic Daylight Time          Atlantic Standard Time
## 122              Eastern Daylight Time  Turks And Caicos Standard Time
## 123                               <NA>        SA Western Standard Time
## 124                               <NA>        SA Western Standard Time
## 125                               <NA>   Central America Standard Time
## 126                               <NA>        SA Pacific Standard Time
## 127                               <NA>        SA Western Standard Time
## 128             Atlantic Daylight Time          Atlantic Standard Time
## 129                 Cuba Daylight Time              Cuba Standard Time
## 130                               <NA>       US Mountain Standard Time
## 131              Eastern Daylight Time        US Eastern Standard Time
## 132              Central Daylight Time           Central Standard Time
## 133              Eastern Daylight Time        US Eastern Standard Time
## 134              Eastern Daylight Time           Eastern Standard Time
## 135              Central Daylight Time           Central Standard Time
## 136              Eastern Daylight Time        US Eastern Standard Time
## 137              Eastern Daylight Time           Eastern Standard Time
## 138              Eastern Daylight Time           Eastern Standard Time
## 139              Eastern Daylight Time        US Eastern Standard Time
## 140             Mountain Daylight Time          Mountain Standard Time
## 141              Eastern Daylight Time           Eastern Standard Time
## 142                               <NA>        SA Pacific Standard Time
## 143                               <NA>         Argentina Standard Time
## 144               Alaska Daylight Time           Alaskan Standard Time
## 145              Eastern Daylight Time           Eastern Standard Time
## 146              Eastern Daylight Time           Eastern Standard Time
## 147              Central Daylight Time           Central Standard Time
## 148                               <NA>        SA Western Standard Time
## 149                               <NA>        SA Western Standard Time
## 150                               <NA>        SA Pacific Standard Time
## 151              Pacific Daylight Time           Pacific Standard Time
## 152              Eastern Daylight Time           Eastern Standard Time
## 153                               <NA>        SA Western Standard Time
## 154                               <NA>        SA Eastern Standard Time
## 155                               <NA>   Central America Standard Time
## 156                               <NA>        SA Western Standard Time
## 157                               <NA>        SA Western Standard Time
## 158                               <NA>        SA Western Standard Time
## 159              Central Daylight Time           Central Standard Time
## 160                               <NA> Mountain Standard Time (Mexico)
## 161                               <NA>         Argentina Standard Time
## 162              Central Daylight Time           Central Standard Time
## 163                               <NA>  Central Standard Time (Mexico)
## 164               Alaska Daylight Time           Alaskan Standard Time
## 165                               <NA>  Central Standard Time (Mexico)
## 166 St Pierre & Miquelon Daylight Time      Saint Pierre Standard Time
## 167             Atlantic Daylight Time          Atlantic Standard Time
## 168                               <NA>  Central Standard Time (Mexico)
## 169                               <NA>        Montevideo Standard Time
## 170              Eastern Daylight Time           Eastern Standard Time
## 171                               <NA>        SA Western Standard Time
## 172              Eastern Daylight Time           Eastern Standard Time
## 173              Eastern Daylight Time           Eastern Standard Time
## 174              Eastern Daylight Time           Eastern Standard Time
## 175               Alaska Daylight Time           Alaskan Standard Time
## 176                               <NA>                          UTC-02
## 177              Central Daylight Time           Central Standard Time
## 178              Central Daylight Time           Central Standard Time
## 179              Central Daylight Time           Central Standard Time
## 180         West Greenland Summer Time         Greenland Standard Time
## 181              Central Daylight Time           Central Standard Time
## 182                               <NA>        SA Pacific Standard Time
## 183              Eastern Daylight Time           Eastern Standard Time
## 184                               <NA>        SA Eastern Standard Time
## 185                               <NA>       US Mountain Standard Time
## 186                               <NA>        SA Western Standard Time
## 187              Eastern Daylight Time             Haiti Standard Time
## 188                               <NA>        SA Pacific Standard Time
## 189                               <NA>        SA Western Standard Time
## 190                               <NA>        SA Western Standard Time
## 191                               <NA>        Magallanes Standard Time
## 192              Central Daylight Time           Central Standard Time
## 193              Central Daylight Time           Central Standard Time
## 194                               <NA>        SA Eastern Standard Time
## 195                               <NA>    Canada Central Standard Time
## 196              Central Daylight Time           Central Standard Time
## 197                               <NA>        SA Pacific Standard Time
## 198                               <NA>         Argentina Standard Time
## 199              Pacific Daylight Time  Pacific Standard Time (Mexico)
## 200                               <NA>        SA Eastern Standard Time
## 201                  Chile Summer Time        Pacific SA Standard Time
## 202                               <NA>        SA Western Standard Time
## 203                               <NA>  E. South America Standard Time
## 204         East Greenland Summer Time            Azores Standard Time
## 205             Mountain Daylight Time          Mountain Standard Time
## 206               Alaska Daylight Time           Alaskan Standard Time
## 207                               <NA>        SA Western Standard Time
## 208         Newfoundland Daylight Time      Newfoundland Standard Time
## 209                               <NA>        SA Western Standard Time
## 210                               <NA>        SA Western Standard Time
## 211                               <NA>        SA Western Standard Time
## 212                               <NA>        SA Western Standard Time
## 213                               <NA>    Canada Central Standard Time
## 214                               <NA>   Central America Standard Time
## 215             Atlantic Daylight Time          Atlantic Standard Time
## 216              Eastern Daylight Time           Eastern Standard Time
## 217              Pacific Daylight Time  Pacific Standard Time (Mexico)
## 218              Eastern Daylight Time           Eastern Standard Time
## 219                               <NA>        SA Western Standard Time
## 220              Pacific Daylight Time           Pacific Standard Time
## 221                               <NA>        SA Western Standard Time
## 222                               <NA>             Yukon Standard Time
## 223              Central Daylight Time           Central Standard Time
## 224               Alaska Daylight Time           Alaskan Standard Time
## 225             Mountain Daylight Time          Mountain Standard Time
## 226                               <NA>   Central Pacific Standard Time
## 227                               <NA>           SE Asia Standard Time
## 228                               <NA>      West Pacific Standard Time
## 229   Australian Eastern Daylight Time          Tasmania Standard Time
## 230                               <NA>         West Asia Standard Time
## 231          New Zealand Daylight Time       New Zealand Standard Time
## 232                               <NA>        SA Eastern Standard Time
## 233                               <NA>        SA Eastern Standard Time
## 234          New Zealand Daylight Time       New Zealand Standard Time
## 235                               <NA>         E. Africa Standard Time
## 236                          GMT+02:00                            <NA>
## 237                               <NA>      Central Asia Standard Time
## 238       Central European Summer Time         W. Europe Standard Time
## 239       Eastern European Summer Time             Egypt Standard Time
## 240                               <NA>              Arab Standard Time
## 241                               <NA>      Central Asia Standard Time
## 242                               <NA>            Jordan Standard Time
## 243                               <NA>             Russia Time Zone 11
## 244                               <NA>         West Asia Standard Time
## 245                               <NA>         West Asia Standard Time
## 246                               <NA>         West Asia Standard Time
## 247                               <NA>         West Asia Standard Time
## 248                               <NA>         West Asia Standard Time
## 249                               <NA>            Arabic Standard Time
## 250                               <NA>              Arab Standard Time
## 251                               <NA>        Azerbaijan Standard Time
## 252                               <NA>           SE Asia Standard Time
## 253                               <NA>             Altai Standard Time
## 254       Eastern European Summer Time       Middle East Standard Time
## 255                               <NA>      Central Asia Standard Time
## 256                               <NA>         Singapore Standard Time
## 257                               <NA>             India Standard Time
## 258                               <NA>       Transbaikal Standard Time
## 259                               <NA>       Ulaanbaatar Standard Time
## 260                               <NA>             China Standard Time
## 261                               <NA>             China Standard Time
## 262                               <NA>         Sri Lanka Standard Time
## 263                               <NA>        Bangladesh Standard Time
## 264                               <NA>             Syria Standard Time
## 265                               <NA>        Bangladesh Standard Time
## 266                               <NA>             Tokyo Standard Time
## 267                               <NA>           Arabian Standard Time
## 268                               <NA>         West Asia Standard Time
## 269                          GMT+03:00               GTB Standard Time
## 270       Eastern European Summer Time         West Bank Standard Time
## 271                               <NA>             China Standard Time
## 272       Eastern European Summer Time         West Bank Standard Time
## 273                               <NA>           SE Asia Standard Time
## 274                               <NA>             China Standard Time
## 275                               <NA>       W. Mongolia Standard Time
## 276                               <NA>   North Asia East Standard Time
## 277                               <NA>            Turkey Standard Time
## 278                               <NA>           SE Asia Standard Time
## 279                               <NA>             Tokyo Standard Time
## 280               Israel Daylight Time            Israel Standard Time
## 281                               <NA>       Afghanistan Standard Time
## 282                               <NA>             Russia Time Zone 11
## 283                               <NA>          Pakistan Standard Time
## 284                               <NA>      Central Asia Standard Time
## 285                               <NA>             Nepal Standard Time
## 286                               <NA>             Nepal Standard Time
## 287                               <NA>           Yakutsk Standard Time
## 288                               <NA>             India Standard Time
## 289                               <NA>        North Asia Standard Time
## 290                               <NA>         Singapore Standard Time
## 291                               <NA>         Singapore Standard Time
## 292                               <NA>              Arab Standard Time
## 293                               <NA>             China Standard Time
## 294                               <NA>             China Standard Time
## 295                               <NA>           Magadan Standard Time
## 296                               <NA>         Singapore Standard Time
## 297                               <NA>         Singapore Standard Time
## 298                               <NA>           Arabian Standard Time
## 299       Eastern European Summer Time               GTB Standard Time
## 300                               <NA>        North Asia Standard Time
## 301                               <NA>   N. Central Asia Standard Time
## 302                               <NA>              Omsk Standard Time
## 303                               <NA>         West Asia Standard Time
## 304                               <NA>           SE Asia Standard Time
## 305                               <NA>           SE Asia Standard Time
## 306                               <NA>       North Korea Standard Time
## 307                               <NA>              Arab Standard Time
## 308                               <NA>      Central Asia Standard Time
## 309                               <NA>         Qyzylorda Standard Time
## 310                               <NA>           Myanmar Standard Time
## 311                               <NA>              Arab Standard Time
## 312                               <NA>           SE Asia Standard Time
## 313                               <NA>          Sakhalin Standard Time
## 314                               <NA>         West Asia Standard Time
## 315                               <NA>             Korea Standard Time
## 316                               <NA>             China Standard Time
## 317                               <NA>         Singapore Standard Time
## 318                               <NA>             Russia Time Zone 10
## 319                               <NA>            Taipei Standard Time
## 320                               <NA>         West Asia Standard Time
## 321                               <NA>          Georgian Standard Time
## 322                               <NA>              Iran Standard Time
## 323               Israel Daylight Time            Israel Standard Time
## 324                               <NA>        Bangladesh Standard Time
## 325                               <NA>        Bangladesh Standard Time
## 326                               <NA>             Tokyo Standard Time
## 327                               <NA>             Tomsk Standard Time
## 328                               <NA>         Singapore Standard Time
## 329                               <NA>       Ulaanbaatar Standard Time
## 330                               <NA>       Ulaanbaatar Standard Time
## 331                               <NA>      Central Asia Standard Time
## 332                               <NA>       Vladivostok Standard Time
## 333                               <NA>           SE Asia Standard Time
## 334                               <NA>       Vladivostok Standard Time
## 335                               <NA>           Yakutsk Standard Time
## 336                               <NA>           Myanmar Standard Time
## 337                               <NA>      Ekaterinburg Standard Time
## 338                               <NA>          Caucasus Standard Time
## 339               Alaska Daylight Time           Alaskan Standard Time
## 340                 Azores Summer Time            Azores Standard Time
## 341             Atlantic Daylight Time          Atlantic Standard Time
## 342       Western European Summer Time               GMT Standard Time
## 343                               <NA>        Cape Verde Standard Time
## 344       Western European Summer Time               GMT Standard Time
## 345       Western European Summer Time               GMT Standard Time
## 346       Central European Summer Time         W. Europe Standard Time
## 347       Western European Summer Time               GMT Standard Time
## 348                               <NA>         Greenwich Standard Time
## 349                               <NA>                          UTC-02
## 350                               <NA>         Greenwich Standard Time
## 351                               <NA>        SA Eastern Standard Time
## 352   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 353   Australian Central Daylight Time    Cen. Australia Standard Time
## 354                               <NA>      E. Australia Standard Time
## 355   Australian Central Daylight Time    Cen. Australia Standard Time
## 356   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 357   Australian Eastern Daylight Time          Tasmania Standard Time
## 358                               <NA>       AUS Central Standard Time
## 359                               <NA>    Aus Central W. Standard Time
## 360   Australian Eastern Daylight Time          Tasmania Standard Time
## 361            Lord Howe Daylight Time         Lord Howe Standard Time
## 362                               <NA>      E. Australia Standard Time
## 363            Lord Howe Daylight Time         Lord Howe Standard Time
## 364   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 365                               <NA>       AUS Central Standard Time
## 366   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 367                               <NA>      W. Australia Standard Time
## 368                               <NA>      E. Australia Standard Time
## 369   Australian Central Daylight Time    Cen. Australia Standard Time
## 370   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 371   Australian Eastern Daylight Time          Tasmania Standard Time
## 372   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 373                               <NA>      W. Australia Standard Time
## 374   Australian Central Daylight Time    Cen. Australia Standard Time
## 375                               <NA>  E. South America Standard Time
## 376                               <NA>        SA Pacific Standard Time
## 377                               <NA>                          UTC-02
## 378                               <NA>  E. South America Standard Time
## 379                               <NA>        SA Western Standard Time
## 380                               <NA>        Bangladesh Standard Time
## 381             Atlantic Daylight Time          Atlantic Standard Time
## 382              Central Daylight Time           Central Standard Time
## 383                               <NA>    Canada Central Standard Time
## 384              Eastern Daylight Time           Eastern Standard Time
## 385             Mountain Daylight Time          Mountain Standard Time
## 386         Newfoundland Daylight Time      Newfoundland Standard Time
## 387              Pacific Daylight Time           Pacific Standard Time
## 388                               <NA>    Canada Central Standard Time
## 389                               <NA>             Yukon Standard Time
## 390                               <NA>      South Africa Standard Time
## 391                          GMT+02:00                            <NA>
## 392                  Chile Summer Time        Pacific SA Standard Time
## 393          Easter Island Summer Time     Easter Island Standard Time
## 394         Newfoundland Daylight Time      Newfoundland Standard Time
## 395              Central Daylight Time           Central Standard Time
## 396              Central Daylight Time           Central Standard Time
## 397                               <NA>             China Standard Time
## 398                 Cuba Daylight Time              Cuba Standard Time
## 399                               <NA>         E. Africa Standard Time
## 400       Central European Summer Time           Romance Standard Time
## 401                          GMT+03:00                            <NA>
## 402       Eastern European Summer Time             Egypt Standard Time
## 403                Irish Standard Time               GMT Standard Time
## 404                               <NA>        SA Pacific Standard Time
## 405              Eastern Daylight Time           Eastern Standard Time
## 406                               <NA>                             UTC
## 407                               <NA>                             UTC
## 408                               <NA> W. Central Africa Standard Time
## 409                               <NA>      South Africa Standard Time
## 410                               <NA>         E. Africa Standard Time
## 411                               <NA>           Arabian Standard Time
## 412                               <NA>         West Asia Standard Time
## 413                               <NA>      Central Asia Standard Time
## 414                               <NA>           SE Asia Standard Time
## 415                               <NA>         Singapore Standard Time
## 416                               <NA>             Tokyo Standard Time
## 417                               <NA>      West Pacific Standard Time
## 418                               <NA>   Central Pacific Standard Time
## 419                               <NA>                          UTC+12
## 420                               <NA>                          UTC+13
## 421                               <NA>      Line Islands Standard Time
## 422                               <NA>                             UTC
## 423                               <NA>        Cape Verde Standard Time
## 424                               <NA>                          UTC-02
## 425                               <NA>        SA Eastern Standard Time
## 426                               <NA>        SA Western Standard Time
## 427                               <NA>        SA Pacific Standard Time
## 428                               <NA>   Central America Standard Time
## 429                               <NA>       US Mountain Standard Time
## 430                               <NA>                          UTC-08
## 431                               <NA>                          UTC-09
## 432                               <NA>          Hawaiian Standard Time
## 433                               <NA>                          UTC-11
## 434                               <NA>          Dateline Standard Time
## 435                               <NA>                             UTC
## 436                               <NA>                             UTC
## 437                               <NA>                             UTC
## 438                               <NA>                             UTC
## 439                               <NA>                             UTC
## 440                               <NA>                             UTC
## 441       Central European Summer Time         W. Europe Standard Time
## 442       Central European Summer Time         W. Europe Standard Time
## 443                               <NA>         Astrakhan Standard Time
## 444       Eastern European Summer Time               GTB Standard Time
## 445                British Summer Time               GMT Standard Time
## 446       Central European Summer Time    Central Europe Standard Time
## 447       Central European Summer Time         W. Europe Standard Time
## 448       Central European Summer Time    Central Europe Standard Time
## 449       Central European Summer Time           Romance Standard Time
## 450       Eastern European Summer Time               GTB Standard Time
## 451       Central European Summer Time    Central Europe Standard Time
## 452       Central European Summer Time         W. Europe Standard Time
## 453       Eastern European Summer Time         E. Europe Standard Time
## 454       Central European Summer Time           Romance Standard Time
## 455                Irish Standard Time               GMT Standard Time
## 456       Central European Summer Time         W. Europe Standard Time
## 457                          GMT+01:00               GMT Standard Time
## 458       Eastern European Summer Time               FLE Standard Time
## 459                          GMT+01:00               GMT Standard Time
## 460                               <NA>            Turkey Standard Time
## 461                          GMT+01:00               GMT Standard Time
## 462                               <NA>       Kaliningrad Standard Time
## 463       Eastern European Summer Time               FLE Standard Time
## 464                               <NA>           Russian Standard Time
## 465       Eastern European Summer Time               FLE Standard Time
## 466       Western European Summer Time               GMT Standard Time
## 467       Central European Summer Time    Central Europe Standard Time
## 468                British Summer Time               GMT Standard Time
## 469       Central European Summer Time         W. Europe Standard Time
## 470       Central European Summer Time           Romance Standard Time
## 471       Central European Summer Time         W. Europe Standard Time
## 472       Eastern European Summer Time               FLE Standard Time
## 473                               <NA>           Belarus Standard Time
## 474       Central European Summer Time         W. Europe Standard Time
## 475                               <NA>           Russian Standard Time
## 476       Eastern European Summer Time               GTB Standard Time
## 477       Central European Summer Time         W. Europe Standard Time
## 478       Central European Summer Time           Romance Standard Time
## 479       Central European Summer Time    Central Europe Standard Time
## 480       Central European Summer Time    Central Europe Standard Time
## 481       Eastern European Summer Time               FLE Standard Time
## 482       Central European Summer Time         W. Europe Standard Time
## 483                               <NA>              Russia Time Zone 3
## 484       Central European Summer Time         W. Europe Standard Time
## 485       Central European Summer Time  Central European Standard Time
## 486                               <NA>           Saratov Standard Time
## 487                               <NA>           Russian Standard Time
## 488       Central European Summer Time  Central European Standard Time
## 489       Eastern European Summer Time               FLE Standard Time
## 490       Central European Summer Time         W. Europe Standard Time
## 491       Eastern European Summer Time               FLE Standard Time
## 492       Central European Summer Time    Central Europe Standard Time
## 493       Eastern European Summer Time         E. Europe Standard Time
## 494                               <NA>         Astrakhan Standard Time
## 495       Eastern European Summer Time               FLE Standard Time
## 496       Central European Summer Time         W. Europe Standard Time
## 497       Central European Summer Time         W. Europe Standard Time
## 498       Central European Summer Time         W. Europe Standard Time
## 499       Eastern European Summer Time               FLE Standard Time
## 500                               <NA>         Volgograd Standard Time
## 501       Central European Summer Time  Central European Standard Time
## 502       Central European Summer Time  Central European Standard Time
## 503       Eastern European Summer Time               FLE Standard Time
## 504       Central European Summer Time         W. Europe Standard Time
## 505                               <NA>                            <NA>
## 506                British Summer Time               GMT Standard Time
## 507                British Summer Time               GMT Standard Time
## 508                               <NA>                             UTC
## 509                               <NA>                             UTC
## 510                               <NA>                             UTC
## 511                               <NA>                             UTC
## 512                               <NA>                             UTC
## 513                               <NA>             China Standard Time
## 514                               <NA>          Hawaiian Standard Time
## 515                               <NA>         Greenwich Standard Time
## 516              Eastern Daylight Time        US Eastern Standard Time
## 517                               <NA>         E. Africa Standard Time
## 518                               <NA>      Central Asia Standard Time
## 519                               <NA>           SE Asia Standard Time
## 520                               <NA>           Myanmar Standard Time
## 521                               <NA>         E. Africa Standard Time
## 522                               <NA>         West Asia Standard Time
## 523                               <NA>         Mauritius Standard Time
## 524                               <NA>         West Asia Standard Time
## 525                               <NA>         Mauritius Standard Time
## 526                               <NA>         E. Africa Standard Time
## 527                               <NA>         Mauritius Standard Time
## 528                               <NA>              Iran Standard Time
## 529               Israel Daylight Time            Israel Standard Time
## 530                               <NA>             India Standard Time
## 531                               <NA>        SA Pacific Standard Time
## 532                               <NA>             Tokyo Standard Time
## 533                               <NA>             Tokyo Standard Time
## 534                               <NA>                          UTC+12
## 535                               <NA>             Libya Standard Time
## 536                          GMT+02:00                            <NA>
## 537              Pacific Daylight Time  Pacific Standard Time (Mexico)
## 538                               <NA> Mountain Standard Time (Mexico)
## 539                               <NA>  Central Standard Time (Mexico)
## 540                               <NA>             Samoa Standard Time
## 541                               <NA>       US Mountain Standard Time
## 542             Mountain Daylight Time          Mountain Standard Time
## 543             Mountain Daylight Time          Mountain Standard Time
## 544                               <NA>          Caucasus Standard Time
## 545          New Zealand Daylight Time       New Zealand Standard Time
## 546          New Zealand Daylight Time       New Zealand Standard Time
## 547              Chatham Daylight Time   Chatham Islands Standard Time
## 548                               <NA>             Samoa Standard Time
## 549          New Zealand Daylight Time       New Zealand Standard Time
## 550                               <NA>      Bougainville Standard Time
## 551              Chatham Daylight Time   Chatham Islands Standard Time
## 552                               <NA>      West Pacific Standard Time
## 553          Easter Island Summer Time     Easter Island Standard Time
## 554                               <NA>   Central Pacific Standard Time
## 555                               <NA>                          UTC+13
## 556                               <NA>                          UTC+13
## 557                               <NA>              Fiji Standard Time
## 558                               <NA>                          UTC+12
## 559                               <NA>   Central America Standard Time
## 560                               <NA>                          UTC-09
## 561                               <NA>   Central Pacific Standard Time
## 562                               <NA>      West Pacific Standard Time
## 563                               <NA>          Hawaiian Standard Time
## 564                               <NA>          Hawaiian Standard Time
## 565                               <NA>                          UTC+13
## 566                               <NA>      Line Islands Standard Time
## 567                               <NA>   Central Pacific Standard Time
## 568                               <NA>                          UTC+12
## 569                               <NA>                          UTC+12
## 570                               <NA>         Marquesas Standard Time
## 571                               <NA>                          UTC-11
## 572                               <NA>                          UTC+12
## 573                               <NA>                          UTC-11
## 574       Norfolk Island Daylight Time           Norfolk Standard Time
## 575                               <NA>   Central Pacific Standard Time
## 576                               <NA>                          UTC-11
## 577                               <NA>             Tokyo Standard Time
## 578                               <NA>                          UTC-08
## 579                               <NA>   Central Pacific Standard Time
## 580                               <NA>   Central Pacific Standard Time
## 581                               <NA>      West Pacific Standard Time
## 582                               <NA>          Hawaiian Standard Time
## 583                               <NA>      West Pacific Standard Time
## 584                               <NA>                          UTC-11
## 585                               <NA>          Hawaiian Standard Time
## 586                               <NA>                          UTC+12
## 587                               <NA>             Tonga Standard Time
## 588                               <NA>      West Pacific Standard Time
## 589                               <NA>                          UTC+12
## 590                               <NA>                          UTC+12
## 591                               <NA>      West Pacific Standard Time
## 592                               <NA>          Pakistan Standard Time
## 593                               <NA>       US Mountain Standard Time
## 594       Central European Summer Time  Central European Standard Time
## 595       Western European Summer Time               GMT Standard Time
## 596                               <NA>             China Standard Time
## 597                               <NA>        SA Western Standard Time
## 598              Pacific Daylight Time           Pacific Standard Time
## 599              Pacific Daylight Time           Pacific Standard Time
## 600                               <NA>            Taipei Standard Time
## 601                               <NA>             Korea Standard Time
## 602                               <NA>         Singapore Standard Time
## 603                               <NA>   Central Pacific Standard Time
## 604                               <NA>                            <NA>
## 605                          GMT-03:00                            <NA>
## 606                               <NA>                            <NA>
## 607                          GMT-05:00                            <NA>
## 608                               <NA>                            <NA>
## 609                          GMT-04:00                            <NA>
## 610                               <NA>                            <NA>
## 611                               <NA>                            <NA>
## 612                          GMT-06:00                            <NA>
## 613                               <NA>                            <NA>
## 614                          GMT-07:00                            <NA>
## 615                               <NA>                            <NA>
## 616                          GMT-08:00                            <NA>
## 617                               <NA>            Turkey Standard Time
## 618                               <NA>                             UTC
## 619                               <NA>                             UTC
## 620               Alaska Daylight Time           Alaskan Standard Time
## 621      Hawaii-Aleutian Daylight Time          Aleutian Standard Time
## 622                               <NA>       US Mountain Standard Time
## 623              Central Daylight Time           Central Standard Time
## 624              Eastern Daylight Time        US Eastern Standard Time
## 625              Eastern Daylight Time           Eastern Standard Time
## 626                               <NA>          Hawaiian Standard Time
## 627              Central Daylight Time           Central Standard Time
## 628              Eastern Daylight Time           Eastern Standard Time
## 629             Mountain Daylight Time          Mountain Standard Time
## 630              Pacific Daylight Time           Pacific Standard Time
## 631              Pacific Daylight Time           Pacific Standard Time
## 632                               <NA>                          UTC-11
## 633                               <NA>                             UTC
## 634                               <NA>           SE Asia Standard Time
## 635                               <NA>           Russian Standard Time
## 636                          GMT+01:00                            <NA>
## 637                               <NA>                             UTC
##     RawOffset UsesDaylightTime
## 1        9.50            FALSE
## 2       10.00             TRUE
## 3        0.00            FALSE
## 4        0.00            FALSE
## 5        3.00            FALSE
## 6        1.00            FALSE
## 7        3.00            FALSE
## 8        3.00            FALSE
## 9        0.00            FALSE
## 10       1.00            FALSE
## 11       0.00            FALSE
## 12       0.00            FALSE
## 13       2.00            FALSE
## 14       1.00            FALSE
## 15       2.00            FALSE
## 16       2.00             TRUE
## 17       0.00             TRUE
## 18       1.00             TRUE
## 19       0.00            FALSE
## 20       0.00            FALSE
## 21       3.00            FALSE
## 22       3.00            FALSE
## 23       1.00            FALSE
## 24       0.00             TRUE
## 25       0.00            FALSE
## 26       2.00            FALSE
## 27       2.00            FALSE
## 28       2.00            FALSE
## 29       2.00            FALSE
## 30       3.00            FALSE
## 31       2.00            FALSE
## 32       2.00            FALSE
## 33       1.00            FALSE
## 34       1.00            FALSE
## 35       1.00            FALSE
## 36       0.00            FALSE
## 37       1.00            FALSE
## 38       2.00            FALSE
## 39       2.00            FALSE
## 40       1.00            FALSE
## 41       2.00            FALSE
## 42       2.00            FALSE
## 43       2.00            FALSE
## 44       3.00            FALSE
## 45       0.00            FALSE
## 46       3.00            FALSE
## 47       1.00            FALSE
## 48       1.00            FALSE
## 49       0.00            FALSE
## 50       0.00            FALSE
## 51       1.00            FALSE
## 52       0.00            FALSE
## 53       0.00            FALSE
## 54       2.00            FALSE
## 55       1.00            FALSE
## 56       2.00            FALSE
## 57      -3.00            FALSE
## 58     -10.00             TRUE
## 59      -9.00             TRUE
## 60      -4.00            FALSE
## 61      -4.00            FALSE
## 62      -3.00            FALSE
## 63      -3.00            FALSE
## 64      -3.00            FALSE
## 65      -3.00            FALSE
## 66      -3.00            FALSE
## 67      -3.00            FALSE
## 68      -3.00            FALSE
## 69      -3.00            FALSE
## 70      -3.00            FALSE
## 71      -3.00            FALSE
## 72      -3.00            FALSE
## 73      -3.00            FALSE
## 74      -3.00            FALSE
## 75      -3.00            FALSE
## 76      -4.00            FALSE
## 77      -4.00             TRUE
## 78      -5.00            FALSE
## 79     -10.00             TRUE
## 80      -3.00            FALSE
## 81      -6.00            FALSE
## 82      -4.00            FALSE
## 83      -3.00            FALSE
## 84      -6.00            FALSE
## 85      -4.00            FALSE
## 86      -4.00            FALSE
## 87      -5.00            FALSE
## 88      -7.00             TRUE
## 89      -3.00            FALSE
## 90      -7.00             TRUE
## 91      -4.00            FALSE
## 92      -5.00            FALSE
## 93      -4.00            FALSE
## 94      -3.00            FALSE
## 95      -3.00            FALSE
## 96      -5.00            FALSE
## 97      -6.00             TRUE
## 98      -6.00            FALSE
## 99      -7.00             TRUE
## 100     -5.00            FALSE
## 101     -3.00            FALSE
## 102     -6.00            FALSE
## 103     -7.00            FALSE
## 104     -4.00            FALSE
## 105     -4.00            FALSE
## 106      0.00            FALSE
## 107     -7.00            FALSE
## 108     -7.00            FALSE
## 109     -7.00             TRUE
## 110     -5.00             TRUE
## 111     -4.00            FALSE
## 112     -7.00             TRUE
## 113     -5.00            FALSE
## 114     -6.00            FALSE
## 115     -8.00             TRUE
## 116     -7.00            FALSE
## 117     -5.00             TRUE
## 118     -3.00            FALSE
## 119     -4.00             TRUE
## 120     -2.00             TRUE
## 121     -4.00             TRUE
## 122     -5.00             TRUE
## 123     -4.00            FALSE
## 124     -4.00            FALSE
## 125     -6.00            FALSE
## 126     -5.00            FALSE
## 127     -4.00            FALSE
## 128     -4.00             TRUE
## 129     -5.00             TRUE
## 130     -7.00            FALSE
## 131     -5.00             TRUE
## 132     -6.00             TRUE
## 133     -5.00             TRUE
## 134     -5.00             TRUE
## 135     -6.00             TRUE
## 136     -5.00             TRUE
## 137     -5.00             TRUE
## 138     -5.00             TRUE
## 139     -5.00             TRUE
## 140     -7.00             TRUE
## 141     -5.00             TRUE
## 142     -5.00            FALSE
## 143     -3.00            FALSE
## 144     -9.00             TRUE
## 145     -5.00             TRUE
## 146     -5.00             TRUE
## 147     -6.00             TRUE
## 148     -4.00            FALSE
## 149     -4.00            FALSE
## 150     -5.00            FALSE
## 151     -8.00             TRUE
## 152     -5.00             TRUE
## 153     -4.00            FALSE
## 154     -3.00            FALSE
## 155     -6.00            FALSE
## 156     -4.00            FALSE
## 157     -4.00            FALSE
## 158     -4.00            FALSE
## 159     -6.00             TRUE
## 160     -7.00            FALSE
## 161     -3.00            FALSE
## 162     -6.00             TRUE
## 163     -6.00            FALSE
## 164     -9.00             TRUE
## 165     -6.00            FALSE
## 166     -3.00             TRUE
## 167     -4.00             TRUE
## 168     -6.00            FALSE
## 169     -3.00            FALSE
## 170     -5.00             TRUE
## 171     -4.00            FALSE
## 172     -5.00             TRUE
## 173     -5.00             TRUE
## 174     -5.00             TRUE
## 175     -9.00             TRUE
## 176     -2.00            FALSE
## 177     -6.00             TRUE
## 178     -6.00             TRUE
## 179     -6.00             TRUE
## 180     -2.00             TRUE
## 181     -6.00             TRUE
## 182     -5.00            FALSE
## 183     -5.00             TRUE
## 184     -3.00            FALSE
## 185     -7.00            FALSE
## 186     -4.00            FALSE
## 187     -5.00             TRUE
## 188     -5.00            FALSE
## 189     -4.00            FALSE
## 190     -4.00            FALSE
## 191     -3.00            FALSE
## 192     -6.00             TRUE
## 193     -6.00             TRUE
## 194     -3.00            FALSE
## 195     -6.00            FALSE
## 196     -6.00             TRUE
## 197     -5.00            FALSE
## 198     -3.00            FALSE
## 199     -8.00             TRUE
## 200     -3.00            FALSE
## 201     -4.00             TRUE
## 202     -4.00            FALSE
## 203     -3.00            FALSE
## 204     -1.00             TRUE
## 205     -7.00             TRUE
## 206     -9.00             TRUE
## 207     -4.00            FALSE
## 208     -3.50             TRUE
## 209     -4.00            FALSE
## 210     -4.00            FALSE
## 211     -4.00            FALSE
## 212     -4.00            FALSE
## 213     -6.00            FALSE
## 214     -6.00            FALSE
## 215     -4.00             TRUE
## 216     -5.00             TRUE
## 217     -8.00             TRUE
## 218     -5.00             TRUE
## 219     -4.00            FALSE
## 220     -8.00             TRUE
## 221     -4.00            FALSE
## 222     -7.00            FALSE
## 223     -6.00             TRUE
## 224     -9.00             TRUE
## 225     -7.00             TRUE
## 226     11.00            FALSE
## 227      7.00            FALSE
## 228     10.00            FALSE
## 229     10.00             TRUE
## 230      5.00            FALSE
## 231     12.00             TRUE
## 232     -3.00            FALSE
## 233     -3.00            FALSE
## 234     12.00             TRUE
## 235      3.00            FALSE
## 236      0.00             TRUE
## 237      6.00            FALSE
## 238      1.00             TRUE
## 239      2.00             TRUE
## 240      3.00            FALSE
## 241      6.00            FALSE
## 242      3.00            FALSE
## 243     12.00            FALSE
## 244      5.00            FALSE
## 245      5.00            FALSE
## 246      5.00            FALSE
## 247      5.00            FALSE
## 248      5.00            FALSE
## 249      3.00            FALSE
## 250      3.00            FALSE
## 251      4.00            FALSE
## 252      7.00            FALSE
## 253      7.00            FALSE
## 254      2.00             TRUE
## 255      6.00            FALSE
## 256      8.00            FALSE
## 257      5.50            FALSE
## 258      9.00            FALSE
## 259      8.00            FALSE
## 260      8.00            FALSE
## 261      8.00            FALSE
## 262      5.50            FALSE
## 263      6.00            FALSE
## 264      3.00            FALSE
## 265      6.00            FALSE
## 266      9.00            FALSE
## 267      4.00            FALSE
## 268      5.00            FALSE
## 269      2.00             TRUE
## 270      2.00             TRUE
## 271      8.00            FALSE
## 272      2.00             TRUE
## 273      7.00            FALSE
## 274      8.00            FALSE
## 275      7.00            FALSE
## 276      8.00            FALSE
## 277      3.00            FALSE
## 278      7.00            FALSE
## 279      9.00            FALSE
## 280      2.00             TRUE
## 281      4.50            FALSE
## 282     12.00            FALSE
## 283      5.00            FALSE
## 284      6.00            FALSE
## 285      5.75            FALSE
## 286      5.75            FALSE
## 287      9.00            FALSE
## 288      5.50            FALSE
## 289      7.00            FALSE
## 290      8.00            FALSE
## 291      8.00            FALSE
## 292      3.00            FALSE
## 293      8.00            FALSE
## 294      8.00            FALSE
## 295     11.00            FALSE
## 296      8.00            FALSE
## 297      8.00            FALSE
## 298      4.00            FALSE
## 299      2.00             TRUE
## 300      7.00            FALSE
## 301      7.00            FALSE
## 302      6.00            FALSE
## 303      5.00            FALSE
## 304      7.00            FALSE
## 305      7.00            FALSE
## 306      9.00            FALSE
## 307      3.00            FALSE
## 308      6.00            FALSE
## 309      5.00            FALSE
## 310      6.50            FALSE
## 311      3.00            FALSE
## 312      7.00            FALSE
## 313     11.00            FALSE
## 314      5.00            FALSE
## 315      9.00            FALSE
## 316      8.00            FALSE
## 317      8.00            FALSE
## 318     11.00            FALSE
## 319      8.00            FALSE
## 320      5.00            FALSE
## 321      4.00            FALSE
## 322      3.50            FALSE
## 323      2.00             TRUE
## 324      6.00            FALSE
## 325      6.00            FALSE
## 326      9.00            FALSE
## 327      7.00            FALSE
## 328      8.00            FALSE
## 329      8.00            FALSE
## 330      8.00            FALSE
## 331      6.00            FALSE
## 332     10.00            FALSE
## 333      7.00            FALSE
## 334     10.00            FALSE
## 335      9.00            FALSE
## 336      6.50            FALSE
## 337      5.00            FALSE
## 338      4.00            FALSE
## 339     -9.00             TRUE
## 340     -1.00             TRUE
## 341     -4.00             TRUE
## 342      0.00             TRUE
## 343     -1.00            FALSE
## 344      0.00             TRUE
## 345      0.00             TRUE
## 346      1.00             TRUE
## 347      0.00             TRUE
## 348      0.00            FALSE
## 349     -2.00            FALSE
## 350      0.00            FALSE
## 351     -3.00            FALSE
## 352     10.00             TRUE
## 353      9.50             TRUE
## 354     10.00            FALSE
## 355      9.50             TRUE
## 356     10.00             TRUE
## 357     10.00             TRUE
## 358      9.50            FALSE
## 359      8.75            FALSE
## 360     10.00             TRUE
## 361     10.50             TRUE
## 362     10.00            FALSE
## 363     10.50             TRUE
## 364     10.00             TRUE
## 365      9.50            FALSE
## 366     10.00             TRUE
## 367      8.00            FALSE
## 368     10.00            FALSE
## 369      9.50             TRUE
## 370     10.00             TRUE
## 371     10.00             TRUE
## 372     10.00             TRUE
## 373      8.00            FALSE
## 374      9.50             TRUE
## 375     -3.00            FALSE
## 376     -5.00            FALSE
## 377     -2.00            FALSE
## 378     -3.00            FALSE
## 379     -4.00            FALSE
## 380      6.00            FALSE
## 381     -4.00             TRUE
## 382     -6.00             TRUE
## 383     -6.00            FALSE
## 384     -5.00             TRUE
## 385     -7.00             TRUE
## 386     -3.50             TRUE
## 387     -8.00             TRUE
## 388     -6.00            FALSE
## 389     -7.00            FALSE
## 390      2.00            FALSE
## 391      1.00             TRUE
## 392     -4.00             TRUE
## 393     -6.00             TRUE
## 394     -3.50             TRUE
## 395     -6.00             TRUE
## 396     -6.00             TRUE
## 397      8.00            FALSE
## 398     -5.00             TRUE
## 399      3.00            FALSE
## 400      1.00             TRUE
## 401      2.00             TRUE
## 402      2.00             TRUE
## 403      0.00             TRUE
## 404     -5.00            FALSE
## 405     -5.00             TRUE
## 406      0.00            FALSE
## 407      0.00            FALSE
## 408      1.00            FALSE
## 409      2.00            FALSE
## 410      3.00            FALSE
## 411      4.00            FALSE
## 412      5.00            FALSE
## 413      6.00            FALSE
## 414      7.00            FALSE
## 415      8.00            FALSE
## 416      9.00            FALSE
## 417     10.00            FALSE
## 418     11.00            FALSE
## 419     12.00            FALSE
## 420     13.00            FALSE
## 421     14.00            FALSE
## 422      0.00            FALSE
## 423     -1.00            FALSE
## 424     -2.00            FALSE
## 425     -3.00            FALSE
## 426     -4.00            FALSE
## 427     -5.00            FALSE
## 428     -6.00            FALSE
## 429     -7.00            FALSE
## 430     -8.00            FALSE
## 431     -9.00            FALSE
## 432    -10.00            FALSE
## 433    -11.00            FALSE
## 434    -12.00            FALSE
## 435      0.00            FALSE
## 436      0.00            FALSE
## 437      0.00            FALSE
## 438      0.00            FALSE
## 439      0.00            FALSE
## 440      0.00            FALSE
## 441      1.00             TRUE
## 442      1.00             TRUE
## 443      4.00            FALSE
## 444      2.00             TRUE
## 445      0.00             TRUE
## 446      1.00             TRUE
## 447      1.00             TRUE
## 448      1.00             TRUE
## 449      1.00             TRUE
## 450      2.00             TRUE
## 451      1.00             TRUE
## 452      1.00             TRUE
## 453      2.00             TRUE
## 454      1.00             TRUE
## 455      0.00             TRUE
## 456      1.00             TRUE
## 457      0.00             TRUE
## 458      2.00             TRUE
## 459      0.00             TRUE
## 460      3.00            FALSE
## 461      0.00             TRUE
## 462      2.00            FALSE
## 463      2.00             TRUE
## 464      3.00            FALSE
## 465      2.00             TRUE
## 466      0.00             TRUE
## 467      1.00             TRUE
## 468      0.00             TRUE
## 469      1.00             TRUE
## 470      1.00             TRUE
## 471      1.00             TRUE
## 472      2.00             TRUE
## 473      3.00            FALSE
## 474      1.00             TRUE
## 475      3.00            FALSE
## 476      2.00             TRUE
## 477      1.00             TRUE
## 478      1.00             TRUE
## 479      1.00             TRUE
## 480      1.00             TRUE
## 481      2.00             TRUE
## 482      1.00             TRUE
## 483      4.00            FALSE
## 484      1.00             TRUE
## 485      1.00             TRUE
## 486      4.00            FALSE
## 487      3.00            FALSE
## 488      1.00             TRUE
## 489      2.00             TRUE
## 490      1.00             TRUE
## 491      2.00             TRUE
## 492      1.00             TRUE
## 493      2.00             TRUE
## 494      4.00            FALSE
## 495      2.00             TRUE
## 496      1.00             TRUE
## 497      1.00             TRUE
## 498      1.00             TRUE
## 499      2.00             TRUE
## 500      3.00            FALSE
## 501      1.00             TRUE
## 502      1.00             TRUE
## 503      2.00             TRUE
## 504      1.00             TRUE
## 505      0.00            FALSE
## 506      0.00             TRUE
## 507      0.00             TRUE
## 508      0.00            FALSE
## 509      0.00            FALSE
## 510      0.00            FALSE
## 511      0.00            FALSE
## 512      0.00            FALSE
## 513      8.00            FALSE
## 514    -10.00            FALSE
## 515      0.00            FALSE
## 516     -5.00             TRUE
## 517      3.00            FALSE
## 518      6.00            FALSE
## 519      7.00            FALSE
## 520      6.50            FALSE
## 521      3.00            FALSE
## 522      5.00            FALSE
## 523      4.00            FALSE
## 524      5.00            FALSE
## 525      4.00            FALSE
## 526      3.00            FALSE
## 527      4.00            FALSE
## 528      3.50            FALSE
## 529      2.00             TRUE
## 530      5.50            FALSE
## 531     -5.00            FALSE
## 532      9.00            FALSE
## 533      9.00            FALSE
## 534     12.00            FALSE
## 535      2.00            FALSE
## 536      1.00             TRUE
## 537     -8.00             TRUE
## 538     -7.00            FALSE
## 539     -6.00            FALSE
## 540     13.00            FALSE
## 541     -7.00            FALSE
## 542     -7.00             TRUE
## 543     -7.00             TRUE
## 544      4.00            FALSE
## 545     12.00             TRUE
## 546     12.00             TRUE
## 547     12.75             TRUE
## 548     13.00            FALSE
## 549     12.00             TRUE
## 550     11.00            FALSE
## 551     12.75             TRUE
## 552     10.00            FALSE
## 553     -6.00             TRUE
## 554     11.00            FALSE
## 555     13.00            FALSE
## 556     13.00            FALSE
## 557     12.00            FALSE
## 558     12.00            FALSE
## 559     -6.00            FALSE
## 560     -9.00            FALSE
## 561     11.00            FALSE
## 562     10.00            FALSE
## 563    -10.00            FALSE
## 564    -10.00            FALSE
## 565     13.00            FALSE
## 566     14.00            FALSE
## 567     11.00            FALSE
## 568     12.00            FALSE
## 569     12.00            FALSE
## 570     -9.50            FALSE
## 571    -11.00            FALSE
## 572     12.00            FALSE
## 573    -11.00            FALSE
## 574     11.00             TRUE
## 575     11.00            FALSE
## 576    -11.00            FALSE
## 577      9.00            FALSE
## 578     -8.00            FALSE
## 579     11.00            FALSE
## 580     11.00            FALSE
## 581     10.00            FALSE
## 582    -10.00            FALSE
## 583     10.00            FALSE
## 584    -11.00            FALSE
## 585    -10.00            FALSE
## 586     12.00            FALSE
## 587     13.00            FALSE
## 588     10.00            FALSE
## 589     12.00            FALSE
## 590     12.00            FALSE
## 591     10.00            FALSE
## 592      5.00            FALSE
## 593     -7.00            FALSE
## 594      1.00             TRUE
## 595      0.00             TRUE
## 596      8.00            FALSE
## 597     -4.00            FALSE
## 598     -8.00             TRUE
## 599     -8.00             TRUE
## 600      8.00            FALSE
## 601      9.00            FALSE
## 602      8.00            FALSE
## 603     11.00            FALSE
## 604     -4.00            FALSE
## 605     -4.00             TRUE
## 606     -6.00            FALSE
## 607     -6.00             TRUE
## 608     -5.00            FALSE
## 609     -5.00             TRUE
## 610    -10.00            FALSE
## 611     -7.00            FALSE
## 612     -7.00             TRUE
## 613     -8.00            FALSE
## 614     -8.00             TRUE
## 615     -9.00            FALSE
## 616     -9.00             TRUE
## 617      3.00            FALSE
## 618      0.00            FALSE
## 619      0.00            FALSE
## 620     -9.00             TRUE
## 621    -10.00             TRUE
## 622     -7.00            FALSE
## 623     -6.00             TRUE
## 624     -5.00             TRUE
## 625     -5.00             TRUE
## 626    -10.00            FALSE
## 627     -6.00             TRUE
## 628     -5.00             TRUE
## 629     -7.00             TRUE
## 630     -8.00             TRUE
## 631     -8.00             TRUE
## 632    -11.00            FALSE
## 633      0.00            FALSE
## 634      7.00            FALSE
## 635      3.00            FALSE
## 636      0.00             TRUE
## 637      0.00            FALSE
```
