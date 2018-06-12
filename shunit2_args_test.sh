#!/bin/sh
#
# shunit2 unit test for running subset(s) of tests based upon command line arguments.
# Shows how non-default tests or a arbitrary subset of tests can be run.
#

# These variables will be overridden by the test helpers.
stdoutF="${TMPDIR:-/tmp}/STDOUT"
stderrF="${TMPDIR:-/tmp}/STDERR"

# Load test helpers.
. ./shunit2_test_helpers

# This test does not nomrally run because it does not begin "test*"
# Will be run by settting the arguments to the script to include the name of this test.
non_default_test() {
  # arbitrary assert
  assertTrue 0
  # true intent is to set this variable, which will be tested below
  NON_DEFAULT_TEST_RAN="yup, we ran"
}

# Test that the "non_default_test" ran, otherwise fail
test_non_default_ran() {
  assertNotNull "'non_default_test' did not run" "$NON_DEFAULT_TEST_RAN"
}

# fail if this test runs, which is shouldn't if args are set correctly.
test_will_fail() {
  fail "test_will_fail should not be run if arg-parsing works"
}

oneTimeSetUp() {
  th_oneTimeSetUp
  # prime with "null" value
  NON_DEFAULT_TEST_RAN=""
}

# Load and run shunit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
# if zero/one arguments provided, artificially set the arguments to this script, in a POSIX way
# helpful tip: https://unix.stackexchange.com/questions/258512/how-to-remove-a-positional-parameter-from
if command [ "$#" -le 1 ]; then
  set -- "--" "non_default_test" "test_non_default_ran"
fi
# Load and run tests, but only if running as a script, not if being sourced by shunit2
command [ -z "${SHUNIT_VERSION:-}" ] && . "${TH_SHUNIT}"
