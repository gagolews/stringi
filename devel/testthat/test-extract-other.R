require(testthat)
context("test-extract-other.R")

test_that("stri_extract_all_words", {
    
    expect_identical(stri_extract_all_words("   ala ma   kota... above-mentioned    123.45...  ")[[1]], 
        c("ala", "ma", "kota", "above", "mentioned", "123.45"))
    
    expect_identical(stri_extract_all_words(c("   ", "", NA)), list(NA_character_, 
        NA_character_, NA_character_))
    
    expect_identical(stri_extract_all_words(c("   ", "", NA), omit_no_match = TRUE), 
        list(character(0), character(0), NA_character_))
    
    expect_identical(stri_extract_all_words(c("", "ala", "ma kota"), simplify = TRUE), 
        matrix(c(NA, "", "ala", "", "ma", "kota"), nrow = 3, byrow = TRUE))
    
    expect_identical(stri_extract_all_words(c("", "ala", "ma kota"), simplify = NA), 
        matrix(c(NA, NA, "ala", NA, "ma", "kota"), nrow = 3, byrow = TRUE))
    
    expect_identical(stri_extract_all_words(c("", "ala", "ma kota"), simplify = NA, 
        omit_no_match = TRUE), matrix(c(NA, NA, "ala", NA, "ma", "kota"), nrow = 3, 
        byrow = TRUE))
    
    # example from http://sujitpal.blogspot.co.uk/2008/05/tokenizing-text-with-icu4js.html
    rules <- "
!!chain;
$VoiceMarks = [\\uff9e\\uff9f];
$Format = [\\p{Word_Break = Format}];
$Katakana = [\\p{Word_Break = Katakana}-$VoiceMarks];
$ALetter = [\\p{Word_Break = ALetter}];
$MidLetter = [\\p{Word_Break = MidLetter}];
$MidNum = [\\p{Word_Break = MidNum}];
$Numeric = [\\p{Word_Break = Numeric}];
$ExtendNumLet = [\\p{Word_Break = ExtendNumLet}];
$CR = \\u000d;
$LF = \\u000a;
$Extend = [\\p{Grapheme_Cluster_Break = Extend}$VoiceMarks];
$Control = [\\p{Grapheme_Cluster_Break = Control}];
$dictionary = [:LineBreak = Complex_Context:];
$ALetterPlus = [$ALetter [$dictionary-$Extend-$Control]];
$KatakanaEx = $Katakana     ($Extend |  $Format)*;
$ALetterEx = $ALetterPlus  ($Extend |  $Format)*;
$MidLetterEx = $MidLetter    ($Extend |  $Format)*;
$MidNumEx = $MidNum       ($Extend |  $Format)*;
$NumericEx = $Numeric      ($Extend |  $Format)*;
$ExtendNumLetEx = $ExtendNumLet ($Extend |  $Format)*;
$Hiragana = [:Hiragana:];
$Ideographic = [:IDEOGRAPHIC:];
$HiraganaEx = $Hiragana ($Extend |  $Format)*;
$IdeographicEx = $Ideographic  ($Extend |  $Format)*;
# ============= Custom Rules ================
# Abbreviation: Uppercase alpha chars separated by period and optionally followed by a period
$Abbreviation = [A-Z0-9](\\.[A-Z0-9])+(\\.)*;
# Hyphenated Word : sequence of letter or digit, (punctuated by - or _, with following letter or digit sequence)+
$HyphenatedWord = [A-Za-z0-9]+([\\-_][A-Za-z0-9]+)+;
# Email address: sequence of letters, digits and punctuation followed by @ and followed by another sequence
$EmailAddress = [A-Za-z0-9_\\-\\.]+\\@[A-Za-z][A-Za-z0-9_]+\\.[a-z]+;
# Internet Addresses: http://www.foo.com(/bar)
$InternetAddress = [a-z]+\\:\\/\\/[a-z0-9]+(\\.[a-z0-9]+)+(\\/[a-z0-9][a-z0-9\\.]+);
# XML markup: A run begins with < and ends with the first matching >
$XmlMarkup = \\<[^\\>]+\\>;
# Emoticon: A run that starts with :;B8{[ and contains only one or more of the following -=/{})(
$Emoticon = [B8\\:\\;\\{\\[][-=\\/\\{\\}\\)\\(]+;

!!forward;
$CR $LF  ($Extend | $Format)*;
.? ($Extend |  $Format)+;
$NumericEx {100};
$ALetterEx {200};
$KatakanaEx {300};
$HiraganaEx {300};
$IdeographicEx {400};
$ALetterEx $ALetterEx {200};
$ALetterEx $MidLetterEx $ALetterEx {200};
$NumericEx $NumericEx {100};
$ALetterEx $Format* $NumericEx {200};
$NumericEx $ALetterEx {200};
$NumericEx $MidNumEx $NumericEx {100};
$KatakanaEx $KatakanaEx {300};
$ALetterEx $ExtendNumLetEx {200};
$NumericEx $ExtendNumLetEx {100};
$KatakanaEx $ExtendNumLetEx {300};
$ExtendNumLetEx $ExtendNumLetEx{200};
$ExtendNumLetEx $ALetterEx  {200};
$ExtendNumLetEx $NumericEx  {100};
$ExtendNumLetEx $KatakanaEx {300};
# Custom : Abbreviation
$Abbreviation {500};
$HyphenatedWord {501};
$EmailAddress {502};
$InternetAddress {503};
$XmlMarkup {504};
$Emoticon {505};

!!reverse;
$BackALetterEx = ($Format | $Extend)* $ALetterPlus;
$BackNumericEx = ($Format | $Extend)* $Numeric;
$BackMidNumEx = ($Format | $Extend)* $MidNum;
$BackMidLetterEx = ($Format | $Extend)* $MidLetter;
$BackKatakanaEx = ($Format | $Extend)* $Katakana;
$BackExtendNumLetEx= ($Format | $Extend)* $ExtendNumLet;
($Format | $Extend)* $LF $CR;
($Format | $Extend)*  .?;
$BackALetterEx $BackALetterEx;
$BackALetterEx $BackMidLetterEx $BackALetterEx;
$BackNumericEx $BackNumericEx;
$BackNumericEx $BackALetterEx;
$BackALetterEx $BackNumericEx;
$BackNumericEx $BackMidNumEx $BackNumericEx;
$BackKatakanaEx $BackKatakanaEx;
($BackALetterEx | $BackNumericEx | $BackKatakanaEx | $BackExtendNumLetEx) $BackExtendNumLetEx;
$BackExtendNumLetEx ($BackALetterEx | $BackNumericEx | $BackKatakanaEx);

!!safe_reverse;
($Extend | $Format)+ .?;
$MidLetter $BackALetterEx;
$MidNum $BackNumericEx;
$dictionary $dictionary;

!!safe_forward;
($Extend | $Format)+ .?;
$MidLetterEx $ALetterEx;
$MidNumEx $NumericEx;
$dictionary $dictionary;
   "
    
    expect_identical(stri_extract_all_boundaries("test1 test2\ntest3\ttest4", skip_word_none = TRUE, 
        type = "word"), stri_extract_all_boundaries("test1 test2\ntest3\ttest4", 
        skip_word_none = TRUE, type = rules))
    
    x <- "
Jaguar will sell its new XJ-6 model in the U.S. for a small fortune :-).
Expect to pay around USD 120ks. Custom options can set you back another
few 10,000 dollars. For details, go to <a href=\"http://www.jaguar.com/sales\"
alt=\"Click here\">Jaguar Sales</a> or contact xj-6@jaguar.com.
   "
    stri_extract_all_boundaries(x, skip_word_none = TRUE, type = "word")
    stri_extract_all_boundaries(x, skip_word_none = TRUE, type = rules)
    
    #    expect_identical(stri_extract_all_words(c('', 'stringi', NA)),
    #       list(character(0), 'stringi', NA_character_))
})


test_that("stri_extract_first_words", {
    
    expect_identical(stri_extract_first_words("   ala ma   kota... above-mentioned    123.45...  "), 
        c("ala"))
    
    expect_identical(stri_extract_first_words(c("   ", "", NA)), c(NA_character_, 
        NA_character_, NA_character_))
    
    expect_identical(stri_extract_first_words(character(0)), character(0))
    
    expect_identical(stri_extract_first_words(c("", "ala", "ma kota")), c(NA, "ala", 
        "ma"))
    
})


test_that("stri_extract_last_words", {
    
    expect_identical(stri_extract_last_words("   ala ma   kota... above-mentioned    123.45...  "), 
        c("123.45"))
    
    expect_identical(stri_extract_last_words(c("   ", "", NA)), c(NA_character_, 
        NA_character_, NA_character_))
    
    expect_identical(stri_extract_last_words(character(0)), character(0))
    
    expect_identical(stri_extract_last_words(c("", "ala", "ma kota")), c(NA, "ala", 
        "kota"))
    
})
