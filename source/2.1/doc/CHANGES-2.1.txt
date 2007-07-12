Changes in shUnit2 2.1.X
========================

Changes with 2.1.1

Fixed bug where ``fail()`` was not honoring skipping.

Fixed problem with ``docs-docbook-prep`` target that prevented it from working.
(Thanks to Bryan Larsen for pointing this out.)

Changed the test in ``assertFalse()`` so that any non-zero value registers as
false. (Credits to Bryan Larsen)

Major fiddling to bring more in line with `JUnit <http://junit.org/>`. Asserts
give better output when no message is given, and failures now just fail.

It was pointed out that the simple 'failed' message for a failed assert was not
only insufficient, it was nonstandard (when compared to JUnit) and didn't
provide the user with an expected vs actual result. The code was revised
somewhat to bring closer into alignment with JUnit (v4.3.1 specifically) so
that it feels more "normal". (Credits to Richard Jensen)

As part of the JUnit realignment, it was noticed that fail*() functions in
JUnit don't actually do any comparisons themselves. They only generate a
failure message. Updated the code to match.

Added self-testing unit tests. Kinda horkey, but they did find bugs during the
JUnit realignment.

Fixed the code for returning from asserts as the return was being called before
the unsetting of variables occurred. (Credits to Mathias Goldau)

The assert(True|False)() functions now accept an integer value for a
conditional test. A value of '0' is considered 'true', while any non-zero value
is considered 'false'.

All public functions now fill use default values to work properly with the '-x'
shell debugging flag.

Fixed the method of percent calculation for the report to get achieve better
accuracy.


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
