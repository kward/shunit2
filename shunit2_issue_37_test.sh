#! /bin/sh
#
# shunit2 unit test for issue #37.
#
# Copyright 2008-2020 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
#
# According to https://github.com/kward/shunit2/issues/37
#
#   assertTrue does not work with "set -e"
#
# According to the bash man page, when the `-e` option is used on `set`, the
# shell will…
#
#   Exit immediately if a simple command exits with a non-zero status. The shell
#   does not exit if the command that fails is part of the command list
#   immediately following a while or until keyword, part of the test in an if
#   statement, part of a && or || list, or if the command's return value is
#   being inverted via !. A trap on ERR, if set, is executed before the shell
#   exits.
#
# This test is fully stand-alone so that the full loading and execution of
# shUnit2 can be evaluated under the `-e` option.
#
# Disable source following.
#  shellcheck disable=SC1090,SC1091

# Enable the -e shell option.
set -e

# Load test helpers.
. ./shunit2_test_helpers

testIssue37() {
  assertTrue 0
  assertFalse 1
}

oneTimeSetUp() {
  th_oneTimeSetUp
}

# Load and run shunit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
