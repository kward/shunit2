#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shUnit2 unit tests for general commands.
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

testSkipping() {
  # We shouldn't be skipping to start.
  if isSkipping; then
    th_error 'skipping *should not be* enabled'
    return
  fi

  startSkipping
  was_skipping_started=${SHUNIT_FALSE}
  if isSkipping; then was_skipping_started=${SHUNIT_TRUE}; fi

  endSkipping
  was_skipping_ended=${SHUNIT_FALSE}
  if isSkipping; then was_skipping_ended=${SHUNIT_TRUE}; fi

  assertEquals "skipping wasn't started" "${was_skipping_started}" "${SHUNIT_TRUE}"
  assertNotEquals "skipping wasn't ended" "${was_skipping_ended}" "${SHUNIT_TRUE}"
  return 0
}

testStartSkippingWithMessage() {
  unittestF="${SHUNIT_TMPDIR}/unittest"
  sed 's/^#//' >"${unittestF}" <<\EOF
## Start skipping with a message.
#testSkipping() {
#  startSkipping 'SKIP-a-Dee-Doo-Dah'
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF
  # Ignoring errors with `|| :` as we only care about `FAILED` in the output.
  ( exec "${SHELL:-sh}" "${unittestF}" >"${stdoutF}" 2>"${stderrF}" ) || :
  if ! grep '\[skipping\] SKIP-a-Dee-Doo-Dah' "${stderrF}" >/dev/null; then
    fail 'skipping message was not generated'
  fi
  return 0
}

testStartSkippingWithoutMessage() {
  unittestF="${SHUNIT_TMPDIR}/unittest"
  sed 's/^#//' >"${unittestF}" <<\EOF
## Start skipping with a message.
#testSkipping() {
#  startSkipping
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF
  # Ignoring errors with `|| :` as we only care about `FAILED` in the output.
  ( exec "${SHELL:-sh}" "${unittestF}" >"${stdoutF}" 2>"${stderrF}" ) || :
  if grep '\[skipping\]' "${stderrF}" >/dev/null; then
    fail 'skipping message was unexpectedly generated'
  fi
  return 0
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
