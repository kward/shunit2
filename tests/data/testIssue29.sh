# Support test prefixes.
test_assert() { assertTrue ${SHUNIT_TRUE}; }
SHUNIT_COLOR='none'
SHUNIT_TEST_PREFIX='--- '
. ${TH_SHUNIT}
