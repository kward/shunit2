#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shunit2 unit test for macros.
#
# Copyright 2008-2021 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
# http://www.apache.org/licenses/LICENSE-2.0
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
#
# Disable source following.
#   shellcheck disable=SC1090,SC1091

# These variables will be overridden by the test helpers.
stdoutF="${TMPDIR:-/tmp}/STDOUT"
stderrF="${TMPDIR:-/tmp}/STDERR"

# Load test helpers.
. ./shunit2_test_helpers

testAssertEquals() {
  isLinenoWorking || startSkipping

  ( ${_ASSERT_EQUALS_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_EQUALS_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_ASSERT_EQUALS_} '"some msg"' 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_EQUALS_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testAssertNotEquals() {
  isLinenoWorking || startSkipping

  ( ${_ASSERT_NOT_EQUALS_} 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_NOT_EQUALS_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_ASSERT_NOT_EQUALS_} '"some msg"' 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_NOT_EQUALS_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testSame() {
  isLinenoWorking || startSkipping

  ( ${_ASSERT_SAME_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_SAME_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_ASSERT_SAME_} '"some msg"' 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_SAME_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testNotSame() {
  isLinenoWorking || startSkipping

  ( ${_ASSERT_NOT_SAME_} 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_NOT_SAME_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_ASSERT_NOT_SAME_} '"some msg"' 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_NOT_SAME_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testNull() {
  isLinenoWorking || startSkipping

  ( ${_ASSERT_NULL_} 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_NULL_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_ASSERT_NULL_} '"some msg"' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_NULL_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testNotNull() {
  isLinenoWorking || startSkipping

  ( ${_ASSERT_NOT_NULL_} '' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_NOT_NULL_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_ASSERT_NOT_NULL_} '"some msg"' '""' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_NOT_NULL_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testAssertTrue() {
  isLinenoWorking || startSkipping

  ( ${_ASSERT_TRUE_} "${SHUNIT_FALSE}" >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_TRUE_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_ASSERT_TRUE_} '"some msg"' "${SHUNIT_FALSE}" >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_TRUE_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testAssertFalse() {
  isLinenoWorking || startSkipping

  ( ${_ASSERT_FALSE_} "${SHUNIT_TRUE}" >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_FALSE_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_ASSERT_FALSE_} '"some msg"' "${SHUNIT_TRUE}" >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_ASSERT_FALSE_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testFail() {
  isLinenoWorking || startSkipping

  ( ${_FAIL_} >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_FAIL_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_FAIL_} '"some msg"' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_FAIL_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testFailNotEquals() {
  isLinenoWorking || startSkipping

  ( ${_FAIL_NOT_EQUALS_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_FAIL_NOT_EQUALS_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_FAIL_NOT_EQUALS_} '"some msg"' 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_FAIL_NOT_EQUALS_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testFailSame() {
  isLinenoWorking || startSkipping

  ( ${_FAIL_SAME_} 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_FAIL_SAME_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_FAIL_SAME_} '"some msg"' 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_FAIL_SAME_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

testFailNotSame() {
  isLinenoWorking || startSkipping

  ( ${_FAIL_NOT_SAME_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_FAIL_NOT_SAME_ failed to produce an ASSERT message'
    showTestOutput
  fi

  ( ${_FAIL_NOT_SAME_} '"some msg"' 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  if ! wasAssertGenerated; then
    fail '_FAIL_NOT_SAME_ (with a message) failed to produce an ASSERT message'
    showTestOutput
  fi
}

oneTimeSetUp() {
  th_oneTimeSetUp

  if ! isLinenoWorking; then
    # shellcheck disable=SC2016
    th_warn '${LINENO} is not working for this shell. Tests will be skipped.'
  fi
}

# isLinenoWorking returns true if the `$LINENO` shell variable works properly.
isLinenoWorking() {
  # shellcheck disable=SC2016
  ln='eval echo "${LINENO:-}"'
  case ${ln} in
    [0-9]*) return "${SHUNIT_TRUE}" ;;
    -[0-9]*) return "${SHUNIT_FALSE}" ;; # The dash shell produces negative values.
  esac
  return "${SHUNIT_FALSE}"
}

# showTestOutput for the most recently run test.
showTestOutput() { th_showOutput "${SHUNIT_FALSE}" "${stdoutF}" "${stderrF}"; }

# wasAssertGenerated returns true if an ASSERT was generated to STDOUT.
wasAssertGenerated() { grep '^ASSERT:\[[0-9]*\] *' "${stdoutF}" >/dev/null; }

# Disable output coloring as it breaks the tests.
SHUNIT_COLOR='none'; export SHUNIT_COLOR

# Load and run shUnit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT="$0"
. "${TH_SHUNIT}"
