#!/bin/sh
#
# shUnit2 example for mocking commands.
#
# This example demonstrates a simple mechanism for mocking external
# dependencies such as commands or functions.
#
# In this example, the mocking function `date` behaves the same for
# all tests.

. ./lib.inc

# static mock (overrides original dependency)
date() {
	echo "now"
}

testMyFuncMissingPath() {
	unset LOG_FILE_PATH

	local result rc
	result=$(myFunc "some message")
	rc=$?

	assertEquals 0 "${rc}"
	assertEquals "[now] some message" "${result}"
}

testMyFuncHappy() {
	LOG_FILE_PATH="/tmp/01.log"

	local result rc exists contents
	result=$(myFunc "some message")
	rc=$?

	assertEquals 0 "${rc}"
	assertEquals "[now] some message" "${result}"

	exists=0
	[ -e "/tmp/01.log" ] && exists=1
	assertEquals 1 "${exists}"
    contents=$(cat /tmp/01.log)
	assertEquals "[now] some message" "${contents}"
}

setUp() {
	cp /dev/null /tmp/01.log
}

. ../shunit2
