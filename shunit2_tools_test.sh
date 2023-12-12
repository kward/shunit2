#!/bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shunit2 unit test for tools testing.
#
# Copyright 2023 AxxonSoft. All Rights Reserved.
# Released under the Apache 2.0 license.
# http://www.apache.org/licenses/LICENSE-2.0
#
# https://github.com/kward/shunit2
#
# Disable source following.
#   shellcheck disable=SC1090,SC1091

# Load test helpers.
. ./shunit2_test_helpers

# Run integer calculation checks.
# Arguments:
#   funcName: string: name of function to call as a calculator.
commonCalcInteger() {
  _common_function="$1"

  assertEquals "3" "$("${_common_function}" 1 + 2)"
  assertEquals "42" "$("${_common_function}" 0 + 42)"
  assertEquals "-42" "$("${_common_function}" 0 - 42)"
  assertEquals "78" "$("${_common_function}" 123 - 45)"
  assertEquals "0" "$("${_common_function}" 1 - 1)"
}

# Run float calculation checks.
# Arguments:
#   funcName: string: name of function to call as a calculator.
commonCalcFloat() {
  _common_function="$1"

  assertEquals "3" "$("${_common_function}" 1.0 + 2.0)"
  assertEquals "42" "$("${_common_function}" 0.000 + 42.0)"
  assertEquals "-42" "$("${_common_function}" 0 - 42.0)"
  assertEquals "78" "$("${_common_function}" 123 - 45.00)"
  assertEquals "0" "$("${_common_function}" 1.0 - 1.0)"
  assertEquals "0" "$("${_common_function}" 1.0 - 1.00)"

  assertEquals "4.6" "$("${_common_function}" 1.2 + 3.4)"
  assertEquals "5.1" "$("${_common_function}" 1.2 + 3.9)"
  assertEquals "-2.9005" "$("${_common_function}" 1 - 3.9005)"
  assertEquals "7.905" "$("${_common_function}" 11.005 - 3.1)"
  assertEquals "0.01" "$("${_common_function}" 0.085 - 0.075)"
}

testFloatFormat() {
  # Bad values.
  assertEquals '' "$(_shunit_float_format ..)"
  assertEquals '' "$(_shunit_float_format 0.1.2)"
  assertEquals '' "$(_shunit_float_format 0...)"
  assertEquals '' "$(_shunit_float_format 123.123.123)"
  assertEquals '' "$(_shunit_float_format 123.123.123.)"

  # Good values (unusual cases).
  assertEquals '0' "$(_shunit_float_format .)"

  # Good values (integer).
  assertEquals '1' "$(_shunit_float_format 1)"
  assertEquals '10' "$(_shunit_float_format 10)"
  assertEquals '2300' "$(_shunit_float_format 2300)"

  # Good values (float).
  assertEquals '1' "$(_shunit_float_format 1.)"
  assertEquals '10' "$(_shunit_float_format 10.)"
  assertEquals '2300' "$(_shunit_float_format 2300.)"
  assertEquals '1' "$(_shunit_float_format 1.0)"
  assertEquals '10' "$(_shunit_float_format 10.0)"
  assertEquals '2300' "$(_shunit_float_format 2300.000)"
  assertEquals '0' "$(_shunit_float_format .000)"
  assertEquals '1.2' "$(_shunit_float_format 1.2)"
  assertEquals '4.3' "$(_shunit_float_format 4.30)"
  assertEquals '0.3' "$(_shunit_float_format .30)"
  assertEquals '0.7' "$(_shunit_float_format .7)"
  assertEquals '1.08' "$(_shunit_float_format 1.080)"
}

testCalcDc() {
  if [ -z "${__SHUNIT_CMD_DC}" ]; then
    # shellcheck disable=SC2016
    startSkipping '`dc` not found'
  fi

  commonCalcInteger "_shunit_calc_dc"
  commonCalcFloat "_shunit_calc_dc"
}

testCalcBc() {
  if [ -z "${__SHUNIT_CMD_BC}" ]; then
    # shellcheck disable=SC2016
    startSkipping '`bc` not found'
  fi

  commonCalcInteger "_shunit_calc_bc"
  commonCalcFloat "_shunit_calc_bc"
}

testCalcExpr() {
  commonCalcInteger "_shunit_calc_expr"
}

oneTimeSetUp() {
  th_oneTimeSetUp
}

# Load and run shunit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
