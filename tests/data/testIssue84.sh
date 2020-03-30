# Function with syntax error.
syntax_error() { ${!#3442} -334 a$@2[1]; }
test_syntax_error() {
  syntax_error
  assertTrue ${SHUNIT_TRUE}
}
SHUNIT_COLOR='none'
SHUNIT_TEST_PREFIX='--- '
. ${TH_SHUNIT}
