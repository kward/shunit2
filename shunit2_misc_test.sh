#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shUnit2 unit tests of miscellaneous things
#
# Copyright 2008-2021 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
# http://www.apache.org/licenses/LICENSE-2.0
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
#
# Allow usage of legacy backticked `...` notation instead of $(...).
#  shellcheck disable=SC2006
# Disable source following.
#   shellcheck disable=SC1090,SC1091

# These variables will be overridden by the test helpers.
stdoutF="${TMPDIR:-/tmp}/STDOUT"
stderrF="${TMPDIR:-/tmp}/STDERR"

# Load test helpers.
. ./shunit2_test_helpers

# Note: the test script is prefixed with '#' chars so that shUnit2 does not
# incorrectly interpret the embedded functions as real functions.
testUnboundVariable() {
  unittestF="${SHUNIT_TMPDIR}/unittest"
  sed 's/^#//' >"${unittestF}" <<EOF
## Treat unset variables as an error when performing parameter expansion.
#set -u
#
#boom() { x=\$1; }  # This function goes boom if no parameters are passed!
#test_boom() {
#  assertEquals 1 1
#  boom  # No parameter given
#  assertEquals 0 \$?
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF
  if ( exec "${SHELL:-sh}" "${unittestF}" >"${stdoutF}" 2>"${stderrF}" ); then
    fail 'expected a non-zero exit value'
  fi
  if ! grep '^ASSERT:unknown failure' "${stdoutF}" >/dev/null; then
    fail 'assert message was not generated'
  fi
  if ! grep '^Ran [0-9]* test' "${stdoutF}" >/dev/null; then
    fail 'test count message was not generated'
  fi
  if ! grep '^FAILED' "${stdoutF}" >/dev/null; then
    fail 'failure message was not generated'
  fi
}

# assertEquals repeats message argument.
# https://github.com/kward/shunit2/issues/7
testIssue7() {
  # Disable coloring so 'ASSERT:' lines can be matched correctly.
  _shunit_configureColor 'none'

  # Ignoring errors with `|| :` as we only care about the message in this test.
  ( assertEquals 'Some message.' 1 2 >"${stdoutF}" 2>"${stderrF}" ) || :
  diff "${stdoutF}" - >/dev/null <<EOF
ASSERT:Some message. expected:<1> but was:<2>
EOF
  rtrn=$?
  assertEquals "${SHUNIT_TRUE}" "${rtrn}"
  [ "${rtrn}" -eq "${SHUNIT_TRUE}" ] || cat "${stderrF}" >&2
}

# Support prefixes on test output.
# https://github.com/kward/shunit2/issues/29
testIssue29() {
  unittestF="${SHUNIT_TMPDIR}/unittest"
  sed 's/^#//' >"${unittestF}" <<EOF
## Support test prefixes.
#test_assert() { assertTrue ${SHUNIT_TRUE}; }
#SHUNIT_COLOR='none'
#SHUNIT_TEST_PREFIX='--- '
#. ${TH_SHUNIT}
EOF
  ( exec "${SHELL:-sh}" "${unittestF}" >"${stdoutF}" 2>"${stderrF}" )
  grep '^--- test_assert' "${stdoutF}" >/dev/null
  rtrn=$?
  assertEquals "${SHUNIT_TRUE}" "${rtrn}"
  [ "${rtrn}" -eq "${SHUNIT_TRUE}" ] || cat "${stdoutF}" >&2
}

# Test that certain external commands sometimes "stubbed" by users are escaped.
testIssue54() {
  for c in mkdir rm cat chmod sed; do
    if grep "^[^#]*${c} " "${TH_SHUNIT}" | grep -qv "command ${c}"; then
      fail "external call to ${c} not protected somewhere"
    fi
  done
  # shellcheck disable=2016
  if grep '^[^#]*[^ ]  *\[' "${TH_SHUNIT}" | grep -qv '${__SHUNIT_BUILTIN} \['; then
    fail 'call to [ not protected somewhere'
  fi
  # shellcheck disable=2016
  if grep '^[^#]*  *\.' "${TH_SHUNIT}" | grep -qv '${__SHUNIT_BUILTIN} \.'; then
    fail 'call to . not protected somewhere'
  fi
}

# shUnit2 should not exit with 0 when it has syntax errors.
# https://github.com/kward/shunit2/issues/69
testIssue69() {
  unittestF="${SHUNIT_TMPDIR}/unittest"

  # Note: assertNull not tested as zero arguments == null, which is valid.
  for t in Equals NotEquals NotNull Same NotSame True False; do
    assert="assert${t}"
    sed 's/^#//' >"${unittestF}" <<EOF
## Asserts with invalid argument counts should be counted as failures.
#test_assert() { ${assert}; }
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF
    # Ignoring errors with `|| :` as we only care about `FAILED` in the output.
    ( exec "${SHELL:-sh}" "${unittestF}" >"${stdoutF}" 2>"${stderrF}" ) || :
    grep '^FAILED' "${stdoutF}" >/dev/null
    assertTrue "failure message for ${assert} was not generated" $?
  done
}

