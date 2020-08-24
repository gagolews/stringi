stri_rand_lipsum: A Lorem Ipsum Generator
=========================================

Description
~~~~~~~~~~~

Generates (pseudo)random *lorem ipsum* text consisting of a given number of text paragraphs.

Usage
~~~~~

.. code-block:: r

   stri_rand_lipsum(n_paragraphs, start_lipsum = TRUE)

Arguments
~~~~~~~~~

+------------------+------------------------------------------------------------------------------------------+
| ``n_paragraphs`` | single integer, number of paragraphs to generate                                         |
+------------------+------------------------------------------------------------------------------------------+
| ``start_lipsum`` | single logical value; should the resulting text start with *Lorem ipsum dolor sit amet*? |
+------------------+------------------------------------------------------------------------------------------+

Details
~~~~~~~

*Lorem ipsum* is a dummy text often used as a source of data for string processing and displaying/lay-outing exercises.

The current implementation is very simple: words are selected randomly from a Zipf distribution (based on a set of ca. 190 predefined Latin words). The number of words per sentence and sentences per paragraph follows a discretized, truncated normal distribution. No Markov chain modeling, just i.i.d. word selection.

Value
~~~~~

Returns a character vector of length ``nparagraphs``.

See Also
~~~~~~~~

Other random: `stri_rand_shuffle() <stri_rand_shuffle.html>`__, `stri_rand_strings() <stri_rand_strings.html>`__

Examples
~~~~~~~~

.. code-block:: r

   cat(sapply(
      stri_wrap(stri_rand_lipsum(10), 80, simplify=FALSE),
      stri_flatten, collapse='\n'), sep='\n\n')
   cat(stri_rand_lipsum(10), sep='\n\n')

