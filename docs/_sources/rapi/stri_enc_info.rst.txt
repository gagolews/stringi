stri_enc_info: Query a Character Encoding
=========================================

Description
~~~~~~~~~~~

Gets basic information on a character encoding.

Usage
~~~~~

.. code-block:: r

   stri_enc_info(enc = NULL)

Arguments
~~~~~~~~~

+---------+------------------------------------------------------------------------------------+
| ``enc`` | ``NULL`` or ``''`` for the default encoding, or a single string with encoding name |
+---------+------------------------------------------------------------------------------------+

Details
~~~~~~~

An error is raised if the provided encoding is unknown to ICU (see `stri_enc_list <stri_enc_list.html>`__ for more details).

Value
~~~~~

Returns a list with the following components:

-  ``Name.friendly`` – friendly encoding name: MIME Name or JAVA Name or ICU Canonical Name (the first of provided ones is selected, see below);

-  ``Name.ICU`` – encoding name as identified by ICU;

-  ``Name.*`` – other standardized encoding names, e.g., ``Name.UTR22``, ``Name.IBM``, ``Name.WINDOWS``, ``Name.JAVA``, ``Name.IANA``, ``Name.MIME`` (some of them may be unavailable for all the encodings);

-  ``ASCII.subset`` – is ASCII a subset of the given encoding?;

-  ``Unicode.1to1`` – for 8-bit encodings only: are all characters translated to exactly one Unicode code point and is the translation scheme reversible?;

-  ``CharSize.8bit`` – is this an 8-bit encoding, i.e., do we have ``CharSize.min == CharSize.max`` and ``CharSize.min == 1``?;

-  ``CharSize.min`` – minimal number of bytes used to represent a UChar (in UTF-16, this is not the same as UChar32)

-  ``CharSize.max`` – maximal number of bytes used to represent a UChar (in UTF-16, this is not the same as UChar32, i.e., does not reflect the maximal code point representation size)

See Also
~~~~~~~~

Other encoding_management: `stri_enc_list() <stri_enc_list.html>`__, `stri_enc_mark() <stri_enc_mark.html>`__, `stri_enc_set() <stri_enc_set.html>`__, `stringi-encoding <stringi-encoding.html>`__
