about_locale: Locales and stringi
=================================

Description
~~~~~~~~~~~

In this section we explain how we specify locales in stringi. Locale is a fundamental concept in ICU. It identifies a specific user community, i.e., a group of users who have similar culture and language expectations for human-computer interaction.

Details
~~~~~~~

Because a locale is just an identifier of a region, no validity check is performed when you specify a Locale. ICU is implemented as a set of services. If you want to verify whether particular resources are available in the locale you asked for, you must query those resources. Note: when you ask for a resource for a particular locale, you get back the best available match, not necessarily precisely the one you requested.

Locale Identifiers
~~~~~~~~~~~~~~~~~~

ICU services are parametrized by locale, to deliver culturally correct results. Locales are identified by character strings of the form ``Language`` code, ``Language_Country`` code, or ``Language_Country_Variant`` code, e.g., 'en_US'.

The two-letter ``Language`` code uses the ISO-639-1 standard, e.g., 'en' stands for English, 'pl' – Polish, 'fr' – French, and 'de' for German.

``Country`` is a two-letter code following the ISO-3166 standard. This is to reflect different language conventions within the same language, for example in US-English ('en_US') and Australian-English ('en_AU').

Differences may also appear in language conventions used within the same country. For example, the Euro currency may be used in several European countries while the individual country's currency is still in circulation. In such a case, ICU ``Variant`` '_EURO' could be used for selecting locales that support the Euro currency.

The final (optional) element of a locale is a list of keywords together with their values. Keywords must be unique. Their order is not significant. Unknown keywords are ignored. The handling of keywords depends on the specific services that utilize them. Currently, the following keywords are recognized: ``calendar``, ``collation``, ``currency``, and ``numbers``, e.g., ``fr@collation=phonebook;``\ ``calendar=islamic-civil`` is a valid French locale specifier together with keyword arguments. For more information, refer to the ICU user guide.

For a list of locales that are recognized by ICU, call `stri_locale_list`_.

A Note on Default Locales
~~~~~~~~~~~~~~~~~~~~~~~~~

Each locale-sensitive function in stringi selects the current default locale if an empty string or ``NULL`` is provided as its ``locale`` argument. Default locales are available to all the functions: they are initially set to be the system locale on that platform, and may be changed with `stri_locale_set`_, for example, if automatic detection fails to recognize your locale properly.

It is suggested that your program should avoid changing the default locale. All locale-sensitive functions may request any desired locale per-call (by specifying the ``locale`` argument), i.e., without referencing to the default locale. During many tests, however, we did not observe any improper behavior of stringi while using a modified default locale.

Locale-Sensitive Functions in stringi
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

One of many examples of locale-dependent services is the Collator, which performs a locale-aware string comparison. It is used for string comparing, ordering, sorting, and searching. See `stri_opts_collator`_ for the description on how to tune its settings, and its ``locale`` argument in particular.

Other locale-sensitive functions include, e.g., `stri_trans_tolower`_ (that does character case mapping).

References
~~~~~~~~~~

*Locale* – ICU User Guide, http://userguide.icu-project.org/locale

*ISO 639: Language Codes*, https://www.iso.org/iso-639-language-codes.html

*ISO 3166: Country Codes*, https://www.iso.org/iso-3166-country-codes.html

See Also
~~~~~~~~

Other locale_management: `stri_locale_info()`_, `stri_locale_list()`_, `stri_locale_set()`_

Other locale_sensitive: `%s<%()`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_enc_detect2()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Other stringi_general_topics: `about_arguments`_, `about_encoding`_, `about_search_boundaries`_, `about_search_charclass`_, `about_search_coll`_, `about_search_fixed`_, `about_search_regex`_, `about_search`_, `about_stringi`_

.. _stri_locale_list: stri_locale_list.html
.. _stri_locale_set: stri_locale_set.html
.. _stri_opts_collator: stri_opts_collator.html
.. _stri_trans_tolower: stri_trans_casemap.html
.. _stri_locale_info(): stri_locale_info.html
.. _stri_locale_list(): stri_locale_list.html
.. _stri_locale_set(): stri_locale_set.html
.. _%s<%(): operator_compare.html
.. _about_search_boundaries: about_search_boundaries.html
.. _about_search_coll: about_search_coll.html
.. _stri_compare(): stri_compare.html
.. _stri_count_boundaries(): stri_count_boundaries.html
.. _stri_duplicated(): stri_duplicated.html
.. _stri_enc_detect2(): stri_enc_detect2.html
.. _stri_extract_all_boundaries(): stri_extract_boundaries.html
.. _stri_locate_all_boundaries(): stri_locate_boundaries.html
.. _stri_opts_collator(): stri_opts_collator.html
.. _stri_order(): stri_order.html
.. _stri_rank(): stri_rank.html
.. _stri_sort_key(): stri_sort_key.html
.. _stri_sort(): stri_sort.html
.. _stri_split_boundaries(): stri_split_boundaries.html
.. _stri_trans_tolower(): stri_trans_casemap.html
.. _stri_unique(): stri_unique.html
.. _stri_wrap(): stri_wrap.html
.. _about_arguments: about_arguments.html
.. _about_encoding: about_encoding.html
.. _about_search_charclass: about_search_charclass.html
.. _about_search_fixed: about_search_fixed.html
.. _about_search_regex: about_search_regex.html
.. _about_search: about_search.html
.. _about_stringi: about_stringi.html
