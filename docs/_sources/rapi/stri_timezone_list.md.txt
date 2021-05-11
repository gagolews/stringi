# stri\_timezone\_list: List Available Time Zone Identifiers

## Description

Returns a list of available time zone identifiers.

## Usage

```r
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

## References

*TimeZone* class -- ICU API Documentation, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1TimeZone.html>

*ICU 4.8 Time Zone Names*. <http://site.icu-project.org/design/formatting/timezone/icu-4-8-time-zone-names>

*ICU TimeZone classes* -- ICU User Guide, <http://userguide.icu-project.org/datetime/timezone>

*Date/Time Services* -- ICU User Guide, <http://userguide.icu-project.org/datetime>

## See Also

Other datetime: [`stri_datetime_add()`,](stri_datetime_add.md) [`stri_datetime_create()`,](stri_datetime_create.md) [`stri_datetime_fields()`,](stri_datetime_fields.md) [`stri_datetime_format()`,](stri_datetime_format.md) [`stri_datetime_fstr()`,](stri_datetime_fstr.md) [`stri_datetime_now()`,](stri_datetime_now.md) [`stri_datetime_symbols()`,](stri_datetime_symbols.md) [`stri_timezone_get()`,](stri_timezone_set.md) `stri_timezone_info()`

Other timezone: [`stri_timezone_get()`,](stri_timezone_set.md) `stri_timezone_info()`

## Examples




```r
stri_timezone_list()
##   [1] "ACT"                              "AET"                             
##   [3] "AGT"                              "ART"                             
##   [5] "AST"                              "Africa/Abidjan"                  
##   [7] "Africa/Accra"                     "Africa/Addis_Ababa"              
##   [9] "Africa/Algiers"                   "Africa/Asmara"                   
##  [11] "Africa/Asmera"                    "Africa/Bamako"                   
##  [13] "Africa/Bangui"                    "Africa/Banjul"                   
##  [15] "Africa/Bissau"                    "Africa/Blantyre"                 
##  [17] "Africa/Brazzaville"               "Africa/Bujumbura"                
##  [19] "Africa/Cairo"                     "Africa/Casablanca"               
##  [21] "Africa/Ceuta"                     "Africa/Conakry"                  
##  [23] "Africa/Dakar"                     "Africa/Dar_es_Salaam"            
##  [25] "Africa/Djibouti"                  "Africa/Douala"                   
##  [27] "Africa/El_Aaiun"                  "Africa/Freetown"                 
##  [29] "Africa/Gaborone"                  "Africa/Harare"                   
##  [31] "Africa/Johannesburg"              "Africa/Juba"                     
##  [33] "Africa/Kampala"                   "Africa/Khartoum"                 
##  [35] "Africa/Kigali"                    "Africa/Kinshasa"                 
##  [37] "Africa/Lagos"                     "Africa/Libreville"               
##  [39] "Africa/Lome"                      "Africa/Luanda"                   
##  [41] "Africa/Lubumbashi"                "Africa/Lusaka"                   
##  [43] "Africa/Malabo"                    "Africa/Maputo"                   
##  [45] "Africa/Maseru"                    "Africa/Mbabane"                  
##  [47] "Africa/Mogadishu"                 "Africa/Monrovia"                 
##  [49] "Africa/Nairobi"                   "Africa/Ndjamena"                 
##  [51] "Africa/Niamey"                    "Africa/Nouakchott"               
##  [53] "Africa/Ouagadougou"               "Africa/Porto-Novo"               
##  [55] "Africa/Sao_Tome"                  "Africa/Timbuktu"                 
##  [57] "Africa/Tripoli"                   "Africa/Tunis"                    
##  [59] "Africa/Windhoek"                  "America/Adak"                    
##  [61] "America/Anchorage"                "America/Anguilla"                
##  [63] "America/Antigua"                  "America/Araguaina"               
##  [65] "America/Argentina/Buenos_Aires"   "America/Argentina/Catamarca"     
##  [67] "America/Argentina/ComodRivadavia" "America/Argentina/Cordoba"       
##  [69] "America/Argentina/Jujuy"          "America/Argentina/La_Rioja"      
##  [71] "America/Argentina/Mendoza"        "America/Argentina/Rio_Gallegos"  
##  [73] "America/Argentina/Salta"          "America/Argentina/San_Juan"      
##  [75] "America/Argentina/San_Luis"       "America/Argentina/Tucuman"       
##  [77] "America/Argentina/Ushuaia"        "America/Aruba"                   
##  [79] "America/Asuncion"                 "America/Atikokan"                
##  [81] "America/Atka"                     "America/Bahia"                   
##  [83] "America/Bahia_Banderas"           "America/Barbados"                
##  [85] "America/Belem"                    "America/Belize"                  
##  [87] "America/Blanc-Sablon"             "America/Boa_Vista"               
##  [89] "America/Bogota"                   "America/Boise"                   
##  [91] "America/Buenos_Aires"             "America/Cambridge_Bay"           
##  [93] "America/Campo_Grande"             "America/Cancun"                  
##  [95] "America/Caracas"                  "America/Catamarca"               
##  [97] "America/Cayenne"                  "America/Cayman"                  
##  [99] "America/Chicago"                  "America/Chihuahua"               
## [101] "America/Coral_Harbour"            "America/Cordoba"                 
## [103] "America/Costa_Rica"               "America/Creston"                 
## [105] "America/Cuiaba"                   "America/Curacao"                 
## [107] "America/Danmarkshavn"             "America/Dawson"                  
## [109] "America/Dawson_Creek"             "America/Denver"                  
## [111] "America/Detroit"                  "America/Dominica"                
## [113] "America/Edmonton"                 "America/Eirunepe"                
## [115] "America/El_Salvador"              "America/Ensenada"                
## [117] "America/Fort_Nelson"              "America/Fort_Wayne"              
## [119] "America/Fortaleza"                "America/Glace_Bay"               
## [121] "America/Godthab"                  "America/Goose_Bay"               
## [123] "America/Grand_Turk"               "America/Grenada"                 
## [125] "America/Guadeloupe"               "America/Guatemala"               
## [127] "America/Guayaquil"                "America/Guyana"                  
## [129] "America/Halifax"                  "America/Havana"                  
## [131] "America/Hermosillo"               "America/Indiana/Indianapolis"    
## [133] "America/Indiana/Knox"             "America/Indiana/Marengo"         
## [135] "America/Indiana/Petersburg"       "America/Indiana/Tell_City"       
## [137] "America/Indiana/Vevay"            "America/Indiana/Vincennes"       
## [139] "America/Indiana/Winamac"          "America/Indianapolis"            
## [141] "America/Inuvik"                   "America/Iqaluit"                 
## [143] "America/Jamaica"                  "America/Jujuy"                   
## [145] "America/Juneau"                   "America/Kentucky/Louisville"     
## [147] "America/Kentucky/Monticello"      "America/Knox_IN"                 
## [149] "America/Kralendijk"               "America/La_Paz"                  
## [151] "America/Lima"                     "America/Los_Angeles"             
## [153] "America/Louisville"               "America/Lower_Princes"           
## [155] "America/Maceio"                   "America/Managua"                 
## [157] "America/Manaus"                   "America/Marigot"                 
## [159] "America/Martinique"               "America/Matamoros"               
## [161] "America/Mazatlan"                 "America/Mendoza"                 
## [163] "America/Menominee"                "America/Merida"                  
## [165] "America/Metlakatla"               "America/Mexico_City"             
## [167] "America/Miquelon"                 "America/Moncton"                 
## [169] "America/Monterrey"                "America/Montevideo"              
## [171] "America/Montreal"                 "America/Montserrat"              
## [173] "America/Nassau"                   "America/New_York"                
## [175] "America/Nipigon"                  "America/Nome"                    
## [177] "America/Noronha"                  "America/North_Dakota/Beulah"     
## [179] "America/North_Dakota/Center"      "America/North_Dakota/New_Salem"  
## [181] "America/Nuuk"                     "America/Ojinaga"                 
## [183] "America/Panama"                   "America/Pangnirtung"             
## [185] "America/Paramaribo"               "America/Phoenix"                 
## [187] "America/Port-au-Prince"           "America/Port_of_Spain"           
## [189] "America/Porto_Acre"               "America/Porto_Velho"             
## [191] "America/Puerto_Rico"              "America/Punta_Arenas"            
## [193] "America/Rainy_River"              "America/Rankin_Inlet"            
## [195] "America/Recife"                   "America/Regina"                  
## [197] "America/Resolute"                 "America/Rio_Branco"              
## [199] "America/Rosario"                  "America/Santa_Isabel"            
## [201] "America/Santarem"                 "America/Santiago"                
## [203] "America/Santo_Domingo"            "America/Sao_Paulo"               
## [205] "America/Scoresbysund"             "America/Shiprock"                
## [207] "America/Sitka"                    "America/St_Barthelemy"           
## [209] "America/St_Johns"                 "America/St_Kitts"                
## [211] "America/St_Lucia"                 "America/St_Thomas"               
## [213] "America/St_Vincent"               "America/Swift_Current"           
## [215] "America/Tegucigalpa"              "America/Thule"                   
## [217] "America/Thunder_Bay"              "America/Tijuana"                 
## [219] "America/Toronto"                  "America/Tortola"                 
## [221] "America/Vancouver"                "America/Virgin"                  
## [223] "America/Whitehorse"               "America/Winnipeg"                
## [225] "America/Yakutat"                  "America/Yellowknife"             
## [227] "Antarctica/Casey"                 "Antarctica/Davis"                
## [229] "Antarctica/DumontDUrville"        "Antarctica/Macquarie"            
## [231] "Antarctica/Mawson"                "Antarctica/McMurdo"              
## [233] "Antarctica/Palmer"                "Antarctica/Rothera"              
## [235] "Antarctica/South_Pole"            "Antarctica/Syowa"                
## [237] "Antarctica/Troll"                 "Antarctica/Vostok"               
## [239] "Arctic/Longyearbyen"              "Asia/Aden"                       
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
## [363] "Australia/Melbourne"              "Australia/NSW"                   
## [365] "Australia/North"                  "Australia/Perth"                 
## [367] "Australia/Queensland"             "Australia/South"                 
## [369] "Australia/Sydney"                 "Australia/Tasmania"              
## [371] "Australia/Victoria"               "Australia/West"                  
## [373] "Australia/Yancowinna"             "BET"                             
## [375] "BST"                              "Brazil/Acre"                     
## [377] "Brazil/DeNoronha"                 "Brazil/East"                     
## [379] "Brazil/West"                      "CAT"                             
## [381] "CET"                              "CNT"                             
## [383] "CST"                              "CST6CDT"                         
## [385] "CTT"                              "Canada/Atlantic"                 
## [387] "Canada/Central"                   "Canada/East-Saskatchewan"        
## [389] "Canada/Eastern"                   "Canada/Mountain"                 
## [391] "Canada/Newfoundland"              "Canada/Pacific"                  
## [393] "Canada/Saskatchewan"              "Canada/Yukon"                    
## [395] "Chile/Continental"                "Chile/EasterIsland"              
## [397] "Cuba"                             "EAT"                             
## [399] "ECT"                              "EET"                             
## [401] "EST"                              "EST5EDT"                         
## [403] "Egypt"                            "Eire"                            
## [405] "Etc/GMT"                          "Etc/GMT+0"                       
## [407] "Etc/GMT+1"                        "Etc/GMT+10"                      
## [409] "Etc/GMT+11"                       "Etc/GMT+12"                      
## [411] "Etc/GMT+2"                        "Etc/GMT+3"                       
## [413] "Etc/GMT+4"                        "Etc/GMT+5"                       
## [415] "Etc/GMT+6"                        "Etc/GMT+7"                       
## [417] "Etc/GMT+8"                        "Etc/GMT+9"                       
## [419] "Etc/GMT-0"                        "Etc/GMT-1"                       
## [421] "Etc/GMT-10"                       "Etc/GMT-11"                      
## [423] "Etc/GMT-12"                       "Etc/GMT-13"                      
## [425] "Etc/GMT-14"                       "Etc/GMT-2"                       
## [427] "Etc/GMT-3"                        "Etc/GMT-4"                       
## [429] "Etc/GMT-5"                        "Etc/GMT-6"                       
## [431] "Etc/GMT-7"                        "Etc/GMT-8"                       
## [433] "Etc/GMT-9"                        "Etc/GMT0"                        
## [435] "Etc/Greenwich"                    "Etc/UCT"                         
## [437] "Etc/UTC"                          "Etc/Universal"                   
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
## [507] "GMT+0"                            "GMT-0"                           
## [509] "GMT0"                             "Greenwich"                       
## [511] "HST"                              "Hongkong"                        
## [513] "IET"                              "IST"                             
## [515] "Iceland"                          "Indian/Antananarivo"             
## [517] "Indian/Chagos"                    "Indian/Christmas"                
## [519] "Indian/Cocos"                     "Indian/Comoro"                   
## [521] "Indian/Kerguelen"                 "Indian/Mahe"                     
## [523] "Indian/Maldives"                  "Indian/Mauritius"                
## [525] "Indian/Mayotte"                   "Indian/Reunion"                  
## [527] "Iran"                             "Israel"                          
## [529] "JST"                              "Jamaica"                         
## [531] "Japan"                            "Kwajalein"                       
## [533] "Libya"                            "MET"                             
## [535] "MIT"                              "MST"                             
## [537] "MST7MDT"                          "Mexico/BajaNorte"                
## [539] "Mexico/BajaSur"                   "Mexico/General"                  
## [541] "NET"                              "NST"                             
## [543] "NZ"                               "NZ-CHAT"                         
## [545] "Navajo"                           "PLT"                             
## [547] "PNT"                              "PRC"                             
## [549] "PRT"                              "PST"                             
## [551] "PST8PDT"                          "Pacific/Apia"                    
## [553] "Pacific/Auckland"                 "Pacific/Bougainville"            
## [555] "Pacific/Chatham"                  "Pacific/Chuuk"                   
## [557] "Pacific/Easter"                   "Pacific/Efate"                   
## [559] "Pacific/Enderbury"                "Pacific/Fakaofo"                 
## [561] "Pacific/Fiji"                     "Pacific/Funafuti"                
## [563] "Pacific/Galapagos"                "Pacific/Gambier"                 
## [565] "Pacific/Guadalcanal"              "Pacific/Guam"                    
## [567] "Pacific/Honolulu"                 "Pacific/Johnston"                
## [569] "Pacific/Kiritimati"               "Pacific/Kosrae"                  
## [571] "Pacific/Kwajalein"                "Pacific/Majuro"                  
## [573] "Pacific/Marquesas"                "Pacific/Midway"                  
## [575] "Pacific/Nauru"                    "Pacific/Niue"                    
## [577] "Pacific/Norfolk"                  "Pacific/Noumea"                  
## [579] "Pacific/Pago_Pago"                "Pacific/Palau"                   
## [581] "Pacific/Pitcairn"                 "Pacific/Pohnpei"                 
## [583] "Pacific/Ponape"                   "Pacific/Port_Moresby"            
## [585] "Pacific/Rarotonga"                "Pacific/Saipan"                  
## [587] "Pacific/Samoa"                    "Pacific/Tahiti"                  
## [589] "Pacific/Tarawa"                   "Pacific/Tongatapu"               
## [591] "Pacific/Truk"                     "Pacific/Wake"                    
## [593] "Pacific/Wallis"                   "Pacific/Yap"                     
## [595] "Poland"                           "Portugal"                        
## [597] "ROC"                              "ROK"                             
## [599] "SST"                              "Singapore"                       
## [601] "SystemV/AST4"                     "SystemV/AST4ADT"                 
## [603] "SystemV/CST6"                     "SystemV/CST6CDT"                 
## [605] "SystemV/EST5"                     "SystemV/EST5EDT"                 
## [607] "SystemV/HST10"                    "SystemV/MST7"                    
## [609] "SystemV/MST7MDT"                  "SystemV/PST8"                    
## [611] "SystemV/PST8PDT"                  "SystemV/YST9"                    
## [613] "SystemV/YST9YDT"                  "Turkey"                          
## [615] "UCT"                              "US/Alaska"                       
## [617] "US/Aleutian"                      "US/Arizona"                      
## [619] "US/Central"                       "US/East-Indiana"                 
## [621] "US/Eastern"                       "US/Hawaii"                       
## [623] "US/Indiana-Starke"                "US/Michigan"                     
## [625] "US/Mountain"                      "US/Pacific"                      
## [627] "US/Pacific-New"                   "US/Samoa"                        
## [629] "UTC"                              "Universal"                       
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
# Fetch info on all time zones
do.call(rbind.data.frame,
   lapply(stri_timezone_list(), function(tz) stri_timezone_info(tz)))
