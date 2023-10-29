# stri_datetime_symbols: List Localizable Date-Time Formatting Data

## Description

Returns a list of all localizable date-time formatting data, including month and weekday names, localized AM/PM strings, etc.

## Usage

``` r
stri_datetime_symbols(locale = NULL, context = "standalone", width = "wide")
```

## Arguments

|           |                                                                              |
|-----------|------------------------------------------------------------------------------|
| `locale`  | `NULL` or `''` for default locale, or a single string with locale identifier |
| `context` | single string; one of: `'format'`, `'standalone'`                            |
| `width`   | single string; one of: `'abbreviated'`, `'wide'`, `'narrow'`                 |

## Details

`context` stands for a selector for date formatting context and `width` - for date formatting width.

## Value

Returns a list with the following named components:

1.  `Month` - month names,

2.  `Weekday` - weekday names,

3.  `Quarter` - quarter names,

4.  `AmPm` - AM/PM names,

5.  `Era` - era names.

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Calendar* - ICU User Guide, <https://unicode-org.github.io/icu/userguide/datetime/calendar/>

*DateFormatSymbols* class -- ICU API Documentation, <https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1DateFormatSymbols.html>

*Formatting Dates and Times* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/format_parse/datetime/>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, [doi:10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other datetime: [`stri_datetime_add()`](stri_datetime_add.md), [`stri_datetime_create()`](stri_datetime_create.md), [`stri_datetime_fields()`](stri_datetime_fields.md), [`stri_datetime_format()`](stri_datetime_format.md), [`stri_datetime_fstr()`](stri_datetime_fstr.md), [`stri_datetime_now()`](stri_datetime_now.md), [`stri_timezone_get()`](stri_timezone_set.md), [`stri_timezone_info()`](stri_timezone_info.md), [`stri_timezone_list()`](stri_timezone_list.md)

## Examples




```r
stri_datetime_symbols() # uses the Gregorian calendar in most locales
```

```
## $Month
##  [1] "January"   "February"  "March"     "April"     "May"       "June"     
##  [7] "July"      "August"    "September" "October"   "November"  "December" 
## 
## $Weekday
## [1] "Sunday"    "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Friday"   
## [7] "Saturday" 
## 
## $Quarter
## [1] "1st quarter" "2nd quarter" "3rd quarter" "4th quarter"
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
## [1] "Before Christ" "Anno Domini"
```

```r
stri_datetime_symbols('@calendar=hebrew')
```

```
## $Month
##  [1] "Tishri"  "Heshvan" "Kislev"  "Tevet"   "Shevat"  "Adar I"  "Adar"   
##  [8] "Nisan"   "Iyar"    "Sivan"   "Tamuz"   "Av"      "Elul"    "Adar II"
## 
## $Weekday
## [1] "Sunday"    "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Friday"   
## [7] "Saturday" 
## 
## $Quarter
## [1] "1st quarter" "2nd quarter" "3rd quarter" "4th quarter"
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
## [1] "AM"
```

```r
stri_datetime_symbols('he_IL@calendar=hebrew')
```

```
## $Month
##  [1] "תשרי"   "חשוון"  "כסלו"   "טבת"    "שבט"    "אדר א׳" "אדר"    "ניסן"  
##  [9] "אייר"   "סיוון"  "תמוז"   "אב"     "אלול"   "אדר ב׳"
## 
## $Weekday
## [1] "יום ראשון" "יום שני"   "יום שלישי" "יום רביעי" "יום חמישי" "יום שישי" 
## [7] "יום שבת"  
## 
## $Quarter
## [1] "רבעון 1" "רבעון 2" "רבעון 3" "רבעון 4"
## 
## $AmPm
## [1] "לפנה״צ" "אחה״צ" 
## 
## $Era
## [1] "לבריאת העולם"
```

```r
stri_datetime_symbols('@calendar=islamic')
```

```
## $Month
##  [1] "Muharram"     "Safar"        "Rabiʻ I"      "Rabiʻ II"     "Jumada I"    
##  [6] "Jumada II"    "Rajab"        "Shaʻban"      "Ramadan"      "Shawwal"     
## [11] "Dhuʻl-Qiʻdah" "Dhuʻl-Hijjah"
## 
## $Weekday
## [1] "Sunday"    "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Friday"   
## [7] "Saturday" 
## 
## $Quarter
## [1] "1st quarter" "2nd quarter" "3rd quarter" "4th quarter"
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
## [1] "AH"
```

```r
stri_datetime_symbols('@calendar=persian')
```

```
## $Month
##  [1] "Farvardin"   "Ordibehesht" "Khordad"     "Tir"         "Mordad"     
##  [6] "Shahrivar"   "Mehr"        "Aban"        "Azar"        "Dey"        
## [11] "Bahman"      "Esfand"     
## 
## $Weekday
## [1] "Sunday"    "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Friday"   
## [7] "Saturday" 
## 
## $Quarter
## [1] "1st quarter" "2nd quarter" "3rd quarter" "4th quarter"
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
## [1] "AP"
```

```r
stri_datetime_symbols('@calendar=indian')
```

```
## $Month
##  [1] "Chaitra"    "Vaisakha"   "Jyaistha"   "Asadha"     "Sravana"   
##  [6] "Bhadra"     "Asvina"     "Kartika"    "Agrahayana" "Pausa"     
## [11] "Magha"      "Phalguna"  
## 
## $Weekday
## [1] "Sunday"    "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Friday"   
## [7] "Saturday" 
## 
## $Quarter
## [1] "1st quarter" "2nd quarter" "3rd quarter" "4th quarter"
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
## [1] "Saka"
```

```r
stri_datetime_symbols('@calendar=coptic')
```

```
## $Month
##  [1] "Tout"      "Baba"      "Hator"     "Kiahk"     "Toba"      "Amshir"   
##  [7] "Baramhat"  "Baramouda" "Bashans"   "Paona"     "Epep"      "Mesra"    
## [13] "Nasie"    
## 
## $Weekday
## [1] "Sunday"    "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Friday"   
## [7] "Saturday" 
## 
## $Quarter
## [1] "1st quarter" "2nd quarter" "3rd quarter" "4th quarter"
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
## [1] "ERA0" "ERA1"
```

```r
stri_datetime_symbols('@calendar=japanese')
```

```
## $Month
##  [1] "January"   "February"  "March"     "April"     "May"       "June"     
##  [7] "July"      "August"    "September" "October"   "November"  "December" 
## 
## $Weekday
## [1] "Sunday"    "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Friday"   
## [7] "Saturday" 
## 
## $Quarter
## [1] "1st quarter" "2nd quarter" "3rd quarter" "4th quarter"
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
##   [1] "Taika (645–650)"        "Hakuchi (650–671)"      "Hakuhō (672–686)"      
##   [4] "Shuchō (686–701)"       "Taihō (701–704)"        "Keiun (704–708)"       
##   [7] "Wadō (708–715)"         "Reiki (715–717)"        "Yōrō (717–724)"        
##  [10] "Jinki (724–729)"        "Tenpyō (729–749)"       "Tenpyō-kampō (749–749)"
##  [13] "Tenpyō-shōhō (749–757)" "Tenpyō-hōji (757–765)"  "Tenpyō-jingo (765–767)"
##  [16] "Jingo-keiun (767–770)"  "Hōki (770–780)"         "Ten-ō (781–782)"       
##  [19] "Enryaku (782–806)"      "Daidō (806–810)"        "Kōnin (810–824)"       
##  [22] "Tenchō (824–834)"       "Jōwa (834–848)"         "Kajō (848–851)"        
##  [25] "Ninju (851–854)"        "Saikō (854–857)"        "Ten-an (857–859)"      
##  [28] "Jōgan (859–877)"        "Gangyō (877–885)"       "Ninna (885–889)"       
##  [31] "Kanpyō (889–898)"       "Shōtai (898–901)"       "Engi (901–923)"        
##  [34] "Enchō (923–931)"        "Jōhei (931–938)"        "Tengyō (938–947)"      
##  [37] "Tenryaku (947–957)"     "Tentoku (957–961)"      "Ōwa (961–964)"         
##  [40] "Kōhō (964–968)"         "Anna (968–970)"         "Tenroku (970–973)"     
##  [43] "Ten’en (973–976)"       "Jōgen (976–978)"        "Tengen (978–983)"      
##  [46] "Eikan (983–985)"        "Kanna (985–987)"        "Eien (987–989)"        
##  [49] "Eiso (989–990)"         "Shōryaku (990–995)"     "Chōtoku (995–999)"     
##  [52] "Chōhō (999–1004)"       "Kankō (1004–1012)"      "Chōwa (1012–1017)"     
##  [55] "Kannin (1017–1021)"     "Jian (1021–1024)"       "Manju (1024–1028)"     
##  [58] "Chōgen (1028–1037)"     "Chōryaku (1037–1040)"   "Chōkyū (1040–1044)"    
##  [61] "Kantoku (1044–1046)"    "Eishō (1046–1053)"      "Tengi (1053–1058)"     
##  [64] "Kōhei (1058–1065)"      "Jiryaku (1065–1069)"    "Enkyū (1069–1074)"     
##  [67] "Shōho (1074–1077)"      "Shōryaku (1077–1081)"   "Eihō (1081–1084)"      
##  [70] "Ōtoku (1084–1087)"      "Kanji (1087–1094)"      "Kahō (1094–1096)"      
##  [73] "Eichō (1096–1097)"      "Jōtoku (1097–1099)"     "Kōwa (1099–1104)"      
##  [76] "Chōji (1104–1106)"      "Kashō (1106–1108)"      "Tennin (1108–1110)"    
##  [79] "Ten-ei (1110–1113)"     "Eikyū (1113–1118)"      "Gen’ei (1118–1120)"    
##  [82] "Hōan (1120–1124)"       "Tenji (1124–1126)"      "Daiji (1126–1131)"     
##  [85] "Tenshō (1131–1132)"     "Chōshō (1132–1135)"     "Hōen (1135–1141)"      
##  [88] "Eiji (1141–1142)"       "Kōji (1142–1144)"       "Ten’yō (1144–1145)"    
##  [91] "Kyūan (1145–1151)"      "Ninpei (1151–1154)"     "Kyūju (1154–1156)"     
##  [94] "Hōgen (1156–1159)"      "Heiji (1159–1160)"      "Eiryaku (1160–1161)"   
##  [97] "Ōho (1161–1163)"        "Chōkan (1163–1165)"     "Eiman (1165–1166)"     
## [100] "Nin’an (1166–1169)"     "Kaō (1169–1171)"        "Shōan (1171–1175)"     
## [103] "Angen (1175–1177)"      "Jishō (1177–1181)"      "Yōwa (1181–1182)"      
## [106] "Juei (1182–1184)"       "Genryaku (1184–1185)"   "Bunji (1185–1190)"     
## [109] "Kenkyū (1190–1199)"     "Shōji (1199–1201)"      "Kennin (1201–1204)"    
## [112] "Genkyū (1204–1206)"     "Ken’ei (1206–1207)"     "Jōgen (1207–1211)"     
## [115] "Kenryaku (1211–1213)"   "Kenpō (1213–1219)"      "Jōkyū (1219–1222)"     
## [118] "Jōō (1222–1224)"        "Gennin (1224–1225)"     "Karoku (1225–1227)"    
## [121] "Antei (1227–1229)"      "Kanki (1229–1232)"      "Jōei (1232–1233)"      
## [124] "Tenpuku (1233–1234)"    "Bunryaku (1234–1235)"   "Katei (1235–1238)"     
## [127] "Ryakunin (1238–1239)"   "En’ō (1239–1240)"       "Ninji (1240–1243)"     
## [130] "Kangen (1243–1247)"     "Hōji (1247–1249)"       "Kenchō (1249–1256)"    
## [133] "Kōgen (1256–1257)"      "Shōka (1257–1259)"      "Shōgen (1259–1260)"    
## [136] "Bun’ō (1260–1261)"      "Kōchō (1261–1264)"      "Bun’ei (1264–1275)"    
## [139] "Kenji (1275–1278)"      "Kōan (1278–1288)"       "Shōō (1288–1293)"      
## [142] "Einin (1293–1299)"      "Shōan (1299–1302)"      "Kengen (1302–1303)"    
## [145] "Kagen (1303–1306)"      "Tokuji (1306–1308)"     "Enkyō (1308–1311)"     
## [148] "Ōchō (1311–1312)"       "Shōwa (1312–1317)"      "Bunpō (1317–1319)"     
## [151] "Genō (1319–1321)"       "Genkō (1321–1324)"      "Shōchū (1324–1326)"    
## [154] "Karyaku (1326–1329)"    "Gentoku (1329–1331)"    "Genkō (1331–1334)"     
## [157] "Kenmu (1334–1336)"      "Engen (1336–1340)"      "Kōkoku (1340–1346)"    
## [160] "Shōhei (1346–1370)"     "Kentoku (1370–1372)"    "Bunchū (1372–1375)"    
## [163] "Tenju (1375–1379)"      "Kōryaku (1379–1381)"    "Kōwa (1381–1384)"      
## [166] "Genchū (1384–1392)"     "Meitoku (1384–1387)"    "Kakei (1387–1389)"     
## [169] "Kōō (1389–1390)"        "Meitoku (1390–1394)"    "Ōei (1394–1428)"       
## [172] "Shōchō (1428–1429)"     "Eikyō (1429–1441)"      "Kakitsu (1441–1444)"   
## [175] "Bun’an (1444–1449)"     "Hōtoku (1449–1452)"     "Kyōtoku (1452–1455)"   
## [178] "Kōshō (1455–1457)"      "Chōroku (1457–1460)"    "Kanshō (1460–1466)"    
## [181] "Bunshō (1466–1467)"     "Ōnin (1467–1469)"       "Bunmei (1469–1487)"    
## [184] "Chōkyō (1487–1489)"     "Entoku (1489–1492)"     "Meiō (1492–1501)"      
## [187] "Bunki (1501–1504)"      "Eishō (1504–1521)"      "Taiei (1521–1528)"     
## [190] "Kyōroku (1528–1532)"    "Tenbun (1532–1555)"     "Kōji (1555–1558)"      
## [193] "Eiroku (1558–1570)"     "Genki (1570–1573)"      "Tenshō (1573–1592)"    
## [196] "Bunroku (1592–1596)"    "Keichō (1596–1615)"     "Genna (1615–1624)"     
## [199] "Kan’ei (1624–1644)"     "Shōho (1644–1648)"      "Keian (1648–1652)"     
## [202] "Jōō (1652–1655)"        "Meireki (1655–1658)"    "Manji (1658–1661)"     
## [205] "Kanbun (1661–1673)"     "Enpō (1673–1681)"       "Tenna (1681–1684)"     
## [208] "Jōkyō (1684–1688)"      "Genroku (1688–1704)"    "Hōei (1704–1711)"      
## [211] "Shōtoku (1711–1716)"    "Kyōhō (1716–1736)"      "Genbun (1736–1741)"    
## [214] "Kanpō (1741–1744)"      "Enkyō (1744–1748)"      "Kan’en (1748–1751)"    
## [217] "Hōreki (1751–1764)"     "Meiwa (1764–1772)"      "An’ei (1772–1781)"     
## [220] "Tenmei (1781–1789)"     "Kansei (1789–1801)"     "Kyōwa (1801–1804)"     
## [223] "Bunka (1804–1818)"      "Bunsei (1818–1830)"     "Tenpō (1830–1844)"     
## [226] "Kōka (1844–1848)"       "Kaei (1848–1854)"       "Ansei (1854–1860)"     
## [229] "Man’en (1860–1861)"     "Bunkyū (1861–1864)"     "Genji (1864–1865)"     
## [232] "Keiō (1865–1868)"       "Meiji"                  "Taishō"                
## [235] "Shōwa"                  "Heisei"                 "Reiwa"
```

```r
stri_datetime_symbols('ja_JP_TRADITIONAL') # uses the Japanese calendar by default
```

```
## $Month
##  [1] "1月"  "2月"  "3月"  "4月"  "5月"  "6月"  "7月"  "8月"  "9月"  "10月"
## [11] "11月" "12月"
## 
## $Weekday
## [1] "日曜日" "月曜日" "火曜日" "水曜日" "木曜日" "金曜日" "土曜日"
## 
## $Quarter
## [1] "第1四半期" "第2四半期" "第3四半期" "第4四半期"
## 
## $AmPm
## [1] "午前" "午後"
## 
## $Era
## [1] "紀元前" "西暦"
```

```r
stri_datetime_symbols('th_TH_TRADITIONAL') # uses the Buddhist calendar
```

```
## $Month
##  [1] "มกราคม"   "กุมภาพันธ์"  "มีนาคม"    "เมษายน"   "พฤษภาคม"  "มิถุนายน"  
##  [7] "กรกฎาคม"  "สิงหาคม"   "กันยายน"   "ตุลาคม"    "พฤศจิกายน" "ธันวาคม"  
## 
## $Weekday
## [1] "วันอาทิตย์"  "วันจันทร์"   "วันอังคาร"  "วันพุธ"     "วันพฤหัสบดี" "วันศุกร์"    "วันเสาร์"  
## 
## $Quarter
## [1] "ไตรมาส 1" "ไตรมาส 2" "ไตรมาส 3" "ไตรมาส 4"
## 
## $AmPm
## [1] "ก่อนเที่ยง" "หลังเที่ยง"
## 
## $Era
## [1] "ปีก่อนคริสตกาล" "คริสต์ศักราช"
```

```r
stri_datetime_symbols('pl_PL', context='format')
```

```
## $Month
##  [1] "stycznia"     "lutego"       "marca"        "kwietnia"     "maja"        
##  [6] "czerwca"      "lipca"        "sierpnia"     "września"     "października"
## [11] "listopada"    "grudnia"     
## 
## $Weekday
## [1] "niedziela"    "poniedziałek" "wtorek"       "środa"        "czwartek"    
## [6] "piątek"       "sobota"      
## 
## $Quarter
## [1] "I kwartał"   "II kwartał"  "III kwartał" "IV kwartał" 
## 
## $AmPm
## [1] "AM" "PM"
## 
## $Era
## [1] "przed naszą erą" "naszej ery"
```

```r
stri_datetime_symbols('pl_PL', context='standalone')
```

```
## $Month
##  [1] "styczeń"     "luty"        "marzec"      "kwiecień"    "maj"        
##  [6] "czerwiec"    "lipiec"      "sierpień"    "wrzesień"    "październik"
## [11] "listopad"    "grudzień"   
## 
## $Weekday
## [1] "niedziela"    "poniedziałek" "wtorek"       "środa"        "czwartek"    
## [6] "piątek"       "sobota"      
## 
## $Quarter
## [1] "I kwartał"   "II kwartał"  "III kwartał" "IV kwartał" 
## 
## $AmPm
## [1] "AM" "PM"
## 
## $Era
## [1] "przed naszą erą" "naszej ery"
```

```r
stri_datetime_symbols(width='wide')
```

```
## $Month
##  [1] "January"   "February"  "March"     "April"     "May"       "June"     
##  [7] "July"      "August"    "September" "October"   "November"  "December" 
## 
## $Weekday
## [1] "Sunday"    "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Friday"   
## [7] "Saturday" 
## 
## $Quarter
## [1] "1st quarter" "2nd quarter" "3rd quarter" "4th quarter"
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
## [1] "Before Christ" "Anno Domini"
```

```r
stri_datetime_symbols(width='abbreviated')
```

```
## $Month
##  [1] "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"
## 
## $Weekday
## [1] "Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat"
## 
## $Quarter
## [1] "Q1" "Q2" "Q3" "Q4"
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
## [1] "BC" "AD"
```

```r
stri_datetime_symbols(width='narrow')
```

```
## $Month
##  [1] "J" "F" "M" "A" "M" "J" "J" "A" "S" "O" "N" "D"
## 
## $Weekday
## [1] "Su." "M."  "Tu." "W."  "Th." "F."  "Sa."
## 
## $Quarter
## character(0)
## 
## $AmPm
## [1] "am" "pm"
## 
## $Era
## [1] "B" "A"
```
