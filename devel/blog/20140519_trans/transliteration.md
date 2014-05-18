Transforms/Transliteration
========================================================

Transforms provide a general-purpose package for processing Unicode text. They are a powerful and flexible mechanism for handling a variety of different tasks, including:

    Uppercase, Lowercase, Titlecase, Full/Halfwidth conversions
    (Full (Language-Specific) Case Mapping)
    
case mapping can change the number of code points and/or code units of a string,
is language-sensitive (results may differ depending on language), and
is context-sensitive (a character in the input string may map differently depending on surrounding characters).



    Normalization
Normalization is used to convert text to a unique, equivalent form
Normalization allows for easier sorting and searching of text



```r
library(stringi)
stri_trans_nfd(stri_unescape_unicode("\\u0105"))  # Polish a with ogonek -> a, ogonek
```

```
## [1] "ą"
```

```r
stri_trans_nfkc(stri_unescape_unicode("\\ufdfa"))  # 1 codepoint -> 18 codepoints
```

```
## [1] "صلى الله عليه وسلم"
```

```r
"ﷺ"
```

```
## [1] "ﷺ"
```


    Hex and Character Name conversions

    Script to Script conversion
    
    
    
http://userguide.icu-project.org/transforms/general


```r
library(stringi)
stri_trans_list()
```

