
mush_api_test_2022 () {
  echo "Filter: $1"
  echo "Functions:"
  declare -F | awk '{print $3}' | grep "test_$1" | while read unit_test; do
    echo "Testing: $unit_test"
    eval "$unit_test"
  done
}
