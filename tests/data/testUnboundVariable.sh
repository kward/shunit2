# Treat unset variables as an error when performing parameter expansion.
set -u

boom() { x=$1; }  # This function goes boom if no parameters are passed!
test_boom() {
  assertEquals 1 1
  boom  # No parameter given
  assertEquals 0 $?
}
SHUNIT_COLOR='none'
. "${TH_SHUNIT}"
