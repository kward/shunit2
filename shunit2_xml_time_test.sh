#!/bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shunit2 unit test for running subset(s) of tests based upon junit XML time-specific fields.
#
# Copyright 2023 AxxonSoft. All Rights Reserved.
# Released under the Apache 2.0 license.
# http://www.apache.org/licenses/LICENSE-2.0
#
# https://github.com/kward/shunit2
#
# Disable source following.
#   shellcheck disable=SC1090,SC1091

# These variables will be overridden by the test helpers.
stdoutF=""
stderrF=""

# Load test helpers.
. ./shunit2_test_helpers

# Run test and check test finished correctly.
commonRunAndCheck() {
  _common_test_should_succeed=true
  _common_test_succeed=true

  _common_testStartSeconds="$(${__SHUNIT_CMD_DATE_SECONDS} -u)"

  ( exec "${SHELL:-sh}" "${unittestF}" -- "--output-junit-xml=${currentXmlF}" >"${stdoutF}" 2>"${stderrF}" ) || {
    _common_test_succeed=false
  }

  _common_testEndSeconds="$(${__SHUNIT_CMD_DATE_SECONDS} -u)"
  _common_testDuration="$(${__SHUNIT_CMD_CALC} "${_common_testEndSeconds}" - "${_common_testStartSeconds}")"

  assertEquals "Test exit status" "${_common_test_should_succeed}" "${_common_test_succeed}"

  if ! grep '^Ran [0-9]* test' "${stdoutF}" >/dev/null; then
    fail 'test count message was not generated'
    th_showOutput
  fi
}

commonCompareTimes() {
  _common_testDurationPatched="${_common_testDuration}"

  # Busybox'es ash (date with 1 second precision) test with GNU sh (date with 1 nanosecond precision) conflicts with time precision.
  # That is why we need to add 1 second to the test duration in this case.
  if [ "$(date '+%N')" = '%N' ] && [ "$("${SHELL:-sh}" -c "date '+%N'")" != '%N' ]; then
    _common_testDurationPatched="$(${__SHUNIT_CMD_CALC} "${_common_testDurationPatched}" + 1)"
  fi

  _common_executionTimeChecker="$(awk -v externTestDuration="${_common_testDurationPatched}" '
  BEGIN {
    sumStamps = 0
    isTotalGiven = 0
  }
  /^(.*[[:blank:]])?time="/ {
    # Extract the time value.
    sub(/.*time="/, "")
    sub(/"$/, "")
    sub(/" .*/, "")

    if (isTotalGiven == 1) {
      sumStamps += $0
    } else {
      isTotalGiven = 1
      total = $0
    }
  }
  END {
    error = 0
    if (isTotalGiven == 0) {
      print "No time=\"XXX\" given"
      error = 1
    }
    if (externTestDuration <= 0) {
      print "0 >= externTestDuration =", externTestDuration
      error = 1
    }
    if (total <= 0) {
      print "0 >= total =", total
      error = 1
    }
    if (sumStamps <= 0) {
      print "0 >= sumStamps =", sumStamps
      error = 1
    }
    if (sumStamps > total) {
      print "Sum is larger than total. Sum:", sumStamps, "Total:", total
      error = 1
    }
    if (externTestDuration < total) {
      print "externTestDuration is smaller than total. externTestDuration:", externTestDuration, "Total:", total
      error = 1
    }

    if (error == 0) {
      print "OK"
    } else {
      print "ERROR"
    }
  }
' "${currentXmlF}")"
}

testTimeStamp() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 1 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  commonRunAndCheck

  _test_timestamp="$(awk '
    /^(.*[[:blank:]])?timestamp="/ {
      # Extract the timestamp.
      sub(/.*timestamp="/, "")
      sub(/"$/, "")
      sub(/" .*/, "")

      # Print it.
      print
    }' "${currentXmlF}")"

  _test_timestampFormat="%Y-%m-%dT%H:%M:%S%z"

  if date -D "${_test_timestampFormat}" > /dev/null 2>&1; then
    # BusyBox date tool does not support the ISO 8601 input, but support the input format.
    _test_xmlStartSeconds="$(${__SHUNIT_CMD_DATE_SECONDS} -D "${_test_timestampFormat}" -d "${_test_timestamp}" -u)"
  else
    _test_xmlStartSeconds="$(${__SHUNIT_CMD_DATE_SECONDS} -d "${_test_timestamp}" -u)"
  fi

  # XML timestamp has no sub-second precision.
  _test_startComparison="$(${__SHUNIT_CMD_CALC} "${_test_xmlStartSeconds}" - "${_common_testStartSeconds%.*}")"
  _test_endComparison="$(${__SHUNIT_CMD_CALC} "${_common_testEndSeconds}" - "${_test_xmlStartSeconds}")"

  _test_startComparison="$(${__SHUNIT_CMD_CALC} "${_test_startComparison}" ">=" "0")"
  _test_endComparison="$(${__SHUNIT_CMD_CALC} "${_test_endComparison}" ">=" "0")"

  # shellcheck disable=SC2016
  assertTrue 'XML timestamp is so early' '[ "${_test_startComparison}" -gt 0 ]'
  # shellcheck disable=SC2016
  assertTrue 'XML timestamp is so late' '[ "${_test_endComparison}" -gt 0 ]'
}

testSingleTimePeriod() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 1 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  commonRunAndCheck

  commonCompareTimes

  if ! assertEquals 'OK' "${_common_executionTimeChecker}"; then
    echo "<<<XML output start"
    cat "${currentXmlF}" >&2
    echo "<<<XML output end"
  fi
}

testSumFewTimePeriods() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 1 1
#}
#testSuccess1() {
#  assertEquals 1 1
#}
#testS2() {
#  assertEquals 1 1
#}
#testS333() {
#  assertEquals 1 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  commonRunAndCheck

  commonCompareTimes

  if ! assertEquals 'OK' "${_common_executionTimeChecker}"; then
    echo "<<<XML output start"
    cat "${currentXmlF}" >&2
    echo "<<<XML output end"
  fi
}

testLongSleeps() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 1 1
#}
#testSuccess1() {
#  sleep 3
#  assertEquals 1 1
#}
#testS2() {
#  assertEquals 1 1
#}
#testS333() {
#  sleep 2
#  assertEquals 1 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  commonRunAndCheck

  commonCompareTimes

  if ! assertEquals 'OK' "${_common_executionTimeChecker}"; then
    echo "<<<XML output start"
    cat "${currentXmlF}" >&2
    echo "<<<XML output end"
  fi

  if ! awk "BEGIN {exit !(${_common_testDuration} >= 5)}"; then
    fail "Test duration should be at least 5 seconds"
  fi

  if [ "$(grep -c 'time="2\(\.[0-9]\+\)\?"' "${currentXmlF}")" -ne 1 ]; then
    fail "Must have a test with 2 seconds duration"
  fi

  if [ "$(grep -c 'time="3\(\.[0-9]\+\)\?"' "${currentXmlF}")" -ne 1 ]; then
    fail "Must have a test with 3 seconds duration"
  fi
}

oneTimeSetUp() {
  th_oneTimeSetUp
  unittestF="${SHUNIT_TMPDIR}/unittest"
  currentXmlF="${SHUNIT_TMPDIR}/current.xml"
}

# Load and run shunit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
