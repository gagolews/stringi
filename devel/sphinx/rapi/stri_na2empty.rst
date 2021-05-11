stri_na2empty: Replace NAs with Empty Strings
=============================================

Description
~~~~~~~~~~~

This function replaces all missing values with empty strings. See `stri_replace_na`_ for a generalization.

Usage
~~~~~

.. code-block:: r

   stri_na2empty(x)

Arguments
~~~~~~~~~

===== ==================
``x`` a character vector
===== ==================

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other utils: `stri_list2matrix()`_, `stri_remove_empty()`_, `stri_replace_na()`_

Examples
~~~~~~~~

.. code-block:: r

   stri_na2empty(c('a', NA, '', 'b'))

.. _stri_replace_na: stri_replace_na.html
.. _stri_list2matrix(): stri_list2matrix.html
.. _stri_remove_empty(): stri_remove_empty.html
.. _stri_replace_na(): stri_replace_na.html
