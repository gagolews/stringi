stri_rand_strings: Generate Random Strings
==========================================

Description
~~~~~~~~~~~

Generates (pseudo)random strings of desired lengths.

Usage
~~~~~

.. code-block:: r

   stri_rand_strings(n, length, pattern = "[A-Za-z0-9]")

Arguments
~~~~~~~~~

+-------------+---------------------------------------------------------------------------------------------------------------------------------------+
| ``n``       | single integer, number of observations                                                                                                |
+-------------+---------------------------------------------------------------------------------------------------------------------------------------+
| ``length``  | integer vector, desired string lengths                                                                                                |
+-------------+---------------------------------------------------------------------------------------------------------------------------------------+
| ``pattern`` | character vector specifying character classes to draw elements from, see `stringi-search-charclass <stringi-search-charclass.html>`__ |
+-------------+---------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``length`` and ``pattern``. If length of ``length`` or ``pattern`` is greater than ``n``, then redundant elements are ignored. Otherwise, these vectors are recycled if necessary.

This operation may result in non-Unicode-normalized strings and may give peculiar outputs for bidirectional strings.

Sampling of code points from the set specified by ``pattern`` is always done with replacement and each code point appears with equal probability.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other random: `stri_rand_lipsum() <stri_rand_lipsum.html>`__, `stri_rand_shuffle() <stri_rand_shuffle.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_rand_strings(5, 10) # 5 strings of length 10
   stri_rand_strings(5, sample(1:10, 5, replace=TRUE)) # 5 strings of random lengths
   stri_rand_strings(10, 5, '[\\p{script=latin}&\\p{Ll}]') # small letters from the Latin script

   # generate n random passwords of length in [8, 14]
   # consisting of at least one digit, small and big ASCII letter:
   n <- 10
   stri_rand_shuffle(stri_paste(
      stri_rand_strings(n, 1, '[0-9]'),
      stri_rand_strings(n, 1, '[a-z]'),
      stri_rand_strings(n, 1, '[A-Z]'),
      stri_rand_strings(n, sample(5:11, 5, replace=TRUE), '[a-zA-Z0-9]')
   ))

