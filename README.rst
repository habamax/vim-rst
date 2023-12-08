###############################################################################
                       vim-rst: reStructuredText for Vim
###############################################################################


Installation
============

Clone to the ``~/.vim/pack/plugins/start/vim-rst`` where ``plugins`` is an
arbitrary directory name inside ``/pack``::

  git clone https://github.com/habamax/vim-rst ~/.vim/pack/plugins/start/

Or use instructions of your plugin manager of choice.


Difference to bundled reStructuredText
======================================

- ``formatlistpat`` is added (although it doesn't handle ``ii.`` or ``I.`` etc.).

- Arguably "sane" indentation.

- Handle nested directives.

- Inline markup highlighting takes care of a lot of edge cases and follows
  `inline markup recognition rules`__.

- Section highlighting doesn't clash with simple tables and has separate
  section delimiter highlight.

- Roles are highlighted such as ``:kbd:`Enter```.

- List items are highlighted.

- Simple table delimiters with empty rows are highlighted.

- Field lists and URLs are highlighted.

- and more...

__ https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#inline-markup-recognition-rules


Additional things you could try
===============================

- `Fuzzy Table Of Contents`_ for Vim9
- `Auto adjust section delimiters`_
- `Generate PDF using Chrome web browser`_
- `Preview HTML version in web browser`_

.. _Fuzzy Table Of Contents: https://github.com/habamax/vim-rst/wiki/Fuzzy-Table-Of-Contents
.. _Auto adjust section delimiters: https://github.com/habamax/vim-rst/wiki/Auto-adjust-section-delimiters
.. _Generate PDF using Chrome web browser: https://github.com/habamax/vim-rst/wiki/Generate-PDF-using-Chrome-web-browser
.. _Preview HTML version in web browser: https://github.com/habamax/vim-rst/wiki/Preview-HTML-version-in-web-browser


Screens
=======

.. image:: https://user-images.githubusercontent.com/234774/139922362-55787849-193b-475d-a91f-838ea29982cd.png

.. image:: https://user-images.githubusercontent.com/234774/140016933-3f0e5ebb-5220-4e29-945b-b10c1c334cf1.png

.. image:: https://user-images.githubusercontent.com/234774/139923458-864e0f7a-d07a-4970-b7ca-3567861768f8.png

.. image:: https://user-images.githubusercontent.com/234774/139924145-19517dfb-b93c-494f-8f86-85564cf19acf.png
