#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008-2019 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
# http://www.apache.org/licenses/LICENSE-2.0
#
# shUnit2 -- Unit testing framework for Unix shell scripts.
# https://github.com/kward/shunit2
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# shUnit2 unit test for failure functions. These functions do not test values
#
# Disable source following.
#   shellcheck disable=SC1090,SC1091

# These variables will be overridden by the test helpers.
stdoutF="${TMPDIR:-/tmp}/STDOUT"
stderrF="${TMPDIR:-/tmp}/STDERR"

# Load test helpers.
. ./shunit2_test_helpers

testFail() {
  # Test without a message.
  desc='fail_without_message'
  if ( fail >"${stdoutF}" 2>"${stderrF}" ); then
    fail "${desc}: expected a failure"
    th_showOutput
  else
    th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  fi

  # Test with a message.
  desc='fail_with_message'
  if ( fail 'some message' >"${stdoutF}" 2>"${stderrF}" ); then
    fail "${desc}: expected a failure"
    th_showOutput
  else
    th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  fi
}

# FN_TESTS hold all the functions to be tested.
# shellcheck disable=SC2006
FN_TESTS=`
# fn num_args pattern
cat <<EOF
fail          1
failNotEquals 3 but was:
failFound     2 found$
failNotFound  2 not found:
failSame      3 not same
failNotSame   3 but was:
EOF
`

testFailsWithArgs() {
  echo "${FN_TESTS}" |\
  while read -r fn num_args pattern; do
    case "${fn}" in
      fail) continue ;;
    esac

    # Test without a message.
    desc="${fn}_without_message"
    if ( ${fn} arg1 arg2 >"${stdoutF}" 2>"${stderrF}" ); then
      fail "${desc}: expected a failure"
      th_showOutput
    else
      th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    fi

    # Test with a message.
    arg1='' arg2=''
    case ${num_args} in
      1) ;;
      2) arg1='arg1' ;;
      3) arg1='arg1' arg2='arg2' ;;
    esac

    desc="${fn}_with_message"
    if ( ${fn} 'some message' ${arg1} ${arg2} >"${stdoutF}" 2>"${stderrF}" ); then
      fail "${desc}: expected a failure"
      th_showOutput
    else
      th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
      if ! grep -- "${pattern}" "${stdoutF}" >/dev/null; then
        fail "${desc}: incorrect message to STDOUT"
        th_showOutput
      fi
    fi
  done
}

testTooFewArguments() {
  echo "${FN_TESTS}" \
  |while read -r fn num_args pattern; do
    # Skip functions that support a single message argument.
    if [ "${num_args}" -eq 1 ]; then
      continue
    fi

    desc="${fn}"
    if (${fn} >"${stdoutF}" 2>"${stderrF}"); then
      fail "${desc}: expected a failure"
      _showTestOutput
    else
      got=$? want=${SHUNIT_ERROR}
      assertEquals "${desc}: incorrect return code" "${got}" "${want}"
      th_assertFalseWithError "${desc}" "${got}" "${stdoutF}" "${stderrF}"
    fi
  done
}

testTooManyArguments() {
  echo "${FN_TESTS}" \
  |while read -r fn num_args pattern; do
    desc="${fn}"
    if (${fn} arg1 arg2 arg3 arg4 >"${stdoutF}" 2>"${stderrF}"); then
      fail "${desc}: expected a failure"
      _showTestOutput
    else
      got=$? want=${SHUNIT_ERROR}
      assertEquals "${desc}: incorrect return code" "${got}" "${want}"
      th_assertFalseWithError "${desc}" "${got}" "${stdoutF}" "${stderrF}"
    fi
  done
}

oneTimeSetUp() {
  th_oneTimeSetUp
}

# Load and run shUnit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
