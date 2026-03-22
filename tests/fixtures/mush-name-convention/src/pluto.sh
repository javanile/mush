
# This module intentionally contains naming convention violations.
# Functions here are inside the module 'pluto' of package 'greeting',
# so they must start with  greeting_pluto_

# GOOD: compliant module function
greeting_pluto_hello() {
  echo "Hello from pluto, ${1:-World}!"
}

# BAD: has package prefix but missing module name → should trigger E0100
greeting_greet() {
  echo "hi"
}

# BAD: has module name but missing package prefix → should trigger E0100
pluto_hello() {
  echo "hello"
}
