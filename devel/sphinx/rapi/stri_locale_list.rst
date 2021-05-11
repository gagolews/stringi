stri_locale_list: List Available Locales
========================================

Description
~~~~~~~~~~~

Creates a character vector with all available locale identifies.

Usage
~~~~~

.. code-block:: r

   stri_locale_list()

Details
~~~~~~~

Note that some of the services may be unavailable in some locales. Querying for locale-specific services is always performed during the resource request.

See `stringi-locale`_ for more information.

Value
~~~~~

Returns a character vector with locale identifiers that are known to ICU.

See Also
~~~~~~~~

Other locale_management: `about_locale`_, `stri_locale_info()`_, `stri_locale_set()`_

.. _stringi-locale: about_locale.html
.. _about_locale: about_locale.html
.. _stri_locale_info(): stri_locale_info.html
.. _stri_locale_set(): stri_locale_set.html
