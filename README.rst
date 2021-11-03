*******************************************************************************
                       vim-rst: reStructuredText for Vim
*******************************************************************************


Installation
============

Clone to the ``~/.vim/pack/plugins/start/vim-rst`` where ``plugins`` is an
arbitrary directory name inside ``/pack``::

  git clone https://github.com/habamax/vim-rst ~/.vim/pack/plugins/start/

Or use instructions of your plugin manager or choice.


Difference to bundled reStructuredText
======================================

- ``formatlistpat`` is added (Although it doesn't handle ``ii.`` or ``I.`` etc.).

- Arguably "sane" indentation, that also take into account  ``formatlistpat``.

- Handle nested directives.

- Inline markup highlighting takes care of a lot of edge cases and follows
  `inline markup recognition rules`__.

- Section highlighting doesn't clash with simple tables and has separate
  section delimiter highlight.

- Roles are highlighted such as ``:kbd:`Enter```.

- List items are highlighted (although not in tables).

- Simple table delimiters with empty rows are highlighted.

- Field lists and URLs are highlighted.

- and more...

__ https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#inline-markup-recognition-rules


Screens
=======

.. image:: https://user-images.githubusercontent.com/234774/139922362-55787849-193b-475d-a91f-838ea29982cd.png

.. image:: https://user-images.githubusercontent.com/234774/140016441-d633367d-8e06-4fe1-ae58-4591bee9d829.png

.. image:: https://user-images.githubusercontent.com/234774/139923458-864e0f7a-d07a-4970-b7ca-3567861768f8.png

.. image:: https://user-images.githubusercontent.com/234774/139924145-19517dfb-b93c-494f-8f86-85564cf19acf.png