```
##   [1] "ASCII-Latin"             "Accents-Any"            
##   [3] "Amharic-Latin/BGN"       "Any-Accents"            
##   [5] "Any-Publishing"          "Arabic-Latin"           
##   [7] "Arabic-Latin/BGN"        "Armenian-Latin"         
##   [9] "Armenian-Latin/BGN"      "Azerbaijani-Latin/BGN"  
##  [11] "Belarusian-Latin/BGN"    "Bengali-Devanagari"     
##  [13] "Bengali-Gujarati"        "Bengali-Gurmukhi"       
##  [15] "Bengali-Kannada"         "Bengali-Latin"          
##  [17] "Bengali-Malayalam"       "Bengali-Oriya"          
##  [19] "Bengali-Tamil"           "Bengali-Telugu"         
##  [21] "Bopomofo-Latin"          "Bulgarian-Latin/BGN"    
##  [23] "Cyrillic-Latin"          "Devanagari-Bengali"     
##  [25] "Devanagari-Gujarati"     "Devanagari-Gurmukhi"    
##  [27] "Devanagari-Kannada"      "Devanagari-Latin"       
##  [29] "Devanagari-Malayalam"    "Devanagari-Oriya"       
##  [31] "Devanagari-Tamil"        "Devanagari-Telugu"      
##  [33] "Digit-Tone"              "Fullwidth-Halfwidth"    
##  [35] "Georgian-Latin"          "Georgian-Latin/BGN"     
##  [37] "Greek-Latin"             "Greek-Latin/BGN"        
##  [39] "Greek-Latin/UNGEGN"      "Gujarati-Bengali"       
##  [41] "Gujarati-Devanagari"     "Gujarati-Gurmukhi"      
##  [43] "Gujarati-Kannada"        "Gujarati-Latin"         
##  [45] "Gujarati-Malayalam"      "Gujarati-Oriya"         
##  [47] "Gujarati-Tamil"          "Gujarati-Telugu"        
##  [49] "Gurmukhi-Bengali"        "Gurmukhi-Devanagari"    
##  [51] "Gurmukhi-Gujarati"       "Gurmukhi-Kannada"       
##  [53] "Gurmukhi-Latin"          "Gurmukhi-Malayalam"     
##  [55] "Gurmukhi-Oriya"          "Gurmukhi-Tamil"         
##  [57] "Gurmukhi-Telugu"         "Halfwidth-Fullwidth"    
##  [59] "Han-Latin"               "Han-Latin/Names"        
##  [61] "Hangul-Latin"            "Hans-Hant"              
##  [63] "Hant-Hans"               "Hebrew-Latin"           
##  [65] "Hebrew-Latin/BGN"        "Hiragana-Katakana"      
##  [67] "Hiragana-Latin"          "IPA-XSampa"             
##  [69] "Jamo-Latin"              "JapaneseKana-Latin/BGN" 
##  [71] "Kannada-Bengali"         "Kannada-Devanagari"     
##  [73] "Kannada-Gujarati"        "Kannada-Gurmukhi"       
##  [75] "Kannada-Latin"           "Kannada-Malayalam"      
##  [77] "Kannada-Oriya"           "Kannada-Tamil"          
##  [79] "Kannada-Telugu"          "Katakana-Hiragana"      
##  [81] "Katakana-Latin"          "Kazakh-Latin/BGN"       
##  [83] "Kirghiz-Latin/BGN"       "Korean-Latin/BGN"       
##  [85] "Latin-ASCII"             "Latin-Arabic"           
##  [87] "Latin-Armenian"          "Latin-Bengali"          
##  [89] "Latin-Bopomofo"          "Latin-Cyrillic"         
##  [91] "Latin-Devanagari"        "Latin-Georgian"         
##  [93] "Latin-Greek"             "Latin-Greek/UNGEGN"     
##  [95] "Latin-Gujarati"          "Latin-Gurmukhi"         
##  [97] "Latin-Han"               "Latin-Hangul"           
##  [99] "Latin-Hebrew"            "Latin-Hiragana"         
## [101] "Latin-Jamo"              "Latin-Kannada"          
## [103] "Latin-Katakana"          "Latin-Malayalam"        
## [105] "Latin-NumericPinyin"     "Latin-Oriya"            
## [107] "Latin-Syriac"            "Latin-Tamil"            
## [109] "Latin-Telugu"            "Latin-Thaana"           
## [111] "Latin-Thai"              "Macedonian-Latin/BGN"   
## [113] "Malayalam-Bengali"       "Malayalam-Devanagari"   
## [115] "Malayalam-Gujarati"      "Malayalam-Gurmukhi"     
## [117] "Malayalam-Kannada"       "Malayalam-Latin"        
## [119] "Malayalam-Oriya"         "Malayalam-Tamil"        
## [121] "Malayalam-Telugu"        "Maldivian-Latin/BGN"    
## [123] "Mongolian-Latin/BGN"     "NumericPinyin-Latin"    
## [125] "NumericPinyin-Pinyin"    "Oriya-Bengali"          
## [127] "Oriya-Devanagari"        "Oriya-Gujarati"         
## [129] "Oriya-Gurmukhi"          "Oriya-Kannada"          
## [131] "Oriya-Latin"             "Oriya-Malayalam"        
## [133] "Oriya-Tamil"             "Oriya-Telugu"           
## [135] "Pashto-Latin/BGN"        "Persian-Latin/BGN"      
## [137] "Pinyin-NumericPinyin"    "Publishing-Any"         
## [139] "Russian-Latin/BGN"       "Serbian-Latin/BGN"      
## [141] "Simplified-Traditional"  "Syriac-Latin"           
## [143] "Tamil-Bengali"           "Tamil-Devanagari"       
## [145] "Tamil-Gujarati"          "Tamil-Gurmukhi"         
## [147] "Tamil-Kannada"           "Tamil-Latin"            
## [149] "Tamil-Malayalam"         "Tamil-Oriya"            
## [151] "Tamil-Telugu"            "Telugu-Bengali"         
## [153] "Telugu-Devanagari"       "Telugu-Gujarati"        
## [155] "Telugu-Gurmukhi"         "Telugu-Kannada"         
## [157] "Telugu-Latin"            "Telugu-Malayalam"       
## [159] "Telugu-Oriya"            "Telugu-Tamil"           
## [161] "Thaana-Latin"            "Thai-Latin"             
## [163] "Tone-Digit"              "Traditional-Simplified" 
## [165] "Turkmen-Latin/BGN"       "Ukrainian-Latin/BGN"    
## [167] "Uzbek-Latin/BGN"         "XSampa-IPA"             
## [169] "cs-cs_FONIPA"            "cs-ja"                  
## [171] "cs-ko"                   "cs_FONIPA-ja"           
## [173] "cs_FONIPA-ko"            "es-am"                  
## [175] "es-es_FONIPA"            "es-ja"                  
## [177] "es-zh"                   "es_419-ja"              
## [179] "es_419-zh"               "es_FONIPA-am"           
## [181] "es_FONIPA-es_419_FONIPA" "es_FONIPA-ja"           
## [183] "es_FONIPA-zh"            "it-am"                  
## [185] "it-ja"                   "ja_Latn-ko"             
## [187] "ja_Latn-ru"              "pl-ja"                  
## [189] "pl-pl_FONIPA"            "pl_FONIPA-ja"           
## [191] "ro-ja"                   "ro-ro_FONIPA"           
## [193] "ro_FONIPA-ja"            "ru-ja"                  
## [195] "ru-zh"                   "sk-ja"                  
## [197] "sk-sk_FONIPA"            "sk_FONIPA-ja"           
## [199] "zh_Latn_PINYIN-ru"       "Any-Null"               
## [201] "Any-Lower"               "Any-Upper"              
## [203] "Any-Title"               "Any-Name"               
## [205] "Name-Any"                "Any-Remove"             
## [207] "Any-Hex/Unicode"         "Any-Hex/Java"           
## [209] "Any-Hex/C"               "Any-Hex/XML"            
## [211] "Any-Hex/XML10"           "Any-Hex/Perl"           
## [213] "Any-Hex"                 "Hex-Any/Unicode"        
## [215] "Hex-Any/Java"            "Hex-Any/C"              
## [217] "Hex-Any/XML"             "Hex-Any/XML10"          
## [219] "Hex-Any/Perl"            "Hex-Any"                
## [221] "Any-NFC"                 "Any-NFKC"               
## [223] "Any-NFD"                 "Any-NFKD"               
## [225] "Any-FCD"                 "Any-FCC"                
## [227] "Any-Latin"               "Any-Telugu"             
## [229] "Any-Gurmukhi"            "Any-Gujarati"           
## [231] "Any-Malayalam"           "Any-Oriya"              
## [233] "Any-Devanagari"          "Any-Kannada"            
## [235] "Any-Tamil"               "Any-cs_FONIPA"          
## [237] "Any-ru"                  "Any-Bengali"            
## [239] "Any-Katakana"            "Any-ro_FONIPA"          
## [241] "Any-zh"                  "Any-am"                 
## [243] "Any-es_419_FONIPA"       "Any-es_FONIPA"          
## [245] "Any-sk_FONIPA"           "Any-Hant"               
## [247] "Any-Hans"                "Any-Hiragana"           
## [249] "Any-Syriac"              "Any-Greek"              
## [251] "Any-Greek/UNGEGN"        "Any-Cyrillic"           
## [253] "Any-Hangul"              "Any-Bopomofo"           
## [255] "Any-Arabic"              "Any-Thai"               
## [257] "Any-Armenian"            "Any-Thaana"             
## [259] "Any-Han"                 "Any-Georgian"           
## [261] "Any-Hebrew"              "Any-pl_FONIPA"
```

