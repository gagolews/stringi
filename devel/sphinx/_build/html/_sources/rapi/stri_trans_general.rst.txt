stri_trans_general: General Text Transforms, Including Transliteration
======================================================================

Description
~~~~~~~~~~~

ICU General transforms provide different ways for processing Unicode text. They are useful in handling a variety of different tasks, including:

-  Upper Case, Lower Case, Title Case, Full/Halfwidth conversions,

-  Normalization,

-  Hex and Character Name conversions,

-  Script to Script conversion/transliteration.

Usage
~~~~~

.. code-block:: r

   stri_trans_general(str, id)

Arguments
~~~~~~~~~

+---------+-------------------------------------------------------------------------------------------+
| ``str`` | character vector                                                                          |
+---------+-------------------------------------------------------------------------------------------+
| ``id``  | a single string with transform identifier, see `stri_trans_list <stri_trans_list.html>`__ |
+---------+-------------------------------------------------------------------------------------------+

Details
~~~~~~~

ICU Transforms were mainly designed to transliterate characters from one script to another (for example, from Greek to Latin, or Japanese Katakana to Latin). However, these services are also capable of handling a much broader range of tasks. In particular, the Transforms include pre-built transformations for case conversions, for normalization conversions, for the removal of given characters, and also for a variety of language and script transliterations. Transforms can be chained together to perform a series of operations and each step of the process can use a UnicodeSet to restrict the characters that are affected.

To get the list of available transforms, call `stri_trans_list <stri_trans_list.html>`__.

Note that transliterators are often combined in sequence to achieve a desired transformation. This is analogous to the composition of mathematical functions. For example, given a script that converts lowercase ASCII characters from Latin script to Katakana script, it is convenient to first (1) separate input base characters and accents, and then (2) convert uppercase to lowercase. To achieve this, a compound transform can be specified as follows: ``NFKD; Lower; Latin-Katakana;``

Value
~~~~~

Returns a character vector.

References
~~~~~~~~~~

*General Transforms* – ICU User Guide, http://userguide.icu-project.org/transforms/general

See Also
~~~~~~~~

Other transform: `stri_trans_char() <stri_trans_char.html>`__, `stri_trans_list() <stri_trans_list.html>`__, `stri_trans_nfc() <stri_trans_nf.html>`__, `stri_trans_tolower() <stri_trans_casemap.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_trans_general('gro\u00df', 'latin-ascii')
   stri_trans_general('stringi', 'latin-greek')
   stri_trans_general('stringi', 'latin-cyrillic')
   stri_trans_general('stringi', 'upper') # see stri_trans_toupper
   stri_trans_general('\u0104', 'nfd; lower') # compound id; see stri_trans_nfd
   stri_trans_general('tato nie wraca ranki wieczory', 'pl-pl_FONIPA')
   stri_trans_general('\u2620', 'any-name') # character name
   stri_trans_general('\\N{latin small letter a}', 'name-any') # decode name
   stri_trans_general('\u2620', 'hex') # to hex
