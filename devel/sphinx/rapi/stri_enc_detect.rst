stri_enc_detect: Detect Character Set and Language
==================================================

Description
~~~~~~~~~~~

This function uses the ICU engine to determine the character set, or encoding, of character data in an unknown format.

Usage
~~~~~

.. code-block:: r

   stri_enc_detect(str, filter_angle_brackets = FALSE)

Arguments
~~~~~~~~~

+---------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``str``                   | character vector, a raw vector, or a list of ``raw`` vectors                                                                                            |
+---------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``filter_angle_brackets`` | logical; If filtering is enabled, text within angle brackets ('<' and '>') will be removed before detection, which will remove most HTML or XML markup. |
+---------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+

Details
~~~~~~~

Vectorized over ``str`` and ``filter_angle_brackets``.

For a character vector input, merging all text lines via `stri_flatten(str, collapse='\n') <stri_flatten.html>`__ might be needed if ``str`` has been obtained via a call to ``readLines`` and in fact represents an image of a single text file.

This is, at best, an imprecise operation using statistics and heuristics. Because of this, detection works best if you supply at least a few hundred bytes of character data that is mostly in a single language. However, because the detection only looks at a limited amount of the input data, some of the returned character sets may fail to handle all of the input data. Note that in some cases, the language can be determined along with the encoding.

Several different techniques are used for character set detection. For multi-byte encodings, the sequence of bytes is checked for legible patterns. The detected characters are also checked against a list of frequently used characters in that encoding. For single byte encodings, the data is checked against a list of the most commonly occurring three letter groups for each language that can be written using that encoding.

The detection process can be configured to optionally ignore HTML or XML style markup (using ICU's internal facilities), which can interfere with the detection process by changing the statistics.

This function should most often be used for byte-marked input strings, especially after loading them from text files and before the main conversion with `stri_encode <stri_encode.html>`__. The input encoding is of course not taken into account here, even if marked.

The following table shows all the encodings that can be detected:

+-------------------+---------------------------------------------------------------------------------+
| **Character_Set** | **Languages**                                                                   |
+-------------------+---------------------------------------------------------------------------------+
| UTF-8             | --                                                                              |
+-------------------+---------------------------------------------------------------------------------+
| UTF-16BE          | --                                                                              |
+-------------------+---------------------------------------------------------------------------------+
| UTF-16LE          | --                                                                              |
+-------------------+---------------------------------------------------------------------------------+
| UTF-32BE          | --                                                                              |
+-------------------+---------------------------------------------------------------------------------+
| UTF-32LE          | --                                                                              |
+-------------------+---------------------------------------------------------------------------------+
| Shift_JIS         | Japanese                                                                        |
+-------------------+---------------------------------------------------------------------------------+
| ISO-2022-JP       | Japanese                                                                        |
+-------------------+---------------------------------------------------------------------------------+
| ISO-2022-CN       | Simplified Chinese                                                              |
+-------------------+---------------------------------------------------------------------------------+
| ISO-2022-KR       | Korean                                                                          |
+-------------------+---------------------------------------------------------------------------------+
| GB18030           | Chinese                                                                         |
+-------------------+---------------------------------------------------------------------------------+
| Big5              | Traditional Chinese                                                             |
+-------------------+---------------------------------------------------------------------------------+
| EUC-JP            | Japanese                                                                        |
+-------------------+---------------------------------------------------------------------------------+
| EUC-KR            | Korean                                                                          |
+-------------------+---------------------------------------------------------------------------------+
| ISO-8859-1        | Danish, Dutch, English, French, German, Italian, Norwegian, Portuguese, Swedish |
+-------------------+---------------------------------------------------------------------------------+
| ISO-8859-2        | Czech, Hungarian, Polish, Romanian                                              |
+-------------------+---------------------------------------------------------------------------------+
| ISO-8859-5        | Russian                                                                         |
+-------------------+---------------------------------------------------------------------------------+
| ISO-8859-6        | Arabic                                                                          |
+-------------------+---------------------------------------------------------------------------------+
| ISO-8859-7        | Greek                                                                           |
+-------------------+---------------------------------------------------------------------------------+
| ISO-8859-8        | Hebrew                                                                          |
+-------------------+---------------------------------------------------------------------------------+
| ISO-8859-9        | Turkish                                                                         |
+-------------------+---------------------------------------------------------------------------------+
| windows-1250      | Czech, Hungarian, Polish, Romanian                                              |
+-------------------+---------------------------------------------------------------------------------+
| windows-1251      | Russian                                                                         |
+-------------------+---------------------------------------------------------------------------------+
| windows-1252      | Danish, Dutch, English, French, German, Italian, Norwegian, Portuguese, Swedish |
+-------------------+---------------------------------------------------------------------------------+
| windows-1253      | Greek                                                                           |
+-------------------+---------------------------------------------------------------------------------+
| windows-1254      | Turkish                                                                         |
+-------------------+---------------------------------------------------------------------------------+
| windows-1255      | Hebrew                                                                          |
+-------------------+---------------------------------------------------------------------------------+
| windows-1256      | Arabic                                                                          |
+-------------------+---------------------------------------------------------------------------------+
| KOI8-R            | Russian                                                                         |
+-------------------+---------------------------------------------------------------------------------+
| IBM420            | Arabic                                                                          |
+-------------------+---------------------------------------------------------------------------------+
| IBM424            | Hebrew                                                                          |
+-------------------+---------------------------------------------------------------------------------+
|                   |                                                                                 |
+-------------------+---------------------------------------------------------------------------------+

Value
~~~~~

Returns a list of length equal to the length of ``str``. Each list element is a data frame with the following three named vectors representing all the guesses:

-  ``Encoding`` – string; guessed encodings; ``NA`` on failure,

-  ``Language`` – string; guessed languages; ``NA`` if the language could not be determined (e.g., in case of UTF-8),

-  ``Confidence`` – numeric in [0,1]; the higher the value, the more confidence there is in the match; ``NA`` on failure.

The guesses are ordered by decreasing confidence.

References
~~~~~~~~~~

*Character Set Detection* – ICU User Guide, http://userguide.icu-project.org/conversion/detection

See Also
~~~~~~~~

Other encoding_detection: `about_encoding <about_encoding.html>`__, `stri_enc_detect2() <stri_enc_detect2.html>`__, `stri_enc_isascii() <stri_enc_isascii.html>`__, `stri_enc_isutf16be() <stri_enc_isutf16.html>`__, `stri_enc_isutf8() <stri_enc_isutf8.html>`__

Examples
~~~~~~~~

.. code-block:: r

   ## Not run: 
   f <- rawToChar(readBin('test.txt', 'raw', 100000))
   stri_enc_detect(f)

   ## End(Not run)
