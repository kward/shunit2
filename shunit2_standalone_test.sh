#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shUnit2 unit test for standalone operation.
#
# Copyright 2010-2020 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
#
# This unit test is purely to test that calling shunit2 directly, while passing
# the name of a unit test script, works. When run, this script determines if it
# is running as a standalone program, and calls main() if it is.
#
### ShellCheck http://www.shellcheck.net/
# $() are not fully portable (POSIX != portable).
#   shellcheck disable=SC2006
# Disable source following.
#   shellcheck disable=SC1090,SC1091

ARGV0="`basename "$0"`"

# Load test helpers.
. ./shunit2_test_helpers

testStandalone() {
  assertTrue "${SHUNIT_TRUE}"
}

main() {
  ${TH_SHUNIT} "${ARGV0}"
}

# Run main() if are running as a standalone script.
if [ "${ARGV0}" = 'shunit2_standalone_test.sh' ]; then
	main "$@"
fi
