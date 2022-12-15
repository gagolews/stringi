# stri_timezone_list: List Available Time Zone Identifiers

## Description

Returns a list of available time zone identifiers.

## Usage

``` r
stri_timezone_list(region = NA_character_, offset = NA_integer_)
```

## Arguments

|          |                                                                                                          |
|----------|----------------------------------------------------------------------------------------------------------|
| `region` | single string; a ISO 3166 two-letter country code or UN M.49 three-digit area code; `NA` for all regions |
| `offset` | single numeric value; a given raw offset from GMT, in hours; `NA` for all offsets                        |

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




```r
stri_timezone_list()
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
##  [99] "America/Coral_Harbour"            "America/Cordoba"                 
## [101] "America/Costa_Rica"               "America/Creston"                 
## [103] "America/Cuiaba"                   "America/Curacao"                 
## [105] "America/Danmarkshavn"             "America/Dawson"                  
## [107] "America/Dawson_Creek"             "America/Denver"                  
## [109] "America/Detroit"                  "America/Dominica"                
## [111] "America/Edmonton"                 "America/Eirunepe"                
## [113] "America/El_Salvador"              "America/Ensenada"                
## [115] "America/Fort_Nelson"              "America/Fort_Wayne"              
## [117] "America/Fortaleza"                "America/Glace_Bay"               
## [119] "America/Godthab"                  "America/Goose_Bay"               
## [121] "America/Grand_Turk"               "America/Grenada"                 
## [123] "America/Guadeloupe"               "America/Guatemala"               
## [125] "America/Guayaquil"                "America/Guyana"                  
## [127] "America/Halifax"                  "America/Havana"                  
## [129] "America/Hermosillo"               "America/Indiana/Indianapolis"    
## [131] "America/Indiana/Knox"             "America/Indiana/Marengo"         
## [133] "America/Indiana/Petersburg"       "America/Indiana/Tell_City"       
## [135] "America/Indiana/Vevay"            "America/Indiana/Vincennes"       
## [137] "America/Indiana/Winamac"          "America/Indianapolis"            
## [139] "America/Inuvik"                   "America/Iqaluit"                 
## [141] "America/Jamaica"                  "America/Jujuy"                   
## [143] "America/Juneau"                   "America/Kentucky/Louisville"     
## [145] "America/Kentucky/Monticello"      "America/Knox_IN"                 
## [147] "America/Kralendijk"               "America/La_Paz"                  
## [149] "America/Lima"                     "America/Los_Angeles"             
## [151] "America/Louisville"               "America/Lower_Princes"           
## [153] "America/Maceio"                   "America/Managua"                 
## [155] "America/Manaus"                   "America/Marigot"                 
## [157] "America/Martinique"               "America/Matamoros"               
## [159] "America/Mazatlan"                 "America/Mendoza"                 
## [161] "America/Menominee"                "America/Merida"                  
## [163] "America/Metlakatla"               "America/Mexico_City"             
## [165] "America/Miquelon"                 "America/Moncton"                 
## [167] "America/Monterrey"                "America/Montevideo"              
## [169] "America/Montreal"                 "America/Montserrat"              
## [171] "America/Nassau"                   "America/New_York"                
## [173] "America/Nipigon"                  "America/Nome"                    
## [175] "America/Noronha"                  "America/North_Dakota/Beulah"     
## [177] "America/North_Dakota/Center"      "America/North_Dakota/New_Salem"  
## [179] "America/Nuuk"                     "America/Ojinaga"                 
## [181] "America/Panama"                   "America/Pangnirtung"             
## [183] "America/Paramaribo"               "America/Phoenix"                 
## [185] "America/Port_of_Spain"            "America/Port-au-Prince"          
## [187] "America/Porto_Acre"               "America/Porto_Velho"             
## [189] "America/Puerto_Rico"              "America/Punta_Arenas"            
## [191] "America/Rainy_River"              "America/Rankin_Inlet"            
## [193] "America/Recife"                   "America/Regina"                  
## [195] "America/Resolute"                 "America/Rio_Branco"              
## [197] "America/Rosario"                  "America/Santa_Isabel"            
## [199] "America/Santarem"                 "America/Santiago"                
## [201] "America/Santo_Domingo"            "America/Sao_Paulo"               
## [203] "America/Scoresbysund"             "America/Shiprock"                
## [205] "America/Sitka"                    "America/St_Barthelemy"           
## [207] "America/St_Johns"                 "America/St_Kitts"                
## [209] "America/St_Lucia"                 "America/St_Thomas"               
## [211] "America/St_Vincent"               "America/Swift_Current"           
## [213] "America/Tegucigalpa"              "America/Thule"                   
## [215] "America/Thunder_Bay"              "America/Tijuana"                 
## [217] "America/Toronto"                  "America/Tortola"                 
## [219] "America/Vancouver"                "America/Virgin"                  
## [221] "America/Whitehorse"               "America/Winnipeg"                
## [223] "America/Yakutat"                  "America/Yellowknife"             
## [225] "Antarctica/Casey"                 "Antarctica/Davis"                
## [227] "Antarctica/DumontDUrville"        "Antarctica/Macquarie"            
## [229] "Antarctica/Mawson"                "Antarctica/McMurdo"              
## [231] "Antarctica/Palmer"                "Antarctica/Rothera"              
## [233] "Antarctica/South_Pole"            "Antarctica/Syowa"                
## [235] "Antarctica/Troll"                 "Antarctica/Vostok"               
## [237] "Arctic/Longyearbyen"              "ART"                             
## [239] "Asia/Aden"                        "Asia/Almaty"                     
## [241] "Asia/Amman"                       "Asia/Anadyr"                     
## [243] "Asia/Aqtau"                       "Asia/Aqtobe"                     
## [245] "Asia/Ashgabat"                    "Asia/Ashkhabad"                  
## [247] "Asia/Atyrau"                      "Asia/Baghdad"                    
## [249] "Asia/Bahrain"                     "Asia/Baku"                       
## [251] "Asia/Bangkok"                     "Asia/Barnaul"                    
## [253] "Asia/Beirut"                      "Asia/Bishkek"                    
## [255] "Asia/Brunei"                      "Asia/Calcutta"                   
## [257] "Asia/Chita"                       "Asia/Choibalsan"                 
## [259] "Asia/Chongqing"                   "Asia/Chungking"                  
## [261] "Asia/Colombo"                     "Asia/Dacca"                      
## [263] "Asia/Damascus"                    "Asia/Dhaka"                      
## [265] "Asia/Dili"                        "Asia/Dubai"                      
## [267] "Asia/Dushanbe"                    "Asia/Famagusta"                  
## [269] "Asia/Gaza"                        "Asia/Harbin"                     
## [271] "Asia/Hebron"                      "Asia/Ho_Chi_Minh"                
## [273] "Asia/Hong_Kong"                   "Asia/Hovd"                       
## [275] "Asia/Irkutsk"                     "Asia/Istanbul"                   
## [277] "Asia/Jakarta"                     "Asia/Jayapura"                   
## [279] "Asia/Jerusalem"                   "Asia/Kabul"                      
## [281] "Asia/Kamchatka"                   "Asia/Karachi"                    
## [283] "Asia/Kashgar"                     "Asia/Kathmandu"                  
## [285] "Asia/Katmandu"                    "Asia/Khandyga"                   
## [287] "Asia/Kolkata"                     "Asia/Krasnoyarsk"                
## [289] "Asia/Kuala_Lumpur"                "Asia/Kuching"                    
## [291] "Asia/Kuwait"                      "Asia/Macao"                      
## [293] "Asia/Macau"                       "Asia/Magadan"                    
## [295] "Asia/Makassar"                    "Asia/Manila"                     
## [297] "Asia/Muscat"                      "Asia/Nicosia"                    
## [299] "Asia/Novokuznetsk"                "Asia/Novosibirsk"                
## [301] "Asia/Omsk"                        "Asia/Oral"                       
## [303] "Asia/Phnom_Penh"                  "Asia/Pontianak"                  
## [305] "Asia/Pyongyang"                   "Asia/Qatar"                      
## [307] "Asia/Qostanay"                    "Asia/Qyzylorda"                  
## [309] "Asia/Rangoon"                     "Asia/Riyadh"                     
## [311] "Asia/Saigon"                      "Asia/Sakhalin"                   
## [313] "Asia/Samarkand"                   "Asia/Seoul"                      
## [315] "Asia/Shanghai"                    "Asia/Singapore"                  
## [317] "Asia/Srednekolymsk"               "Asia/Taipei"                     
## [319] "Asia/Tashkent"                    "Asia/Tbilisi"                    
## [321] "Asia/Tehran"                      "Asia/Tel_Aviv"                   
## [323] "Asia/Thimbu"                      "Asia/Thimphu"                    
## [325] "Asia/Tokyo"                       "Asia/Tomsk"                      
## [327] "Asia/Ujung_Pandang"               "Asia/Ulaanbaatar"                
## [329] "Asia/Ulan_Bator"                  "Asia/Urumqi"                     
## [331] "Asia/Ust-Nera"                    "Asia/Vientiane"                  
## [333] "Asia/Vladivostok"                 "Asia/Yakutsk"                    
## [335] "Asia/Yangon"                      "Asia/Yekaterinburg"              
## [337] "Asia/Yerevan"                     "AST"                             
## [339] "Atlantic/Azores"                  "Atlantic/Bermuda"                
## [341] "Atlantic/Canary"                  "Atlantic/Cape_Verde"             
## [343] "Atlantic/Faeroe"                  "Atlantic/Faroe"                  
## [345] "Atlantic/Jan_Mayen"               "Atlantic/Madeira"                
## [347] "Atlantic/Reykjavik"               "Atlantic/South_Georgia"          
## [349] "Atlantic/St_Helena"               "Atlantic/Stanley"                
## [351] "Australia/ACT"                    "Australia/Adelaide"              
## [353] "Australia/Brisbane"               "Australia/Broken_Hill"           
## [355] "Australia/Canberra"               "Australia/Currie"                
## [357] "Australia/Darwin"                 "Australia/Eucla"                 
## [359] "Australia/Hobart"                 "Australia/LHI"                   
## [361] "Australia/Lindeman"               "Australia/Lord_Howe"             
## [363] "Australia/Melbourne"              "Australia/North"                 
## [365] "Australia/NSW"                    "Australia/Perth"                 
## [367] "Australia/Queensland"             "Australia/South"                 
## [369] "Australia/Sydney"                 "Australia/Tasmania"              
## [371] "Australia/Victoria"               "Australia/West"                  
## [373] "Australia/Yancowinna"             "BET"                             
## [375] "Brazil/Acre"                      "Brazil/DeNoronha"                
## [377] "Brazil/East"                      "Brazil/West"                     
## [379] "BST"                              "Canada/Atlantic"                 
## [381] "Canada/Central"                   "Canada/East-Saskatchewan"        
## [383] "Canada/Eastern"                   "Canada/Mountain"                 
## [385] "Canada/Newfoundland"              "Canada/Pacific"                  
## [387] "Canada/Saskatchewan"              "Canada/Yukon"                    
## [389] "CAT"                              "CET"                             
## [391] "Chile/Continental"                "Chile/EasterIsland"              
## [393] "CNT"                              "CST"                             
## [395] "CST6CDT"                          "CTT"                             
## [397] "Cuba"                             "EAT"                             
## [399] "ECT"                              "EET"                             
## [401] "Egypt"                            "Eire"                            
## [403] "EST"                              "EST5EDT"                         
## [405] "Etc/GMT"                          "Etc/GMT-0"                       
## [407] "Etc/GMT-1"                        "Etc/GMT-2"                       
## [409] "Etc/GMT-3"                        "Etc/GMT-4"                       
## [411] "Etc/GMT-5"                        "Etc/GMT-6"                       
## [413] "Etc/GMT-7"                        "Etc/GMT-8"                       
## [415] "Etc/GMT-9"                        "Etc/GMT-10"                      
## [417] "Etc/GMT-11"                       "Etc/GMT-12"                      
## [419] "Etc/GMT-13"                       "Etc/GMT-14"                      
## [421] "Etc/GMT+0"                        "Etc/GMT+1"                       
## [423] "Etc/GMT+2"                        "Etc/GMT+3"                       
## [425] "Etc/GMT+4"                        "Etc/GMT+5"                       
## [427] "Etc/GMT+6"                        "Etc/GMT+7"                       
## [429] "Etc/GMT+8"                        "Etc/GMT+9"                       
## [431] "Etc/GMT+10"                       "Etc/GMT+11"                      
## [433] "Etc/GMT+12"                       "Etc/GMT0"                        
## [435] "Etc/Greenwich"                    "Etc/UCT"                         
## [437] "Etc/Universal"                    "Etc/UTC"                         
## [439] "Etc/Zulu"                         "Europe/Amsterdam"                
## [441] "Europe/Andorra"                   "Europe/Astrakhan"                
## [443] "Europe/Athens"                    "Europe/Belfast"                  
## [445] "Europe/Belgrade"                  "Europe/Berlin"                   
## [447] "Europe/Bratislava"                "Europe/Brussels"                 
## [449] "Europe/Bucharest"                 "Europe/Budapest"                 
## [451] "Europe/Busingen"                  "Europe/Chisinau"                 
## [453] "Europe/Copenhagen"                "Europe/Dublin"                   
## [455] "Europe/Gibraltar"                 "Europe/Guernsey"                 
## [457] "Europe/Helsinki"                  "Europe/Isle_of_Man"              
## [459] "Europe/Istanbul"                  "Europe/Jersey"                   
## [461] "Europe/Kaliningrad"               "Europe/Kiev"                     
## [463] "Europe/Kirov"                     "Europe/Lisbon"                   
## [465] "Europe/Ljubljana"                 "Europe/London"                   
## [467] "Europe/Luxembourg"                "Europe/Madrid"                   
## [469] "Europe/Malta"                     "Europe/Mariehamn"                
## [471] "Europe/Minsk"                     "Europe/Monaco"                   
## [473] "Europe/Moscow"                    "Europe/Nicosia"                  
## [475] "Europe/Oslo"                      "Europe/Paris"                    
## [477] "Europe/Podgorica"                 "Europe/Prague"                   
## [479] "Europe/Riga"                      "Europe/Rome"                     
## [481] "Europe/Samara"                    "Europe/San_Marino"               
## [483] "Europe/Sarajevo"                  "Europe/Saratov"                  
## [485] "Europe/Simferopol"                "Europe/Skopje"                   
## [487] "Europe/Sofia"                     "Europe/Stockholm"                
## [489] "Europe/Tallinn"                   "Europe/Tirane"                   
## [491] "Europe/Tiraspol"                  "Europe/Ulyanovsk"                
## [493] "Europe/Uzhgorod"                  "Europe/Vaduz"                    
## [495] "Europe/Vatican"                   "Europe/Vienna"                   
## [497] "Europe/Vilnius"                   "Europe/Volgograd"                
## [499] "Europe/Warsaw"                    "Europe/Zagreb"                   
## [501] "Europe/Zaporozhye"                "Europe/Zurich"                   
## [503] "Factory"                          "GB"                              
## [505] "GB-Eire"                          "GMT"                             
## [507] "GMT-0"                            "GMT+0"                           
## [509] "GMT0"                             "Greenwich"                       
## [511] "Hongkong"                         "HST"                             
## [513] "Iceland"                          "IET"                             
## [515] "Indian/Antananarivo"              "Indian/Chagos"                   
## [517] "Indian/Christmas"                 "Indian/Cocos"                    
## [519] "Indian/Comoro"                    "Indian/Kerguelen"                
## [521] "Indian/Mahe"                      "Indian/Maldives"                 
## [523] "Indian/Mauritius"                 "Indian/Mayotte"                  
## [525] "Indian/Reunion"                   "Iran"                            
## [527] "Israel"                           "IST"                             
## [529] "Jamaica"                          "Japan"                           
## [531] "JST"                              "Kwajalein"                       
## [533] "Libya"                            "MET"                             
## [535] "Mexico/BajaNorte"                 "Mexico/BajaSur"                  
## [537] "Mexico/General"                   "MIT"                             
## [539] "MST"                              "MST7MDT"                         
## [541] "Navajo"                           "NET"                             
## [543] "NST"                              "NZ"                              
## [545] "NZ-CHAT"                          "Pacific/Apia"                    
## [547] "Pacific/Auckland"                 "Pacific/Bougainville"            
## [549] "Pacific/Chatham"                  "Pacific/Chuuk"                   
## [551] "Pacific/Easter"                   "Pacific/Efate"                   
## [553] "Pacific/Enderbury"                "Pacific/Fakaofo"                 
## [555] "Pacific/Fiji"                     "Pacific/Funafuti"                
## [557] "Pacific/Galapagos"                "Pacific/Gambier"                 
## [559] "Pacific/Guadalcanal"              "Pacific/Guam"                    
## [561] "Pacific/Honolulu"                 "Pacific/Johnston"                
## [563] "Pacific/Kiritimati"               "Pacific/Kosrae"                  
## [565] "Pacific/Kwajalein"                "Pacific/Majuro"                  
## [567] "Pacific/Marquesas"                "Pacific/Midway"                  
## [569] "Pacific/Nauru"                    "Pacific/Niue"                    
## [571] "Pacific/Norfolk"                  "Pacific/Noumea"                  
## [573] "Pacific/Pago_Pago"                "Pacific/Palau"                   
## [575] "Pacific/Pitcairn"                 "Pacific/Pohnpei"                 
## [577] "Pacific/Ponape"                   "Pacific/Port_Moresby"            
## [579] "Pacific/Rarotonga"                "Pacific/Saipan"                  
## [581] "Pacific/Samoa"                    "Pacific/Tahiti"                  
## [583] "Pacific/Tarawa"                   "Pacific/Tongatapu"               
## [585] "Pacific/Truk"                     "Pacific/Wake"                    
## [587] "Pacific/Wallis"                   "Pacific/Yap"                     
## [589] "PLT"                              "PNT"                             
## [591] "Poland"                           "Portugal"                        
## [593] "PRC"                              "PRT"                             
## [595] "PST"                              "PST8PDT"                         
## [597] "ROC"                              "ROK"                             
## [599] "Singapore"                        "SST"                             
## [601] "SystemV/AST4"                     "SystemV/AST4ADT"                 
## [603] "SystemV/CST6"                     "SystemV/CST6CDT"                 
## [605] "SystemV/EST5"                     "SystemV/EST5EDT"                 
## [607] "SystemV/HST10"                    "SystemV/MST7"                    
## [609] "SystemV/MST7MDT"                  "SystemV/PST8"                    
## [611] "SystemV/PST8PDT"                  "SystemV/YST9"                    
## [613] "SystemV/YST9YDT"                  "Turkey"                          
## [615] "UCT"                              "Universal"                       
## [617] "US/Alaska"                        "US/Aleutian"                     
## [619] "US/Arizona"                       "US/Central"                      
## [621] "US/East-Indiana"                  "US/Eastern"                      
## [623] "US/Hawaii"                        "US/Indiana-Starke"               
## [625] "US/Michigan"                      "US/Mountain"                     
## [627] "US/Pacific"                       "US/Pacific-New"                  
## [629] "US/Samoa"                         "UTC"                             
## [631] "VST"                              "W-SU"                            
## [633] "WET"                              "Zulu"
stri_timezone_list(offset=1)
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
stri_timezone_list(offset=5.5)
## [1] "Asia/Calcutta" "Asia/Colombo"  "Asia/Kolkata"  "IST"
stri_timezone_list(offset=5.75)
## [1] "Asia/Kathmandu" "Asia/Katmandu"
stri_timezone_list(region='PL')
## [1] "Europe/Warsaw" "Poland"
stri_timezone_list(region='US', offset=-10)
## [1] "America/Adak"     "America/Atka"     "Pacific/Honolulu" "US/Aleutian"     
## [5] "US/Hawaii"
# Fetch information on all time zones
do.call(rbind.data.frame,
   lapply(stri_timezone_list(), function(tz) stri_timezone_info(tz)))
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
## 98                 America/Chihuahua            Mexican Pacific Standard Time
## 99             America/Coral_Harbour                    Eastern Standard Time
## 100                  America/Cordoba                  Argentina Standard Time
## 101               America/Costa_Rica                    Central Standard Time
## 102                  America/Creston                   Mountain Standard Time
## 103                   America/Cuiaba                     Amazon Standard Time
## 104                  America/Curacao                   Atlantic Standard Time
## 105             America/Danmarkshavn                      Greenwich Mean Time
## 106                   America/Dawson                   Mountain Standard Time
## 107             America/Dawson_Creek                   Mountain Standard Time
## 108                   America/Denver                   Mountain Standard Time
## 109                  America/Detroit                    Eastern Standard Time
## 110                 America/Dominica                   Atlantic Standard Time
## 111                 America/Edmonton                   Mountain Standard Time
## 112                 America/Eirunepe                       Acre Standard Time
## 113              America/El_Salvador                    Central Standard Time
## 114                 America/Ensenada                    Pacific Standard Time
## 115              America/Fort_Nelson                   Mountain Standard Time
## 116               America/Fort_Wayne                    Eastern Standard Time
## 117                America/Fortaleza                   Brasilia Standard Time
## 118                America/Glace_Bay                   Atlantic Standard Time
## 119                  America/Godthab             West Greenland Standard Time
## 120                America/Goose_Bay                   Atlantic Standard Time
## 121               America/Grand_Turk                    Eastern Standard Time
## 122                  America/Grenada                   Atlantic Standard Time
## 123               America/Guadeloupe                   Atlantic Standard Time
## 124                America/Guatemala                    Central Standard Time
## 125                America/Guayaquil                             Ecuador Time
## 126                   America/Guyana                              Guyana Time
## 127                  America/Halifax                   Atlantic Standard Time
## 128                   America/Havana                       Cuba Standard Time
## 129               America/Hermosillo            Mexican Pacific Standard Time
## 130     America/Indiana/Indianapolis                    Eastern Standard Time
## 131             America/Indiana/Knox                    Central Standard Time
## 132          America/Indiana/Marengo                    Eastern Standard Time
## 133       America/Indiana/Petersburg                    Eastern Standard Time
## 134        America/Indiana/Tell_City                    Central Standard Time
## 135            America/Indiana/Vevay                    Eastern Standard Time
## 136        America/Indiana/Vincennes                    Eastern Standard Time
## 137          America/Indiana/Winamac                    Eastern Standard Time
## 138             America/Indianapolis                    Eastern Standard Time
## 139                   America/Inuvik                   Mountain Standard Time
## 140                  America/Iqaluit                    Eastern Standard Time
## 141                  America/Jamaica                    Eastern Standard Time
## 142                    America/Jujuy                  Argentina Standard Time
## 143                   America/Juneau                     Alaska Standard Time
## 144      America/Kentucky/Louisville                    Eastern Standard Time
## 145      America/Kentucky/Monticello                    Eastern Standard Time
## 146                  America/Knox_IN                    Central Standard Time
## 147               America/Kralendijk                   Atlantic Standard Time
## 148                   America/La_Paz                             Bolivia Time
## 149                     America/Lima                       Peru Standard Time
## 150              America/Los_Angeles                    Pacific Standard Time
## 151               America/Louisville                    Eastern Standard Time
## 152            America/Lower_Princes                   Atlantic Standard Time
## 153                   America/Maceio                   Brasilia Standard Time
## 154                  America/Managua                    Central Standard Time
## 155                   America/Manaus                     Amazon Standard Time
## 156                  America/Marigot                   Atlantic Standard Time
## 157               America/Martinique                   Atlantic Standard Time
## 158                America/Matamoros                    Central Standard Time
## 159                 America/Mazatlan            Mexican Pacific Standard Time
## 160                  America/Mendoza                  Argentina Standard Time
## 161                America/Menominee                    Central Standard Time
## 162                   America/Merida                    Central Standard Time
## 163               America/Metlakatla                     Alaska Standard Time
## 164              America/Mexico_City                    Central Standard Time
## 165                 America/Miquelon       St Pierre & Miquelon Standard Time
## 166                  America/Moncton                   Atlantic Standard Time
## 167                America/Monterrey                    Central Standard Time
## 168               America/Montevideo                    Uruguay Standard Time
## 169                 America/Montreal                                GMT-05:00
## 170               America/Montserrat                   Atlantic Standard Time
## 171                   America/Nassau                    Eastern Standard Time
## 172                 America/New_York                    Eastern Standard Time
## 173                  America/Nipigon                    Eastern Standard Time
## 174                     America/Nome                     Alaska Standard Time
## 175                  America/Noronha        Fernando de Noronha Standard Time
## 176      America/North_Dakota/Beulah                    Central Standard Time
## 177      America/North_Dakota/Center                    Central Standard Time
## 178   America/North_Dakota/New_Salem                    Central Standard Time
## 179                     America/Nuuk             West Greenland Standard Time
## 180                  America/Ojinaga                   Mountain Standard Time
## 181                   America/Panama                    Eastern Standard Time
## 182              America/Pangnirtung                    Eastern Standard Time
## 183               America/Paramaribo                            Suriname Time
## 184                  America/Phoenix                   Mountain Standard Time
## 185            America/Port_of_Spain                   Atlantic Standard Time
## 186           America/Port-au-Prince                    Eastern Standard Time
## 187               America/Porto_Acre                       Acre Standard Time
## 188              America/Porto_Velho                     Amazon Standard Time
## 189              America/Puerto_Rico                   Atlantic Standard Time
## 190             America/Punta_Arenas                                GMT-03:00
## 191              America/Rainy_River                    Central Standard Time
## 192             America/Rankin_Inlet                    Central Standard Time
## 193                   America/Recife                   Brasilia Standard Time
## 194                   America/Regina                    Central Standard Time
## 195                 America/Resolute                    Central Standard Time
## 196               America/Rio_Branco                       Acre Standard Time
## 197                  America/Rosario                  Argentina Standard Time
## 198             America/Santa_Isabel           Northwest Mexico Standard Time
## 199                 America/Santarem                   Brasilia Standard Time
## 200                 America/Santiago                      Chile Standard Time
## 201            America/Santo_Domingo                   Atlantic Standard Time
## 202                America/Sao_Paulo                   Brasilia Standard Time
## 203             America/Scoresbysund             East Greenland Standard Time
## 204                 America/Shiprock                   Mountain Standard Time
## 205                    America/Sitka                     Alaska Standard Time
## 206            America/St_Barthelemy                   Atlantic Standard Time
## 207                 America/St_Johns               Newfoundland Standard Time
## 208                 America/St_Kitts                   Atlantic Standard Time
## 209                 America/St_Lucia                   Atlantic Standard Time
## 210                America/St_Thomas                   Atlantic Standard Time
## 211               America/St_Vincent                   Atlantic Standard Time
## 212            America/Swift_Current                    Central Standard Time
## 213              America/Tegucigalpa                    Central Standard Time
## 214                    America/Thule                   Atlantic Standard Time
## 215              America/Thunder_Bay                    Eastern Standard Time
## 216                  America/Tijuana                    Pacific Standard Time
## 217                  America/Toronto                    Eastern Standard Time
## 218                  America/Tortola                   Atlantic Standard Time
## 219                America/Vancouver                    Pacific Standard Time
## 220                   America/Virgin                   Atlantic Standard Time
## 221               America/Whitehorse                   Mountain Standard Time
## 222                 America/Winnipeg                    Central Standard Time
## 223                  America/Yakutat                     Alaska Standard Time
## 224              America/Yellowknife                   Mountain Standard Time
## 225                 Antarctica/Casey                               Casey Time
## 226                 Antarctica/Davis                               Davis Time
## 227        Antarctica/DumontDUrville                    Dumont-d’Urville Time
## 228             Antarctica/Macquarie         Australian Eastern Standard Time
## 229                Antarctica/Mawson                              Mawson Time
## 230               Antarctica/McMurdo                New Zealand Standard Time
## 231                Antarctica/Palmer                                GMT-03:00
## 232               Antarctica/Rothera                             Rothera Time
## 233            Antarctica/South_Pole                New Zealand Standard Time
## 234                 Antarctica/Syowa                               Syowa Time
## 235                 Antarctica/Troll                      Greenwich Mean Time
## 236                Antarctica/Vostok                              Vostok Time
## 237              Arctic/Longyearbyen           Central European Standard Time
## 238                              ART           Eastern European Standard Time
## 239                        Asia/Aden                     Arabia Standard Time
## 240                      Asia/Almaty                     East Kazakhstan Time
## 241                       Asia/Amman           Eastern European Standard Time
## 242                      Asia/Anadyr                     Anadyr Standard Time
## 243                       Asia/Aqtau                     West Kazakhstan Time
## 244                      Asia/Aqtobe                     West Kazakhstan Time
## 245                    Asia/Ashgabat               Turkmenistan Standard Time
## 246                   Asia/Ashkhabad               Turkmenistan Standard Time
## 247                      Asia/Atyrau                     West Kazakhstan Time
## 248                     Asia/Baghdad                     Arabia Standard Time
## 249                     Asia/Bahrain                     Arabia Standard Time
## 250                        Asia/Baku                 Azerbaijan Standard Time
## 251                     Asia/Bangkok                           Indochina Time
## 252                     Asia/Barnaul                                GMT+07:00
## 253                      Asia/Beirut           Eastern European Standard Time
## 254                     Asia/Bishkek                          Kyrgyzstan Time
## 255                      Asia/Brunei                   Brunei Darussalam Time
## 256                    Asia/Calcutta                      India Standard Time
## 257                       Asia/Chita                    Yakutsk Standard Time
## 258                  Asia/Choibalsan                Ulaanbaatar Standard Time
## 259                   Asia/Chongqing                      China Standard Time
## 260                   Asia/Chungking                      China Standard Time
## 261                     Asia/Colombo                      India Standard Time
## 262                       Asia/Dacca                 Bangladesh Standard Time
## 263                    Asia/Damascus           Eastern European Standard Time
## 264                       Asia/Dhaka                 Bangladesh Standard Time
## 265                        Asia/Dili                          East Timor Time
## 266                       Asia/Dubai                       Gulf Standard Time
## 267                    Asia/Dushanbe                          Tajikistan Time
## 268                   Asia/Famagusta                                GMT+02:00
## 269                        Asia/Gaza           Eastern European Standard Time
## 270                      Asia/Harbin                      China Standard Time
## 271                      Asia/Hebron           Eastern European Standard Time
## 272                 Asia/Ho_Chi_Minh                           Indochina Time
## 273                   Asia/Hong_Kong                  Hong Kong Standard Time
## 274                        Asia/Hovd                       Hovd Standard Time
## 275                     Asia/Irkutsk                    Irkutsk Standard Time
## 276                    Asia/Istanbul                                GMT+03:00
## 277                     Asia/Jakarta                   Western Indonesia Time
## 278                    Asia/Jayapura                   Eastern Indonesia Time
## 279                   Asia/Jerusalem                     Israel Standard Time
## 280                       Asia/Kabul                         Afghanistan Time
## 281                   Asia/Kamchatka   Petropavlovsk-Kamchatski Standard Time
## 282                     Asia/Karachi                   Pakistan Standard Time
## 283                     Asia/Kashgar                                GMT+06:00
## 284                   Asia/Kathmandu                               Nepal Time
## 285                    Asia/Katmandu                               Nepal Time
## 286                    Asia/Khandyga                    Yakutsk Standard Time
## 287                     Asia/Kolkata                      India Standard Time
## 288                 Asia/Krasnoyarsk                Krasnoyarsk Standard Time
## 289                Asia/Kuala_Lumpur                            Malaysia Time
## 290                     Asia/Kuching                            Malaysia Time
## 291                      Asia/Kuwait                     Arabia Standard Time
## 292                       Asia/Macao                      China Standard Time
## 293                       Asia/Macau                      China Standard Time
## 294                     Asia/Magadan                    Magadan Standard Time
## 295                    Asia/Makassar                   Central Indonesia Time
## 296                      Asia/Manila                 Philippine Standard Time
## 297                      Asia/Muscat                       Gulf Standard Time
## 298                     Asia/Nicosia           Eastern European Standard Time
## 299                Asia/Novokuznetsk                Krasnoyarsk Standard Time
## 300                 Asia/Novosibirsk                Novosibirsk Standard Time
## 301                        Asia/Omsk                       Omsk Standard Time
## 302                        Asia/Oral                     West Kazakhstan Time
## 303                  Asia/Phnom_Penh                           Indochina Time
## 304                   Asia/Pontianak                   Western Indonesia Time
## 305                   Asia/Pyongyang                     Korean Standard Time
## 306                       Asia/Qatar                     Arabia Standard Time
## 307                    Asia/Qostanay                     East Kazakhstan Time
## 308                   Asia/Qyzylorda                     West Kazakhstan Time
## 309                     Asia/Rangoon                             Myanmar Time
## 310                      Asia/Riyadh                     Arabia Standard Time
## 311                      Asia/Saigon                           Indochina Time
## 312                    Asia/Sakhalin                   Sakhalin Standard Time
## 313                   Asia/Samarkand                 Uzbekistan Standard Time
## 314                       Asia/Seoul                     Korean Standard Time
## 315                    Asia/Shanghai                      China Standard Time
## 316                   Asia/Singapore                  Singapore Standard Time
## 317               Asia/Srednekolymsk                                GMT+11:00
## 318                      Asia/Taipei                     Taipei Standard Time
## 319                    Asia/Tashkent                 Uzbekistan Standard Time
## 320                     Asia/Tbilisi                    Georgia Standard Time
## 321                      Asia/Tehran                       Iran Standard Time
## 322                    Asia/Tel_Aviv                     Israel Standard Time
## 323                      Asia/Thimbu                              Bhutan Time
## 324                     Asia/Thimphu                              Bhutan Time
## 325                       Asia/Tokyo                      Japan Standard Time
## 326                       Asia/Tomsk                                GMT+07:00
## 327               Asia/Ujung_Pandang                   Central Indonesia Time
## 328                 Asia/Ulaanbaatar                Ulaanbaatar Standard Time
## 329                  Asia/Ulan_Bator                Ulaanbaatar Standard Time
## 330                      Asia/Urumqi                                GMT+06:00
## 331                    Asia/Ust-Nera                Vladivostok Standard Time
## 332                   Asia/Vientiane                           Indochina Time
## 333                 Asia/Vladivostok                Vladivostok Standard Time
## 334                     Asia/Yakutsk                    Yakutsk Standard Time
## 335                      Asia/Yangon                             Myanmar Time
## 336               Asia/Yekaterinburg              Yekaterinburg Standard Time
## 337                     Asia/Yerevan                    Armenia Standard Time
## 338                              AST                     Alaska Standard Time
## 339                  Atlantic/Azores                     Azores Standard Time
## 340                 Atlantic/Bermuda                   Atlantic Standard Time
## 341                  Atlantic/Canary           Western European Standard Time
## 342              Atlantic/Cape_Verde                 Cape Verde Standard Time
## 343                  Atlantic/Faeroe           Western European Standard Time
## 344                   Atlantic/Faroe           Western European Standard Time
## 345               Atlantic/Jan_Mayen           Central European Standard Time
## 346                 Atlantic/Madeira           Western European Standard Time
## 347               Atlantic/Reykjavik                      Greenwich Mean Time
## 348           Atlantic/South_Georgia                       South Georgia Time
## 349               Atlantic/St_Helena                      Greenwich Mean Time
## 350                 Atlantic/Stanley           Falkland Islands Standard Time
## 351                    Australia/ACT         Australian Eastern Standard Time
## 352               Australia/Adelaide         Australian Central Standard Time
## 353               Australia/Brisbane         Australian Eastern Standard Time
## 354            Australia/Broken_Hill         Australian Central Standard Time
## 355               Australia/Canberra         Australian Eastern Standard Time
## 356                 Australia/Currie         Australian Eastern Standard Time
## 357                 Australia/Darwin         Australian Central Standard Time
## 358                  Australia/Eucla Australian Central Western Standard Time
## 359                 Australia/Hobart         Australian Eastern Standard Time
## 360                    Australia/LHI                  Lord Howe Standard Time
## 361               Australia/Lindeman         Australian Eastern Standard Time
## 362              Australia/Lord_Howe                  Lord Howe Standard Time
## 363              Australia/Melbourne         Australian Eastern Standard Time
## 364                  Australia/North         Australian Central Standard Time
## 365                    Australia/NSW         Australian Eastern Standard Time
## 366                  Australia/Perth         Australian Western Standard Time
## 367             Australia/Queensland         Australian Eastern Standard Time
## 368                  Australia/South         Australian Central Standard Time
## 369                 Australia/Sydney         Australian Eastern Standard Time
## 370               Australia/Tasmania         Australian Eastern Standard Time
## 371               Australia/Victoria         Australian Eastern Standard Time
## 372                   Australia/West         Australian Western Standard Time
## 373             Australia/Yancowinna         Australian Central Standard Time
## 374                              BET                   Brasilia Standard Time
## 375                      Brazil/Acre                       Acre Standard Time
## 376                 Brazil/DeNoronha        Fernando de Noronha Standard Time
## 377                      Brazil/East                   Brasilia Standard Time
## 378                      Brazil/West                     Amazon Standard Time
## 379                              BST                 Bangladesh Standard Time
## 380                  Canada/Atlantic                   Atlantic Standard Time
## 381                   Canada/Central                    Central Standard Time
## 382         Canada/East-Saskatchewan                    Central Standard Time
## 383                   Canada/Eastern                    Eastern Standard Time
## 384                  Canada/Mountain                   Mountain Standard Time
## 385              Canada/Newfoundland               Newfoundland Standard Time
## 386                   Canada/Pacific                    Pacific Standard Time
## 387              Canada/Saskatchewan                    Central Standard Time
## 388                     Canada/Yukon                   Mountain Standard Time
## 389                              CAT                      Central Africa Time
## 390                              CET                                GMT+01:00
## 391                Chile/Continental                      Chile Standard Time
## 392               Chile/EasterIsland              Easter Island Standard Time
## 393                              CNT               Newfoundland Standard Time
## 394                              CST                    Central Standard Time
## 395                          CST6CDT                    Central Standard Time
## 396                              CTT                      China Standard Time
## 397                             Cuba                       Cuba Standard Time
## 398                              EAT                      Eastern Africa Time
## 399                              ECT           Central European Standard Time
## 400                              EET                                GMT+02:00
## 401                            Egypt           Eastern European Standard Time
## 402                             Eire                      Greenwich Mean Time
## 403                              EST                                GMT-05:00
## 404                          EST5EDT                    Eastern Standard Time
## 405                          Etc/GMT                      Greenwich Mean Time
## 406                        Etc/GMT-0                      Greenwich Mean Time
## 407                        Etc/GMT-1                                GMT+01:00
## 408                        Etc/GMT-2                                GMT+02:00
## 409                        Etc/GMT-3                                GMT+03:00
## 410                        Etc/GMT-4                                GMT+04:00
## 411                        Etc/GMT-5                                GMT+05:00
## 412                        Etc/GMT-6                                GMT+06:00
## 413                        Etc/GMT-7                                GMT+07:00
## 414                        Etc/GMT-8                                GMT+08:00
## 415                        Etc/GMT-9                                GMT+09:00
## 416                       Etc/GMT-10                                GMT+10:00
## 417                       Etc/GMT-11                                GMT+11:00
## 418                       Etc/GMT-12                                GMT+12:00
## 419                       Etc/GMT-13                                GMT+13:00
## 420                       Etc/GMT-14                                GMT+14:00
## 421                        Etc/GMT+0                      Greenwich Mean Time
## 422                        Etc/GMT+1                                GMT-01:00
## 423                        Etc/GMT+2                                GMT-02:00
## 424                        Etc/GMT+3                                GMT-03:00
## 425                        Etc/GMT+4                                GMT-04:00
## 426                        Etc/GMT+5                                GMT-05:00
## 427                        Etc/GMT+6                                GMT-06:00
## 428                        Etc/GMT+7                                GMT-07:00
## 429                        Etc/GMT+8                                GMT-08:00
## 430                        Etc/GMT+9                                GMT-09:00
## 431                       Etc/GMT+10                                GMT-10:00
## 432                       Etc/GMT+11                                GMT-11:00
## 433                       Etc/GMT+12                                GMT-12:00
## 434                         Etc/GMT0                      Greenwich Mean Time
## 435                    Etc/Greenwich                      Greenwich Mean Time
## 436                          Etc/UCT               Coordinated Universal Time
## 437                    Etc/Universal               Coordinated Universal Time
## 438                          Etc/UTC               Coordinated Universal Time
## 439                         Etc/Zulu               Coordinated Universal Time
## 440                 Europe/Amsterdam           Central European Standard Time
## 441                   Europe/Andorra           Central European Standard Time
## 442                 Europe/Astrakhan                                GMT+04:00
## 443                    Europe/Athens           Eastern European Standard Time
## 444                   Europe/Belfast                      Greenwich Mean Time
## 445                  Europe/Belgrade           Central European Standard Time
## 446                    Europe/Berlin           Central European Standard Time
## 447                Europe/Bratislava           Central European Standard Time
## 448                  Europe/Brussels           Central European Standard Time
## 449                 Europe/Bucharest           Eastern European Standard Time
## 450                  Europe/Budapest           Central European Standard Time
## 451                  Europe/Busingen           Central European Standard Time
## 452                  Europe/Chisinau           Eastern European Standard Time
## 453                Europe/Copenhagen           Central European Standard Time
## 454                    Europe/Dublin                      Greenwich Mean Time
## 455                 Europe/Gibraltar           Central European Standard Time
## 456                  Europe/Guernsey                      Greenwich Mean Time
## 457                  Europe/Helsinki           Eastern European Standard Time
## 458               Europe/Isle_of_Man                      Greenwich Mean Time
## 459                  Europe/Istanbul                                GMT+03:00
## 460                    Europe/Jersey                      Greenwich Mean Time
## 461               Europe/Kaliningrad           Eastern European Standard Time
## 462                      Europe/Kiev           Eastern European Standard Time
## 463                     Europe/Kirov                                GMT+03:00
## 464                    Europe/Lisbon           Western European Standard Time
## 465                 Europe/Ljubljana           Central European Standard Time
## 466                    Europe/London                      Greenwich Mean Time
## 467                Europe/Luxembourg           Central European Standard Time
## 468                    Europe/Madrid           Central European Standard Time
## 469                     Europe/Malta           Central European Standard Time
## 470                 Europe/Mariehamn           Eastern European Standard Time
## 471                     Europe/Minsk                     Moscow Standard Time
## 472                    Europe/Monaco           Central European Standard Time
## 473                    Europe/Moscow                     Moscow Standard Time
## 474                   Europe/Nicosia           Eastern European Standard Time
## 475                      Europe/Oslo           Central European Standard Time
## 476                     Europe/Paris           Central European Standard Time
## 477                 Europe/Podgorica           Central European Standard Time
## 478                    Europe/Prague           Central European Standard Time
## 479                      Europe/Riga           Eastern European Standard Time
## 480                      Europe/Rome           Central European Standard Time
## 481                    Europe/Samara                     Samara Standard Time
## 482                Europe/San_Marino           Central European Standard Time
## 483                  Europe/Sarajevo           Central European Standard Time
## 484                   Europe/Saratov                                GMT+04:00
## 485                Europe/Simferopol                     Moscow Standard Time
## 486                    Europe/Skopje           Central European Standard Time
## 487                     Europe/Sofia           Eastern European Standard Time
## 488                 Europe/Stockholm           Central European Standard Time
## 489                   Europe/Tallinn           Eastern European Standard Time
## 490                    Europe/Tirane           Central European Standard Time
## 491                  Europe/Tiraspol           Eastern European Standard Time
## 492                 Europe/Ulyanovsk                                GMT+04:00
## 493                  Europe/Uzhgorod           Eastern European Standard Time
## 494                     Europe/Vaduz           Central European Standard Time
## 495                   Europe/Vatican           Central European Standard Time
## 496                    Europe/Vienna           Central European Standard Time
## 497                   Europe/Vilnius           Eastern European Standard Time
## 498                 Europe/Volgograd                  Volgograd Standard Time
## 499                    Europe/Warsaw           Central European Standard Time
## 500                    Europe/Zagreb           Central European Standard Time
## 501                Europe/Zaporozhye           Eastern European Standard Time
## 502                    Europe/Zurich           Central European Standard Time
## 503                          Factory                                      GMT
## 504                               GB                      Greenwich Mean Time
## 505                          GB-Eire                      Greenwich Mean Time
## 506                              GMT                      Greenwich Mean Time
## 507                            GMT-0                      Greenwich Mean Time
## 508                            GMT+0                      Greenwich Mean Time
## 509                             GMT0                      Greenwich Mean Time
## 510                        Greenwich                      Greenwich Mean Time
## 511                         Hongkong                  Hong Kong Standard Time
## 512                              HST                                GMT-10:00
## 513                          Iceland                      Greenwich Mean Time
## 514                              IET                    Eastern Standard Time
## 515              Indian/Antananarivo                      Eastern Africa Time
## 516                    Indian/Chagos                        Indian Ocean Time
## 517                 Indian/Christmas                    Christmas Island Time
## 518                     Indian/Cocos                       Cocos Islands Time
## 519                    Indian/Comoro                      Eastern Africa Time
## 520                 Indian/Kerguelen         French Southern & Antarctic Time
## 521                      Indian/Mahe                          Seychelles Time
## 522                  Indian/Maldives                            Maldives Time
## 523                 Indian/Mauritius                  Mauritius Standard Time
## 524                   Indian/Mayotte                      Eastern Africa Time
## 525                   Indian/Reunion                             Réunion Time
## 526                             Iran                       Iran Standard Time
## 527                           Israel                     Israel Standard Time
## 528                              IST                      India Standard Time
## 529                          Jamaica                    Eastern Standard Time
## 530                            Japan                      Japan Standard Time
## 531                              JST                      Japan Standard Time
## 532                        Kwajalein                    Marshall Islands Time
## 533                            Libya           Eastern European Standard Time
## 534                              MET                                GMT+01:00
## 535                 Mexico/BajaNorte                    Pacific Standard Time
## 536                   Mexico/BajaSur            Mexican Pacific Standard Time
## 537                   Mexico/General                    Central Standard Time
## 538                              MIT                       Apia Standard Time
## 539                              MST                                GMT-07:00
## 540                          MST7MDT                   Mountain Standard Time
## 541                           Navajo                   Mountain Standard Time
## 542                              NET                    Armenia Standard Time
## 543                              NST                New Zealand Standard Time
## 544                               NZ                New Zealand Standard Time
## 545                          NZ-CHAT                    Chatham Standard Time
## 546                     Pacific/Apia                       Apia Standard Time
## 547                 Pacific/Auckland                New Zealand Standard Time
## 548             Pacific/Bougainville                                GMT+11:00
## 549                  Pacific/Chatham                    Chatham Standard Time
## 550                    Pacific/Chuuk                               Chuuk Time
## 551                   Pacific/Easter              Easter Island Standard Time
## 552                    Pacific/Efate                    Vanuatu Standard Time
## 553                Pacific/Enderbury                     Phoenix Islands Time
## 554                  Pacific/Fakaofo                             Tokelau Time
## 555                     Pacific/Fiji                       Fiji Standard Time
## 556                 Pacific/Funafuti                              Tuvalu Time
## 557                Pacific/Galapagos                           Galapagos Time
## 558                  Pacific/Gambier                             Gambier Time
## 559              Pacific/Guadalcanal                     Solomon Islands Time
## 560                     Pacific/Guam                   Chamorro Standard Time
## 561                 Pacific/Honolulu            Hawaii-Aleutian Standard Time
## 562                 Pacific/Johnston            Hawaii-Aleutian Standard Time
## 563               Pacific/Kiritimati                        Line Islands Time
## 564                   Pacific/Kosrae                              Kosrae Time
## 565                Pacific/Kwajalein                    Marshall Islands Time
## 566                   Pacific/Majuro                    Marshall Islands Time
## 567                Pacific/Marquesas                           Marquesas Time
## 568                   Pacific/Midway                      Samoa Standard Time
## 569                    Pacific/Nauru                               Nauru Time
## 570                     Pacific/Niue                                Niue Time
## 571                  Pacific/Norfolk             Norfolk Island Standard Time
## 572                   Pacific/Noumea              New Caledonia Standard Time
## 573                Pacific/Pago_Pago                      Samoa Standard Time
## 574                    Pacific/Palau                               Palau Time
## 575                 Pacific/Pitcairn                            Pitcairn Time
## 576                  Pacific/Pohnpei                              Ponape Time
## 577                   Pacific/Ponape                              Ponape Time
## 578             Pacific/Port_Moresby                    Papua New Guinea Time
## 579                Pacific/Rarotonga                Cook Island Standard Time
## 580                   Pacific/Saipan                   Chamorro Standard Time
## 581                    Pacific/Samoa                      Samoa Standard Time
## 582                   Pacific/Tahiti                              Tahiti Time
## 583                   Pacific/Tarawa                     Gilbert Islands Time
## 584                Pacific/Tongatapu                      Tonga Standard Time
## 585                     Pacific/Truk                               Chuuk Time
## 586                     Pacific/Wake                         Wake Island Time
## 587                   Pacific/Wallis                     Wallis & Futuna Time
## 588                      Pacific/Yap                               Chuuk Time
## 589                              PLT                   Pakistan Standard Time
## 590                              PNT                   Mountain Standard Time
## 591                           Poland           Central European Standard Time
## 592                         Portugal           Western European Standard Time
## 593                              PRC                      China Standard Time
## 594                              PRT                   Atlantic Standard Time
## 595                              PST                    Pacific Standard Time
## 596                          PST8PDT                    Pacific Standard Time
## 597                              ROC                     Taipei Standard Time
## 598                              ROK                     Korean Standard Time
## 599                        Singapore                  Singapore Standard Time
## 600                              SST                     Solomon Islands Time
## 601                     SystemV/AST4                                GMT-04:00
## 602                  SystemV/AST4ADT                                GMT-04:00
## 603                     SystemV/CST6                                GMT-06:00
## 604                  SystemV/CST6CDT                                GMT-06:00
## 605                     SystemV/EST5                                GMT-05:00
## 606                  SystemV/EST5EDT                                GMT-05:00
## 607                    SystemV/HST10                                GMT-10:00
## 608                     SystemV/MST7                                GMT-07:00
## 609                  SystemV/MST7MDT                                GMT-07:00
## 610                     SystemV/PST8                                GMT-08:00
## 611                  SystemV/PST8PDT                                GMT-08:00
## 612                     SystemV/YST9                                GMT-09:00
## 613                  SystemV/YST9YDT                                GMT-09:00
## 614                           Turkey                                GMT+03:00
## 615                              UCT               Coordinated Universal Time
## 616                        Universal               Coordinated Universal Time
## 617                        US/Alaska                     Alaska Standard Time
## 618                      US/Aleutian            Hawaii-Aleutian Standard Time
## 619                       US/Arizona                   Mountain Standard Time
## 620                       US/Central                    Central Standard Time
## 621                  US/East-Indiana                    Eastern Standard Time
## 622                       US/Eastern                    Eastern Standard Time
## 623                        US/Hawaii            Hawaii-Aleutian Standard Time
## 624                US/Indiana-Starke                    Central Standard Time
## 625                      US/Michigan                    Eastern Standard Time
## 626                      US/Mountain                   Mountain Standard Time
## 627                       US/Pacific                    Pacific Standard Time
## 628                   US/Pacific-New                    Pacific Standard Time
## 629                         US/Samoa                      Samoa Standard Time
## 630                              UTC               Coordinated Universal Time
## 631                              VST                           Indochina Time
## 632                             W-SU                     Moscow Standard Time
## 633                              WET                                      GMT
## 634                             Zulu               Coordinated Universal Time
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
## 16                                <NA>             Egypt Standard Time
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
## 29                                <NA>      South Africa Standard Time
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
## 81               Central Daylight Time  Central Standard Time (Mexico)
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
## 98       Mexican Pacific Daylight Time Mountain Standard Time (Mexico)
## 99                                <NA>        SA Pacific Standard Time
## 100                               <NA>         Argentina Standard Time
## 101                               <NA>   Central America Standard Time
## 102                               <NA>       US Mountain Standard Time
## 103                               <NA> Central Brazilian Standard Time
## 104                               <NA>        SA Western Standard Time
## 105                               <NA>         Greenwich Standard Time
## 106                               <NA>             Yukon Standard Time
## 107                               <NA>       US Mountain Standard Time
## 108             Mountain Daylight Time          Mountain Standard Time
## 109              Eastern Daylight Time           Eastern Standard Time
## 110                               <NA>        SA Western Standard Time
## 111             Mountain Daylight Time          Mountain Standard Time
## 112                               <NA>        SA Pacific Standard Time
## 113                               <NA>   Central America Standard Time
## 114              Pacific Daylight Time  Pacific Standard Time (Mexico)
## 115                               <NA>       US Mountain Standard Time
## 116              Eastern Daylight Time        US Eastern Standard Time
## 117                               <NA>        SA Eastern Standard Time
## 118             Atlantic Daylight Time          Atlantic Standard Time
## 119         West Greenland Summer Time         Greenland Standard Time
## 120             Atlantic Daylight Time          Atlantic Standard Time
## 121              Eastern Daylight Time  Turks And Caicos Standard Time
## 122                               <NA>        SA Western Standard Time
## 123                               <NA>        SA Western Standard Time
## 124                               <NA>   Central America Standard Time
## 125                               <NA>        SA Pacific Standard Time
## 126                               <NA>        SA Western Standard Time
## 127             Atlantic Daylight Time          Atlantic Standard Time
## 128                 Cuba Daylight Time              Cuba Standard Time
## 129                               <NA>       US Mountain Standard Time
## 130              Eastern Daylight Time        US Eastern Standard Time
## 131              Central Daylight Time           Central Standard Time
## 132              Eastern Daylight Time        US Eastern Standard Time
## 133              Eastern Daylight Time           Eastern Standard Time
## 134              Central Daylight Time           Central Standard Time
## 135              Eastern Daylight Time        US Eastern Standard Time
## 136              Eastern Daylight Time           Eastern Standard Time
## 137              Eastern Daylight Time           Eastern Standard Time
## 138              Eastern Daylight Time        US Eastern Standard Time
## 139             Mountain Daylight Time          Mountain Standard Time
## 140              Eastern Daylight Time           Eastern Standard Time
## 141                               <NA>        SA Pacific Standard Time
## 142                               <NA>         Argentina Standard Time
## 143               Alaska Daylight Time           Alaskan Standard Time
## 144              Eastern Daylight Time           Eastern Standard Time
## 145              Eastern Daylight Time           Eastern Standard Time
## 146              Central Daylight Time           Central Standard Time
## 147                               <NA>        SA Western Standard Time
## 148                               <NA>        SA Western Standard Time
## 149                               <NA>        SA Pacific Standard Time
## 150              Pacific Daylight Time           Pacific Standard Time
## 151              Eastern Daylight Time           Eastern Standard Time
## 152                               <NA>        SA Western Standard Time
## 153                               <NA>        SA Eastern Standard Time
## 154                               <NA>   Central America Standard Time
## 155                               <NA>        SA Western Standard Time
## 156                               <NA>        SA Western Standard Time
## 157                               <NA>        SA Western Standard Time
## 158              Central Daylight Time           Central Standard Time
## 159      Mexican Pacific Daylight Time Mountain Standard Time (Mexico)
## 160                               <NA>         Argentina Standard Time
## 161              Central Daylight Time           Central Standard Time
## 162              Central Daylight Time  Central Standard Time (Mexico)
## 163               Alaska Daylight Time           Alaskan Standard Time
## 164              Central Daylight Time  Central Standard Time (Mexico)
## 165 St Pierre & Miquelon Daylight Time      Saint Pierre Standard Time
## 166             Atlantic Daylight Time          Atlantic Standard Time
## 167              Central Daylight Time  Central Standard Time (Mexico)
## 168                               <NA>        Montevideo Standard Time
## 169                          GMT-04:00           Eastern Standard Time
## 170                               <NA>        SA Western Standard Time
## 171              Eastern Daylight Time           Eastern Standard Time
## 172              Eastern Daylight Time           Eastern Standard Time
## 173              Eastern Daylight Time           Eastern Standard Time
## 174               Alaska Daylight Time           Alaskan Standard Time
## 175                               <NA>                          UTC-02
## 176              Central Daylight Time           Central Standard Time
## 177              Central Daylight Time           Central Standard Time
## 178              Central Daylight Time           Central Standard Time
## 179         West Greenland Summer Time         Greenland Standard Time
## 180             Mountain Daylight Time          Mountain Standard Time
## 181                               <NA>        SA Pacific Standard Time
## 182              Eastern Daylight Time           Eastern Standard Time
## 183                               <NA>        SA Eastern Standard Time
## 184                               <NA>       US Mountain Standard Time
## 185                               <NA>        SA Western Standard Time
## 186              Eastern Daylight Time             Haiti Standard Time
## 187                               <NA>        SA Pacific Standard Time
## 188                               <NA>        SA Western Standard Time
## 189                               <NA>        SA Western Standard Time
## 190                               <NA>        Magallanes Standard Time
## 191              Central Daylight Time           Central Standard Time
## 192              Central Daylight Time           Central Standard Time
## 193                               <NA>        SA Eastern Standard Time
## 194                               <NA>    Canada Central Standard Time
## 195              Central Daylight Time           Central Standard Time
## 196                               <NA>        SA Pacific Standard Time
## 197                               <NA>         Argentina Standard Time
## 198     Northwest Mexico Daylight Time  Pacific Standard Time (Mexico)
## 199                               <NA>        SA Eastern Standard Time
## 200                  Chile Summer Time        Pacific SA Standard Time
## 201                               <NA>        SA Western Standard Time
## 202                               <NA>  E. South America Standard Time
## 203         East Greenland Summer Time            Azores Standard Time
## 204             Mountain Daylight Time          Mountain Standard Time
## 205               Alaska Daylight Time           Alaskan Standard Time
## 206                               <NA>        SA Western Standard Time
## 207         Newfoundland Daylight Time      Newfoundland Standard Time
## 208                               <NA>        SA Western Standard Time
## 209                               <NA>        SA Western Standard Time
## 210                               <NA>        SA Western Standard Time
## 211                               <NA>        SA Western Standard Time
## 212                               <NA>    Canada Central Standard Time
## 213                               <NA>   Central America Standard Time
## 214             Atlantic Daylight Time          Atlantic Standard Time
## 215              Eastern Daylight Time           Eastern Standard Time
## 216              Pacific Daylight Time  Pacific Standard Time (Mexico)
## 217              Eastern Daylight Time           Eastern Standard Time
## 218                               <NA>        SA Western Standard Time
## 219              Pacific Daylight Time           Pacific Standard Time
## 220                               <NA>        SA Western Standard Time
## 221                               <NA>             Yukon Standard Time
## 222              Central Daylight Time           Central Standard Time
## 223               Alaska Daylight Time           Alaskan Standard Time
## 224             Mountain Daylight Time          Mountain Standard Time
## 225                               <NA>   Central Pacific Standard Time
## 226                               <NA>           SE Asia Standard Time
## 227                               <NA>      West Pacific Standard Time
## 228   Australian Eastern Daylight Time          Tasmania Standard Time
## 229                               <NA>         West Asia Standard Time
## 230          New Zealand Daylight Time       New Zealand Standard Time
## 231                               <NA>        SA Eastern Standard Time
## 232                               <NA>        SA Eastern Standard Time
## 233          New Zealand Daylight Time       New Zealand Standard Time
## 234                               <NA>         E. Africa Standard Time
## 235                          GMT+02:00                            <NA>
## 236                               <NA>      Central Asia Standard Time
## 237       Central European Summer Time         W. Europe Standard Time
## 238                               <NA>             Egypt Standard Time
## 239                               <NA>              Arab Standard Time
## 240                               <NA>      Central Asia Standard Time
## 241       Eastern European Summer Time            Jordan Standard Time
## 242                               <NA>             Russia Time Zone 11
## 243                               <NA>         West Asia Standard Time
## 244                               <NA>         West Asia Standard Time
## 245                               <NA>         West Asia Standard Time
## 246                               <NA>         West Asia Standard Time
## 247                               <NA>         West Asia Standard Time
## 248                               <NA>            Arabic Standard Time
## 249                               <NA>              Arab Standard Time
## 250                               <NA>        Azerbaijan Standard Time
## 251                               <NA>           SE Asia Standard Time
## 252                               <NA>             Altai Standard Time
## 253       Eastern European Summer Time       Middle East Standard Time
## 254                               <NA>      Central Asia Standard Time
## 255                               <NA>         Singapore Standard Time
## 256                               <NA>             India Standard Time
## 257                               <NA>       Transbaikal Standard Time
## 258                               <NA>       Ulaanbaatar Standard Time
## 259                               <NA>             China Standard Time
## 260                               <NA>             China Standard Time
## 261                               <NA>         Sri Lanka Standard Time
## 262                               <NA>        Bangladesh Standard Time
## 263       Eastern European Summer Time             Syria Standard Time
## 264                               <NA>        Bangladesh Standard Time
## 265                               <NA>             Tokyo Standard Time
## 266                               <NA>           Arabian Standard Time
## 267                               <NA>         West Asia Standard Time
## 268                          GMT+03:00               GTB Standard Time
## 269       Eastern European Summer Time         West Bank Standard Time
## 270                               <NA>             China Standard Time
## 271       Eastern European Summer Time         West Bank Standard Time
## 272                               <NA>           SE Asia Standard Time
## 273                               <NA>             China Standard Time
## 274                               <NA>       W. Mongolia Standard Time
## 275                               <NA>   North Asia East Standard Time
## 276                               <NA>            Turkey Standard Time
## 277                               <NA>           SE Asia Standard Time
## 278                               <NA>             Tokyo Standard Time
## 279               Israel Daylight Time            Israel Standard Time
## 280                               <NA>       Afghanistan Standard Time
## 281                               <NA>             Russia Time Zone 11
## 282                               <NA>          Pakistan Standard Time
## 283                               <NA>      Central Asia Standard Time
## 284                               <NA>             Nepal Standard Time
## 285                               <NA>             Nepal Standard Time
## 286                               <NA>           Yakutsk Standard Time
## 287                               <NA>             India Standard Time
## 288                               <NA>        North Asia Standard Time
## 289                               <NA>         Singapore Standard Time
## 290                               <NA>         Singapore Standard Time
## 291                               <NA>              Arab Standard Time
## 292                               <NA>             China Standard Time
## 293                               <NA>             China Standard Time
## 294                               <NA>           Magadan Standard Time
## 295                               <NA>         Singapore Standard Time
## 296                               <NA>         Singapore Standard Time
## 297                               <NA>           Arabian Standard Time
## 298       Eastern European Summer Time               GTB Standard Time
## 299                               <NA>        North Asia Standard Time
## 300                               <NA>   N. Central Asia Standard Time
## 301                               <NA>              Omsk Standard Time
## 302                               <NA>         West Asia Standard Time
## 303                               <NA>           SE Asia Standard Time
## 304                               <NA>           SE Asia Standard Time
## 305                               <NA>       North Korea Standard Time
## 306                               <NA>              Arab Standard Time
## 307                               <NA>      Central Asia Standard Time
## 308                               <NA>         Qyzylorda Standard Time
## 309                               <NA>           Myanmar Standard Time
## 310                               <NA>              Arab Standard Time
## 311                               <NA>           SE Asia Standard Time
## 312                               <NA>          Sakhalin Standard Time
## 313                               <NA>         West Asia Standard Time
## 314                               <NA>             Korea Standard Time
## 315                               <NA>             China Standard Time
## 316                               <NA>         Singapore Standard Time
## 317                               <NA>             Russia Time Zone 10
## 318                               <NA>            Taipei Standard Time
## 319                               <NA>         West Asia Standard Time
## 320                               <NA>          Georgian Standard Time
## 321                 Iran Daylight Time              Iran Standard Time
## 322               Israel Daylight Time            Israel Standard Time
## 323                               <NA>        Bangladesh Standard Time
## 324                               <NA>        Bangladesh Standard Time
## 325                               <NA>             Tokyo Standard Time
## 326                               <NA>             Tomsk Standard Time
## 327                               <NA>         Singapore Standard Time
## 328                               <NA>       Ulaanbaatar Standard Time
## 329                               <NA>       Ulaanbaatar Standard Time
## 330                               <NA>      Central Asia Standard Time
## 331                               <NA>       Vladivostok Standard Time
## 332                               <NA>           SE Asia Standard Time
## 333                               <NA>       Vladivostok Standard Time
## 334                               <NA>           Yakutsk Standard Time
## 335                               <NA>           Myanmar Standard Time
## 336                               <NA>      Ekaterinburg Standard Time
## 337                               <NA>          Caucasus Standard Time
## 338               Alaska Daylight Time           Alaskan Standard Time
## 339                 Azores Summer Time            Azores Standard Time
## 340             Atlantic Daylight Time          Atlantic Standard Time
## 341       Western European Summer Time               GMT Standard Time
## 342                               <NA>        Cape Verde Standard Time
## 343       Western European Summer Time               GMT Standard Time
## 344       Western European Summer Time               GMT Standard Time
## 345       Central European Summer Time         W. Europe Standard Time
## 346       Western European Summer Time               GMT Standard Time
## 347                               <NA>         Greenwich Standard Time
## 348                               <NA>                          UTC-02
## 349                               <NA>         Greenwich Standard Time
## 350                               <NA>        SA Eastern Standard Time
## 351   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 352   Australian Central Daylight Time    Cen. Australia Standard Time
## 353                               <NA>      E. Australia Standard Time
## 354   Australian Central Daylight Time    Cen. Australia Standard Time
## 355   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 356   Australian Eastern Daylight Time          Tasmania Standard Time
## 357                               <NA>       AUS Central Standard Time
## 358                               <NA>    Aus Central W. Standard Time
## 359   Australian Eastern Daylight Time          Tasmania Standard Time
## 360            Lord Howe Daylight Time         Lord Howe Standard Time
## 361                               <NA>      E. Australia Standard Time
## 362            Lord Howe Daylight Time         Lord Howe Standard Time
## 363   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 364                               <NA>       AUS Central Standard Time
## 365   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 366                               <NA>      W. Australia Standard Time
## 367                               <NA>      E. Australia Standard Time
## 368   Australian Central Daylight Time    Cen. Australia Standard Time
## 369   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 370   Australian Eastern Daylight Time          Tasmania Standard Time
## 371   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 372                               <NA>      W. Australia Standard Time
## 373   Australian Central Daylight Time    Cen. Australia Standard Time
## 374                               <NA>  E. South America Standard Time
## 375                               <NA>        SA Pacific Standard Time
## 376                               <NA>                          UTC-02
## 377                               <NA>  E. South America Standard Time
## 378                               <NA>        SA Western Standard Time
## 379                               <NA>        Bangladesh Standard Time
## 380             Atlantic Daylight Time          Atlantic Standard Time
## 381              Central Daylight Time           Central Standard Time
## 382                               <NA>    Canada Central Standard Time
## 383              Eastern Daylight Time           Eastern Standard Time
## 384             Mountain Daylight Time          Mountain Standard Time
## 385         Newfoundland Daylight Time      Newfoundland Standard Time
## 386              Pacific Daylight Time           Pacific Standard Time
## 387                               <NA>    Canada Central Standard Time
## 388                               <NA>             Yukon Standard Time
## 389                               <NA>      South Africa Standard Time
## 390                          GMT+02:00                            <NA>
## 391                  Chile Summer Time        Pacific SA Standard Time
## 392          Easter Island Summer Time     Easter Island Standard Time
## 393         Newfoundland Daylight Time      Newfoundland Standard Time
## 394              Central Daylight Time           Central Standard Time
## 395              Central Daylight Time           Central Standard Time
## 396                               <NA>             China Standard Time
## 397                 Cuba Daylight Time              Cuba Standard Time
## 398                               <NA>         E. Africa Standard Time
## 399       Central European Summer Time           Romance Standard Time
## 400                          GMT+03:00                            <NA>
## 401                               <NA>             Egypt Standard Time
## 402                Irish Standard Time               GMT Standard Time
## 403                               <NA>        SA Pacific Standard Time
## 404              Eastern Daylight Time           Eastern Standard Time
## 405                               <NA>                             UTC
## 406                               <NA>                             UTC
## 407                               <NA> W. Central Africa Standard Time
## 408                               <NA>      South Africa Standard Time
## 409                               <NA>         E. Africa Standard Time
## 410                               <NA>           Arabian Standard Time
## 411                               <NA>         West Asia Standard Time
## 412                               <NA>      Central Asia Standard Time
## 413                               <NA>           SE Asia Standard Time
## 414                               <NA>         Singapore Standard Time
## 415                               <NA>             Tokyo Standard Time
## 416                               <NA>      West Pacific Standard Time
## 417                               <NA>   Central Pacific Standard Time
## 418                               <NA>                          UTC+12
## 419                               <NA>                          UTC+13
## 420                               <NA>      Line Islands Standard Time
## 421                               <NA>                             UTC
## 422                               <NA>        Cape Verde Standard Time
## 423                               <NA>                          UTC-02
## 424                               <NA>        SA Eastern Standard Time
## 425                               <NA>        SA Western Standard Time
## 426                               <NA>        SA Pacific Standard Time
## 427                               <NA>   Central America Standard Time
## 428                               <NA>       US Mountain Standard Time
## 429                               <NA>                          UTC-08
## 430                               <NA>                          UTC-09
## 431                               <NA>          Hawaiian Standard Time
## 432                               <NA>                          UTC-11
## 433                               <NA>          Dateline Standard Time
## 434                               <NA>                             UTC
## 435                               <NA>                             UTC
## 436                               <NA>                             UTC
## 437                               <NA>                             UTC
## 438                               <NA>                             UTC
## 439                               <NA>                             UTC
## 440       Central European Summer Time         W. Europe Standard Time
## 441       Central European Summer Time         W. Europe Standard Time
## 442                               <NA>         Astrakhan Standard Time
## 443       Eastern European Summer Time               GTB Standard Time
## 444                British Summer Time               GMT Standard Time
## 445       Central European Summer Time    Central Europe Standard Time
## 446       Central European Summer Time         W. Europe Standard Time
## 447       Central European Summer Time    Central Europe Standard Time
## 448       Central European Summer Time           Romance Standard Time
## 449       Eastern European Summer Time               GTB Standard Time
## 450       Central European Summer Time    Central Europe Standard Time
## 451       Central European Summer Time         W. Europe Standard Time
## 452       Eastern European Summer Time         E. Europe Standard Time
## 453       Central European Summer Time           Romance Standard Time
## 454                Irish Standard Time               GMT Standard Time
## 455       Central European Summer Time         W. Europe Standard Time
## 456                          GMT+01:00               GMT Standard Time
## 457       Eastern European Summer Time               FLE Standard Time
## 458                          GMT+01:00               GMT Standard Time
## 459                               <NA>            Turkey Standard Time
## 460                          GMT+01:00               GMT Standard Time
## 461                               <NA>       Kaliningrad Standard Time
## 462       Eastern European Summer Time               FLE Standard Time
## 463                               <NA>           Russian Standard Time
## 464       Western European Summer Time               GMT Standard Time
## 465       Central European Summer Time    Central Europe Standard Time
## 466                British Summer Time               GMT Standard Time
## 467       Central European Summer Time         W. Europe Standard Time
## 468       Central European Summer Time           Romance Standard Time
## 469       Central European Summer Time         W. Europe Standard Time
## 470       Eastern European Summer Time               FLE Standard Time
## 471                               <NA>           Belarus Standard Time
## 472       Central European Summer Time         W. Europe Standard Time
## 473                               <NA>           Russian Standard Time
## 474       Eastern European Summer Time               GTB Standard Time
## 475       Central European Summer Time         W. Europe Standard Time
## 476       Central European Summer Time           Romance Standard Time
## 477       Central European Summer Time    Central Europe Standard Time
## 478       Central European Summer Time    Central Europe Standard Time
## 479       Eastern European Summer Time               FLE Standard Time
## 480       Central European Summer Time         W. Europe Standard Time
## 481                               <NA>              Russia Time Zone 3
## 482       Central European Summer Time         W. Europe Standard Time
## 483       Central European Summer Time  Central European Standard Time
## 484                               <NA>           Saratov Standard Time
## 485                               <NA>           Russian Standard Time
## 486       Central European Summer Time  Central European Standard Time
## 487       Eastern European Summer Time               FLE Standard Time
## 488       Central European Summer Time         W. Europe Standard Time
## 489       Eastern European Summer Time               FLE Standard Time
## 490       Central European Summer Time    Central Europe Standard Time
## 491       Eastern European Summer Time         E. Europe Standard Time
## 492                               <NA>         Astrakhan Standard Time
## 493       Eastern European Summer Time               FLE Standard Time
## 494       Central European Summer Time         W. Europe Standard Time
## 495       Central European Summer Time         W. Europe Standard Time
## 496       Central European Summer Time         W. Europe Standard Time
## 497       Eastern European Summer Time               FLE Standard Time
## 498                               <NA>         Volgograd Standard Time
## 499       Central European Summer Time  Central European Standard Time
## 500       Central European Summer Time  Central European Standard Time
## 501       Eastern European Summer Time               FLE Standard Time
## 502       Central European Summer Time         W. Europe Standard Time
## 503                               <NA>                            <NA>
## 504                British Summer Time               GMT Standard Time
## 505                British Summer Time               GMT Standard Time
## 506                               <NA>                             UTC
## 507                               <NA>                             UTC
## 508                               <NA>                             UTC
## 509                               <NA>                             UTC
## 510                               <NA>                             UTC
## 511                               <NA>             China Standard Time
## 512                               <NA>          Hawaiian Standard Time
## 513                               <NA>         Greenwich Standard Time
## 514              Eastern Daylight Time        US Eastern Standard Time
## 515                               <NA>         E. Africa Standard Time
## 516                               <NA>      Central Asia Standard Time
## 517                               <NA>           SE Asia Standard Time
## 518                               <NA>           Myanmar Standard Time
## 519                               <NA>         E. Africa Standard Time
## 520                               <NA>         West Asia Standard Time
## 521                               <NA>         Mauritius Standard Time
## 522                               <NA>         West Asia Standard Time
## 523                               <NA>         Mauritius Standard Time
## 524                               <NA>         E. Africa Standard Time
## 525                               <NA>         Mauritius Standard Time
## 526                 Iran Daylight Time              Iran Standard Time
## 527               Israel Daylight Time            Israel Standard Time
## 528                               <NA>             India Standard Time
## 529                               <NA>        SA Pacific Standard Time
## 530                               <NA>             Tokyo Standard Time
## 531                               <NA>             Tokyo Standard Time
## 532                               <NA>                          UTC+12
## 533                               <NA>             Libya Standard Time
## 534                          GMT+02:00                            <NA>
## 535              Pacific Daylight Time  Pacific Standard Time (Mexico)
## 536      Mexican Pacific Daylight Time Mountain Standard Time (Mexico)
## 537              Central Daylight Time  Central Standard Time (Mexico)
## 538                 Apia Daylight Time             Samoa Standard Time
## 539                               <NA>       US Mountain Standard Time
## 540             Mountain Daylight Time          Mountain Standard Time
## 541             Mountain Daylight Time          Mountain Standard Time
## 542                               <NA>          Caucasus Standard Time
## 543          New Zealand Daylight Time       New Zealand Standard Time
## 544          New Zealand Daylight Time       New Zealand Standard Time
## 545              Chatham Daylight Time   Chatham Islands Standard Time
## 546                 Apia Daylight Time             Samoa Standard Time
## 547          New Zealand Daylight Time       New Zealand Standard Time
## 548                               <NA>      Bougainville Standard Time
## 549              Chatham Daylight Time   Chatham Islands Standard Time
## 550                               <NA>      West Pacific Standard Time
## 551          Easter Island Summer Time     Easter Island Standard Time
## 552                               <NA>   Central Pacific Standard Time
## 553                               <NA>                          UTC+13
## 554                               <NA>                          UTC+13
## 555                   Fiji Summer Time              Fiji Standard Time
## 556                               <NA>                          UTC+12
## 557                               <NA>   Central America Standard Time
## 558                               <NA>                          UTC-09
## 559                               <NA>   Central Pacific Standard Time
## 560                               <NA>      West Pacific Standard Time
## 561                               <NA>          Hawaiian Standard Time
## 562                               <NA>          Hawaiian Standard Time
## 563                               <NA>      Line Islands Standard Time
## 564                               <NA>   Central Pacific Standard Time
## 565                               <NA>                          UTC+12
## 566                               <NA>                          UTC+12
## 567                               <NA>         Marquesas Standard Time
## 568                               <NA>                          UTC-11
## 569                               <NA>                          UTC+12
## 570                               <NA>                          UTC-11
## 571       Norfolk Island Daylight Time           Norfolk Standard Time
## 572                               <NA>   Central Pacific Standard Time
## 573                               <NA>                          UTC-11
## 574                               <NA>             Tokyo Standard Time
## 575                               <NA>                          UTC-08
## 576                               <NA>   Central Pacific Standard Time
## 577                               <NA>   Central Pacific Standard Time
## 578                               <NA>      West Pacific Standard Time
## 579                               <NA>          Hawaiian Standard Time
## 580                               <NA>      West Pacific Standard Time
## 581                               <NA>                          UTC-11
## 582                               <NA>          Hawaiian Standard Time
## 583                               <NA>                          UTC+12
## 584                               <NA>             Tonga Standard Time
## 585                               <NA>      West Pacific Standard Time
## 586                               <NA>                          UTC+12
## 587                               <NA>                          UTC+12
## 588                               <NA>      West Pacific Standard Time
## 589                               <NA>          Pakistan Standard Time
## 590                               <NA>       US Mountain Standard Time
## 591       Central European Summer Time  Central European Standard Time
## 592       Western European Summer Time               GMT Standard Time
## 593                               <NA>             China Standard Time
## 594                               <NA>        SA Western Standard Time
## 595              Pacific Daylight Time           Pacific Standard Time
## 596              Pacific Daylight Time           Pacific Standard Time
## 597                               <NA>            Taipei Standard Time
## 598                               <NA>             Korea Standard Time
## 599                               <NA>         Singapore Standard Time
## 600                               <NA>   Central Pacific Standard Time
## 601                               <NA>                            <NA>
## 602                          GMT-03:00                            <NA>
## 603                               <NA>                            <NA>
## 604                          GMT-05:00                            <NA>
## 605                               <NA>                            <NA>
## 606                          GMT-04:00                            <NA>
## 607                               <NA>                            <NA>
## 608                               <NA>                            <NA>
## 609                          GMT-06:00                            <NA>
## 610                               <NA>                            <NA>
## 611                          GMT-07:00                            <NA>
## 612                               <NA>                            <NA>
## 613                          GMT-08:00                            <NA>
## 614                               <NA>            Turkey Standard Time
## 615                               <NA>                             UTC
## 616                               <NA>                             UTC
## 617               Alaska Daylight Time           Alaskan Standard Time
## 618      Hawaii-Aleutian Daylight Time          Aleutian Standard Time
## 619                               <NA>       US Mountain Standard Time
## 620              Central Daylight Time           Central Standard Time
## 621              Eastern Daylight Time        US Eastern Standard Time
## 622              Eastern Daylight Time           Eastern Standard Time
## 623                               <NA>          Hawaiian Standard Time
## 624              Central Daylight Time           Central Standard Time
## 625              Eastern Daylight Time           Eastern Standard Time
## 626             Mountain Daylight Time          Mountain Standard Time
## 627              Pacific Daylight Time           Pacific Standard Time
## 628              Pacific Daylight Time           Pacific Standard Time
## 629                               <NA>                          UTC-11
## 630                               <NA>                             UTC
## 631                               <NA>           SE Asia Standard Time
## 632                               <NA>           Russian Standard Time
## 633                          GMT+01:00                            <NA>
## 634                               <NA>                             UTC
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
## 16       2.00            FALSE
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
## 81      -6.00             TRUE
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
## 98      -7.00             TRUE
## 99      -5.00            FALSE
## 100     -3.00            FALSE
## 101     -6.00            FALSE
## 102     -7.00            FALSE
## 103     -4.00            FALSE
## 104     -4.00            FALSE
## 105      0.00            FALSE
## 106     -7.00            FALSE
## 107     -7.00            FALSE
## 108     -7.00             TRUE
## 109     -5.00             TRUE
## 110     -4.00            FALSE
## 111     -7.00             TRUE
## 112     -5.00            FALSE
## 113     -6.00            FALSE
## 114     -8.00             TRUE
## 115     -7.00            FALSE
## 116     -5.00             TRUE
## 117     -3.00            FALSE
## 118     -4.00             TRUE
## 119     -3.00             TRUE
## 120     -4.00             TRUE
## 121     -5.00             TRUE
## 122     -4.00            FALSE
## 123     -4.00            FALSE
## 124     -6.00            FALSE
## 125     -5.00            FALSE
## 126     -4.00            FALSE
## 127     -4.00             TRUE
## 128     -5.00             TRUE
## 129     -7.00            FALSE
## 130     -5.00             TRUE
## 131     -6.00             TRUE
## 132     -5.00             TRUE
## 133     -5.00             TRUE
## 134     -6.00             TRUE
## 135     -5.00             TRUE
## 136     -5.00             TRUE
## 137     -5.00             TRUE
## 138     -5.00             TRUE
## 139     -7.00             TRUE
## 140     -5.00             TRUE
## 141     -5.00            FALSE
## 142     -3.00            FALSE
## 143     -9.00             TRUE
## 144     -5.00             TRUE
## 145     -5.00             TRUE
## 146     -6.00             TRUE
## 147     -4.00            FALSE
## 148     -4.00            FALSE
## 149     -5.00            FALSE
## 150     -8.00             TRUE
## 151     -5.00             TRUE
## 152     -4.00            FALSE
## 153     -3.00            FALSE
## 154     -6.00            FALSE
## 155     -4.00            FALSE
## 156     -4.00            FALSE
## 157     -4.00            FALSE
## 158     -6.00             TRUE
## 159     -7.00             TRUE
## 160     -3.00            FALSE
## 161     -6.00             TRUE
## 162     -6.00             TRUE
## 163     -9.00             TRUE
## 164     -6.00             TRUE
## 165     -3.00             TRUE
## 166     -4.00             TRUE
## 167     -6.00             TRUE
## 168     -3.00            FALSE
## 169     -5.00             TRUE
## 170     -4.00            FALSE
## 171     -5.00             TRUE
## 172     -5.00             TRUE
## 173     -5.00             TRUE
## 174     -9.00             TRUE
## 175     -2.00            FALSE
## 176     -6.00             TRUE
## 177     -6.00             TRUE
## 178     -6.00             TRUE
## 179     -3.00             TRUE
## 180     -7.00             TRUE
## 181     -5.00            FALSE
## 182     -5.00             TRUE
## 183     -3.00            FALSE
## 184     -7.00            FALSE
## 185     -4.00            FALSE
## 186     -5.00             TRUE
## 187     -5.00            FALSE
## 188     -4.00            FALSE
## 189     -4.00            FALSE
## 190     -3.00            FALSE
## 191     -6.00             TRUE
## 192     -6.00             TRUE
## 193     -3.00            FALSE
## 194     -6.00            FALSE
## 195     -6.00             TRUE
## 196     -5.00            FALSE
## 197     -3.00            FALSE
## 198     -8.00             TRUE
## 199     -3.00            FALSE
## 200     -4.00             TRUE
## 201     -4.00            FALSE
## 202     -3.00            FALSE
## 203     -1.00             TRUE
## 204     -7.00             TRUE
## 205     -9.00             TRUE
## 206     -4.00            FALSE
## 207     -3.50             TRUE
## 208     -4.00            FALSE
## 209     -4.00            FALSE
## 210     -4.00            FALSE
## 211     -4.00            FALSE
## 212     -6.00            FALSE
## 213     -6.00            FALSE
## 214     -4.00             TRUE
## 215     -5.00             TRUE
## 216     -8.00             TRUE
## 217     -5.00             TRUE
## 218     -4.00            FALSE
## 219     -8.00             TRUE
## 220     -4.00            FALSE
## 221     -7.00            FALSE
## 222     -6.00             TRUE
## 223     -9.00             TRUE
## 224     -7.00             TRUE
## 225     11.00            FALSE
## 226      7.00            FALSE
## 227     10.00            FALSE
## 228     10.00             TRUE
## 229      5.00            FALSE
## 230     12.00             TRUE
## 231     -3.00            FALSE
## 232     -3.00            FALSE
## 233     12.00             TRUE
## 234      3.00            FALSE
## 235      0.00             TRUE
## 236      6.00            FALSE
## 237      1.00             TRUE
## 238      2.00            FALSE
## 239      3.00            FALSE
## 240      6.00            FALSE
## 241      2.00             TRUE
## 242     12.00            FALSE
## 243      5.00            FALSE
## 244      5.00            FALSE
## 245      5.00            FALSE
## 246      5.00            FALSE
## 247      5.00            FALSE
## 248      3.00            FALSE
## 249      3.00            FALSE
## 250      4.00            FALSE
## 251      7.00            FALSE
## 252      7.00            FALSE
## 253      2.00             TRUE
## 254      6.00            FALSE
## 255      8.00            FALSE
## 256      5.50            FALSE
## 257      9.00            FALSE
## 258      8.00            FALSE
## 259      8.00            FALSE
## 260      8.00            FALSE
## 261      5.50            FALSE
## 262      6.00            FALSE
## 263      2.00             TRUE
## 264      6.00            FALSE
## 265      9.00            FALSE
## 266      4.00            FALSE
## 267      5.00            FALSE
## 268      2.00             TRUE
## 269      2.00             TRUE
## 270      8.00            FALSE
## 271      2.00             TRUE
## 272      7.00            FALSE
## 273      8.00            FALSE
## 274      7.00            FALSE
## 275      8.00            FALSE
## 276      3.00            FALSE
## 277      7.00            FALSE
## 278      9.00            FALSE
## 279      2.00             TRUE
## 280      4.50            FALSE
## 281     12.00            FALSE
## 282      5.00            FALSE
## 283      6.00            FALSE
## 284      5.75            FALSE
## 285      5.75            FALSE
## 286      9.00            FALSE
## 287      5.50            FALSE
## 288      7.00            FALSE
## 289      8.00            FALSE
## 290      8.00            FALSE
## 291      3.00            FALSE
## 292      8.00            FALSE
## 293      8.00            FALSE
## 294     11.00            FALSE
## 295      8.00            FALSE
## 296      8.00            FALSE
## 297      4.00            FALSE
## 298      2.00             TRUE
## 299      7.00            FALSE
## 300      7.00            FALSE
## 301      6.00            FALSE
## 302      5.00            FALSE
## 303      7.00            FALSE
## 304      7.00            FALSE
## 305      9.00            FALSE
## 306      3.00            FALSE
## 307      6.00            FALSE
## 308      5.00            FALSE
## 309      6.50            FALSE
## 310      3.00            FALSE
## 311      7.00            FALSE
## 312     11.00            FALSE
## 313      5.00            FALSE
## 314      9.00            FALSE
## 315      8.00            FALSE
## 316      8.00            FALSE
## 317     11.00            FALSE
## 318      8.00            FALSE
## 319      5.00            FALSE
## 320      4.00            FALSE
## 321      3.50             TRUE
## 322      2.00             TRUE
## 323      6.00            FALSE
## 324      6.00            FALSE
## 325      9.00            FALSE
## 326      7.00            FALSE
## 327      8.00            FALSE
## 328      8.00            FALSE
## 329      8.00            FALSE
## 330      6.00            FALSE
## 331     10.00            FALSE
## 332      7.00            FALSE
## 333     10.00            FALSE
## 334      9.00            FALSE
## 335      6.50            FALSE
## 336      5.00            FALSE
## 337      4.00            FALSE
## 338     -9.00             TRUE
## 339     -1.00             TRUE
## 340     -4.00             TRUE
## 341      0.00             TRUE
## 342     -1.00            FALSE
## 343      0.00             TRUE
## 344      0.00             TRUE
## 345      1.00             TRUE
## 346      0.00             TRUE
## 347      0.00            FALSE
## 348     -2.00            FALSE
## 349      0.00            FALSE
## 350     -3.00            FALSE
## 351     10.00             TRUE
## 352      9.50             TRUE
## 353     10.00            FALSE
## 354      9.50             TRUE
## 355     10.00             TRUE
## 356     10.00             TRUE
## 357      9.50            FALSE
## 358      8.75            FALSE
## 359     10.00             TRUE
## 360     10.50             TRUE
## 361     10.00            FALSE
## 362     10.50             TRUE
## 363     10.00             TRUE
## 364      9.50            FALSE
## 365     10.00             TRUE
## 366      8.00            FALSE
## 367     10.00            FALSE
## 368      9.50             TRUE
## 369     10.00             TRUE
## 370     10.00             TRUE
## 371     10.00             TRUE
## 372      8.00            FALSE
## 373      9.50             TRUE
## 374     -3.00            FALSE
## 375     -5.00            FALSE
## 376     -2.00            FALSE
## 377     -3.00            FALSE
## 378     -4.00            FALSE
## 379      6.00            FALSE
## 380     -4.00             TRUE
## 381     -6.00             TRUE
## 382     -6.00            FALSE
## 383     -5.00             TRUE
## 384     -7.00             TRUE
## 385     -3.50             TRUE
## 386     -8.00             TRUE
## 387     -6.00            FALSE
## 388     -7.00            FALSE
## 389      2.00            FALSE
## 390      1.00             TRUE
## 391     -4.00             TRUE
## 392     -6.00             TRUE
## 393     -3.50             TRUE
## 394     -6.00             TRUE
## 395     -6.00             TRUE
## 396      8.00            FALSE
## 397     -5.00             TRUE
## 398      3.00            FALSE
## 399      1.00             TRUE
## 400      2.00             TRUE
## 401      2.00            FALSE
## 402      0.00             TRUE
## 403     -5.00            FALSE
## 404     -5.00             TRUE
## 405      0.00            FALSE
## 406      0.00            FALSE
## 407      1.00            FALSE
## 408      2.00            FALSE
## 409      3.00            FALSE
## 410      4.00            FALSE
## 411      5.00            FALSE
## 412      6.00            FALSE
## 413      7.00            FALSE
## 414      8.00            FALSE
## 415      9.00            FALSE
## 416     10.00            FALSE
## 417     11.00            FALSE
## 418     12.00            FALSE
## 419     13.00            FALSE
## 420     14.00            FALSE
## 421      0.00            FALSE
## 422     -1.00            FALSE
## 423     -2.00            FALSE
## 424     -3.00            FALSE
## 425     -4.00            FALSE
## 426     -5.00            FALSE
## 427     -6.00            FALSE
## 428     -7.00            FALSE
## 429     -8.00            FALSE
## 430     -9.00            FALSE
## 431    -10.00            FALSE
## 432    -11.00            FALSE
## 433    -12.00            FALSE
## 434      0.00            FALSE
## 435      0.00            FALSE
## 436      0.00            FALSE
## 437      0.00            FALSE
## 438      0.00            FALSE
## 439      0.00            FALSE
## 440      1.00             TRUE
## 441      1.00             TRUE
## 442      4.00            FALSE
## 443      2.00             TRUE
## 444      0.00             TRUE
## 445      1.00             TRUE
## 446      1.00             TRUE
## 447      1.00             TRUE
## 448      1.00             TRUE
## 449      2.00             TRUE
## 450      1.00             TRUE
## 451      1.00             TRUE
## 452      2.00             TRUE
## 453      1.00             TRUE
## 454      0.00             TRUE
## 455      1.00             TRUE
## 456      0.00             TRUE
## 457      2.00             TRUE
## 458      0.00             TRUE
## 459      3.00            FALSE
## 460      0.00             TRUE
## 461      2.00            FALSE
## 462      2.00             TRUE
## 463      3.00            FALSE
## 464      0.00             TRUE
## 465      1.00             TRUE
## 466      0.00             TRUE
## 467      1.00             TRUE
## 468      1.00             TRUE
## 469      1.00             TRUE
## 470      2.00             TRUE
## 471      3.00            FALSE
## 472      1.00             TRUE
## 473      3.00            FALSE
## 474      2.00             TRUE
## 475      1.00             TRUE
## 476      1.00             TRUE
## 477      1.00             TRUE
## 478      1.00             TRUE
## 479      2.00             TRUE
## 480      1.00             TRUE
## 481      4.00            FALSE
## 482      1.00             TRUE
## 483      1.00             TRUE
## 484      4.00            FALSE
## 485      3.00            FALSE
## 486      1.00             TRUE
## 487      2.00             TRUE
## 488      1.00             TRUE
## 489      2.00             TRUE
## 490      1.00             TRUE
## 491      2.00             TRUE
## 492      4.00            FALSE
## 493      2.00             TRUE
## 494      1.00             TRUE
## 495      1.00             TRUE
## 496      1.00             TRUE
## 497      2.00             TRUE
## 498      3.00            FALSE
## 499      1.00             TRUE
## 500      1.00             TRUE
## 501      2.00             TRUE
## 502      1.00             TRUE
## 503      0.00            FALSE
## 504      0.00             TRUE
## 505      0.00             TRUE
## 506      0.00            FALSE
## 507      0.00            FALSE
## 508      0.00            FALSE
## 509      0.00            FALSE
## 510      0.00            FALSE
## 511      8.00            FALSE
## 512    -10.00            FALSE
## 513      0.00            FALSE
## 514     -5.00             TRUE
## 515      3.00            FALSE
## 516      6.00            FALSE
## 517      7.00            FALSE
## 518      6.50            FALSE
## 519      3.00            FALSE
## 520      5.00            FALSE
## 521      4.00            FALSE
## 522      5.00            FALSE
## 523      4.00            FALSE
## 524      3.00            FALSE
## 525      4.00            FALSE
## 526      3.50             TRUE
## 527      2.00             TRUE
## 528      5.50            FALSE
## 529     -5.00            FALSE
## 530      9.00            FALSE
## 531      9.00            FALSE
## 532     12.00            FALSE
## 533      2.00            FALSE
## 534      1.00             TRUE
## 535     -8.00             TRUE
## 536     -7.00             TRUE
## 537     -6.00             TRUE
## 538     13.00             TRUE
## 539     -7.00            FALSE
## 540     -7.00             TRUE
## 541     -7.00             TRUE
## 542      4.00            FALSE
## 543     12.00             TRUE
## 544     12.00             TRUE
## 545     12.75             TRUE
## 546     13.00             TRUE
## 547     12.00             TRUE
## 548     11.00            FALSE
## 549     12.75             TRUE
## 550     10.00            FALSE
## 551     -6.00             TRUE
## 552     11.00            FALSE
## 553     13.00            FALSE
## 554     13.00            FALSE
## 555     12.00             TRUE
## 556     12.00            FALSE
## 557     -6.00            FALSE
## 558     -9.00            FALSE
## 559     11.00            FALSE
## 560     10.00            FALSE
## 561    -10.00            FALSE
## 562    -10.00            FALSE
## 563     14.00            FALSE
## 564     11.00            FALSE
## 565     12.00            FALSE
## 566     12.00            FALSE
## 567     -9.50            FALSE
## 568    -11.00            FALSE
## 569     12.00            FALSE
## 570    -11.00            FALSE
## 571     11.00             TRUE
## 572     11.00            FALSE
## 573    -11.00            FALSE
## 574      9.00            FALSE
## 575     -8.00            FALSE
## 576     11.00            FALSE
## 577     11.00            FALSE
## 578     10.00            FALSE
## 579    -10.00            FALSE
## 580     10.00            FALSE
## 581    -11.00            FALSE
## 582    -10.00            FALSE
## 583     12.00            FALSE
## 584     13.00            FALSE
## 585     10.00            FALSE
## 586     12.00            FALSE
## 587     12.00            FALSE
## 588     10.00            FALSE
## 589      5.00            FALSE
## 590     -7.00            FALSE
## 591      1.00             TRUE
## 592      0.00             TRUE
## 593      8.00            FALSE
## 594     -4.00            FALSE
## 595     -8.00             TRUE
## 596     -8.00             TRUE
## 597      8.00            FALSE
## 598      9.00            FALSE
## 599      8.00            FALSE
## 600     11.00            FALSE
## 601     -4.00            FALSE
## 602     -4.00             TRUE
## 603     -6.00            FALSE
## 604     -6.00             TRUE
## 605     -5.00            FALSE
## 606     -5.00             TRUE
## 607    -10.00            FALSE
## 608     -7.00            FALSE
## 609     -7.00             TRUE
## 610     -8.00            FALSE
## 611     -8.00             TRUE
## 612     -9.00            FALSE
## 613     -9.00             TRUE
## 614      3.00            FALSE
## 615      0.00            FALSE
## 616      0.00            FALSE
## 617     -9.00             TRUE
## 618    -10.00             TRUE
## 619     -7.00            FALSE
## 620     -6.00             TRUE
## 621     -5.00             TRUE
## 622     -5.00             TRUE
## 623    -10.00            FALSE
## 624     -6.00             TRUE
## 625     -5.00             TRUE
## 626     -7.00             TRUE
## 627     -8.00             TRUE
## 628     -8.00             TRUE
## 629    -11.00            FALSE
## 630      0.00            FALSE
## 631      7.00            FALSE
## 632      3.00            FALSE
## 633      0.00             TRUE
## 634      0.00            FALSE
```
