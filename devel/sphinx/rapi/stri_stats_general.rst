stri_stats_general: General Statistics for a Character Vector
=============================================================

Description
~~~~~~~~~~~

This function gives general statistics for a character vector, e.g., obtained by loading a text file with the `readLines`_ or `stri_read_lines`_ function, where each text line' is represented by a separate string.

Usage
~~~~~

.. code-block:: r

   stri_stats_general(str)

Arguments
~~~~~~~~~

======= =================================
``str`` character vector to be aggregated
======= =================================

Details
~~~~~~~

None of the strings may contain ``\r`` or ``\n`` characters, otherwise you will get at error.

Below by 'white space' we mean the Unicode binary property ``WHITE_SPACE``, see ``stringi-search-charclass``.

Value
~~~~~

Returns an integer vector with the following named elements:

#. ``Lines`` - number of lines (number of non-missing strings in the vector);

#. ``LinesNEmpty`` - number of lines with at least one non-``WHITE_SPACE`` character;

#. ``Chars`` - total number of Unicode code points detected;

#. ``CharsNWhite`` - number of Unicode code points that are not ``WHITE_SPACE``\ s;

#. ... (Other stuff that may appear in future releases of stringi).

See Also
~~~~~~~~

Other stats: `stri_stats_latex()`_

Examples
~~~~~~~~

.. code-block:: r

   s <- c('Lorem ipsum dolor sit amet, consectetur adipisicing elit.',
          'nibh augue, suscipit a, scelerisque sed, lacinia in, mi.',
          'Cras vel lorem. Etiam pellentesque aliquet tellus.',
          '')
   stri_stats_general(s)

.. _readLines: https://stat.ethz.ch/R-manual/R-patched/library/base/html/readLines.html
.. _stri_read_lines: stri_read_lines.html
.. _stri_stats_latex(): stri_stats_latex.html
