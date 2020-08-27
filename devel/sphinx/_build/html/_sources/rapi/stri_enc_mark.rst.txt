stri_enc_mark: Get Declared Encodings of Each String
====================================================

Description
~~~~~~~~~~~

Reads declared encodings for each string in a character vector as seen by stringi.

Usage
~~~~~

.. code-block:: r

   stri_enc_mark(str)

Arguments
~~~~~~~~~

+---------+---------------------------------------------------------------+
| ``str`` | character vector or an object coercible to a character vector |
+---------+---------------------------------------------------------------+

Details
~~~~~~~

According to ``Encoding``, R has a simple encoding marking mechanism: strings can be declared to be in ``latin1``, ``UTF-8`` or ``bytes``.

Moreover, we may check (via the R/C API) whether a string is in ASCII (R assumes that this holds if and only if all bytes in a string are not greater than 127, so there is an implicit assumption that your platform uses an encoding that extends ASCII) or in the system's default (a.k.a. ``unknown`` in ``Encoding``) encoding.

Intuitively, the default encoding should be equivalent to the one you use on ``stdin`` (e.g., your 'keyboard'). In stringi we assume that such an encoding is equivalent to the one returned by `stri_enc_get <stri_enc_set.html>`__. It is automatically detected by ICU to match – by default – the encoding part of the ``LC_CTYPE`` category as given by ``Sys.getlocale``.

Value
~~~~~

Returns a character vector of the same length as ``str``. Unlike in the ``Encoding`` function, here the possible encodings are: ``ASCII``, ``latin1``, ``bytes``, ``native``, and ``UTF-8``. Additionally, missing values are handled properly.

This gives exactly the same data that is used by all the functions in stringi to re-encode their inputs.

See Also
~~~~~~~~

Other encoding_management: `about_encoding <about_encoding.html>`__, `stri_enc_info() <stri_enc_info.html>`__, `stri_enc_list() <stri_enc_list.html>`__, `stri_enc_set() <stri_enc_set.html>`__
