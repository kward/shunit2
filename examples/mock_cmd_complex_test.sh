#!/bin/sh
#
# shUnit2 example for mocking commands.
#
# This example demonstrates a more flexible mechanism for mocking external
# dependencies such as commands or functions.
#
# In this example, the behavior of the mocking function `date` can be changed
# by defining the logic in a global variable `__ACTION`. Please note that this
# approach would not work when executing tests in parallel due to race conditions
# when reading/writing the global `__ACTION` variable.

. ./lib.inc

__ACTION="true"

# dynamic mock (overrides original dependency)
date() {
	eval "${__ACTION}"
}

#dedicated function implementing the mock logic
dying_date_func() {
	exit 1
}

testMyFuncDateDies() {
	__ACTION="dying_date_func"
	LOG_FILE_PATH="/tmp/01.log"

	local result rc exists contents
	result=$(myFunc "some message")
	rc=$?

	assertEquals 0 "${rc}"
	assertEquals "[] some message" "${result}"

    exists=0
    [ -e "/tmp/01.log" ] && exists=1
    assertEquals 1 "${exists}"
    contents=$(cat /tmp/01.log)
    assertEquals "[] some message" "${contents}"
}

testMyFuncDoesSomethingMeaningful() {
	__ACTION="echo \"now\""
	LOG_FILE_PATH="/tmp/02.log"

	local result rc exists contents
	result=$(myFunc "some message")
	rc=$?

	assertEquals 0 "${rc}"
	assertEquals "[now] some message" "${result}"

    exists=0
    [ -e "/tmp/02.log" ] && exists=1
    assertEquals 1 "${exists}"
    contents=$(cat /tmp/02.log)
    assertEquals "[now] some message" "${contents}"
}

setUp() {
	cp /dev/null /tmp/01.log
	cp /dev/null /tmp/02.log
}

. ../shunit2