##                                    ID                                     Name
## 2                                 ACT         Australian Central Standard Time
## 2100                              AET         Australian Eastern Standard Time
## 3                                 AGT                  Argentina Standard Time
## 4                                 ART           Eastern European Standard Time
## 5                                 AST                     Alaska Standard Time
## 6                      Africa/Abidjan                      Greenwich Mean Time
## 7                        Africa/Accra                      Greenwich Mean Time
## 8                  Africa/Addis_Ababa                      Eastern Africa Time
## 9                      Africa/Algiers           Central European Standard Time
## 10                      Africa/Asmara                      Eastern Africa Time
## 11                      Africa/Asmera                      Eastern Africa Time
## 12                      Africa/Bamako                      Greenwich Mean Time
## 13                      Africa/Bangui                West Africa Standard Time
## 14                      Africa/Banjul                      Greenwich Mean Time
## 15                      Africa/Bissau                      Greenwich Mean Time
## 16                    Africa/Blantyre                      Central Africa Time
## 17                 Africa/Brazzaville                West Africa Standard Time
## 18                   Africa/Bujumbura                      Central Africa Time
## 19                       Africa/Cairo           Eastern European Standard Time
## 20                  Africa/Casablanca                                      GMT
## 21                       Africa/Ceuta           Central European Standard Time
## 22                     Africa/Conakry                      Greenwich Mean Time
## 23                       Africa/Dakar                      Greenwich Mean Time
## 24               Africa/Dar_es_Salaam                      Eastern Africa Time
## 25                    Africa/Djibouti                      Eastern Africa Time
## 26                      Africa/Douala                West Africa Standard Time
## 27                    Africa/El_Aaiun                                      GMT
## 28                    Africa/Freetown                      Greenwich Mean Time
## 29                    Africa/Gaborone                      Central Africa Time
## 30                      Africa/Harare                      Central Africa Time
## 31                Africa/Johannesburg               South Africa Standard Time
## 32                        Africa/Juba                      Central Africa Time
## 33                     Africa/Kampala                      Eastern Africa Time
## 34                    Africa/Khartoum                      Central Africa Time
## 35                      Africa/Kigali                      Central Africa Time
## 36                    Africa/Kinshasa                West Africa Standard Time
## 37                       Africa/Lagos                West Africa Standard Time
## 38                  Africa/Libreville                West Africa Standard Time
## 39                        Africa/Lome                      Greenwich Mean Time
## 40                      Africa/Luanda                West Africa Standard Time
## 41                  Africa/Lubumbashi                      Central Africa Time
## 42                      Africa/Lusaka                      Central Africa Time
## 43                      Africa/Malabo                West Africa Standard Time
## 44                      Africa/Maputo                      Central Africa Time
## 45                      Africa/Maseru               South Africa Standard Time
## 46                     Africa/Mbabane               South Africa Standard Time
## 47                   Africa/Mogadishu                      Eastern Africa Time
## 48                    Africa/Monrovia                      Greenwich Mean Time
## 49                     Africa/Nairobi                      Eastern Africa Time
## 50                    Africa/Ndjamena                West Africa Standard Time
## 51                      Africa/Niamey                West Africa Standard Time
## 52                  Africa/Nouakchott                      Greenwich Mean Time
## 53                 Africa/Ouagadougou                      Greenwich Mean Time
## 54                  Africa/Porto-Novo                West Africa Standard Time
## 55                    Africa/Sao_Tome                      Greenwich Mean Time
## 56                    Africa/Timbuktu                      Greenwich Mean Time
## 57                     Africa/Tripoli           Eastern European Standard Time
## 58                       Africa/Tunis           Central European Standard Time
## 59                    Africa/Windhoek                      Central Africa Time
## 60                       America/Adak            Hawaii-Aleutian Standard Time
## 61                  America/Anchorage                     Alaska Standard Time
## 62                   America/Anguilla                   Atlantic Standard Time
## 63                    America/Antigua                   Atlantic Standard Time
## 64                  America/Araguaina                   Brasilia Standard Time
## 65     America/Argentina/Buenos_Aires                  Argentina Standard Time
## 66        America/Argentina/Catamarca                  Argentina Standard Time
## 67   America/Argentina/ComodRivadavia                  Argentina Standard Time
## 68          America/Argentina/Cordoba                  Argentina Standard Time
## 69            America/Argentina/Jujuy                  Argentina Standard Time
## 70         America/Argentina/La_Rioja                  Argentina Standard Time
## 71          America/Argentina/Mendoza                  Argentina Standard Time
## 72     America/Argentina/Rio_Gallegos                  Argentina Standard Time
## 73            America/Argentina/Salta                  Argentina Standard Time
## 74         America/Argentina/San_Juan                  Argentina Standard Time
## 75         America/Argentina/San_Luis                  Argentina Standard Time
## 76          America/Argentina/Tucuman                  Argentina Standard Time
## 77          America/Argentina/Ushuaia                  Argentina Standard Time
## 78                      America/Aruba                   Atlantic Standard Time
## 79                   America/Asuncion                   Paraguay Standard Time
## 80                   America/Atikokan                    Eastern Standard Time
## 81                       America/Atka            Hawaii-Aleutian Standard Time
## 82                      America/Bahia                   Brasilia Standard Time
## 83             America/Bahia_Banderas                    Central Standard Time
## 84                   America/Barbados                   Atlantic Standard Time
## 85                      America/Belem                   Brasilia Standard Time
## 86                     America/Belize                    Central Standard Time
## 87               America/Blanc-Sablon                   Atlantic Standard Time
## 88                  America/Boa_Vista                     Amazon Standard Time
## 89                     America/Bogota                   Colombia Standard Time
## 90                      America/Boise                   Mountain Standard Time
## 91               America/Buenos_Aires                  Argentina Standard Time
## 92              America/Cambridge_Bay                   Mountain Standard Time
## 93               America/Campo_Grande                     Amazon Standard Time
## 94                     America/Cancun                    Eastern Standard Time
## 95                    America/Caracas                           Venezuela Time
## 96                  America/Catamarca                  Argentina Standard Time
## 97                    America/Cayenne                       French Guiana Time
## 98                     America/Cayman                    Eastern Standard Time
## 99                    America/Chicago                    Central Standard Time
## 100                 America/Chihuahua            Mexican Pacific Standard Time
## 101             America/Coral_Harbour                    Eastern Standard Time
## 102                   America/Cordoba                  Argentina Standard Time
## 103                America/Costa_Rica                    Central Standard Time
## 104                   America/Creston                   Mountain Standard Time
## 105                    America/Cuiaba                     Amazon Standard Time
## 106                   America/Curacao                   Atlantic Standard Time
## 107              America/Danmarkshavn                      Greenwich Mean Time
## 108                    America/Dawson                   Mountain Standard Time
## 109              America/Dawson_Creek                   Mountain Standard Time
## 110                    America/Denver                   Mountain Standard Time
## 111                   America/Detroit                    Eastern Standard Time
## 112                  America/Dominica                   Atlantic Standard Time
## 113                  America/Edmonton                   Mountain Standard Time
## 114                  America/Eirunepe                       Acre Standard Time
## 115               America/El_Salvador                    Central Standard Time
## 116                  America/Ensenada                    Pacific Standard Time
## 117               America/Fort_Nelson                   Mountain Standard Time
## 118                America/Fort_Wayne                    Eastern Standard Time
## 119                 America/Fortaleza                   Brasilia Standard Time
## 120                 America/Glace_Bay                   Atlantic Standard Time
## 121                   America/Godthab             West Greenland Standard Time
## 122                 America/Goose_Bay                   Atlantic Standard Time
## 123                America/Grand_Turk                    Eastern Standard Time
## 124                   America/Grenada                   Atlantic Standard Time
## 125                America/Guadeloupe                   Atlantic Standard Time
## 126                 America/Guatemala                    Central Standard Time
## 127                 America/Guayaquil                             Ecuador Time
## 128                    America/Guyana                              Guyana Time
## 129                   America/Halifax                   Atlantic Standard Time
## 130                    America/Havana                       Cuba Standard Time
## 131                America/Hermosillo            Mexican Pacific Standard Time
## 132      America/Indiana/Indianapolis                    Eastern Standard Time
## 133              America/Indiana/Knox                    Central Standard Time
## 134           America/Indiana/Marengo                    Eastern Standard Time
## 135        America/Indiana/Petersburg                    Eastern Standard Time
## 136         America/Indiana/Tell_City                    Central Standard Time
## 137             America/Indiana/Vevay                    Eastern Standard Time
## 138         America/Indiana/Vincennes                    Eastern Standard Time
## 139           America/Indiana/Winamac                    Eastern Standard Time
## 140              America/Indianapolis                    Eastern Standard Time
## 141                    America/Inuvik                   Mountain Standard Time
## 142                   America/Iqaluit                    Eastern Standard Time
## 143                   America/Jamaica                    Eastern Standard Time
## 144                     America/Jujuy                  Argentina Standard Time
## 145                    America/Juneau                     Alaska Standard Time
## 146       America/Kentucky/Louisville                    Eastern Standard Time
## 147       America/Kentucky/Monticello                    Eastern Standard Time
## 148                   America/Knox_IN                    Central Standard Time
## 149                America/Kralendijk                   Atlantic Standard Time
## 150                    America/La_Paz                             Bolivia Time
## 151                      America/Lima                       Peru Standard Time
## 152               America/Los_Angeles                    Pacific Standard Time
## 153                America/Louisville                    Eastern Standard Time
## 154             America/Lower_Princes                   Atlantic Standard Time
## 155                    America/Maceio                   Brasilia Standard Time
## 156                   America/Managua                    Central Standard Time
## 157                    America/Manaus                     Amazon Standard Time
## 158                   America/Marigot                   Atlantic Standard Time
## 159                America/Martinique                   Atlantic Standard Time
## 160                 America/Matamoros                    Central Standard Time
## 161                  America/Mazatlan            Mexican Pacific Standard Time
## 162                   America/Mendoza                  Argentina Standard Time
## 163                 America/Menominee                    Central Standard Time
## 164                    America/Merida                    Central Standard Time
## 165                America/Metlakatla                     Alaska Standard Time
## 166               America/Mexico_City                    Central Standard Time
## 167                  America/Miquelon       St Pierre & Miquelon Standard Time
## 168                   America/Moncton                   Atlantic Standard Time
## 169                 America/Monterrey                    Central Standard Time
## 170                America/Montevideo                    Uruguay Standard Time
## 171                  America/Montreal                                GMT-05:00
## 172                America/Montserrat                   Atlantic Standard Time
## 173                    America/Nassau                    Eastern Standard Time
## 174                  America/New_York                    Eastern Standard Time
## 175                   America/Nipigon                    Eastern Standard Time
## 176                      America/Nome                     Alaska Standard Time
## 177                   America/Noronha        Fernando de Noronha Standard Time
## 178       America/North_Dakota/Beulah                    Central Standard Time
## 179       America/North_Dakota/Center                    Central Standard Time
## 180    America/North_Dakota/New_Salem                    Central Standard Time
## 181                      America/Nuuk             West Greenland Standard Time
## 182                   America/Ojinaga                   Mountain Standard Time
## 183                    America/Panama                    Eastern Standard Time
## 184               America/Pangnirtung                    Eastern Standard Time
## 185                America/Paramaribo                            Suriname Time
## 186                   America/Phoenix                   Mountain Standard Time
## 187            America/Port-au-Prince                    Eastern Standard Time
## 188             America/Port_of_Spain                   Atlantic Standard Time
## 189                America/Porto_Acre                       Acre Standard Time
## 190               America/Porto_Velho                     Amazon Standard Time
## 191               America/Puerto_Rico                   Atlantic Standard Time
## 192              America/Punta_Arenas                                GMT-03:00
## 193               America/Rainy_River                    Central Standard Time
## 194              America/Rankin_Inlet                    Central Standard Time
## 195                    America/Recife                   Brasilia Standard Time
## 196                    America/Regina                    Central Standard Time
## 197                  America/Resolute                    Central Standard Time
## 198                America/Rio_Branco                       Acre Standard Time
## 199                   America/Rosario                  Argentina Standard Time
## 200              America/Santa_Isabel           Northwest Mexico Standard Time
## 201                  America/Santarem                   Brasilia Standard Time
## 202                  America/Santiago                      Chile Standard Time
## 203             America/Santo_Domingo                   Atlantic Standard Time
## 204                 America/Sao_Paulo                   Brasilia Standard Time
## 205              America/Scoresbysund             East Greenland Standard Time
## 206                  America/Shiprock                   Mountain Standard Time
## 207                     America/Sitka                     Alaska Standard Time
## 208             America/St_Barthelemy                   Atlantic Standard Time
## 209                  America/St_Johns               Newfoundland Standard Time
## 210                  America/St_Kitts                   Atlantic Standard Time
## 211                  America/St_Lucia                   Atlantic Standard Time
## 212                 America/St_Thomas                   Atlantic Standard Time
## 213                America/St_Vincent                   Atlantic Standard Time
## 214             America/Swift_Current                    Central Standard Time
## 215               America/Tegucigalpa                    Central Standard Time
## 216                     America/Thule                   Atlantic Standard Time
## 217               America/Thunder_Bay                    Eastern Standard Time
## 218                   America/Tijuana                    Pacific Standard Time
## 219                   America/Toronto                    Eastern Standard Time
## 220                   America/Tortola                   Atlantic Standard Time
## 221                 America/Vancouver                    Pacific Standard Time
## 222                    America/Virgin                   Atlantic Standard Time
## 223                America/Whitehorse                   Mountain Standard Time
## 224                  America/Winnipeg                    Central Standard Time
## 225                   America/Yakutat                     Alaska Standard Time
## 226               America/Yellowknife                   Mountain Standard Time
## 227                  Antarctica/Casey                               Casey Time
## 228                  Antarctica/Davis                               Davis Time
## 229         Antarctica/DumontDUrville                    Dumont-d’Urville Time
## 230              Antarctica/Macquarie         Australian Eastern Standard Time
## 231                 Antarctica/Mawson                              Mawson Time
## 232                Antarctica/McMurdo                New Zealand Standard Time
## 233                 Antarctica/Palmer                                GMT-03:00
## 234                Antarctica/Rothera                             Rothera Time
## 235             Antarctica/South_Pole                New Zealand Standard Time
## 236                  Antarctica/Syowa                               Syowa Time
## 237                  Antarctica/Troll                      Greenwich Mean Time
## 238                 Antarctica/Vostok                              Vostok Time
## 239               Arctic/Longyearbyen           Central European Standard Time
## 240                         Asia/Aden                     Arabia Standard Time
## 241                       Asia/Almaty                     East Kazakhstan Time
## 242                        Asia/Amman           Eastern European Standard Time
## 243                       Asia/Anadyr                     Anadyr Standard Time
## 244                        Asia/Aqtau                     West Kazakhstan Time
## 245                       Asia/Aqtobe                     West Kazakhstan Time
## 246                     Asia/Ashgabat               Turkmenistan Standard Time
## 247                    Asia/Ashkhabad               Turkmenistan Standard Time
## 248                       Asia/Atyrau                     West Kazakhstan Time
## 249                      Asia/Baghdad                     Arabia Standard Time
## 250                      Asia/Bahrain                     Arabia Standard Time
## 251                         Asia/Baku                 Azerbaijan Standard Time
## 252                      Asia/Bangkok                           Indochina Time
## 253                      Asia/Barnaul                                GMT+07:00
## 254                       Asia/Beirut           Eastern European Standard Time
## 255                      Asia/Bishkek                          Kyrgyzstan Time
## 256                       Asia/Brunei                   Brunei Darussalam Time
## 257                     Asia/Calcutta                      India Standard Time
## 258                        Asia/Chita                    Yakutsk Standard Time
## 259                   Asia/Choibalsan                Ulaanbaatar Standard Time
## 260                    Asia/Chongqing                      China Standard Time
## 261                    Asia/Chungking                      China Standard Time
## 262                      Asia/Colombo                      India Standard Time
## 263                        Asia/Dacca                 Bangladesh Standard Time
## 264                     Asia/Damascus           Eastern European Standard Time
## 265                        Asia/Dhaka                 Bangladesh Standard Time
## 266                         Asia/Dili                          East Timor Time
## 267                        Asia/Dubai                       Gulf Standard Time
## 268                     Asia/Dushanbe                          Tajikistan Time
## 269                    Asia/Famagusta                                GMT+02:00
## 270                         Asia/Gaza           Eastern European Standard Time
## 271                       Asia/Harbin                      China Standard Time
## 272                       Asia/Hebron           Eastern European Standard Time
## 273                  Asia/Ho_Chi_Minh                           Indochina Time
## 274                    Asia/Hong_Kong                  Hong Kong Standard Time
## 275                         Asia/Hovd                       Hovd Standard Time
## 276                      Asia/Irkutsk                    Irkutsk Standard Time
## 277                     Asia/Istanbul                                GMT+03:00
## 278                      Asia/Jakarta                   Western Indonesia Time
## 279                     Asia/Jayapura                   Eastern Indonesia Time
## 280                    Asia/Jerusalem                     Israel Standard Time
## 281                        Asia/Kabul                         Afghanistan Time
## 282                    Asia/Kamchatka   Petropavlovsk-Kamchatski Standard Time
## 283                      Asia/Karachi                   Pakistan Standard Time
## 284                      Asia/Kashgar                                GMT+06:00
## 285                    Asia/Kathmandu                               Nepal Time
## 286                     Asia/Katmandu                               Nepal Time
## 287                     Asia/Khandyga                    Yakutsk Standard Time
## 288                      Asia/Kolkata                      India Standard Time
## 289                  Asia/Krasnoyarsk                Krasnoyarsk Standard Time
## 290                 Asia/Kuala_Lumpur                            Malaysia Time
## 291                      Asia/Kuching                            Malaysia Time
## 292                       Asia/Kuwait                     Arabia Standard Time
## 293                        Asia/Macao                      China Standard Time
## 294                        Asia/Macau                      China Standard Time
## 295                      Asia/Magadan                    Magadan Standard Time
## 296                     Asia/Makassar                   Central Indonesia Time
## 297                       Asia/Manila                 Philippine Standard Time
## 298                       Asia/Muscat                       Gulf Standard Time
## 299                      Asia/Nicosia           Eastern European Standard Time
## 300                 Asia/Novokuznetsk                Krasnoyarsk Standard Time
## 301                  Asia/Novosibirsk                Novosibirsk Standard Time
## 302                         Asia/Omsk                       Omsk Standard Time
## 303                         Asia/Oral                     West Kazakhstan Time
## 304                   Asia/Phnom_Penh                           Indochina Time
## 305                    Asia/Pontianak                   Western Indonesia Time
## 306                    Asia/Pyongyang                     Korean Standard Time
## 307                        Asia/Qatar                     Arabia Standard Time
## 308                     Asia/Qostanay                     East Kazakhstan Time
## 309                    Asia/Qyzylorda                     West Kazakhstan Time
## 310                      Asia/Rangoon                             Myanmar Time
## 311                       Asia/Riyadh                     Arabia Standard Time
## 312                       Asia/Saigon                           Indochina Time
## 313                     Asia/Sakhalin                   Sakhalin Standard Time
## 314                    Asia/Samarkand                 Uzbekistan Standard Time
## 315                        Asia/Seoul                     Korean Standard Time
## 316                     Asia/Shanghai                      China Standard Time
## 317                    Asia/Singapore                  Singapore Standard Time
## 318                Asia/Srednekolymsk                                GMT+11:00
## 319                       Asia/Taipei                     Taipei Standard Time
## 320                     Asia/Tashkent                 Uzbekistan Standard Time
## 321                      Asia/Tbilisi                    Georgia Standard Time
## 322                       Asia/Tehran                       Iran Standard Time
## 323                     Asia/Tel_Aviv                     Israel Standard Time
## 324                       Asia/Thimbu                              Bhutan Time
## 325                      Asia/Thimphu                              Bhutan Time
## 326                        Asia/Tokyo                      Japan Standard Time
## 327                        Asia/Tomsk                                GMT+07:00
## 328                Asia/Ujung_Pandang                   Central Indonesia Time
## 329                  Asia/Ulaanbaatar                Ulaanbaatar Standard Time
## 330                   Asia/Ulan_Bator                Ulaanbaatar Standard Time
## 331                       Asia/Urumqi                                GMT+06:00
## 332                     Asia/Ust-Nera                Vladivostok Standard Time
## 333                    Asia/Vientiane                           Indochina Time
## 334                  Asia/Vladivostok                Vladivostok Standard Time
## 335                      Asia/Yakutsk                    Yakutsk Standard Time
## 336                       Asia/Yangon                             Myanmar Time
## 337                Asia/Yekaterinburg              Yekaterinburg Standard Time
## 338                      Asia/Yerevan                    Armenia Standard Time
## 339                   Atlantic/Azores                     Azores Standard Time
## 340                  Atlantic/Bermuda                   Atlantic Standard Time
## 341                   Atlantic/Canary           Western European Standard Time
## 342               Atlantic/Cape_Verde                 Cape Verde Standard Time
## 343                   Atlantic/Faeroe           Western European Standard Time
## 344                    Atlantic/Faroe           Western European Standard Time
## 345                Atlantic/Jan_Mayen           Central European Standard Time
## 346                  Atlantic/Madeira           Western European Standard Time
## 347                Atlantic/Reykjavik                      Greenwich Mean Time
## 348            Atlantic/South_Georgia                       South Georgia Time
## 349                Atlantic/St_Helena                      Greenwich Mean Time
## 350                  Atlantic/Stanley           Falkland Islands Standard Time
## 351                     Australia/ACT         Australian Eastern Standard Time
## 352                Australia/Adelaide         Australian Central Standard Time
## 353                Australia/Brisbane         Australian Eastern Standard Time
## 354             Australia/Broken_Hill         Australian Central Standard Time
## 355                Australia/Canberra         Australian Eastern Standard Time
## 356                  Australia/Currie         Australian Eastern Standard Time
## 357                  Australia/Darwin         Australian Central Standard Time
## 358                   Australia/Eucla Australian Central Western Standard Time
## 359                  Australia/Hobart         Australian Eastern Standard Time
## 360                     Australia/LHI                  Lord Howe Standard Time
## 361                Australia/Lindeman         Australian Eastern Standard Time
## 362               Australia/Lord_Howe                  Lord Howe Standard Time
## 363               Australia/Melbourne         Australian Eastern Standard Time
## 364                     Australia/NSW         Australian Eastern Standard Time
## 365                   Australia/North         Australian Central Standard Time
## 366                   Australia/Perth         Australian Western Standard Time
## 367              Australia/Queensland         Australian Eastern Standard Time
## 368                   Australia/South         Australian Central Standard Time
## 369                  Australia/Sydney         Australian Eastern Standard Time
## 370                Australia/Tasmania         Australian Eastern Standard Time
## 371                Australia/Victoria         Australian Eastern Standard Time
## 372                    Australia/West         Australian Western Standard Time
## 373              Australia/Yancowinna         Australian Central Standard Time
## 374                               BET                   Brasilia Standard Time
## 375                               BST                 Bangladesh Standard Time
## 376                       Brazil/Acre                       Acre Standard Time
## 377                  Brazil/DeNoronha        Fernando de Noronha Standard Time
## 378                       Brazil/East                   Brasilia Standard Time
## 379                       Brazil/West                     Amazon Standard Time
## 380                               CAT                      Central Africa Time
## 381                               CET                                GMT+01:00
## 382                               CNT               Newfoundland Standard Time
## 383                               CST                    Central Standard Time
## 384                           CST6CDT                    Central Standard Time
## 385                               CTT                      China Standard Time
## 386                   Canada/Atlantic                   Atlantic Standard Time
## 387                    Canada/Central                    Central Standard Time
## 388          Canada/East-Saskatchewan                    Central Standard Time
## 389                    Canada/Eastern                    Eastern Standard Time
## 390                   Canada/Mountain                   Mountain Standard Time
## 391               Canada/Newfoundland               Newfoundland Standard Time
## 392                    Canada/Pacific                    Pacific Standard Time
## 393               Canada/Saskatchewan                    Central Standard Time
## 394                      Canada/Yukon                   Mountain Standard Time
## 395                 Chile/Continental                      Chile Standard Time
## 396                Chile/EasterIsland              Easter Island Standard Time
## 397                              Cuba                       Cuba Standard Time
## 398                               EAT                      Eastern Africa Time
## 399                               ECT           Central European Standard Time
## 400                               EET                                GMT+02:00
## 401                               EST                                GMT-05:00
## 402                           EST5EDT                    Eastern Standard Time
## 403                             Egypt           Eastern European Standard Time
## 404                              Eire                      Greenwich Mean Time
## 405                           Etc/GMT                      Greenwich Mean Time
## 406                         Etc/GMT+0                      Greenwich Mean Time
## 407                         Etc/GMT+1                                GMT-01:00
## 408                        Etc/GMT+10                                GMT-10:00
## 409                        Etc/GMT+11                                GMT-11:00
## 410                        Etc/GMT+12                                GMT-12:00
## 411                         Etc/GMT+2                                GMT-02:00
## 412                         Etc/GMT+3                                GMT-03:00
## 413                         Etc/GMT+4                                GMT-04:00
## 414                         Etc/GMT+5                                GMT-05:00
## 415                         Etc/GMT+6                                GMT-06:00
## 416                         Etc/GMT+7                                GMT-07:00
## 417                         Etc/GMT+8                                GMT-08:00
## 418                         Etc/GMT+9                                GMT-09:00
## 419                         Etc/GMT-0                      Greenwich Mean Time
## 420                         Etc/GMT-1                                GMT+01:00
## 421                        Etc/GMT-10                                GMT+10:00
## 422                        Etc/GMT-11                                GMT+11:00
## 423                        Etc/GMT-12                                GMT+12:00
## 424                        Etc/GMT-13                                GMT+13:00
## 425                        Etc/GMT-14                                GMT+14:00
## 426                         Etc/GMT-2                                GMT+02:00
## 427                         Etc/GMT-3                                GMT+03:00
## 428                         Etc/GMT-4                                GMT+04:00
## 429                         Etc/GMT-5                                GMT+05:00
## 430                         Etc/GMT-6                                GMT+06:00
## 431                         Etc/GMT-7                                GMT+07:00
## 432                         Etc/GMT-8                                GMT+08:00
## 433                         Etc/GMT-9                                GMT+09:00
## 434                          Etc/GMT0                      Greenwich Mean Time
## 435                     Etc/Greenwich                      Greenwich Mean Time
## 436                           Etc/UCT               Coordinated Universal Time
## 437                           Etc/UTC               Coordinated Universal Time
## 438                     Etc/Universal               Coordinated Universal Time
## 439                          Etc/Zulu               Coordinated Universal Time
## 440                  Europe/Amsterdam           Central European Standard Time
## 441                    Europe/Andorra           Central European Standard Time
## 442                  Europe/Astrakhan                                GMT+04:00
## 443                     Europe/Athens           Eastern European Standard Time
## 444                    Europe/Belfast                      Greenwich Mean Time
## 445                   Europe/Belgrade           Central European Standard Time
## 446                     Europe/Berlin           Central European Standard Time
## 447                 Europe/Bratislava           Central European Standard Time
## 448                   Europe/Brussels           Central European Standard Time
## 449                  Europe/Bucharest           Eastern European Standard Time
## 450                   Europe/Budapest           Central European Standard Time
## 451                   Europe/Busingen           Central European Standard Time
## 452                   Europe/Chisinau           Eastern European Standard Time
## 453                 Europe/Copenhagen           Central European Standard Time
## 454                     Europe/Dublin                      Greenwich Mean Time
## 455                  Europe/Gibraltar           Central European Standard Time
## 456                   Europe/Guernsey                      Greenwich Mean Time
## 457                   Europe/Helsinki           Eastern European Standard Time
## 458                Europe/Isle_of_Man                      Greenwich Mean Time
## 459                   Europe/Istanbul                                GMT+03:00
## 460                     Europe/Jersey                      Greenwich Mean Time
## 461                Europe/Kaliningrad           Eastern European Standard Time
## 462                       Europe/Kiev           Eastern European Standard Time
## 463                      Europe/Kirov                                GMT+03:00
## 464                     Europe/Lisbon           Western European Standard Time
## 465                  Europe/Ljubljana           Central European Standard Time
## 466                     Europe/London                      Greenwich Mean Time
## 467                 Europe/Luxembourg           Central European Standard Time
## 468                     Europe/Madrid           Central European Standard Time
## 469                      Europe/Malta           Central European Standard Time
## 470                  Europe/Mariehamn           Eastern European Standard Time
## 471                      Europe/Minsk                     Moscow Standard Time
## 472                     Europe/Monaco           Central European Standard Time
## 473                     Europe/Moscow                     Moscow Standard Time
## 474                    Europe/Nicosia           Eastern European Standard Time
## 475                       Europe/Oslo           Central European Standard Time
## 476                      Europe/Paris           Central European Standard Time
## 477                  Europe/Podgorica           Central European Standard Time
## 478                     Europe/Prague           Central European Standard Time
## 479                       Europe/Riga           Eastern European Standard Time
## 480                       Europe/Rome           Central European Standard Time
## 481                     Europe/Samara                     Samara Standard Time
## 482                 Europe/San_Marino           Central European Standard Time
## 483                   Europe/Sarajevo           Central European Standard Time
## 484                    Europe/Saratov                                GMT+04:00
## 485                 Europe/Simferopol                     Moscow Standard Time
## 486                     Europe/Skopje           Central European Standard Time
## 487                      Europe/Sofia           Eastern European Standard Time
## 488                  Europe/Stockholm           Central European Standard Time
## 489                    Europe/Tallinn           Eastern European Standard Time
## 490                     Europe/Tirane           Central European Standard Time
## 491                   Europe/Tiraspol           Eastern European Standard Time
## 492                  Europe/Ulyanovsk                                GMT+04:00
## 493                   Europe/Uzhgorod           Eastern European Standard Time
## 494                      Europe/Vaduz           Central European Standard Time
## 495                    Europe/Vatican           Central European Standard Time
## 496                     Europe/Vienna           Central European Standard Time
## 497                    Europe/Vilnius           Eastern European Standard Time
## 498                  Europe/Volgograd                  Volgograd Standard Time
## 499                     Europe/Warsaw           Central European Standard Time
## 500                     Europe/Zagreb           Central European Standard Time
## 501                 Europe/Zaporozhye           Eastern European Standard Time
## 502                     Europe/Zurich           Central European Standard Time
## 503                           Factory                                      GMT
## 504                                GB                      Greenwich Mean Time
## 505                           GB-Eire                      Greenwich Mean Time
## 506                               GMT                      Greenwich Mean Time
## 507                             GMT+0                      Greenwich Mean Time
## 508                             GMT-0                      Greenwich Mean Time
## 509                              GMT0                      Greenwich Mean Time
## 510                         Greenwich                      Greenwich Mean Time
## 511                               HST                                GMT-10:00
## 512                          Hongkong                  Hong Kong Standard Time
## 513                               IET                    Eastern Standard Time
## 514                               IST                      India Standard Time
## 515                           Iceland                      Greenwich Mean Time
## 516               Indian/Antananarivo                      Eastern Africa Time
## 517                     Indian/Chagos                        Indian Ocean Time
## 518                  Indian/Christmas                    Christmas Island Time
## 519                      Indian/Cocos                       Cocos Islands Time
## 520                     Indian/Comoro                      Eastern Africa Time
## 521                  Indian/Kerguelen         French Southern & Antarctic Time
## 522                       Indian/Mahe                          Seychelles Time
## 523                   Indian/Maldives                            Maldives Time
## 524                  Indian/Mauritius                  Mauritius Standard Time
## 525                    Indian/Mayotte                      Eastern Africa Time
## 526                    Indian/Reunion                             Réunion Time
## 527                              Iran                       Iran Standard Time
## 528                            Israel                     Israel Standard Time
## 529                               JST                      Japan Standard Time
## 530                           Jamaica                    Eastern Standard Time
## 531                             Japan                      Japan Standard Time
## 532                         Kwajalein                    Marshall Islands Time
## 533                             Libya           Eastern European Standard Time
## 534                               MET                                GMT+01:00
## 535                               MIT                       Apia Standard Time
## 536                               MST                                GMT-07:00
## 537                           MST7MDT                   Mountain Standard Time
## 538                  Mexico/BajaNorte                    Pacific Standard Time
## 539                    Mexico/BajaSur            Mexican Pacific Standard Time
## 540                    Mexico/General                    Central Standard Time
## 541                               NET                    Armenia Standard Time
## 542                               NST                New Zealand Standard Time
## 543                                NZ                New Zealand Standard Time
## 544                           NZ-CHAT                    Chatham Standard Time
## 545                            Navajo                   Mountain Standard Time
## 546                               PLT                   Pakistan Standard Time
## 547                               PNT                   Mountain Standard Time
## 548                               PRC                      China Standard Time
## 549                               PRT                   Atlantic Standard Time
## 550                               PST                    Pacific Standard Time
## 551                           PST8PDT                    Pacific Standard Time
## 552                      Pacific/Apia                       Apia Standard Time
## 553                  Pacific/Auckland                New Zealand Standard Time
## 554              Pacific/Bougainville                                GMT+11:00
## 555                   Pacific/Chatham                    Chatham Standard Time
## 556                     Pacific/Chuuk                               Chuuk Time
## 557                    Pacific/Easter              Easter Island Standard Time
## 558                     Pacific/Efate                    Vanuatu Standard Time
## 559                 Pacific/Enderbury                     Phoenix Islands Time
## 560                   Pacific/Fakaofo                             Tokelau Time
## 561                      Pacific/Fiji                       Fiji Standard Time
## 562                  Pacific/Funafuti                              Tuvalu Time
## 563                 Pacific/Galapagos                           Galapagos Time
## 564                   Pacific/Gambier                             Gambier Time
## 565               Pacific/Guadalcanal                     Solomon Islands Time
## 566                      Pacific/Guam                   Chamorro Standard Time
## 567                  Pacific/Honolulu            Hawaii-Aleutian Standard Time
## 568                  Pacific/Johnston            Hawaii-Aleutian Standard Time
## 569                Pacific/Kiritimati                        Line Islands Time
## 570                    Pacific/Kosrae                              Kosrae Time
## 571                 Pacific/Kwajalein                    Marshall Islands Time
## 572                    Pacific/Majuro                    Marshall Islands Time
## 573                 Pacific/Marquesas                           Marquesas Time
## 574                    Pacific/Midway                      Samoa Standard Time
## 575                     Pacific/Nauru                               Nauru Time
## 576                      Pacific/Niue                                Niue Time
## 577                   Pacific/Norfolk             Norfolk Island Standard Time
## 578                    Pacific/Noumea              New Caledonia Standard Time
## 579                 Pacific/Pago_Pago                      Samoa Standard Time
## 580                     Pacific/Palau                               Palau Time
## 581                  Pacific/Pitcairn                            Pitcairn Time
## 582                   Pacific/Pohnpei                              Ponape Time
## 583                    Pacific/Ponape                              Ponape Time
## 584              Pacific/Port_Moresby                    Papua New Guinea Time
## 585                 Pacific/Rarotonga                Cook Island Standard Time
## 586                    Pacific/Saipan                   Chamorro Standard Time
## 587                     Pacific/Samoa                      Samoa Standard Time
## 588                    Pacific/Tahiti                              Tahiti Time
## 589                    Pacific/Tarawa                     Gilbert Islands Time
## 590                 Pacific/Tongatapu                      Tonga Standard Time
## 591                      Pacific/Truk                               Chuuk Time
## 592                      Pacific/Wake                         Wake Island Time
## 593                    Pacific/Wallis                     Wallis & Futuna Time
## 594                       Pacific/Yap                               Chuuk Time
## 595                            Poland           Central European Standard Time
## 596                          Portugal           Western European Standard Time
## 597                               ROC                     Taipei Standard Time
## 598                               ROK                     Korean Standard Time
## 599                               SST                     Solomon Islands Time
## 600                         Singapore                  Singapore Standard Time
## 601                      SystemV/AST4                                GMT-04:00
## 602                   SystemV/AST4ADT                                GMT-04:00
## 603                      SystemV/CST6                                GMT-06:00
## 604                   SystemV/CST6CDT                                GMT-06:00
## 605                      SystemV/EST5                                GMT-05:00
## 606                   SystemV/EST5EDT                                GMT-05:00
## 607                     SystemV/HST10                                GMT-10:00
## 608                      SystemV/MST7                                GMT-07:00
## 609                   SystemV/MST7MDT                                GMT-07:00
## 610                      SystemV/PST8                                GMT-08:00
## 611                   SystemV/PST8PDT                                GMT-08:00
## 612                      SystemV/YST9                                GMT-09:00
## 613                   SystemV/YST9YDT                                GMT-09:00
## 614                            Turkey                                GMT+03:00
## 615                               UCT               Coordinated Universal Time
## 616                         US/Alaska                     Alaska Standard Time
## 617                       US/Aleutian            Hawaii-Aleutian Standard Time
## 618                        US/Arizona                   Mountain Standard Time
## 619                        US/Central                    Central Standard Time
## 620                   US/East-Indiana                    Eastern Standard Time
## 621                        US/Eastern                    Eastern Standard Time
## 622                         US/Hawaii            Hawaii-Aleutian Standard Time
## 623                 US/Indiana-Starke                    Central Standard Time
## 624                       US/Michigan                    Eastern Standard Time
## 625                       US/Mountain                   Mountain Standard Time
## 626                        US/Pacific                    Pacific Standard Time
## 627                    US/Pacific-New                    Pacific Standard Time
## 628                          US/Samoa                      Samoa Standard Time
## 629                               UTC               Coordinated Universal Time
## 630                         Universal               Coordinated Universal Time
## 631                               VST                           Indochina Time
## 632                              W-SU                     Moscow Standard Time
## 633                               WET                                      GMT
## 634                              Zulu               Coordinated Universal Time
##                           Name.Daylight                    Name.Windows
## 2                                  <NA>       AUS Central Standard Time
## 2100   Australian Eastern Daylight Time       AUS Eastern Standard Time
## 3                                  <NA>         Argentina Standard Time
## 4                                  <NA>             Egypt Standard Time
## 5                  Alaska Daylight Time           Alaskan Standard Time
## 6                                  <NA>         Greenwich Standard Time
## 7                                  <NA>         Greenwich Standard Time
## 8                                  <NA>         E. Africa Standard Time
## 9                                  <NA> W. Central Africa Standard Time
## 10                                 <NA>         E. Africa Standard Time
## 11                                 <NA>         E. Africa Standard Time
## 12                                 <NA>         Greenwich Standard Time
## 13                                 <NA> W. Central Africa Standard Time
## 14                                 <NA>         Greenwich Standard Time
## 15                                 <NA>         Greenwich Standard Time
## 16                                 <NA>      South Africa Standard Time
## 17                                 <NA> W. Central Africa Standard Time
## 18                                 <NA>      South Africa Standard Time
## 19                                 <NA>             Egypt Standard Time
## 20                            GMT+01:00           Morocco Standard Time
## 21         Central European Summer Time           Romance Standard Time
## 22                                 <NA>         Greenwich Standard Time
## 23                                 <NA>         Greenwich Standard Time
## 24                                 <NA>         E. Africa Standard Time
## 25                                 <NA>         E. Africa Standard Time
## 26                                 <NA> W. Central Africa Standard Time
## 27                            GMT+01:00           Morocco Standard Time
## 28                                 <NA>         Greenwich Standard Time
## 29                                 <NA>      South Africa Standard Time
## 30                                 <NA>      South Africa Standard Time
## 31                                 <NA>      South Africa Standard Time
## 32                                 <NA>      South Africa Standard Time
## 33                                 <NA>         E. Africa Standard Time
## 34                                 <NA>             Sudan Standard Time
## 35                                 <NA>      South Africa Standard Time
## 36                                 <NA> W. Central Africa Standard Time
## 37                                 <NA> W. Central Africa Standard Time
## 38                                 <NA> W. Central Africa Standard Time
## 39                                 <NA>         Greenwich Standard Time
## 40                                 <NA> W. Central Africa Standard Time
## 41                                 <NA>      South Africa Standard Time
## 42                                 <NA>      South Africa Standard Time
## 43                                 <NA> W. Central Africa Standard Time
## 44                                 <NA>      South Africa Standard Time
## 45                                 <NA>      South Africa Standard Time
## 46                                 <NA>      South Africa Standard Time
## 47                                 <NA>         E. Africa Standard Time
## 48                                 <NA>         Greenwich Standard Time
## 49                                 <NA>         E. Africa Standard Time
## 50                                 <NA> W. Central Africa Standard Time
## 51                                 <NA> W. Central Africa Standard Time
## 52                                 <NA>         Greenwich Standard Time
## 53                                 <NA>         Greenwich Standard Time
## 54                                 <NA> W. Central Africa Standard Time
## 55                                 <NA>          Sao Tome Standard Time
## 56                                 <NA>         Greenwich Standard Time
## 57                                 <NA>             Libya Standard Time
## 58                                 <NA> W. Central Africa Standard Time
## 59                                 <NA>           Namibia Standard Time
## 60        Hawaii-Aleutian Daylight Time          Aleutian Standard Time
## 61                 Alaska Daylight Time           Alaskan Standard Time
## 62                                 <NA>        SA Western Standard Time
## 63                                 <NA>        SA Western Standard Time
## 64                                 <NA>         Tocantins Standard Time
## 65                                 <NA>         Argentina Standard Time
## 66                                 <NA>         Argentina Standard Time
## 67                                 <NA>         Argentina Standard Time
## 68                                 <NA>         Argentina Standard Time
## 69                                 <NA>         Argentina Standard Time
## 70                                 <NA>         Argentina Standard Time
## 71                                 <NA>         Argentina Standard Time
## 72                                 <NA>         Argentina Standard Time
## 73                                 <NA>         Argentina Standard Time
## 74                                 <NA>         Argentina Standard Time
## 75                                 <NA>         Argentina Standard Time
## 76                                 <NA>         Argentina Standard Time
## 77                                 <NA>         Argentina Standard Time
## 78                                 <NA>        SA Western Standard Time
## 79                 Paraguay Summer Time          Paraguay Standard Time
## 80                                 <NA>        SA Pacific Standard Time
## 81        Hawaii-Aleutian Daylight Time          Aleutian Standard Time
## 82                                 <NA>             Bahia Standard Time
## 83                Central Daylight Time  Central Standard Time (Mexico)
## 84                                 <NA>        SA Western Standard Time
## 85                                 <NA>        SA Eastern Standard Time
## 86                                 <NA>   Central America Standard Time
## 87                                 <NA>        SA Western Standard Time
## 88                                 <NA>        SA Western Standard Time
## 89                                 <NA>        SA Pacific Standard Time
## 90               Mountain Daylight Time          Mountain Standard Time
## 91                                 <NA>         Argentina Standard Time
## 92               Mountain Daylight Time          Mountain Standard Time
## 93                                 <NA> Central Brazilian Standard Time
## 94                                 <NA>  Eastern Standard Time (Mexico)
## 95                                 <NA>         Venezuela Standard Time
## 96                                 <NA>         Argentina Standard Time
## 97                                 <NA>        SA Eastern Standard Time
## 98                                 <NA>        SA Pacific Standard Time
## 99                Central Daylight Time           Central Standard Time
## 100       Mexican Pacific Daylight Time Mountain Standard Time (Mexico)
## 101                                <NA>        SA Pacific Standard Time
## 102                                <NA>         Argentina Standard Time
## 103                                <NA>   Central America Standard Time
## 104                                <NA>       US Mountain Standard Time
## 105                                <NA> Central Brazilian Standard Time
## 106                                <NA>        SA Western Standard Time
## 107                                <NA>         Greenwich Standard Time
## 108                                <NA>             Yukon Standard Time
## 109                                <NA>       US Mountain Standard Time
## 110              Mountain Daylight Time          Mountain Standard Time
## 111               Eastern Daylight Time           Eastern Standard Time
## 112                                <NA>        SA Western Standard Time
## 113              Mountain Daylight Time          Mountain Standard Time
## 114                                <NA>        SA Pacific Standard Time
## 115                                <NA>   Central America Standard Time
## 116               Pacific Daylight Time  Pacific Standard Time (Mexico)
## 117                                <NA>       US Mountain Standard Time
## 118               Eastern Daylight Time        US Eastern Standard Time
## 119                                <NA>        SA Eastern Standard Time
## 120              Atlantic Daylight Time          Atlantic Standard Time
## 121          West Greenland Summer Time         Greenland Standard Time
## 122              Atlantic Daylight Time          Atlantic Standard Time
## 123               Eastern Daylight Time  Turks And Caicos Standard Time
## 124                                <NA>        SA Western Standard Time
## 125                                <NA>        SA Western Standard Time
## 126                                <NA>   Central America Standard Time
## 127                                <NA>        SA Pacific Standard Time
## 128                                <NA>        SA Western Standard Time
## 129              Atlantic Daylight Time          Atlantic Standard Time
## 130                  Cuba Daylight Time              Cuba Standard Time
## 131                                <NA>       US Mountain Standard Time
## 132               Eastern Daylight Time        US Eastern Standard Time
## 133               Central Daylight Time           Central Standard Time
## 134               Eastern Daylight Time        US Eastern Standard Time
## 135               Eastern Daylight Time           Eastern Standard Time
## 136               Central Daylight Time           Central Standard Time
## 137               Eastern Daylight Time        US Eastern Standard Time
## 138               Eastern Daylight Time           Eastern Standard Time
## 139               Eastern Daylight Time           Eastern Standard Time
## 140               Eastern Daylight Time        US Eastern Standard Time
## 141              Mountain Daylight Time          Mountain Standard Time
## 142               Eastern Daylight Time           Eastern Standard Time
## 143                                <NA>        SA Pacific Standard Time
## 144                                <NA>         Argentina Standard Time
## 145                Alaska Daylight Time           Alaskan Standard Time
## 146               Eastern Daylight Time           Eastern Standard Time
## 147               Eastern Daylight Time           Eastern Standard Time
## 148               Central Daylight Time           Central Standard Time
## 149                                <NA>        SA Western Standard Time
## 150                                <NA>        SA Western Standard Time
## 151                                <NA>        SA Pacific Standard Time
## 152               Pacific Daylight Time           Pacific Standard Time
## 153               Eastern Daylight Time           Eastern Standard Time
## 154                                <NA>        SA Western Standard Time
## 155                                <NA>        SA Eastern Standard Time
## 156                                <NA>   Central America Standard Time
## 157                                <NA>        SA Western Standard Time
## 158                                <NA>        SA Western Standard Time
## 159                                <NA>        SA Western Standard Time
## 160               Central Daylight Time           Central Standard Time
## 161       Mexican Pacific Daylight Time Mountain Standard Time (Mexico)
## 162                                <NA>         Argentina Standard Time
## 163               Central Daylight Time           Central Standard Time
## 164               Central Daylight Time  Central Standard Time (Mexico)
## 165                Alaska Daylight Time           Alaskan Standard Time
## 166               Central Daylight Time  Central Standard Time (Mexico)
## 167  St Pierre & Miquelon Daylight Time      Saint Pierre Standard Time
## 168              Atlantic Daylight Time          Atlantic Standard Time
## 169               Central Daylight Time  Central Standard Time (Mexico)
## 170                                <NA>        Montevideo Standard Time
## 171                           GMT-04:00           Eastern Standard Time
## 172                                <NA>        SA Western Standard Time
## 173               Eastern Daylight Time           Eastern Standard Time
## 174               Eastern Daylight Time           Eastern Standard Time
## 175               Eastern Daylight Time           Eastern Standard Time
## 176                Alaska Daylight Time           Alaskan Standard Time
## 177                                <NA>                          UTC-02
## 178               Central Daylight Time           Central Standard Time
## 179               Central Daylight Time           Central Standard Time
## 180               Central Daylight Time           Central Standard Time
## 181          West Greenland Summer Time         Greenland Standard Time
## 182              Mountain Daylight Time          Mountain Standard Time
## 183                                <NA>        SA Pacific Standard Time
## 184               Eastern Daylight Time           Eastern Standard Time
## 185                                <NA>        SA Eastern Standard Time
## 186                                <NA>       US Mountain Standard Time
## 187               Eastern Daylight Time             Haiti Standard Time
## 188                                <NA>        SA Western Standard Time
## 189                                <NA>        SA Pacific Standard Time
## 190                                <NA>        SA Western Standard Time
## 191                                <NA>        SA Western Standard Time
## 192                                <NA>        Magallanes Standard Time
## 193               Central Daylight Time           Central Standard Time
## 194               Central Daylight Time           Central Standard Time
## 195                                <NA>        SA Eastern Standard Time
## 196                                <NA>    Canada Central Standard Time
## 197               Central Daylight Time           Central Standard Time
## 198                                <NA>        SA Pacific Standard Time
## 199                                <NA>         Argentina Standard Time
## 200      Northwest Mexico Daylight Time  Pacific Standard Time (Mexico)
## 201                                <NA>        SA Eastern Standard Time
## 202                   Chile Summer Time        Pacific SA Standard Time
## 203                                <NA>        SA Western Standard Time
## 204                                <NA>  E. South America Standard Time
## 205          East Greenland Summer Time            Azores Standard Time
## 206              Mountain Daylight Time          Mountain Standard Time
## 207                Alaska Daylight Time           Alaskan Standard Time
## 208                                <NA>        SA Western Standard Time
## 209          Newfoundland Daylight Time      Newfoundland Standard Time
## 210                                <NA>        SA Western Standard Time
## 211                                <NA>        SA Western Standard Time
## 212                                <NA>        SA Western Standard Time
## 213                                <NA>        SA Western Standard Time
## 214                                <NA>    Canada Central Standard Time
## 215                                <NA>   Central America Standard Time
## 216              Atlantic Daylight Time          Atlantic Standard Time
## 217               Eastern Daylight Time           Eastern Standard Time
## 218               Pacific Daylight Time  Pacific Standard Time (Mexico)
## 219               Eastern Daylight Time           Eastern Standard Time
## 220                                <NA>        SA Western Standard Time
## 221               Pacific Daylight Time           Pacific Standard Time
## 222                                <NA>        SA Western Standard Time
## 223                                <NA>             Yukon Standard Time
## 224               Central Daylight Time           Central Standard Time
## 225                Alaska Daylight Time           Alaskan Standard Time
## 226              Mountain Daylight Time          Mountain Standard Time
## 227                                <NA>   Central Pacific Standard Time
## 228                                <NA>           SE Asia Standard Time
## 229                                <NA>      West Pacific Standard Time
## 230    Australian Eastern Daylight Time          Tasmania Standard Time
## 231                                <NA>         West Asia Standard Time
## 232           New Zealand Daylight Time       New Zealand Standard Time
## 233                                <NA>        SA Eastern Standard Time
## 234                                <NA>        SA Eastern Standard Time
## 235           New Zealand Daylight Time       New Zealand Standard Time
## 236                                <NA>         E. Africa Standard Time
## 237                           GMT+02:00                            <NA>
## 238                                <NA>      Central Asia Standard Time
## 239        Central European Summer Time         W. Europe Standard Time
## 240                                <NA>              Arab Standard Time
## 241                                <NA>      Central Asia Standard Time
## 242        Eastern European Summer Time            Jordan Standard Time
## 243                                <NA>             Russia Time Zone 11
## 244                                <NA>         West Asia Standard Time
## 245                                <NA>         West Asia Standard Time
## 246                                <NA>         West Asia Standard Time
## 247                                <NA>         West Asia Standard Time
## 248                                <NA>         West Asia Standard Time
## 249                                <NA>            Arabic Standard Time
## 250                                <NA>              Arab Standard Time
## 251                                <NA>        Azerbaijan Standard Time
## 252                                <NA>           SE Asia Standard Time
## 253                                <NA>             Altai Standard Time
## 254        Eastern European Summer Time       Middle East Standard Time
## 255                                <NA>      Central Asia Standard Time
## 256                                <NA>         Singapore Standard Time
## 257                                <NA>             India Standard Time
## 258                                <NA>       Transbaikal Standard Time
## 259                                <NA>       Ulaanbaatar Standard Time
## 260                                <NA>             China Standard Time
## 261                                <NA>             China Standard Time
## 262                                <NA>         Sri Lanka Standard Time
## 263                                <NA>        Bangladesh Standard Time
## 264        Eastern European Summer Time             Syria Standard Time
## 265                                <NA>        Bangladesh Standard Time
## 266                                <NA>             Tokyo Standard Time
## 267                                <NA>           Arabian Standard Time
## 268                                <NA>         West Asia Standard Time
## 269                           GMT+03:00               GTB Standard Time
## 270        Eastern European Summer Time         West Bank Standard Time
## 271                                <NA>             China Standard Time
## 272        Eastern European Summer Time         West Bank Standard Time
## 273                                <NA>           SE Asia Standard Time
## 274                                <NA>             China Standard Time
## 275                                <NA>       W. Mongolia Standard Time
## 276                                <NA>   North Asia East Standard Time
## 277                                <NA>            Turkey Standard Time
## 278                                <NA>           SE Asia Standard Time
## 279                                <NA>             Tokyo Standard Time
## 280                Israel Daylight Time            Israel Standard Time
## 281                                <NA>       Afghanistan Standard Time
## 282                                <NA>             Russia Time Zone 11
## 283                                <NA>          Pakistan Standard Time
## 284                                <NA>      Central Asia Standard Time
## 285                                <NA>             Nepal Standard Time
## 286                                <NA>             Nepal Standard Time
## 287                                <NA>           Yakutsk Standard Time
## 288                                <NA>             India Standard Time
## 289                                <NA>        North Asia Standard Time
## 290                                <NA>         Singapore Standard Time
## 291                                <NA>         Singapore Standard Time
## 292                                <NA>              Arab Standard Time
## 293                                <NA>             China Standard Time
## 294                                <NA>             China Standard Time
## 295                                <NA>           Magadan Standard Time
## 296                                <NA>         Singapore Standard Time
## 297                                <NA>         Singapore Standard Time
## 298                                <NA>           Arabian Standard Time
## 299        Eastern European Summer Time               GTB Standard Time
## 300                                <NA>        North Asia Standard Time
## 301                                <NA>   N. Central Asia Standard Time
## 302                                <NA>              Omsk Standard Time
## 303                                <NA>         West Asia Standard Time
## 304                                <NA>           SE Asia Standard Time
## 305                                <NA>           SE Asia Standard Time
## 306                                <NA>       North Korea Standard Time
## 307                                <NA>              Arab Standard Time
## 308                                <NA>      Central Asia Standard Time
## 309                                <NA>         Qyzylorda Standard Time
## 310                                <NA>           Myanmar Standard Time
## 311                                <NA>              Arab Standard Time
## 312                                <NA>           SE Asia Standard Time
## 313                                <NA>          Sakhalin Standard Time
## 314                                <NA>         West Asia Standard Time
## 315                                <NA>             Korea Standard Time
## 316                                <NA>             China Standard Time
## 317                                <NA>         Singapore Standard Time
## 318                                <NA>             Russia Time Zone 10
## 319                                <NA>            Taipei Standard Time
## 320                                <NA>         West Asia Standard Time
## 321                                <NA>          Georgian Standard Time
## 322                  Iran Daylight Time              Iran Standard Time
## 323                Israel Daylight Time            Israel Standard Time
## 324                                <NA>        Bangladesh Standard Time
## 325                                <NA>        Bangladesh Standard Time
## 326                                <NA>             Tokyo Standard Time
## 327                                <NA>             Tomsk Standard Time
## 328                                <NA>         Singapore Standard Time
## 329                                <NA>       Ulaanbaatar Standard Time
## 330                                <NA>       Ulaanbaatar Standard Time
## 331                                <NA>      Central Asia Standard Time
## 332                                <NA>       Vladivostok Standard Time
## 333                                <NA>           SE Asia Standard Time
## 334                                <NA>       Vladivostok Standard Time
## 335                                <NA>           Yakutsk Standard Time
## 336                                <NA>           Myanmar Standard Time
## 337                                <NA>      Ekaterinburg Standard Time
## 338                                <NA>          Caucasus Standard Time
## 339                  Azores Summer Time            Azores Standard Time
## 340              Atlantic Daylight Time          Atlantic Standard Time
## 341        Western European Summer Time               GMT Standard Time
## 342                                <NA>        Cape Verde Standard Time
## 343        Western European Summer Time               GMT Standard Time
## 344        Western European Summer Time               GMT Standard Time
## 345        Central European Summer Time         W. Europe Standard Time
## 346        Western European Summer Time               GMT Standard Time
## 347                                <NA>         Greenwich Standard Time
## 348                                <NA>                          UTC-02
## 349                                <NA>         Greenwich Standard Time
## 350                                <NA>        SA Eastern Standard Time
## 351    Australian Eastern Daylight Time       AUS Eastern Standard Time
## 352    Australian Central Daylight Time    Cen. Australia Standard Time
## 353                                <NA>      E. Australia Standard Time
## 354    Australian Central Daylight Time    Cen. Australia Standard Time
## 355    Australian Eastern Daylight Time       AUS Eastern Standard Time
## 356    Australian Eastern Daylight Time          Tasmania Standard Time
## 357                                <NA>       AUS Central Standard Time
## 358                                <NA>    Aus Central W. Standard Time
## 359    Australian Eastern Daylight Time          Tasmania Standard Time
## 360             Lord Howe Daylight Time         Lord Howe Standard Time
## 361                                <NA>      E. Australia Standard Time
## 362             Lord Howe Daylight Time         Lord Howe Standard Time
## 363    Australian Eastern Daylight Time       AUS Eastern Standard Time
## 364    Australian Eastern Daylight Time       AUS Eastern Standard Time
## 365                                <NA>       AUS Central Standard Time
## 366                                <NA>      W. Australia Standard Time
## 367                                <NA>      E. Australia Standard Time
## 368    Australian Central Daylight Time    Cen. Australia Standard Time
## 369    Australian Eastern Daylight Time       AUS Eastern Standard Time
## 370    Australian Eastern Daylight Time          Tasmania Standard Time
## 371    Australian Eastern Daylight Time       AUS Eastern Standard Time
## 372                                <NA>      W. Australia Standard Time
## 373    Australian Central Daylight Time    Cen. Australia Standard Time
## 374                                <NA>  E. South America Standard Time
## 375                                <NA>        Bangladesh Standard Time
## 376                                <NA>        SA Pacific Standard Time
## 377                                <NA>                          UTC-02
## 378                                <NA>  E. South America Standard Time
## 379                                <NA>        SA Western Standard Time
## 380                                <NA>      South Africa Standard Time
## 381                           GMT+02:00                            <NA>
## 382          Newfoundland Daylight Time      Newfoundland Standard Time
## 383               Central Daylight Time           Central Standard Time
## 384               Central Daylight Time           Central Standard Time
## 385                                <NA>             China Standard Time
## 386              Atlantic Daylight Time          Atlantic Standard Time
## 387               Central Daylight Time           Central Standard Time
## 388                                <NA>    Canada Central Standard Time
## 389               Eastern Daylight Time           Eastern Standard Time
## 390              Mountain Daylight Time          Mountain Standard Time
## 391          Newfoundland Daylight Time      Newfoundland Standard Time
## 392               Pacific Daylight Time           Pacific Standard Time
## 393                                <NA>    Canada Central Standard Time
## 394                                <NA>             Yukon Standard Time
## 395                   Chile Summer Time        Pacific SA Standard Time
## 396           Easter Island Summer Time     Easter Island Standard Time
## 397                  Cuba Daylight Time              Cuba Standard Time
## 398                                <NA>         E. Africa Standard Time
## 399        Central European Summer Time           Romance Standard Time
## 400                           GMT+03:00                            <NA>
## 401                                <NA>        SA Pacific Standard Time
## 402               Eastern Daylight Time           Eastern Standard Time
## 403                                <NA>             Egypt Standard Time
## 404                 Irish Standard Time               GMT Standard Time
## 405                                <NA>                             UTC
## 406                                <NA>                             UTC
## 407                                <NA>        Cape Verde Standard Time
## 408                                <NA>          Hawaiian Standard Time
## 409                                <NA>                          UTC-11
## 410                                <NA>          Dateline Standard Time
## 411                                <NA>                          UTC-02
## 412                                <NA>        SA Eastern Standard Time
## 413                                <NA>        SA Western Standard Time
## 414                                <NA>        SA Pacific Standard Time
## 415                                <NA>   Central America Standard Time
## 416                                <NA>       US Mountain Standard Time
## 417                                <NA>                          UTC-08
## 418                                <NA>                          UTC-09
## 419                                <NA>                             UTC
## 420                                <NA> W. Central Africa Standard Time
## 421                                <NA>      West Pacific Standard Time
## 422                                <NA>   Central Pacific Standard Time
## 423                                <NA>                          UTC+12
## 424                                <NA>                          UTC+13
## 425                                <NA>      Line Islands Standard Time
## 426                                <NA>      South Africa Standard Time
## 427                                <NA>         E. Africa Standard Time
## 428                                <NA>           Arabian Standard Time
## 429                                <NA>         West Asia Standard Time
## 430                                <NA>      Central Asia Standard Time
## 431                                <NA>           SE Asia Standard Time
## 432                                <NA>         Singapore Standard Time
## 433                                <NA>             Tokyo Standard Time
## 434                                <NA>                             UTC
## 435                                <NA>                             UTC
## 436                                <NA>                             UTC
## 437                                <NA>                             UTC
## 438                                <NA>                             UTC
## 439                                <NA>                             UTC
## 440        Central European Summer Time         W. Europe Standard Time
## 441        Central European Summer Time         W. Europe Standard Time
## 442                                <NA>         Astrakhan Standard Time
## 443        Eastern European Summer Time               GTB Standard Time
## 444                 British Summer Time               GMT Standard Time
## 445        Central European Summer Time    Central Europe Standard Time
## 446        Central European Summer Time         W. Europe Standard Time
## 447        Central European Summer Time    Central Europe Standard Time
## 448        Central European Summer Time           Romance Standard Time
## 449        Eastern European Summer Time               GTB Standard Time
## 450        Central European Summer Time    Central Europe Standard Time
## 451        Central European Summer Time         W. Europe Standard Time
## 452        Eastern European Summer Time         E. Europe Standard Time
## 453        Central European Summer Time           Romance Standard Time
## 454                 Irish Standard Time               GMT Standard Time
## 455        Central European Summer Time         W. Europe Standard Time
## 456                           GMT+01:00               GMT Standard Time
## 457        Eastern European Summer Time               FLE Standard Time
## 458                           GMT+01:00               GMT Standard Time
## 459                                <NA>            Turkey Standard Time
## 460                           GMT+01:00               GMT Standard Time
## 461                                <NA>       Kaliningrad Standard Time
## 462        Eastern European Summer Time               FLE Standard Time
## 463                                <NA>           Russian Standard Time
## 464        Western European Summer Time               GMT Standard Time
## 465        Central European Summer Time    Central Europe Standard Time
## 466                 British Summer Time               GMT Standard Time
## 467        Central European Summer Time         W. Europe Standard Time
## 468        Central European Summer Time           Romance Standard Time
## 469        Central European Summer Time         W. Europe Standard Time
## 470        Eastern European Summer Time               FLE Standard Time
## 471                                <NA>           Belarus Standard Time
## 472        Central European Summer Time         W. Europe Standard Time
## 473                                <NA>           Russian Standard Time
## 474        Eastern European Summer Time               GTB Standard Time
## 475        Central European Summer Time         W. Europe Standard Time
## 476        Central European Summer Time           Romance Standard Time
## 477        Central European Summer Time    Central Europe Standard Time
## 478        Central European Summer Time    Central Europe Standard Time
## 479        Eastern European Summer Time               FLE Standard Time
## 480        Central European Summer Time         W. Europe Standard Time
## 481                                <NA>              Russia Time Zone 3
## 482        Central European Summer Time         W. Europe Standard Time
## 483        Central European Summer Time  Central European Standard Time
## 484                                <NA>           Saratov Standard Time
## 485                                <NA>           Russian Standard Time
## 486        Central European Summer Time  Central European Standard Time
## 487        Eastern European Summer Time               FLE Standard Time
## 488        Central European Summer Time         W. Europe Standard Time
## 489        Eastern European Summer Time               FLE Standard Time
## 490        Central European Summer Time    Central Europe Standard Time
## 491        Eastern European Summer Time         E. Europe Standard Time
## 492                                <NA>         Astrakhan Standard Time
## 493        Eastern European Summer Time               FLE Standard Time
## 494        Central European Summer Time         W. Europe Standard Time
## 495        Central European Summer Time         W. Europe Standard Time
## 496        Central European Summer Time         W. Europe Standard Time
## 497        Eastern European Summer Time               FLE Standard Time
## 498                                <NA>         Volgograd Standard Time
## 499        Central European Summer Time  Central European Standard Time
## 500        Central European Summer Time  Central European Standard Time
## 501        Eastern European Summer Time               FLE Standard Time
## 502        Central European Summer Time         W. Europe Standard Time
## 503                                <NA>                            <NA>
## 504                 British Summer Time               GMT Standard Time
## 505                 British Summer Time               GMT Standard Time
## 506                                <NA>                             UTC
## 507                                <NA>                             UTC
## 508                                <NA>                             UTC
## 509                                <NA>                             UTC
## 510                                <NA>                             UTC
## 511                                <NA>          Hawaiian Standard Time
## 512                                <NA>             China Standard Time
## 513               Eastern Daylight Time        US Eastern Standard Time
## 514                                <NA>             India Standard Time
## 515                                <NA>         Greenwich Standard Time
## 516                                <NA>         E. Africa Standard Time
## 517                                <NA>      Central Asia Standard Time
## 518                                <NA>           SE Asia Standard Time
## 519                                <NA>           Myanmar Standard Time
## 520                                <NA>         E. Africa Standard Time
## 521                                <NA>         West Asia Standard Time
## 522                                <NA>         Mauritius Standard Time
## 523                                <NA>         West Asia Standard Time
## 524                                <NA>         Mauritius Standard Time
## 525                                <NA>         E. Africa Standard Time
## 526                                <NA>         Mauritius Standard Time
## 527                  Iran Daylight Time              Iran Standard Time
## 528                Israel Daylight Time            Israel Standard Time
## 529                                <NA>             Tokyo Standard Time
## 530                                <NA>        SA Pacific Standard Time
## 531                                <NA>             Tokyo Standard Time
## 532                                <NA>                          UTC+12
## 533                                <NA>             Libya Standard Time
## 534                           GMT+02:00                            <NA>
## 535                  Apia Daylight Time             Samoa Standard Time
## 536                                <NA>       US Mountain Standard Time
## 537              Mountain Daylight Time          Mountain Standard Time
## 538               Pacific Daylight Time  Pacific Standard Time (Mexico)
## 539       Mexican Pacific Daylight Time Mountain Standard Time (Mexico)
## 540               Central Daylight Time  Central Standard Time (Mexico)
## 541                                <NA>          Caucasus Standard Time
## 542           New Zealand Daylight Time       New Zealand Standard Time
## 543           New Zealand Daylight Time       New Zealand Standard Time
## 544               Chatham Daylight Time   Chatham Islands Standard Time
## 545              Mountain Daylight Time          Mountain Standard Time
## 546                                <NA>          Pakistan Standard Time
## 547                                <NA>       US Mountain Standard Time
## 548                                <NA>             China Standard Time
## 549                                <NA>        SA Western Standard Time
## 550               Pacific Daylight Time           Pacific Standard Time
## 551               Pacific Daylight Time           Pacific Standard Time
## 552                  Apia Daylight Time             Samoa Standard Time
## 553           New Zealand Daylight Time       New Zealand Standard Time
## 554                                <NA>      Bougainville Standard Time
## 555               Chatham Daylight Time   Chatham Islands Standard Time
## 556                                <NA>      West Pacific Standard Time
## 557           Easter Island Summer Time     Easter Island Standard Time
## 558                                <NA>   Central Pacific Standard Time
## 559                                <NA>                          UTC+13
## 560                                <NA>                          UTC+13
## 561                    Fiji Summer Time              Fiji Standard Time
## 562                                <NA>                          UTC+12
## 563                                <NA>   Central America Standard Time
## 564                                <NA>                          UTC-09
## 565                                <NA>   Central Pacific Standard Time
## 566                                <NA>      West Pacific Standard Time
## 567                                <NA>          Hawaiian Standard Time
## 568                                <NA>          Hawaiian Standard Time
## 569                                <NA>      Line Islands Standard Time
## 570                                <NA>   Central Pacific Standard Time
## 571                                <NA>                          UTC+12
## 572                                <NA>                          UTC+12
## 573                                <NA>         Marquesas Standard Time
## 574                                <NA>                          UTC-11
## 575                                <NA>                          UTC+12
## 576                                <NA>                          UTC-11
## 577        Norfolk Island Daylight Time           Norfolk Standard Time
## 578                                <NA>   Central Pacific Standard Time
## 579                                <NA>                          UTC-11
## 580                                <NA>             Tokyo Standard Time
## 581                                <NA>                          UTC-08
## 582                                <NA>   Central Pacific Standard Time
## 583                                <NA>   Central Pacific Standard Time
## 584                                <NA>      West Pacific Standard Time
## 585                                <NA>          Hawaiian Standard Time
## 586                                <NA>      West Pacific Standard Time
## 587                                <NA>                          UTC-11
## 588                                <NA>          Hawaiian Standard Time
## 589                                <NA>                          UTC+12
## 590                                <NA>             Tonga Standard Time
## 591                                <NA>      West Pacific Standard Time
## 592                                <NA>                          UTC+12
## 593                                <NA>                          UTC+12
## 594                                <NA>      West Pacific Standard Time
## 595        Central European Summer Time  Central European Standard Time
## 596        Western European Summer Time               GMT Standard Time
## 597                                <NA>            Taipei Standard Time
## 598                                <NA>             Korea Standard Time
## 599                                <NA>   Central Pacific Standard Time
## 600                                <NA>         Singapore Standard Time
## 601                                <NA>                            <NA>
## 602                           GMT-03:00                            <NA>
## 603                                <NA>                            <NA>
## 604                           GMT-05:00                            <NA>
## 605                                <NA>                            <NA>
## 606                           GMT-04:00                            <NA>
## 607                                <NA>                            <NA>
## 608                                <NA>                            <NA>
## 609                           GMT-06:00                            <NA>
## 610                                <NA>                            <NA>
## 611                           GMT-07:00                            <NA>
## 612                                <NA>                            <NA>
## 613                           GMT-08:00                            <NA>
## 614                                <NA>            Turkey Standard Time
## 615                                <NA>                             UTC
## 616                Alaska Daylight Time           Alaskan Standard Time
## 617       Hawaii-Aleutian Daylight Time          Aleutian Standard Time
## 618                                <NA>       US Mountain Standard Time
## 619               Central Daylight Time           Central Standard Time
## 620               Eastern Daylight Time        US Eastern Standard Time
## 621               Eastern Daylight Time           Eastern Standard Time
## 622                                <NA>          Hawaiian Standard Time
## 623               Central Daylight Time           Central Standard Time
## 624               Eastern Daylight Time           Eastern Standard Time
## 625              Mountain Daylight Time          Mountain Standard Time
## 626               Pacific Daylight Time           Pacific Standard Time
## 627               Pacific Daylight Time           Pacific Standard Time
## 628                                <NA>                          UTC-11
## 629                                <NA>                             UTC
## 630                                <NA>                             UTC
## 631                                <NA>           SE Asia Standard Time
## 632                                <NA>           Russian Standard Time
## 633                           GMT+01:00                            <NA>
## 634                                <NA>                             UTC
##      RawOffset UsesDaylightTime
## 2         9.50            FALSE
## 2100     10.00             TRUE
## 3        -3.00            FALSE
## 4         2.00            FALSE
## 5        -9.00             TRUE
## 6         0.00            FALSE
## 7         0.00            FALSE
## 8         3.00            FALSE
## 9         1.00            FALSE
## 10        3.00            FALSE
## 11        3.00            FALSE
## 12        0.00            FALSE
## 13        1.00            FALSE
## 14        0.00            FALSE
## 15        0.00            FALSE
## 16        2.00            FALSE
## 17        1.00            FALSE
## 18        2.00            FALSE
## 19        2.00            FALSE
## 20        0.00             TRUE
## 21        1.00             TRUE
## 22        0.00            FALSE
## 23        0.00            FALSE
## 24        3.00            FALSE
## 25        3.00            FALSE
## 26        1.00            FALSE
## 27        0.00             TRUE
## 28        0.00            FALSE
## 29        2.00            FALSE
## 30        2.00            FALSE
## 31        2.00            FALSE
## 32        2.00            FALSE
## 33        3.00            FALSE
## 34        2.00            FALSE
## 35        2.00            FALSE
## 36        1.00            FALSE
## 37        1.00            FALSE
## 38        1.00            FALSE
## 39        0.00            FALSE
## 40        1.00            FALSE
## 41        2.00            FALSE
## 42        2.00            FALSE
## 43        1.00            FALSE
## 44        2.00            FALSE
## 45        2.00            FALSE
## 46        2.00            FALSE
## 47        3.00            FALSE
## 48        0.00            FALSE
## 49        3.00            FALSE
## 50        1.00            FALSE
## 51        1.00            FALSE
## 52        0.00            FALSE
## 53        0.00            FALSE
## 54        1.00            FALSE
## 55        0.00            FALSE
## 56        0.00            FALSE
## 57        2.00            FALSE
## 58        1.00            FALSE
## 59        2.00            FALSE
## 60      -10.00             TRUE
## 61       -9.00             TRUE
## 62       -4.00            FALSE
## 63       -4.00            FALSE
## 64       -3.00            FALSE
## 65       -3.00            FALSE
## 66       -3.00            FALSE
## 67       -3.00            FALSE
## 68       -3.00            FALSE
## 69       -3.00            FALSE
## 70       -3.00            FALSE
## 71       -3.00            FALSE
## 72       -3.00            FALSE
## 73       -3.00            FALSE
## 74       -3.00            FALSE
## 75       -3.00            FALSE
## 76       -3.00            FALSE
## 77       -3.00            FALSE
## 78       -4.00            FALSE
## 79       -4.00             TRUE
## 80       -5.00            FALSE
## 81      -10.00             TRUE
## 82       -3.00            FALSE
## 83       -6.00             TRUE
## 84       -4.00            FALSE
## 85       -3.00            FALSE
## 86       -6.00            FALSE
## 87       -4.00            FALSE
## 88       -4.00            FALSE
## 89       -5.00            FALSE
## 90       -7.00             TRUE
## 91       -3.00            FALSE
## 92       -7.00             TRUE
## 93       -4.00            FALSE
## 94       -5.00            FALSE
## 95       -4.00            FALSE
## 96       -3.00            FALSE
## 97       -3.00            FALSE
## 98       -5.00            FALSE
## 99       -6.00             TRUE
## 100      -7.00             TRUE
## 101      -5.00            FALSE
## 102      -3.00            FALSE
## 103      -6.00            FALSE
## 104      -7.00            FALSE
## 105      -4.00            FALSE
## 106      -4.00            FALSE
## 107       0.00            FALSE
## 108      -7.00            FALSE
## 109      -7.00            FALSE
## 110      -7.00             TRUE
## 111      -5.00             TRUE
## 112      -4.00            FALSE
## 113      -7.00             TRUE
## 114      -5.00            FALSE
## 115      -6.00            FALSE
## 116      -8.00             TRUE
## 117      -7.00            FALSE
## 118      -5.00             TRUE
## 119      -3.00            FALSE
## 120      -4.00             TRUE
## 121      -3.00             TRUE
## 122      -4.00             TRUE
## 123      -5.00             TRUE
## 124      -4.00            FALSE
## 125      -4.00            FALSE
## 126      -6.00            FALSE
## 127      -5.00            FALSE
## 128      -4.00            FALSE
## 129      -4.00             TRUE
## 130      -5.00             TRUE
## 131      -7.00            FALSE
## 132      -5.00             TRUE
## 133      -6.00             TRUE
## 134      -5.00             TRUE
## 135      -5.00             TRUE
## 136      -6.00             TRUE
## 137      -5.00             TRUE
## 138      -5.00             TRUE
## 139      -5.00             TRUE
## 140      -5.00             TRUE
## 141      -7.00             TRUE
## 142      -5.00             TRUE
## 143      -5.00            FALSE
## 144      -3.00            FALSE
## 145      -9.00             TRUE
## 146      -5.00             TRUE
## 147      -5.00             TRUE
## 148      -6.00             TRUE
## 149      -4.00            FALSE
## 150      -4.00            FALSE
## 151      -5.00            FALSE
## 152      -8.00             TRUE
## 153      -5.00             TRUE
## 154      -4.00            FALSE
## 155      -3.00            FALSE
## 156      -6.00            FALSE
## 157      -4.00            FALSE
## 158      -4.00            FALSE
## 159      -4.00            FALSE
## 160      -6.00             TRUE
## 161      -7.00             TRUE
## 162      -3.00            FALSE
## 163      -6.00             TRUE
## 164      -6.00             TRUE
## 165      -9.00             TRUE
## 166      -6.00             TRUE
## 167      -3.00             TRUE
## 168      -4.00             TRUE
## 169      -6.00             TRUE
## 170      -3.00            FALSE
## 171      -5.00             TRUE
## 172      -4.00            FALSE
## 173      -5.00             TRUE
## 174      -5.00             TRUE
## 175      -5.00             TRUE
## 176      -9.00             TRUE
## 177      -2.00            FALSE
## 178      -6.00             TRUE
## 179      -6.00             TRUE
## 180      -6.00             TRUE
## 181      -3.00             TRUE
## 182      -7.00             TRUE
## 183      -5.00            FALSE
## 184      -5.00             TRUE
## 185      -3.00            FALSE
## 186      -7.00            FALSE
## 187      -5.00             TRUE
## 188      -4.00            FALSE
## 189      -5.00            FALSE
## 190      -4.00            FALSE
## 191      -4.00            FALSE
## 192      -3.00            FALSE
## 193      -6.00             TRUE
## 194      -6.00             TRUE
## 195      -3.00            FALSE
## 196      -6.00            FALSE
## 197      -6.00             TRUE
## 198      -5.00            FALSE
## 199      -3.00            FALSE
## 200      -8.00             TRUE
## 201      -3.00            FALSE
## 202      -4.00             TRUE
## 203      -4.00            FALSE
## 204      -3.00            FALSE
## 205      -1.00             TRUE
## 206      -7.00             TRUE
## 207      -9.00             TRUE
## 208      -4.00            FALSE
## 209      -3.50             TRUE
## 210      -4.00            FALSE
## 211      -4.00            FALSE
## 212      -4.00            FALSE
## 213      -4.00            FALSE
## 214      -6.00            FALSE
## 215      -6.00            FALSE
## 216      -4.00             TRUE
## 217      -5.00             TRUE
## 218      -8.00             TRUE
## 219      -5.00             TRUE
## 220      -4.00            FALSE
## 221      -8.00             TRUE
## 222      -4.00            FALSE
## 223      -7.00            FALSE
## 224      -6.00             TRUE
## 225      -9.00             TRUE
## 226      -7.00             TRUE
## 227      11.00            FALSE
## 228       7.00            FALSE
## 229      10.00            FALSE
## 230      10.00             TRUE
## 231       5.00            FALSE
## 232      12.00             TRUE
## 233      -3.00            FALSE
## 234      -3.00            FALSE
## 235      12.00             TRUE
## 236       3.00            FALSE
## 237       0.00             TRUE
## 238       6.00            FALSE
## 239       1.00             TRUE
## 240       3.00            FALSE
## 241       6.00            FALSE
## 242       2.00             TRUE
## 243      12.00            FALSE
## 244       5.00            FALSE
## 245       5.00            FALSE
## 246       5.00            FALSE
## 247       5.00            FALSE
## 248       5.00            FALSE
## 249       3.00            FALSE
## 250       3.00            FALSE
## 251       4.00            FALSE
## 252       7.00            FALSE
## 253       7.00            FALSE
## 254       2.00             TRUE
## 255       6.00            FALSE
## 256       8.00            FALSE
## 257       5.50            FALSE
## 258       9.00            FALSE
## 259       8.00            FALSE
## 260       8.00            FALSE
## 261       8.00            FALSE
## 262       5.50            FALSE
## 263       6.00            FALSE
## 264       2.00             TRUE
## 265       6.00            FALSE
## 266       9.00            FALSE
## 267       4.00            FALSE
## 268       5.00            FALSE
## 269       2.00             TRUE
## 270       2.00             TRUE
## 271       8.00            FALSE
## 272       2.00             TRUE
## 273       7.00            FALSE
## 274       8.00            FALSE
## 275       7.00            FALSE
## 276       8.00            FALSE
## 277       3.00            FALSE
## 278       7.00            FALSE
## 279       9.00            FALSE
## 280       2.00             TRUE
## 281       4.50            FALSE
## 282      12.00            FALSE
## 283       5.00            FALSE
## 284       6.00            FALSE
## 285       5.75            FALSE
## 286       5.75            FALSE
## 287       9.00            FALSE
## 288       5.50            FALSE
## 289       7.00            FALSE
## 290       8.00            FALSE
## 291       8.00            FALSE
## 292       3.00            FALSE
## 293       8.00            FALSE
## 294       8.00            FALSE
## 295      11.00            FALSE
## 296       8.00            FALSE
## 297       8.00            FALSE
## 298       4.00            FALSE
## 299       2.00             TRUE
## 300       7.00            FALSE
## 301       7.00            FALSE
## 302       6.00            FALSE
## 303       5.00            FALSE
## 304       7.00            FALSE
## 305       7.00            FALSE
## 306       9.00            FALSE
## 307       3.00            FALSE
## 308       6.00            FALSE
## 309       5.00            FALSE
## 310       6.50            FALSE
## 311       3.00            FALSE
## 312       7.00            FALSE
## 313      11.00            FALSE
## 314       5.00            FALSE
## 315       9.00            FALSE
## 316       8.00            FALSE
## 317       8.00            FALSE
## 318      11.00            FALSE
## 319       8.00            FALSE
## 320       5.00            FALSE
## 321       4.00            FALSE
## 322       3.50             TRUE
## 323       2.00             TRUE
## 324       6.00            FALSE
## 325       6.00            FALSE
## 326       9.00            FALSE
## 327       7.00            FALSE
## 328       8.00            FALSE
## 329       8.00            FALSE
## 330       8.00            FALSE
## 331       6.00            FALSE
## 332      10.00            FALSE
## 333       7.00            FALSE
## 334      10.00            FALSE
## 335       9.00            FALSE
## 336       6.50            FALSE
## 337       5.00            FALSE
## 338       4.00            FALSE
## 339      -1.00             TRUE
## 340      -4.00             TRUE
## 341       0.00             TRUE
## 342      -1.00            FALSE
## 343       0.00             TRUE
## 344       0.00             TRUE
## 345       1.00             TRUE
## 346       0.00             TRUE
## 347       0.00            FALSE
## 348      -2.00            FALSE
## 349       0.00            FALSE
## 350      -3.00            FALSE
## 351      10.00             TRUE
## 352       9.50             TRUE
## 353      10.00            FALSE
## 354       9.50             TRUE
## 355      10.00             TRUE
## 356      10.00             TRUE
## 357       9.50            FALSE
## 358       8.75            FALSE
## 359      10.00             TRUE
## 360      10.50             TRUE
## 361      10.00            FALSE
## 362      10.50             TRUE
## 363      10.00             TRUE
## 364      10.00             TRUE
## 365       9.50            FALSE
## 366       8.00            FALSE
## 367      10.00            FALSE
## 368       9.50             TRUE
## 369      10.00             TRUE
## 370      10.00             TRUE
## 371      10.00             TRUE
## 372       8.00            FALSE
## 373       9.50             TRUE
## 374      -3.00            FALSE
## 375       6.00            FALSE
## 376      -5.00            FALSE
## 377      -2.00            FALSE
## 378      -3.00            FALSE
## 379      -4.00            FALSE
## 380       2.00            FALSE
## 381       1.00             TRUE
## 382      -3.50             TRUE
## 383      -6.00             TRUE
## 384      -6.00             TRUE
## 385       8.00            FALSE
## 386      -4.00             TRUE
## 387      -6.00             TRUE
## 388      -6.00            FALSE
## 389      -5.00             TRUE
## 390      -7.00             TRUE
## 391      -3.50             TRUE
## 392      -8.00             TRUE
## 393      -6.00            FALSE
## 394      -7.00            FALSE
## 395      -4.00             TRUE
## 396      -6.00             TRUE
## 397      -5.00             TRUE
## 398       3.00            FALSE
## 399       1.00             TRUE
## 400       2.00             TRUE
## 401      -5.00            FALSE
## 402      -5.00             TRUE
## 403       2.00            FALSE
## 404       0.00             TRUE
## 405       0.00            FALSE
## 406       0.00            FALSE
## 407      -1.00            FALSE
## 408     -10.00            FALSE
## 409     -11.00            FALSE
## 410     -12.00            FALSE
## 411      -2.00            FALSE
## 412      -3.00            FALSE
## 413      -4.00            FALSE
## 414      -5.00            FALSE
## 415      -6.00            FALSE
## 416      -7.00            FALSE
## 417      -8.00            FALSE
## 418      -9.00            FALSE
## 419       0.00            FALSE
## 420       1.00            FALSE
## 421      10.00            FALSE
## 422      11.00            FALSE
## 423      12.00            FALSE
## 424      13.00            FALSE
## 425      14.00            FALSE
## 426       2.00            FALSE
## 427       3.00            FALSE
## 428       4.00            FALSE
## 429       5.00            FALSE
## 430       6.00            FALSE
## 431       7.00            FALSE
## 432       8.00            FALSE
## 433       9.00            FALSE
## 434       0.00            FALSE
## 435       0.00            FALSE
## 436       0.00            FALSE
## 437       0.00            FALSE
## 438       0.00            FALSE
## 439       0.00            FALSE
## 440       1.00             TRUE
## 441       1.00             TRUE
## 442       4.00            FALSE
## 443       2.00             TRUE
## 444       0.00             TRUE
## 445       1.00             TRUE
## 446       1.00             TRUE
## 447       1.00             TRUE
## 448       1.00             TRUE
## 449       2.00             TRUE
## 450       1.00             TRUE
## 451       1.00             TRUE
## 452       2.00             TRUE
## 453       1.00             TRUE
## 454       0.00             TRUE
## 455       1.00             TRUE
## 456       0.00             TRUE
## 457       2.00             TRUE
## 458       0.00             TRUE
## 459       3.00            FALSE
## 460       0.00             TRUE
## 461       2.00            FALSE
## 462       2.00             TRUE
## 463       3.00            FALSE
## 464       0.00             TRUE
## 465       1.00             TRUE
## 466       0.00             TRUE
## 467       1.00             TRUE
## 468       1.00             TRUE
## 469       1.00             TRUE
## 470       2.00             TRUE
## 471       3.00            FALSE
## 472       1.00             TRUE
## 473       3.00            FALSE
## 474       2.00             TRUE
## 475       1.00             TRUE
## 476       1.00             TRUE
## 477       1.00             TRUE
## 478       1.00             TRUE
## 479       2.00             TRUE
## 480       1.00             TRUE
## 481       4.00            FALSE
## 482       1.00             TRUE
## 483       1.00             TRUE
## 484       4.00            FALSE
## 485       3.00            FALSE
## 486       1.00             TRUE
## 487       2.00             TRUE
## 488       1.00             TRUE
## 489       2.00             TRUE
## 490       1.00             TRUE
## 491       2.00             TRUE
## 492       4.00            FALSE
## 493       2.00             TRUE
## 494       1.00             TRUE
## 495       1.00             TRUE
## 496       1.00             TRUE
## 497       2.00             TRUE
## 498       3.00            FALSE
## 499       1.00             TRUE
## 500       1.00             TRUE
## 501       2.00             TRUE
## 502       1.00             TRUE
## 503       0.00            FALSE
## 504       0.00             TRUE
## 505       0.00             TRUE
## 506       0.00            FALSE
## 507       0.00            FALSE
## 508       0.00            FALSE
## 509       0.00            FALSE
## 510       0.00            FALSE
## 511     -10.00            FALSE
## 512       8.00            FALSE
## 513      -5.00             TRUE
## 514       5.50            FALSE
## 515       0.00            FALSE
## 516       3.00            FALSE
## 517       6.00            FALSE
## 518       7.00            FALSE
## 519       6.50            FALSE
## 520       3.00            FALSE
## 521       5.00            FALSE
## 522       4.00            FALSE
## 523       5.00            FALSE
## 524       4.00            FALSE
## 525       3.00            FALSE
## 526       4.00            FALSE
## 527       3.50             TRUE
## 528       2.00             TRUE
## 529       9.00            FALSE
## 530      -5.00            FALSE
## 531       9.00            FALSE
## 532      12.00            FALSE
## 533       2.00            FALSE
## 534       1.00             TRUE
## 535      13.00             TRUE
## 536      -7.00            FALSE
## 537      -7.00             TRUE
## 538      -8.00             TRUE
## 539      -7.00             TRUE
## 540      -6.00             TRUE
## 541       4.00            FALSE
## 542      12.00             TRUE
## 543      12.00             TRUE
## 544      12.75             TRUE
## 545      -7.00             TRUE
## 546       5.00            FALSE
## 547      -7.00            FALSE
## 548       8.00            FALSE
## 549      -4.00            FALSE
## 550      -8.00             TRUE
## 551      -8.00             TRUE
## 552      13.00             TRUE
## 553      12.00             TRUE
## 554      11.00            FALSE
## 555      12.75             TRUE
## 556      10.00            FALSE
## 557      -6.00             TRUE
## 558      11.00            FALSE
## 559      13.00            FALSE
## 560      13.00            FALSE
## 561      12.00             TRUE
## 562      12.00            FALSE
## 563      -6.00            FALSE
## 564      -9.00            FALSE
## 565      11.00            FALSE
## 566      10.00            FALSE
## 567     -10.00            FALSE
## 568     -10.00            FALSE
## 569      14.00            FALSE
## 570      11.00            FALSE
## 571      12.00            FALSE
## 572      12.00            FALSE
## 573      -9.50            FALSE
## 574     -11.00            FALSE
## 575      12.00            FALSE
## 576     -11.00            FALSE
## 577      11.00             TRUE
## 578      11.00            FALSE
## 579     -11.00            FALSE
## 580       9.00            FALSE
## 581      -8.00            FALSE
## 582      11.00            FALSE
## 583      11.00            FALSE
## 584      10.00            FALSE
## 585     -10.00            FALSE
## 586      10.00            FALSE
## 587     -11.00            FALSE
## 588     -10.00            FALSE
## 589      12.00            FALSE
## 590      13.00            FALSE
## 591      10.00            FALSE
## 592      12.00            FALSE
## 593      12.00            FALSE
## 594      10.00            FALSE
## 595       1.00             TRUE
## 596       0.00             TRUE
## 597       8.00            FALSE
## 598       9.00            FALSE
## 599      11.00            FALSE
## 600       8.00            FALSE
## 601      -4.00            FALSE
## 602      -4.00             TRUE
## 603      -6.00            FALSE
## 604      -6.00             TRUE
## 605      -5.00            FALSE
## 606      -5.00             TRUE
## 607     -10.00            FALSE
## 608      -7.00            FALSE
## 609      -7.00             TRUE
## 610      -8.00            FALSE
## 611      -8.00             TRUE
## 612      -9.00            FALSE
## 613      -9.00             TRUE
## 614       3.00            FALSE
## 615       0.00            FALSE
## 616      -9.00             TRUE
## 617     -10.00             TRUE
## 618      -7.00            FALSE
## 619      -6.00             TRUE
## 620      -5.00             TRUE
## 621      -5.00             TRUE
## 622     -10.00            FALSE
## 623      -6.00             TRUE
## 624      -5.00             TRUE
## 625      -7.00             TRUE
## 626      -8.00             TRUE
## 627      -8.00             TRUE
## 628     -11.00            FALSE
## 629       0.00            FALSE
## 630       0.00            FALSE
## 631       7.00            FALSE
## 632       3.00            FALSE
## 633       0.00             TRUE
## 634       0.00            FALSE
```
