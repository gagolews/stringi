stri_reverse: Reverse Each String
=================================

Description
~~~~~~~~~~~

Reverses the order of the code points in every string.

Usage
~~~~~

.. code-block:: r

   stri_reverse(str)

Arguments
~~~~~~~~~

======= ================
``str`` character vector
======= ================

Details
~~~~~~~

Note that this operation may result in non-Unicode-normalized strings and may give peculiar outputs for bidirectional strings.

See also `stri_rand_shuffle`_ for a random permutation of code points.

Value
~~~~~

Returns a character vector.

Examples
~~~~~~~~

.. code-block:: r

   stri_reverse(c('123', 'abc d e f'))
   stri_reverse('ZXY (\u0105\u0104123$^).')
   stri_reverse(stri_trans_nfd('\u0105')) == stri_trans_nfd('\u0105') # A, ogonek -> agonek, A

.. _stri_rand_shuffle: stri_rand_shuffle.html
