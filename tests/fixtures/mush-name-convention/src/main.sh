
# Rule 1: all functions in src/main.sh must start with  greeting_
# Rule 2: functions in src/<module>.sh must start with  greeting_<module>_
#
# This file is intentionally compliant to let rule-2 violations in
# src/pluto.sh surface during the build.

module pluto

# GOOD: compliant function
greeting_hello() {
  echo "Hello, ${1:-World}!"
}

# GOOD: compliant entrypoint (main is always exempt)
main() {
  greeting_hello "$@"
}
