
mush_api_test_2022 () {
  echo "Filter: $1"
  echo "Functions:"
  declare -F | awk '{print $3}' | grep "test_$1" | while read -r unit_test; do
    [ "${unit_test}" = "test_2022" ] && continue
    [ "${unit_test}" = "mush_api_test_2022" ] && continue
    echo "Testing: $unit_test"
    eval "$unit_test"
  done
}