```r
stri_trans_general("w szczebrzeszynie chrząszcz brzmi w trzcinie", "pl-pl_fonipa")
```

```
## [1] "v ʂt͡ʂɛbʐɛʂɨɲɛ xʂɔ̃ʂt͡ʂ bʐmi v tʂt͡ɕiɲɛ"
```

```r
stri_trans_general("w szczebrzeszynie chrząszcz brzmi w trzcinie", "pl-pl_fonipa; ipa-xsampa") # XSampa ASCII-range representation of IPA characters.
```

```
## [1] "v s`t_s`Ebz`Es`1JE xs`O~s`t_s` bz`mi v ts`t_s\\iJE"
```

```r
stri_trans_general("zażółć gęślą jaźń", "[^\\u0000-\\u007f] any-hex")red
```

```
## [1] "za\\u017C\\u00F3\\u0142\\u0107 g\\u0119\\u015Bl\\u0105 ja\\u017A\\u0144"
```

```r
stri_trans_general("zażółć gęślą jaźń", "[^\\u0000-\\u007f] any-hex/xml")
```

```
## [1] "za&#x17C;&#xF3;&#x142;&#x107; g&#x119;&#x15B;l&#x105; ja&#x17A;&#x144;"
```

```r
stri_trans_general("zażółć gęślą jaźń", "latin-ascii")
```

```
## [1] "zazolc gesla jazn"
```

```r
stri_trans_general("ą1©,", "any-name")
```

```
## [1] "\\N{LATIN SMALL LETTER A WITH OGONEK}\\N{DIGIT ONE}\\N{COPYRIGHT SIGN}\\N{COMMA}"
```

```r
stri_trans_general("\\N{LATIN SMALL LETTER SHARP S}", "name-any")
```

```
## [1] "ß"
```

```r
stri_trans_general("Let's go -- she said", "any-publishing")
```

```
## [1] "Let’s go — she said"
```

```r
stri_trans_general("zażółć gęślą jaźń", "[\\p{Z}] remove")
```

```
## [1] "zażółćgęśląjaźń"
```

```r
stri_trans_general("zażółć gęślą jaźń", "[\\p{Z}] remove")
```

```
## [1] "zażółćgęśląjaźń"
```

```r
stri_trans_general("stringi", "latin-greek")  # script transliteration
```

```
## [1] "στριγγι"
```

```r
stri_trans_general("Пётр Ильич Чайковский", "cyrillic-latin")eration
```

```
## [1] "Pëtr Ilʹič Čajkovskij"
```

