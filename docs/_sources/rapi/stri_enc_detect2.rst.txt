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

First, the text is checked whether it is valid UTF-32BE, UTF-32LE, UTF-16BE, UTF-16LE, UTF-8 (as in `stri_enc_detect <stri_enc_detect.html>`__, this is roughly inspired by ICU's ``i18n/csrucode.cpp``) or ASCII.

If ``locale`` is not ``NA`` and the above fails, the text is checked for the number of occurrences of language-specific code points (data provided by the ICU library) converted to all possible 8-bit encodings that fully cover the indicated language. The encoding is selected based on the greatest number of total byte hits.

The guess is of course imprecise, as it is obtained using statistics and heuristics. Because of this, detection works best if you supply at least a few hundred bytes of character data that is in a single language.

If you have no initial guess on the language and encoding, try with `stri_enc_detect <stri_enc_detect.html>`__ (uses ICU facilities).

Value
~~~~~

Just like `stri_enc_detect <stri_enc_detect.html>`__, this function returns a list of length equal to the length of ``str``. Each list element is a data frame with the following three named components:

-  ``Encoding`` – string; guessed encodings; ``NA`` on failure (iff ``encodings`` is empty),

-  ``Language`` – always ``NA``,

-  ``Confidence`` – numeric in [0,1]; the higher the value, the more confidence there is in the match; ``NA`` on failure.

The guesses are ordered by decreasing confidence.

See Also
~~~~~~~~

Other locale_sensitive: `%s<%() <operator_compare.html>`__, `about_locale <about_locale.html>`__, `about_search_boundaries <about_search_boundaries.html>`__, `about_search_coll <about_search_coll.html>`__, `stri_compare() <stri_compare.html>`__, `stri_count_boundaries() <stri_count_boundaries.html>`__, `stri_duplicated() <stri_duplicated.html>`__, `stri_extract_all_boundaries() <stri_extract_boundaries.html>`__, `stri_locate_all_boundaries() <stri_locate_boundaries.html>`__, `stri_opts_collator() <stri_opts_collator.html>`__, `stri_order() <stri_order.html>`__, `stri_sort_key() <stri_sort_key.html>`__, `stri_sort() <stri_sort.html>`__, `stri_split_boundaries() <stri_split_boundaries.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__, `stri_unique() <stri_unique.html>`__, `stri_wrap() <stri_wrap.html>`__

Other encoding_detection: `about_encoding <about_encoding.html>`__, `stri_enc_detect() <stri_enc_detect.html>`__, `stri_enc_isascii() <stri_enc_isascii.html>`__, `stri_enc_isutf16be() <stri_enc_isutf16.html>`__, `stri_enc_isutf8() <stri_enc_isutf8.html>`__