# Ensure that test fails if setup/teardown functions fail.
testIssue77() {
  unittestF="${SHUNIT_TMPDIR}/unittest"
  for func in oneTimeSetUp setUp tearDown oneTimeTearDown; do
    sed 's/^#//' >"${unittestF}" <<EOF
## Environment failure should end test.
#${func}() { return ${SHUNIT_FALSE}; }
#test_true() { assertTrue ${SHUNIT_TRUE}; }
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF
    # Ignoring errors with `|| :` as we only care about `FAILED` in the output.
    ( exec "${SHELL:-sh}" "${unittestF}" ) >"${stdoutF}" 2>"${stderrF}" || :
    grep '^FAILED' "${stdoutF}" >/dev/null
    assertTrue "failure of ${func}() did not end test" $?
  done
}

# Ensure a test failure is recorded for code containing syntax errors.
# https://github.com/kward/shunit2/issues/84
testIssue84() {
  unittestF="${SHUNIT_TMPDIR}/unittest"
  sed 's/^#//' >"${unittestF}" <<\EOF
## Function with syntax error.
#syntax_error() { ${!#3442} -334 a$@2[1]; }
#test_syntax_error() {
#  syntax_error
#  assertTrue ${SHUNIT_TRUE}
#}
#SHUNIT_COLOR='none'
#SHUNIT_TEST_PREFIX='--- '
#. ${TH_SHUNIT}
EOF
  # Ignoring errors with `|| :` as we only care about `FAILED` in the output.
  ( exec "${SHELL:-sh}" "${unittestF}" >"${stdoutF}" 2>"${stderrF}" ) || :
  if ! grep '^FAILED' "${stdoutF}" >/dev/null; then
    fail 'failure message was not generated'
  fi
}

# Demonstrate that asserts are no longer executed in subshells.
# https://github.com/kward/shunit2/issues/123
#
# NOTE: this test only works if the `${BASH_SUBSHELL}` variable is present.
testIssue123() {
  if [ -z "${BASH_SUBSHELL:-}" ]; then
    # shellcheck disable=SC2016
    startSkipping 'The ${BASH_SUBSHELL} variable is unavailable in this shell.'
  fi
  # shellcheck disable=SC2016
  assertTrue 'not in subshell' '[[ ${BASH_SUBSHELL} -eq 0 ]]'
}

testPrepForSourcing() {
  assertEquals '/abc' "`_shunit_prepForSourcing '/abc'`"
  assertEquals './abc' "`_shunit_prepForSourcing './abc'`"
  assertEquals './abc' "`_shunit_prepForSourcing 'abc'`"
}

# Test the various ways of declaring functions.
#
# Prefixing (then stripping) with comment symbol so these functions aren't
# treated as real functions by shUnit2.
testExtractTestFunctions() {
  f="${SHUNIT_TMPDIR}/extract_test_functions"
  sed 's/^#//' <<EOF >"${f}"
## Function on a single line.
#testABC() { echo 'ABC'; }
## Multi-line function with '{' on next line.
#test_def()
# {
#  echo 'def'
#}
## Multi-line function with '{' on first line.
#testG3 () {
#  echo 'G3'
#}
## Function with numerical values in name.
#function test4() { echo '4'; }
## Leading space in front of function.
#	test5() { echo '5'; }
## Function with '_' chars in name.
#some_test_function() { echo 'some func'; }
## Function that sets variables.
#func_with_test_vars() {
#  testVariable=1234
#}
## Function with keyword but no parenthesis
#function test6 { echo '6'; }
## Function with keyword but no parenthesis, multi-line
#function test7 {
#  echo '7';
#}
## Function with no parenthesis, '{' on next line
#function test8
#{
#  echo '8'
#}
## Function with hyphenated name
#test-9() {
#  echo '9';
#}
## Function without parenthesis or keyword
#test_foobar { echo 'hello world'; }
## Function with multiple function keywords
#function function test_test_test() { echo 'lorem'; }
EOF

  actual=`_shunit_extractTestFunctions "${f}"`
  assertEquals 'testABC test_def testG3 test4 test5 test6 test7 test8 test-9' "${actual}"
}

testColors() {
  while read -r cmd colors desc; do
    SHUNIT_CMD_TPUT=${cmd}
    want=${colors} got=`_shunit_colors`
    assertEquals "${desc}: incorrect number of colors;" \
        "${got}" "${want}"
  done <<'EOF'
missing_tput 16  missing tput command
mock_tput    256 mock tput command
EOF
}

testColorsWitoutTERM() {
  SHUNIT_CMD_TPUT='mock_tput'
  got=`TERM='' _shunit_colors`
  want=16
  assertEquals "${got}" "${want}"
}

mock_tput() {
  if [ -z "${TERM}" ]; then
    # shellcheck disable=SC2016
    echo 'tput: No value for $TERM and no -T specified'
    return 2
  fi
  if [ "$1" = 'colors' ]; then
    echo 256
    return 0
  fi
  return 1
}

setUp() {
  for f in "${stdoutF}" "${stderrF}"; do
    cp /dev/null "${f}"
  done

  # Reconfigure coloring as some tests override default behavior.
  _shunit_configureColor "${SHUNIT_COLOR_DEFAULT}"

  # shellcheck disable=SC2034,SC2153
  SHUNIT_CMD_TPUT=${__SHUNIT_CMD_TPUT}
}

oneTimeSetUp() {
  SHUNIT_COLOR_DEFAULT="${SHUNIT_COLOR}"
  th_oneTimeSetUp
}

# Load and run shUnit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
