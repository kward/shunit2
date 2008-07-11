#! /bin/sh
# $Id: shunit2_test_asserts.sh 177 2008-07-07 17:16:36Z kate.ward@forestent.com $
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# shUnit2 unit test for assert functions

# load test helpers
. ./shunit2_test_helpers

#------------------------------------------------------------------------------
# suite tests
#

testLineNo()
{
  # start skipping if LINENO not available
  [ -z "${LINENO:-}" ] && startSkipping

  ### asserts

  ( ${_ASSERT_EQUALS_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_ASSERT_EQUALS_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_ASSERT_NULL_} 'x' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_ASSERT_NULL_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_ASSERT_NOT_NULL_} '' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_ASSERT_NOT_NULL_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_ASSERT_SAME_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_ASSERT_SAME_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_ASSERT_NOT_SAME_} 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_ASSERT_NOT_SAME_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_ASSERT_TRUE_} ${SHUNIT_FALSE} >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_ASSERT_TRUE_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_ASSERT_FALSE_} ${SHUNIT_TRUE} >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_ASSERT_FALSE_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_ASSERT_FALSE_} ${SHUNIT_TRUE} >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_ASSERT_FALSE_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ### failures

  ( ${_FAIL_} >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_FAIL_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_FAIL_NOT_EQUALS_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_FAIL_NOT_EQUALS_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_FAIL_SAME_} 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_FAIL_SAME_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2

  ( ${_FAIL_NOT_SAME_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] *' "${stderrF}" >/dev/null
  rtrn=$?
  assertTrue '_FAIL_NOT_SAME_ failure' ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat ${stderrF} >&2
}

#------------------------------------------------------------------------------
# suite functions
#

oneTimeSetUp()
{
  tmpDir="${__shunit_tmpDir}/output"
  mkdir "${tmpDir}"
  stdoutF="${tmpDir}/stdout"
  stderrF="${tmpDir}/stderr"

  MSG='This is a test message'
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${TH_SHUNIT}
