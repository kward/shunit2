#!/bin/sh
#
# shunit2 unit test for running subset(s) of tests based upon command line
# arguments. Also shows how non-default tests or a arbitrary subset of tests
# can be run.
#
# Disable source following.
#   shellcheck disable=SC1090,SC1091

# Load test helpers.
. ./shunit2_test_helpers

# This test does not nomrally run because it does not begin "test*". Will be
# run by settting the arguments to the script to include the name of this test.
custom_test() {
  # Arbitrary assert.
  assertTrue 0
  # The true intent is to set this variable, which will be tested below.
  CUSTOM_TEST_RAN='yup, we ran'
}

# Test that the "custom_test" ran, otherwise fail.
test_custom_ran() {
  assertNotNull "'non_default_test' did not run" "${CUSTOM_TEST_RAN}"
}

# Fail if this test runs, which is shouldn't if args are set correctly.
test_will_fail() {
  fail 'test_will_fail should not be run if arg-parsing works'
}

oneTimeSetUp() {
  th_oneTimeSetUp
  # Prime with "null" value.
  CUSTOM_TEST_RAN=''
}

# Load and run shunit2.
# shellcheck disable=SC2034
if [ -n "${ZSH_VERSION:-}" ]; then
  SHUNIT_PARENT=$0
fi

# If zero/one argument(s) are provided, this test is being run in it's
# entirety, and therefore we want to set the arguments to the script to
# (simulate and) test the processing of command-line specified tests.  If we
# don't, then the "test_will_fail" test will run (by default) and the overall
# test will fail.
#
# However, if two or more arguments are provided, then assume this test script
# is being run by hand to experiment with command-line test specification, and
# then don't override the user provided arguments.
if [ "$#" -le 1 ]; then
  # We set the arguments in a POSIX way, inasmuch as we can;
  # helpful tip:
  #   https://unix.stackexchange.com/questions/258512/how-to-remove-a-positional-parameter-from
  set -- '--' 'custom_test' 'test_custom_ran'
fi

# Load and run shunit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
