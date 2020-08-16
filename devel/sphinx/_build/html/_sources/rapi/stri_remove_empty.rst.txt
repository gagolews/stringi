stri_remove_empty: Remove All Empty Strings from a Character Vector
===================================================================

Description
~~~~~~~~~~~

``stri_remove_empty`` (alias ``stri_omit_empty``) removes all empty strings from a character vector, and, if ``na_empty`` is ``TRUE``, also gets rid of all missing values.

``stri_remove_empty_na`` (alias ``stri_omit_empty_na``) removes both empty strings and missing values.

``stri_remove_na`` (alias ``stri_omit_na``) returns a version of ``x`` with missing values removed.

Usage
~~~~~

.. code-block:: r

   stri_remove_empty(x, na_empty = FALSE)

   stri_omit_empty(x, na_empty = FALSE)

   stri_remove_empty_na(x)

   stri_omit_empty_na(x)

   stri_remove_na(x)

   stri_omit_na(x)

Arguments
~~~~~~~~~

+--------------+----------------------------------------------------+
| ``x``        | a character vector                                 |
+--------------+----------------------------------------------------+
| ``na_empty`` | should missing values be treated as empty strings? |
+--------------+----------------------------------------------------+

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other utils: `stri_list2matrix() <stri_list2matrix.html>`__, `stri_na2empty() <stri_na2empty.html>`__, `stri_replace_na() <stri_replace_na.html>`__

Examples
~~~~~~~~

.. code-block:: r

   stri_remove_empty(stri_na2empty(c("a", NA, "", "b")))
   stri_remove_empty(c("a", NA, "", "b"))
   stri_remove_empty(c("a", NA, "", "b"), TRUE)

   stri_omit_empty_na(c("a", NA, "", "b"))

