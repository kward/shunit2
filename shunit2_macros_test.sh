#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shunit2 unit test for macros.
#
# Copyright 2008-2020 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
#
### ShellCheck http://www.shellcheck.net/
# Disable source following.
#   shellcheck disable=SC1090,SC1091
# Presence of LINENO variable is checked.
#   shellcheck disable=SC2039

# These variables will be overridden by the test helpers.
stdoutF="${TMPDIR:-/tmp}/STDOUT"
stderrF="${TMPDIR:-/tmp}/STDERR"

# Load test helpers.
. ./shunit2_test_helpers

testAssertEquals() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_ASSERT_EQUALS_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_EQUALS_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_ASSERT_EQUALS_} '"some msg"' 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_EQUALS_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testAssertNotEquals() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_ASSERT_NOT_EQUALS_} 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_NOT_EQUALS_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_ASSERT_NOT_EQUALS_} '"some msg"' 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_NOT_EQUALS_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testSame() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_ASSERT_SAME_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_SAME_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_ASSERT_SAME_} '"some msg"' 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_SAME_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testNotSame() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_ASSERT_NOT_SAME_} 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_NOT_SAME_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_ASSERT_NOT_SAME_} '"some msg"' 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_NOT_SAME_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testNull() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_ASSERT_NULL_} 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_NULL_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_ASSERT_NULL_} '"some msg"' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_NULL_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testNotNull() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_ASSERT_NOT_NULL_} '' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_NOT_NULL_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_ASSERT_NOT_NULL_} '"some msg"' '""' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_NOT_NULL_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testAssertTrue() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_ASSERT_TRUE_} "${SHUNIT_FALSE}" >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_TRUE_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_ASSERT_TRUE_} '"some msg"' "${SHUNIT_FALSE}" >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_TRUE_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testAssertFalse() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_ASSERT_FALSE_} "${SHUNIT_TRUE}" >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_FALSE_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_ASSERT_FALSE_} '"some msg"' "${SHUNIT_TRUE}" >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_ASSERT_FALSE_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testFail() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_FAIL_} >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_FAIL_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_FAIL_} '"some msg"' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_FAIL_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testFailNotEquals() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_FAIL_NOT_EQUALS_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_FAIL_NOT_EQUALS_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_FAIL_NOT_EQUALS_} '"some msg"' 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_FAIL_NOT_EQUALS_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testFailSame() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_FAIL_SAME_} 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_FAIL_SAME_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_FAIL_SAME_} '"some msg"' 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_FAIL_SAME_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

testFailNotSame() {
  if ! th_isLinenoWorking; then
    startSkipping
  fi

  ( ${_FAIL_NOT_SAME_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_FAIL_NOT_SAME_ failed to produce an ASSERT message'
    _showTestOutput
  fi

  ( ${_FAIL_NOT_SAME_} '"some msg"' 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! _assertGenerated; then
    fail '_FAIL_NOT_SAME_ (with a message) failed to produce an ASSERT message'
    _showTestOutput
  fi
}

oneTimeSetUp() {
  th_oneTimeSetUp

  if ! th_isLinenoWorking; then
    # shellcheck disable=SC2016
    th_warn '${LINENO} is not working for this shell. Tests will be skipped.'
  fi
}

# _assertGenerated returns true if an ASSERT was generated to STDOUT.
_assertGenerated() { grep '^ASSERT:\[[0-9]*\] *' "${stdoutF}" >/dev/null; }

# showTestOutput for the most recently run test.
_showTestOutput() { th_showOutput "${SHUNIT_FALSE}" "${stdoutF}" "${stderrF}"; }


# Disable output coloring as it breaks the tests.
SHUNIT_COLOR='none'; export SHUNIT_COLOR

# Load and run shUnit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT="$0"
. "${TH_SHUNIT}"
