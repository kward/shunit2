#! /bin/sh
#
# shunit2 unit test for issue #37.
# assertTrue does not work with "set -e"
#
# Copyright 2008-2020 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
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
# Disable source following.
#  shellcheck disable=SC1090,SC1091

# These variables will be overridden by the test helpers.
stdoutF="${TMPDIR:-/tmp}/STDOUT"
stderrF="${TMPDIR:-/tmp}/STDERR"

# Load test helpers.
. ./shunit2_test_helpers

# Enable the -e shell option.
set -e

testIssue37() {
	echo 'abc'
	assertTrue 0
	echo 'def'
}

oneTimeSetUp() {
	echo 'oneTimeSetup'
  th_oneTimeSetUp

  MSG='This is a test message'
}

# Load and run shunit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
