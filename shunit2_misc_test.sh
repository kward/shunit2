#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shUnit2 unit tests of miscellaneous things
#
# Copyright 2008-2018 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
#
### ShellCheck http://www.shellcheck.net/
# $() are not fully portable (POSIX != portable).
#   shellcheck disable=SC2006
# Disable source following.
#   shellcheck disable=SC1090,SC1091
# Not wanting to escape single quotes.
#   shellcheck disable=SC1003

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
  ( exec "${SHUNIT_SHELL:-sh}" "${unittestF}" >"${stdoutF}" 2>"${stderrF}" )
  assertFalse 'expected a non-zero exit value' $?
  grep '^ASSERT:Unknown failure' "${stdoutF}" >/dev/null
  assertTrue 'assert message was not generated' $?
  grep '^Ran [0-9]* test' "${stdoutF}" >/dev/null
  assertTrue 'test count message was not generated' $?
  grep '^FAILED' "${stdoutF}" >/dev/null
  assertTrue 'failure message was not generated' $?
}

# https://github.com/kward/shunit2/issues/7
testIssue7() {
  # Disable coloring so 'ASSERT:' lines can be matched correctly.
  _shunit_configureColor 'none'

  ( assertEquals 'Some message.' 1 2 >"${stdoutF}" 2>"${stderrF}" )
  diff "${stdoutF}" - >/dev/null <<EOF
ASSERT:Some message. expected:<1> but was:<2>
EOF
  rtrn=$?
  assertEquals "${SHUNIT_TRUE}" "${rtrn}"
  [ "${rtrn}" -ne "${SHUNIT_TRUE}" ] && cat "${stderrF}" >&2
}

# https://github.com/kward/shunit2/issues/69
testIssue69() {
  unittestF="${SHUNIT_TMPDIR}/unittest"

  for t in Equals NotEquals Null NotNull Same NotSame True False; do
    assert="assert${t}"
    sed 's/^#//' >"${unittestF}" <<EOF
## Asserts with invalid argument counts should be counted as failures.
#test_assert() { ${assert}; }
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF
    ( exec "${SHUNIT_SHELL:-sh}" "${unittestF}" >"${stdoutF}" 2>"${stderrF}" )
    grep '^FAILED' "${stdoutF}" >/dev/null
    assertTrue "failure message for ${assert} was not generated" $?
  done
}

testPrepForSourcing() {
  assertEquals '/abc' "`_shunit_prepForSourcing '/abc'`"
  assertEquals './abc' "`_shunit_prepForSourcing './abc'`"
  assertEquals './abc' "`_shunit_prepForSourcing 'abc'`"
}

testEscapeCharInStr() {
  actual="`_shunit_escapeCharInStr '\' ''`"
  assertEquals '' "${actual}"
  assertEquals 'abc\\' "`_shunit_escapeCharInStr '\' 'abc\'`"
  assertEquals 'abc\\def' "`_shunit_escapeCharInStr '\' 'abc\def'`"
  assertEquals '\\def' "`_shunit_escapeCharInStr '\' '\def'`"

  actual=`_shunit_escapeCharInStr '"' ''`
  assertEquals '' "${actual}"
  assertEquals 'abc\"' "`_shunit_escapeCharInStr '"' 'abc"'`"
  assertEquals 'abc\"def' "`_shunit_escapeCharInStr '"' 'abc"def'`"
  assertEquals '\"def' "`_shunit_escapeCharInStr '"' '"def'`"

  actual="`_shunit_escapeCharInStr '$' ''`"
  assertEquals '' "${actual}"
  assertEquals 'abc\$' "`_shunit_escapeCharInStr '$' 'abc$'`"
  # shellcheck disable=2016
  assertEquals 'abc\$def' "`_shunit_escapeCharInStr '$' 'abc$def'`"
  # shellcheck disable=2016
  assertEquals '\$def' "`_shunit_escapeCharInStr '$' '$def'`"

  # TODO(20170924:kward) fix or remove.
#  actual=`_shunit_escapeCharInStr "'" ''`
#  assertEquals '' "${actual}"
#  assertEquals "abc\\'" `_shunit_escapeCharInStr "'" "abc'"`
#  assertEquals "abc\\'def" `_shunit_escapeCharInStr "'" "abc'def"`
#  assertEquals "\\'def" `_shunit_escapeCharInStr "'" "'def"`

#  # Must put the backtick in a variable so the shell doesn't misinterpret it
#  # while inside a backticked sequence (e.g. `echo '`'` would fail).
#  backtick='`'
#  actual=`_shunit_escapeCharInStr ${backtick} ''`
#  assertEquals '' "${actual}"
#  assertEquals '\`abc' \
#      `_shunit_escapeCharInStr "${backtick}" ${backtick}'abc'`
#  assertEquals 'abc\`' \
#      `_shunit_escapeCharInStr "${backtick}" 'abc'${backtick}`
#  assertEquals 'abc\`def' \
#      `_shunit_escapeCharInStr "${backtick}" 'abc'${backtick}'def'`
}

testEscapeCharInStr_specialChars() {
  # Make sure our forward slash doesn't upset sed.
  assertEquals '/' "`_shunit_escapeCharInStr '\' '/'`"

  # Some shells escape these differently.
  # TODO(20170924:kward) fix or remove.
  #assertEquals '\\a' `_shunit_escapeCharInStr '\' '\a'`
  #assertEquals '\\b' `_shunit_escapeCharInStr '\' '\b'`
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
EOF

  actual=`_shunit_extractTestFunctions "${f}"`
  assertEquals 'testABC test_def testG3 test4 test5' "${actual}"
}

setUp() {
  for f in "${stdoutF}" "${stderrF}"; do
    cp /dev/null "${f}"
  done

  # Reconfigure coloring as some tests override default behavior.
  _shunit_configureColor "${SHUNIT_COLOR_DEFAULT}"
}

oneTimeSetUp() {
  SHUNIT_COLOR_DEFAULT="${SHUNIT_COLOR}"
  th_oneTimeSetUp
}

# Load and run shUnit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
