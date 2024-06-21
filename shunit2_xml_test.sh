#!/bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shunit2 unit test for running subset(s) of tests based upon junit XML generator.
#
# Copyright 2023 AxxonSoft. All Rights Reserved.
# Released under the Apache 2.0 license.
# http://www.apache.org/licenses/LICENSE-2.0
#
# https://github.com/kward/shunit2
#
# Also shows how JUnit XML may be generated.
#
# Disable source following.
#   shellcheck disable=SC1090,SC1091

# These variables will be overridden by the test helpers.
stdoutF=""
stderrF=""

# Load test helpers.
. ./shunit2_test_helpers

# Run test and check XML output is correct.
# Arguments:
#   isSuccess: bool: true if the test should succeed. Default is true.
#   $@: additional arguments to pass to shunit2
commonRunAndCheck() {
  _common_test_should_succeed=true
  if [ $# -gt 0 ]; then
    case "$1" in
      --*) ;;
      *) _common_test_should_succeed="$1"; shift ;;
    esac
  fi

  _common_test_succeed=true
  ( exec "${SHELL:-sh}" "${unittestF}" -- "--output-junit-xml=${currentXmlF}" "$@" >"${stdoutF}" 2>"${stderrF}" ) || {
    _common_test_succeed=false
  }

  assertEquals "Test exit status" "${_common_test_should_succeed}" "${_common_test_succeed}"

  if ! grep '^Ran [0-9]* test' "${stdoutF}" >/dev/null; then
    fail 'test count message was not generated'
    th_showOutput
  fi

  # Patch time & timestamp attribute to the magic number constant.
  sed -i \
    -e 's/time="[0-9]*\(.[0-9]*\)\?"/time="42.25"/g' \
    -e 's/timestamp="[-0-9+T:]*"/timestamp="1983-10-27T03:36:45+0000"/g' \
    "${currentXmlF}"

  if ! diff "${idealXmlF}" "${currentXmlF}" >/dev/null; then
    fail 'XML output is not equal'
    echo '>>> Ideal' >&2
    cat "${idealXmlF}" >&2
    echo '<<< Ideal' >&2
    echo '>>> Actual' >&2
    cat "${currentXmlF}" >&2
    echo '<<< Actual' >&2
  fi
}

###
# XML messages escaping logic
###
testEscapeXmlDataAmp() {
  assertEquals "&amp;" "$(_shunit_escapeXmlData "&")"
}

testEscapeXmlDataLess() {
  assertEquals "&lt;" "$(_shunit_escapeXmlData "<")"
}

testEscapeXmlDataGreater() {
  assertEquals "&gt;" "$(_shunit_escapeXmlData ">")"
}

testEscapeXmlDataQuote() {
  assertEquals "&quot;" "$(_shunit_escapeXmlData '"')"
}

testEscapeXmlDataApostrophe() {
  assertEquals "&apos;" "$(_shunit_escapeXmlData "'")"
}

testEscapeXmlDataMultiple() {
  assertEquals "&amp;&lt;&apos;&gt;&quot;" "$(_shunit_escapeXmlData "&<'>\"")"
}

testEscapeXmlDataInverseMultiple() {
  assertEquals "&quot;&gt;&apos;&lt;&amp;" "$(_shunit_escapeXmlData "\">'<&")"
}

###
# XML tests passing/erroring.
###
testSingleSuccess() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 1 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  cat >"${idealXmlF}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuite
  failures="0"
  name="unittest"
  tests="1"
  timestamp="1983-10-27T03:36:45+0000"
  time="42.25"
  assertions="1"
>
  <testcase
    classname="unittest"
    name="testSuccess"
    time="42.25"
    assertions="1"
  >
  </testcase>
</testsuite>
EOF

  commonRunAndCheck
}

testFewSuccess() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 1 1
#}
#testS2() {
#  assertEquals 1 1
#}
#testSSS() {
#  assertEquals 1 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  cat >"${idealXmlF}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuite
  failures="0"
  name="unittest"
  tests="3"
  timestamp="1983-10-27T03:36:45+0000"
  time="42.25"
  assertions="3"
