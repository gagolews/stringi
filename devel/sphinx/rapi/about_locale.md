# about_locale: Locales and <span class="pkg">stringi</span>

## Description

In this section we explain how we specify locales in <span class="pkg">stringi</span>. Locale is a fundamental concept in <span class="pkg">ICU</span>. It identifies a specific user community, i.e., a group of users who have similar culture and language expectations for human-computer interaction.

## Details

Because a locale is just an identifier of a region, no validity check is performed when you specify a Locale. <span class="pkg">ICU</span> is implemented as a set of services. If you want to verify whether particular resources are available in the locale you asked for, you must query those resources. Note: when you ask for a resource for a particular locale, you get back the best available match, not necessarily precisely the one you requested.

## Locale Identifiers

<span class="pkg">ICU</span> services are parametrized by locale, to deliver culturally correct results. Locales are identified by character strings of the form `Language` code, `Language_Country` code, or `Language_Country_Variant` code, e.g., \'en_US\'.

The two-letter `Language` code uses the ISO-639-1 standard, e.g., \'en\' stands for English, \'pl\' -- Polish, \'fr\' -- French, and \'de\' for German.

`Country` is a two-letter code following the ISO-3166 standard. This is to reflect different language conventions within the same language, for example in US-English (\'en_US\') and Australian-English (\'en_AU\').

Differences may also appear in language conventions used within the same country. For example, the Euro currency may be used in several European countries while the individual country\'s currency is still in circulation. In such a case, <span class="pkg">ICU</span> `Variant` \'\_EURO\' could be used for selecting locales that support the Euro currency.

The final (optional) element of a locale is a list of keywords together with their values. Keywords must be unique. Their order is not significant. Unknown keywords are ignored. The handling of keywords depends on the specific services that utilize them. Currently, the following keywords are recognized: `calendar`, `collation`, `currency`, and `numbers`, e.g., `fr@collation=phonebook;``calendar=islamic-civil` is a valid French locale specifier together with keyword arguments. For more information, refer to the ICU user guide.

For a list of locales that are recognized by <span class="pkg">ICU</span>, call [`stri_locale_list`](stri_locale_list.md).

## A Note on Default Locales

Each locale-sensitive function in <span class="pkg">stringi</span> selects the current default locale if an empty string or `NULL` is provided as its `locale` argument. Default locales are available to all the functions: they are initially set to be the system locale on that platform, and may be changed with [`stri_locale_set`](stri_locale_set.md), for example, if automatic detection fails to recognize your locale properly.

It is suggested that your program should avoid changing the default locale. All locale-sensitive functions may request any desired locale per-call (by specifying the `locale` argument), i.e., without referencing to the default locale. During many tests, however, we did not observe any improper behavior of <span class="pkg">stringi</span> while using a modified default locale.

## Locale-Sensitive Functions in <span class="pkg">stringi</span>

One of many examples of locale-dependent services is the Collator, which performs a locale-aware string comparison. It is used for string comparing, ordering, sorting, and searching. See [`stri_opts_collator`](stri_opts_collator.md) for the description on how to tune its settings, and its `locale` argument in particular.

Other locale-sensitive functions include, e.g., [`stri_trans_tolower`](stri_trans_casemap.md) (that does character case mapping).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Locale* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/locale/>

*ISO 639: Language Codes*, <https://www.iso.org/iso-639-language-codes.html>

*ISO 3166: Country Codes*, <https://www.iso.org/iso-3166-country-codes.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Gagolewski M., <span class="pkg">stringi</span>: Fast and portable character string processing in R, *Journal of Statistical Software* 103(2), 2022, 1-59, doi: [10.18637/jss.v103.i02](https://doi.org/10.18637/jss.v103.i02)

Other locale_management: [`stri_locale_info()`](stri_locale_info.md), [`stri_locale_list()`](stri_locale_list.md), [`stri_locale_set()`](stri_locale_set.md)

Other locale_sensitive: [`%s<%()`](+25s+3C+25.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_coll`](about_search_coll.md), [`stri_compare()`](stri_compare.md), [`stri_count_boundaries()`](stri_count_boundaries.md), [`stri_duplicated()`](stri_duplicated.md), [`stri_enc_detect2()`](stri_enc_detect2.md), [`stri_extract_all_boundaries()`](stri_extract_boundaries.md), [`stri_locate_all_boundaries()`](stri_locate_boundaries.md), [`stri_opts_collator()`](stri_opts_collator.md), [`stri_order()`](stri_order.md), [`stri_rank()`](stri_rank.md), [`stri_sort_key()`](stri_sort_key.md), [`stri_sort()`](stri_sort.md), [`stri_split_boundaries()`](stri_split_boundaries.md), [`stri_trans_tolower()`](stri_trans_casemap.md), [`stri_unique()`](stri_unique.md), [`stri_wrap()`](stri_wrap.md)

Other stringi_general_topics: [`about_arguments`](about_arguments.md), [`about_encoding`](about_encoding.md), [`about_search_boundaries`](about_search_boundaries.md), [`about_search_charclass`](about_search_charclass.md), [`about_search_coll`](about_search_coll.md), [`about_search_fixed`](about_search_fixed.md), [`about_search_regex`](about_search_regex.md), [`about_search`](about_search.md), [`about_stringi`](about_stringi.md)
