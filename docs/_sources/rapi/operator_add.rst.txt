operator_add: Concatenate Two Character Vectors
===============================================

Description
~~~~~~~~~~~

Binary operators for joining (concatenating) two character vectors, with a typical R look-and-feel.

Usage
~~~~~

.. code-block:: r

   e1 %s+% e2

   e1 %stri+% e2

Arguments
~~~~~~~~~

====== ===============================================================
``e1`` a character vector or an object coercible to a character vector
``e2`` a character vector or an object coercible to a character vector
====== ===============================================================

Details
~~~~~~~

Vectorized over ``e1`` and ``e2``.

These operators act like a call to `stri_join(e1, e2, sep='') <stri_join.html>`__. However, note that joining 3 vectors, e.g., ``e1 %s+% e2 %s+% e3`` is slower than `stri_join(e1, e2, e3, sep='') <stri_join.html>`__, because it creates a new (temporary) result vector each time the operator is applied.

Value
~~~~~

Returns a character vector.

See Also
~~~~~~~~

Other join: `stri_dup() <stri_dup.html>`__, `stri_flatten() <stri_flatten.html>`__, `stri_join_list() <stri_join_list.html>`__, `stri_join() <stri_join.html>`__

Examples
~~~~~~~~

.. code-block:: r

   c('abc', '123', 'xy') %s+% letters[1:6]
   'ID_' %s+% 1:5
