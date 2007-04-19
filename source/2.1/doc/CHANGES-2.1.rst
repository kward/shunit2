Changes in shUnit2 2.1.X
========================

Changes with 2.1.0 (since 2.0.1)
--------------------------------

This release is a branch of the 2.0.1 release.

Moving to `reStructured Text <http://docutils.sourceforge.net/rst.html>`_ for
the documentation.

Fixed problem with ``fail()``. The failure message was not properly printed.

Fixed the ``Makefile`` so that the DocBook XML and XSLT files would be
downloaded before parsing can continue.

Renamed the internal ``__SHUNIT_TRUE`` and ``__SHUNIT_FALSE`` variables to
``SHUNIT_TRUE`` and ``SHUNIT_FALSE`` so that unit tests can "use" them.

Added support for test "skipping". If skipping is turned on with the
``startSkip()`` function, ``assert`` and ``fail`` functions will return
immediately, and the skip will be recorded.

The report output format was changed to include the percentage for each test
result, rather than just those successful.


.. $Revision$
.. vim:spell
