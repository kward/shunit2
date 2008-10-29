#!/bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# Example unit test for the mkdir command.
#
# There are times when an existing shell script needs to be tested. In this
# example, we will test several aspects of the the mkdir command, but the
# techniques could be used for any existing shell script.

#-----------------------------------------------------------------------------
# suite tests
#

testMissingDirectoryCreation()
{
  ${cmd} "${testDir}" >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertTrue 'directory missing' "[ -d '${testDir}' ]"
  assertEquals 'expecting return code of 0' ${rtrn} 0
  assertNull 'unexpected output to stdout' "`cat ${stdoutF}`"
  assertNull 'unexpected output to stderr' "`cat ${stderrF}`"
}

testExistingDirectoryCreationFails()
{
  # create a directory to test against
  ${cmd} "${testDir}"

  # test for expected failure while trying to create directory that exists
  ${cmd} "${testDir}" >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertTrue 'directory missing' "[ -d '${testDir}' ]"
  assertEquals 'expecting return code of 1' ${rtrn} 1
  assertNull 'unexpected output to stdout' "`cat ${stdoutF}`"
  assertNotNull 'expected error message to stderr' "`cat ${stderrF}`"
}

testParentDirectoryCreation()
{
  testDir2="${testDir}/test2"
  ${cmd} -p "${testDir2}" >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertTrue 'first directory missing' "[ -d '${testDir}' ]"
  assertTrue 'second directory missing' "[ -d '${testDir2}' ]"
  assertEquals 'expecting return code of 0' ${rtrn} 0
  assertNull 'unexpected output to stdout' "`cat ${stdoutF}`"
  assertNull 'unexpected output to stderr' "`cat ${stderrF}`"
}

#-----------------------------------------------------------------------------
# suite functions
#

oneTimeSetUp()
{
  outputDir="${__shunit_tmpDir}/output"
  mkdir "${outputDir}"
  stdoutF="${outputDir}/stdout"
  stderrF="${outputDir}/stderr"

  cmd='mkdir'  # save command name in variable to make future changes easy
  testDir="${__shunit_tmpDir}/some_test_dir"
}

tearDown()
{
  rm -fr "${testDir}"
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ../src/shell/shunit2
