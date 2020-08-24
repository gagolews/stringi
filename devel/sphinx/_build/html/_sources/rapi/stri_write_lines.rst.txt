stri_write_lines: Write Text Lines to a Text File
=================================================

Description
~~~~~~~~~~~

Writes a text file is such a way that each element of a given character vector becomes a separate text line.

Usage
~~~~~

.. code-block:: r

   stri_write_lines(
     str,
     con,
     encoding = "UTF-8",
     sep = ifelse(.Platform$OS.type == "windows", "\r\n", "\n")
   )

Arguments
~~~~~~~~~

+--------------+----------------------------------------------------------------------------+
| ``str``      | character vector with data to write                                        |
+--------------+----------------------------------------------------------------------------+
| ``con``      | name of the output file or a connection object (opened in the binary mode) |
+--------------+----------------------------------------------------------------------------+
| ``encoding`` | output encoding, ``NULL`` or ``''`` for the current default one            |
+--------------+----------------------------------------------------------------------------+
| ``sep``      | newline separator                                                          |
+--------------+----------------------------------------------------------------------------+

Details
~~~~~~~

It is a substitute for the R ``writeLines`` function, with the ability to easily re-encode the output.

We suggest using the UTF-8 encoding for all text files: thus, it is the default one for the output.

Value
~~~~~

This function returns nothing noteworthy.

See Also
~~~~~~~~

Other files: `stri_read_lines() <stri_read_lines.html>`__, `stri_read_raw() <stri_read_raw.html>`__
