stri_stats_latex: Statistics for a Character Vector Containing LaTeX Commands
=============================================================================

Description
~~~~~~~~~~~

This function gives LaTeX-oriented statistics for a character vector, e.g., obtained by loading a text file with the ``readLines`` function, where each text line is represented by a separate string.

Usage
~~~~~

.. code-block:: r

   stri_stats_latex(str)

Arguments
~~~~~~~~~

======= =================================
``str`` character vector to be aggregated
======= =================================

Details
~~~~~~~

We use a slightly modified LaTeX Word Count algorithm implemented in Kile 2.1.3, see https://kile.sourceforge.io/team.php for the original contributors.

Value
~~~~~

Returns an integer vector with the following named elements:

#. ``CharsWord`` - number of word characters;

#. ``CharsCmdEnvir`` - command and words characters;

#. ``CharsWhite`` - LaTeX white spaces, including { and } in some contexts;

#. ``Words`` - number of words;

#. ``Cmds`` - number of commands;

#. ``Envirs`` - number of environments;

#. ... (Other stuff that may appear in future releases of stringi).

See Also
~~~~~~~~

Other stats: `stri_stats_general() <stri_stats_general.html>`__

Examples
~~~~~~~~

.. code-block:: r

   s <- c('Lorem \\textbf{ipsum} dolor sit \\textit{amet}, consectetur adipisicing elit.',
          '\\begin{small}Proin nibh augue,\\end{small} suscipit a, scelerisque sed, lacinia in, mi.',
          '')
   stri_stats_latex(s)
