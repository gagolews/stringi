stri_width: Determine the Width of Code Points
==============================================

Description
~~~~~~~~~~~

Approximates the number of text columns the 'cat()' function should use to print a string with a mono-spaced font.

Usage
~~~~~

.. code-block:: r

   stri_width(str)

Arguments
~~~~~~~~~

+---------+--------------------------------------------+
| ``str`` | character vector or an object coercible to |
+---------+--------------------------------------------+

Details
~~~~~~~

The Unicode standard does not formalize the notion of a character width. Roughly based on http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c and the UAX #11 we proceed as follows. The following code points are of width 0:

-  code points with general category (see `stringi-search-charclass <about_search_charclass.html>`__) ``Me``, ``Mn``, and ``Cf``),

-  ``C0`` and ``C1`` control codes (general category ``Cc``) - for compatibility with the ``nchar`` function,

-  Hangul Jamo medial vowels and final consonants (code points with enumerable property ``UCHAR_HANGUL_SYLLABLE_TYPE`` equal to ``U_HST_VOWEL_JAMO`` or ``U_HST_TRAILING_JAMO``; note that applying the NFC normalization with `stri_trans_nfc <stri_trans_nf.html>`__ is encouraged),

-  ZERO WIDTH SPACE (U+200B),

Characters with the ``UCHAR_EAST_ASIAN_WIDTH`` enumerable property equal to ``U_EA_FULLWIDTH`` or ``U_EA_WIDE`` are of width 2. SOFT HYPHEN (U+00AD) (for compatibility with ``nchar``) as well as any other characters have width 1.

Value
~~~~~

Returns an integer vector of the same length as ``str``.

References
~~~~~~~~~~

*East Asian Width* – Unicode Standard Annex #11, http://www.unicode.org/reports/tr11/

See Also
~~~~~~~~

Other length: `stri_isempty() <stri_isempty.html>`__, `stri_length() <stri_length.html>`__, `stri_numbytes() <stri_numbytes.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_width(LETTERS[1:5])
   stri_width(stri_trans_nfkd('\u0105'))
   stri_width( # Full-width equivalents of ASCII characters:
      stri_enc_fromutf32(as.list(c(0x3000, 0xFF01:0xFF5E)))
   )
   stri_width(stri_trans_nfkd('\ubc1f')) # includes Hangul Jamo medial vowels and final consonants
