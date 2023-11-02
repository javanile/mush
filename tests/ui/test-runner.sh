#!/usr/bin/env bash

function mush_mock() {
  local pwd=$(pwd)
  local mush_bin=$(realpath "${pwd}/target/dist/mush")
  local testsuite=$1
  local testcase=$(basename "$2" .out)
  cd "${testsuite}/package"
  case "${testcase}" in
    build)
      ${mush_bin} build 2>&1 || true
      ;;
  esac
  cd "${pwd}"
}

echo "#!/usr/bin/env bash" > tests/ui/ui-test.sh

find tests/fixtures/ui -mindepth 2 -maxdepth 2 -type d | while read -r testsuite; do
  find "${testsuite}" -type f -name '*.out' | while read -r testcase; do
    mush_mock "${testsuite}" "${testcase}" \
      | sed -e 's/\x1b\[[0-9;]*m//g' \
      > "${testcase}.0"
    testcase_name=$(echo "${testcase:9}" | sed -e 's/\.out$//' | sed -e 's/[\/\-]/_/g')
    echo "test_${testcase_name}() { assert_equals \"\$(cat ${testcase})\" \"\$(cat ${testcase}.0)\"; }" >> tests/ui/ui-test.sh
  done
done

./lib/bashunit tests/ui/ui-test.sh
