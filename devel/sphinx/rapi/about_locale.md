# about\_locale: Locales and <span class="pkg">stringi</span>

## Description

In this section we explain how we specify locales in <span class="pkg">stringi</span>. Locale is a fundamental concept in <span class="pkg">ICU</span>. It identifies a specific user community, i.e., a group of users who have similar culture and language expectations for human-computer interaction.

## Details

Because a locale is just an identifier of a region, no validity check is performed when you specify a Locale. <span class="pkg">ICU</span> is implemented as a set of services. If you want to verify whether particular resources are available in the locale you asked for, you must query those resources. Note: when you ask for a resource for a particular locale, you get back the best available match, not necessarily precisely the one you requested.

## Locale Identifiers

<span class="pkg">ICU</span> services are parametrized by locale, to deliver culturally correct results. Locales are identified by character strings of the form `Language` code, `Language_Country` code, or `Language_Country_Variant` code, e.g., \'en\_US\'.

The two-letter `Language` code uses the ISO-639-1 standard, e.g., \'en\' stands for English, \'pl\' -- Polish, \'fr\' -- French, and \'de\' for German.

`Country` is a two-letter code following the ISO-3166 standard. This is to reflect different language conventions within the same language, for example in US-English (\'en\_US\') and Australian-English (\'en\_AU\').

Differences may also appear in language conventions used within the same country. For example, the Euro currency may be used in several European countries while the individual country\'s currency is still in circulation. In such a case, <span class="pkg">ICU</span> `Variant` \'\_EURO\' could be used for selecting locales that support the Euro currency.

The final (optional) element of a locale is a list of keywords together with their values. Keywords must be unique. Their order is not significant. Unknown keywords are ignored. The handling of keywords depends on the specific services that utilize them. Currently, the following keywords are recognized: `calendar`, `collation`, `currency`, and `numbers`, e.g., `fr@collation=phonebook;``calendar=islamic-civil` is a valid French locale specifier together with keyword arguments. For more information, refer to the ICU user guide.

For a list of locales that are recognized by <span class="pkg">ICU</span>, call [`stri_locale_list`](https://stringi.gagolewski.com/rapi/stri_locale_list.html).

## A Note on Default Locales

Each locale-sensitive function in <span class="pkg">stringi</span> selects the current default locale if an empty string or `NULL` is provided as its `locale` argument. Default locales are available to all the functions: they are initially set to be the system locale on that platform, and may be changed with [`stri_locale_set`](https://stringi.gagolewski.com/rapi/stri_locale_set.html), for example, if automatic detection fails to recognize your locale properly.

It is suggested that your program should avoid changing the default locale. All locale-sensitive functions may request any desired locale per-call (by specifying the `locale` argument), i.e., without referencing to the default locale. During many tests, however, we did not observe any improper behavior of <span class="pkg">stringi</span> while using a modified default locale.

## Locale-Sensitive Functions in <span class="pkg">stringi</span>

One of many examples of locale-dependent services is the Collator, which performs a locale-aware string comparison. It is used for string comparing, ordering, sorting, and searching. See [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html) for the description on how to tune its settings, and its `locale` argument in particular.

Other locale-sensitive functions include, e.g., [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html) (that does character case mapping).

## Author(s)

[Marek Gagolewski](https://www.gagolewski.com/) and other contributors

## References

*Locale* -- ICU User Guide, <https://unicode-org.github.io/icu/userguide/locale/>

*ISO 639: Language Codes*, <https://www.iso.org/iso-639-language-codes.html>

*ISO 3166: Country Codes*, <https://www.iso.org/iso-3166-country-codes.html>

## See Also

The official online manual of <span class="pkg">stringi</span> at <https://stringi.gagolewski.com/>

Other locale\_management: [`stri_locale_info`](https://stringi.gagolewski.com/rapi/stri_locale_info.html)(), [`stri_locale_list`](https://stringi.gagolewski.com/rapi/stri_locale_list.html)(), [`stri_locale_set`](https://stringi.gagolewski.com/rapi/stri_locale_set.html)()

Other locale\_sensitive: `%s<%()`, [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`stri_compare`](https://stringi.gagolewski.com/rapi/stri_compare.html)(), [`stri_count_boundaries`](https://stringi.gagolewski.com/rapi/stri_count_boundaries.html)(), [`stri_duplicated`](https://stringi.gagolewski.com/rapi/stri_duplicated.html)(), [`stri_enc_detect2`](https://stringi.gagolewski.com/rapi/stri_enc_detect2.html)(), [`stri_extract_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_extract_all_boundaries.html)(), [`stri_locate_all_boundaries`](https://stringi.gagolewski.com/rapi/stri_locate_all_boundaries.html)(), [`stri_opts_collator`](https://stringi.gagolewski.com/rapi/stri_opts_collator.html)(), [`stri_order`](https://stringi.gagolewski.com/rapi/stri_order.html)(), [`stri_rank`](https://stringi.gagolewski.com/rapi/stri_rank.html)(), [`stri_sort_key`](https://stringi.gagolewski.com/rapi/stri_sort_key.html)(), [`stri_sort`](https://stringi.gagolewski.com/rapi/stri_sort.html)(), [`stri_split_boundaries`](https://stringi.gagolewski.com/rapi/stri_split_boundaries.html)(), [`stri_trans_tolower`](https://stringi.gagolewski.com/rapi/stri_trans_tolower.html)(), [`stri_unique`](https://stringi.gagolewski.com/rapi/stri_unique.html)(), [`stri_wrap`](https://stringi.gagolewski.com/rapi/stri_wrap.html)()

Other stringi\_general\_topics: [`about_arguments`](https://stringi.gagolewski.com/rapi/about_arguments.html), [`about_encoding`](https://stringi.gagolewski.com/rapi/about_encoding.html), [`about_search_boundaries`](https://stringi.gagolewski.com/rapi/about_search_boundaries.html), [`about_search_charclass`](https://stringi.gagolewski.com/rapi/about_search_charclass.html), [`about_search_coll`](https://stringi.gagolewski.com/rapi/about_search_coll.html), [`about_search_fixed`](https://stringi.gagolewski.com/rapi/about_search_fixed.html), [`about_search_regex`](https://stringi.gagolewski.com/rapi/about_search_regex.html), [`about_search`](https://stringi.gagolewski.com/rapi/about_search.html), [`about_stringi`](https://stringi.gagolewski.com/rapi/about_stringi.html)
