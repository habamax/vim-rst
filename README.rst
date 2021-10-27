#################################
vim-rst: reStructuredText for Vim
#################################


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

- Inline markup highlighting takes care of a lot of edge cases and follows
  `inline markup recognition rules`_.

- Section highlighting doesn't clash with simple tables and has separate
  section delimiter highlight.

- Roles are highlighted such as ``:kbd:`Enter```.

- List items are highlighted (although not in tables).

- Simple table delimiters with empty rows are highlighted.

- Field lists and URLs are highlighted.

- and more...

.. _`inline markup recognition rules`:
  https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#inline-markup-recognition-rules


Screens
=======

.. image:: https://user-images.githubusercontent.com/234774/139091160-ef55351c-b763-45c1-9149-40576c7f9083.png

.. image:: https://user-images.githubusercontent.com/234774/139091329-dfa54f76-b501-4087-8d3d-b1c12e084a6b.png

.. image:: https://user-images.githubusercontent.com/234774/139091489-f2558b8b-9b09-4df1-a07b-41d6c9778bda.png

.. image:: https://user-images.githubusercontent.com/234774/139091727-ef7b6c8c-ab3b-4dcf-84e8-f29391d89ce7.png

.. image:: https://user-images.githubusercontent.com/234774/139092006-b34fda70-1303-4041-a810-85600957c919.png

.. image:: https://user-images.githubusercontent.com/234774/139092196-32683670-ac8b-4d39-b88a-1191d4c99a1f.png

