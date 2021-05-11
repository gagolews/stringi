stri_locale_set: Set or Get Default Locale in stringi
=====================================================

Description
~~~~~~~~~~~

``stri_locale_set`` changes the default locale for all the functions in the stringi package, i.e., establishes the meaning of the “\ ``NULL`` locale” argument of locale-sensitive functions. ``stri_locale_get`` gives the current default locale.

Usage
~~~~~

.. code-block:: r

   stri_locale_set(locale)

   stri_locale_get()

Arguments
~~~~~~~~~

+------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| ``locale`` | single string of the form ``Language``, ``Language_Country``, or ``Language_Country_Variant``, e.g., ``'en_US'``, see `stri_locale_list`_. |
+------------+--------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

See `stringi-locale`_ for more information on the effect of changing the default locale.

``stri_locale_get`` is the same as `stri_locale_info(NULL)$Name`_.

Value
~~~~~

``stri_locale_set`` returns a string with previously used locale, invisibly.

``stri_locale_get`` returns a string of the form ``Language``, ``Language_Country``, or ``Language_Country_Variant``, e.g., ``'en_US'``.

See Also
~~~~~~~~

Other locale_management: `about_locale`_, `stri_locale_info()`_, `stri_locale_list()`_

Examples
~~~~~~~~

.. code-block:: r

   ## Not run: 
   oldloc <- stri_locale_set('pt_BR')
   # ... some locale-dependent operations
   # ... note that you may always modify a locale per-call
   # ... changing the default locale is convenient if you perform
   # ... many operations
   stri_locale_set(oldloc) # restore the previous default locale

   ## End(Not run)

.. _stri_locale_list: stri_locale_list.html
.. _stringi-locale: about_locale.html
.. _stri_locale_info(NULL)$Name: stri_locale_info.html
.. _about_locale: about_locale.html
.. _stri_locale_info(): stri_locale_info.html
.. _stri_locale_list(): stri_locale_list.html
