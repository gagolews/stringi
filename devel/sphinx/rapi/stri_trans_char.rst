stri_trans_char: Translate Characters
=====================================

Description
~~~~~~~~~~~

Translates Unicode code points in each input string.

Usage
~~~~~

.. code-block:: r

   stri_trans_char(str, pattern, replacement)

Arguments
~~~~~~~~~

+-----------------+------------------------------------------------------------------+
| ``str``         | character vector                                                 |
+-----------------+------------------------------------------------------------------+
| ``pattern``     | a single character string providing code points to be translated |
+-----------------+------------------------------------------------------------------+
| ``replacement`` | a single character string giving translated code points          |
+-----------------+------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and with respect to each code point in ``pattern`` and ``replacement``.

If ``pattern`` and ``replacement`` consist of a different number of code points, then the extra code points in the longer of the two are ignored, with a warning.

If code points in a given ``pattern`` are not unique, the last corresponding replacement code point is used.

Time complexity for each string in ``str`` is O(``stri_length(str)*stri_length(pattern)``).

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other transform: `stri_trans_general()`_, `stri_trans_list()`_, `stri_trans_nfc()`_, `stri_trans_tolower()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_trans_char('id.123', '.', '_')
   stri_trans_char('babaab', 'ab', '01')
   stri_trans_char('GCUACGGAGCUUCGGAGCUAG', 'ACGT', 'TGCA')

.. _stri_trans_general(): stri_trans_general.html
.. _stri_trans_list(): stri_trans_list.html
.. _stri_trans_nfc(): stri_trans_nf.html
.. _stri_trans_tolower(): stri_trans_casemap.html