>
  <testcase
    classname="unittest"
    name="testSuccess"
    time="42.25"
    assertions="1"
  >
  </testcase>
  <testcase
    classname="unittest"
    name="testS2"
    time="42.25"
    assertions="1"
  >
  </testcase>
  <testcase
    classname="unittest"
    name="testSSS"
    time="42.25"
    assertions="1"
  >
  </testcase>
</testsuite>
EOF

  commonRunAndCheck
}

testMultipleAsserts() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 1 1
#  assertEquals 1 1
#  assertEquals 1 1
#}
#testS2() {
#  assertEquals 1 1
#  assertEquals 1 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  cat >"${idealXmlF}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuite
  failures="0"
  name="unittest"
  tests="2"
  timestamp="1983-10-27T03:36:45+0000"
  time="42.25"
  assertions="5"
>
  <testcase
    classname="unittest"
    name="testSuccess"
    time="42.25"
    assertions="3"
  >
  </testcase>
  <testcase
    classname="unittest"
    name="testS2"
    time="42.25"
    assertions="2"
  >
  </testcase>
</testsuite>
EOF

  commonRunAndCheck
}

testFailures() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 0 1
#  assertEquals 1 1
#  assertEquals "My message" 0 1
#}
#testSSS() {
#  assertEquals 1 1
#}
#testS2() {
#  assertEquals 1 1
#  assertEquals "Hello, World" 0 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  cat >"${idealXmlF}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuite
  failures="2"
  name="unittest"
  tests="3"
  timestamp="1983-10-27T03:36:45+0000"
  time="42.25"
  assertions="6"
>
  <testcase
    classname="unittest"
    name="testSuccess"
    time="42.25"
    assertions="3"
  >
    <failure
      type="shunit.assertFail"
      message="expected:&lt;0&gt; but was:&lt;1&gt;"
    />
    <failure
      type="shunit.assertFail"
      message="My message expected:&lt;0&gt; but was:&lt;1&gt;"
    />
  </testcase>
  <testcase
    classname="unittest"
    name="testSSS"
    time="42.25"
    assertions="1"
  >
  </testcase>
  <testcase
    classname="unittest"
    name="testS2"
    time="42.25"
    assertions="2"
  >
    <failure
      type="shunit.assertFail"
      message="Hello, World expected:&lt;0&gt; but was:&lt;1&gt;"
    />
  </testcase>
</testsuite>
EOF

  commonRunAndCheck false
}

###
# Custom suite name cases.
###
testCustomSuiteName() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 1 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  cat >"${idealXmlF}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuite
  failures="0"
  name="mySuiteName"
  tests="1"
  timestamp="1983-10-27T03:36:45+0000"
  time="42.25"
  assertions="1"
>
  <testcase
    classname="mySuiteName"
    name="testSuccess"
    time="42.25"
    assertions="1"
  >
  </testcase>
</testsuite>
EOF

  commonRunAndCheck --suite-name=mySuiteName
}

testCustomSuiteNameEscaping() {
  sed 's/^#//' >"${unittestF}" <<EOF
#testSuccess() {
#  assertEquals 1 1
#}
#SHUNIT_COLOR='none'
#. ${TH_SHUNIT}
EOF

  cat >"${idealXmlF}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuite
  failures="0"
  name="Custom name with spaces &amp; some special chars!"
  tests="1"
  timestamp="1983-10-27T03:36:45+0000"
  time="42.25"
  assertions="1"
>
  <testcase
    classname="Custom name with spaces &amp; some special chars!"
    name="testSuccess"
    time="42.25"
    assertions="1"
  >
  </testcase>
</testsuite>
EOF

  commonRunAndCheck "--suite-name=Custom name with spaces & some special chars!"
}

oneTimeSetUp() {
  th_oneTimeSetUp
  unittestF="${SHUNIT_TMPDIR}/unittest"
  idealXmlF="${SHUNIT_TMPDIR}/ideal.xml"
  currentXmlF="${SHUNIT_TMPDIR}/current.xml"
}

# Load and run shunit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
