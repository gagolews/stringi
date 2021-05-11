stri_enc_detect2: [DEPRECATED] Detect Locale-Sensitive Character Encoding
=========================================================================

Description
~~~~~~~~~~~

This function tries to detect character encoding in case the language of text is known.

Usage
~~~~~

.. code-block:: r

   stri_enc_detect2(str, locale = NULL)

Arguments
~~~~~~~~~

+------------+-------------------------------------------------------------------------------------------------------------------------------+
| ``str``    | character vector, a raw vector, or a list of ``raw`` vectors                                                                  |
+------------+-------------------------------------------------------------------------------------------------------------------------------+
| ``locale`` | ``NULL`` or ``''`` for default locale, ``NA`` for just checking the UTF-\* family, or a single string with locale identifier. |
+------------+-------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str``.

First, the text is checked whether it is valid UTF-32BE, UTF-32LE, UTF-16BE, UTF-16LE, UTF-8 (as in `stri_enc_detect`_, this is roughly inspired by ICU's ``i18n/csrucode.cpp``) or ASCII.

If ``locale`` is not ``NA`` and the above fails, the text is checked for the number of occurrences of language-specific code points (data provided by the ICU library) converted to all possible 8-bit encodings that fully cover the indicated language. The encoding is selected based on the greatest number of total byte hits.

The guess is of course imprecise, as it is obtained using statistics and heuristics. Because of this, detection works best if you supply at least a few hundred bytes of character data that is in a single language.

If you have no initial guess on the language and encoding, try with `stri_enc_detect`_ (uses ICU facilities).

Value
~~~~~

Just like `stri_enc_detect`_, this function returns a list of length equal to the length of ``str``. Each list element is a data frame with the following three named components:

-  ``Encoding`` – string; guessed encodings; ``NA`` on failure (iff ``encodings`` is empty),

-  ``Language`` – always ``NA``,

-  ``Confidence`` – numeric in [0,1]; the higher the value, the more confidence there is in the match; ``NA`` on failure.

The guesses are ordered by decreasing confidence.

See Also
~~~~~~~~

Other locale_sensitive: `%s<%()`_, `about_locale`_, `about_search_boundaries`_, `about_search_coll`_, `stri_compare()`_, `stri_count_boundaries()`_, `stri_duplicated()`_, `stri_extract_all_boundaries()`_, `stri_locate_all_boundaries()`_, `stri_opts_collator()`_, `stri_order()`_, `stri_rank()`_, `stri_sort_key()`_, `stri_sort()`_, `stri_split_boundaries()`_, `stri_trans_tolower()`_, `stri_unique()`_, `stri_wrap()`_

Other encoding_detection: `about_encoding`_, `stri_enc_detect()`_, `stri_enc_isascii()`_, `stri_enc_isutf16be()`_, `stri_enc_isutf8()`_

.. _stri_enc_detect: stri_enc_detect.html
.. _%s<%(): operator_compare.html
.. _about_locale: about_locale.html
.. _about_search_boundaries: about_search_boundaries.html
.. _about_search_coll: about_search_coll.html
.. _stri_compare(): stri_compare.html
.. _stri_count_boundaries(): stri_count_boundaries.html
.. _stri_duplicated(): stri_duplicated.html
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
.. _about_encoding: about_encoding.html
.. _stri_enc_detect(): stri_enc_detect.html
.. _stri_enc_isascii(): stri_enc_isascii.html
.. _stri_enc_isutf16be(): stri_enc_isutf16.html
.. _stri_enc_isutf8(): stri_enc_isutf8.html
