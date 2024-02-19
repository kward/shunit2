#! /bin/sh
# file: examples/math_test.sh

testAdding() {
  result=`add_generic 1 2`
  assertEquals \
      "the result of '${result}' was wrong" \
      3 "${result}"

  # Disable non-generic tests.
  [ -z "${BASH_VERSION:-}" ] && startSkippingAsserts

  result=`add_bash 1 2`
  assertEquals \
      "the result of '${result}' was wrong" \
      3 "${result}"
}

testBashFunctions() {
  # Disable non-generic tests.
  [ -z "${BASH_VERSION:-}" ] && skipTest "Works only in bash shell"

  result=`add_bash 1 2`
  assertEquals \
      "the result of '${result}' was wrong" \
      3 "${result}"

  result=`subtract_bash 2 1`
  assertEquals \
      "the result of '${result}' was wrong" \
      1 "${result}"
}

oneTimeSetUp() {
  # Load include to test.
  . ./math.inc
}

# Load and run shUnit2.
. ../shunit2
