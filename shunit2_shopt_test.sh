#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shUnit2 unit tests for `shopt` support.
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

# Load test helpers.
. ./shunit2_test_helpers

# Call shopt from a variable so it can be mocked if it doesn't work.
SHOPT_CMD='shopt'

testNullglob() {
  isShoptWorking || startSkipping

  nullglob=$(${SHOPT_CMD} nullglob |cut -f2)

  # Test without nullglob.
  ${SHOPT_CMD} -u nullglob
  assertEquals 'test without nullglob' 0 0

  # Test with nullglob.
  ${SHOPT_CMD} -s nullglob
  assertEquals 'test with nullglob' 1 1

  # Reset nullglob.
  if [ "${nullglob}" = "on" ]; then
    ${SHOPT_CMD} -s nullglob
  else
    ${SHOPT_CMD} -u nullglob
  fi

  unset nullglob
}

oneTimeSetUp() {
  th_oneTimeSetUp

  if ! isShoptWorking; then
    SHOPT_CMD='mock_shopt'
  fi
}

# isShoptWorking returns true if the `shopt` shell command is available.
# NOTE: `shopt` is not defined as part of the POSIX standard.
isShoptWorking() {
  # shellcheck disable=SC2039,SC3044
  ( shopt >/dev/null 2>&1 );
}

mock_shopt() {
  if [ $# -eq 0 ]; then
    echo "nullglob         off"
  fi
  return
}

# Load and run shUnit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT="$0"
. "${TH_SHUNIT}"
