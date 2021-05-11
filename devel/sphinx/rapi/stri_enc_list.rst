stri_enc_list: List Known Character Encodings
=============================================

Description
~~~~~~~~~~~

Gives the list of encodings that are supported by ICU.

Usage
~~~~~

.. code-block:: r

   stri_enc_list(simplify = FALSE)

Arguments
~~~~~~~~~

+--------------+---------------------------------------------------------------------------------+
| ``simplify`` | single logical value; return a character vector or a list of character vectors? |
+--------------+---------------------------------------------------------------------------------+

Details
~~~~~~~

Apart from given encoding identifiers and their aliases, some other specifiers might be additionally available. This is due to the fact that ICU tries to normalize converter names. For instance, ``'UTF8'`` is also valid, see `stringi-encoding`_ for more information.

Value
~~~~~

If ``simplify`` is ``FALSE`` (the default), a list of character vectors is returned. Each list element represents a unique character encoding. The ``name`` attribute gives the ICU Canonical Name of an encoding family. The elements (character vectors) are its aliases.

If ``simplify`` is ``TRUE``, then the resulting list is coerced to a character vector and sorted, and returned with removed duplicated entries.

See Also
~~~~~~~~

Other encoding_management: `about_encoding`_, `stri_enc_info()`_, `stri_enc_mark()`_, `stri_enc_set()`_

.. _stringi-encoding: about_encoding.html
.. _about_encoding: about_encoding.html
.. _stri_enc_info(): stri_enc_info.html
.. _stri_enc_mark(): stri_enc_mark.html
.. _stri_enc_set(): stri_enc_set.html
