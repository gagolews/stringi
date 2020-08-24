stri_rand_shuffle: Randomly Shuffle Code Points in Each String
==============================================================

Description
~~~~~~~~~~~

Generates a (pseudo)random permutation of the code points in each string.

Usage
~~~~~

.. code-block:: r

   stri_rand_shuffle(str)

Arguments
~~~~~~~~~

+---------+------------------+
| ``str`` | character vector |
+---------+------------------+

Details
~~~~~~~

This operation may result in non-Unicode-normalized strings and may give peculiar outputs in case of bidirectional strings.

See also `stri_reverse <stri_reverse.html>`__ for reversing the order of code points.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other random: `stri_rand_lipsum() <stri_rand_lipsum.html>`__, `stri_rand_strings() <stri_rand_strings.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_rand_shuffle(c('abcdefghi', '0123456789'))
   # you can do better than this with stri_rand_strings:
   stri_rand_shuffle(rep(stri_paste(letters, collapse=''), 10))

