stri_trans_list: List Available Text Transforms and Transliterators
===================================================================

Description
~~~~~~~~~~~

Returns a list of available text transform identifiers. Each of them may be used in `stri_trans_general`_ tasks.

Usage
~~~~~

.. code-block:: r

   stri_trans_list()

Value
~~~~~

Returns a character vector.

References
~~~~~~~~~~

*General Transforms* – ICU User Guide, http://userguide.icu-project.org/transforms/general

See Also
~~~~~~~~

Other transform: `stri_trans_char()`_, `stri_trans_general()`_, `stri_trans_nfc()`_, `stri_trans_tolower()`_

.. _stri_trans_general: stri_trans_general.html
.. _stri_trans_char(): stri_trans_char.html
.. _stri_trans_general(): stri_trans_general.html
.. _stri_trans_nfc(): stri_trans_nf.html
.. _stri_trans_tolower(): stri_trans_casemap.html
