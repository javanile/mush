
# This file intentionally contains naming convention violations.
# With the name_convention plugin enabled (via [features]), the build
# should fail with E0100 errors for the non-compliant functions.
#
# Package name: greeting  →  all functions must start with  greeting_

module pluto

# GOOD: compliant function
greeting_hello() {
  echo "Hello, ${1:-World}!"
}

# BAD: missing package prefix → should trigger E0100
greet() {
  echo "hi"
}

# BAD: wrong prefix → should trigger E0100
say_hello() {
  echo "hello"
}

# GOOD: compliant entrypoint
main() {
  greeting_hello "$@"
}
