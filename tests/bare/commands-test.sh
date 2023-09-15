#!/usr/bin/env bash
set -e

echo "==> Build: mush"
cp target/debug/mush target/debug/mush.sh
bash target/debug/mush.sh build
echo ""

echo "==> Build: command options"

command_options=tests/tmp/command-options.txt
> "$command_options"
bash target/debug/mush --help | grep -A5000 "See" | tail -n+2 | while read line; do
  if [ -s "$command_options" ]; then
    echo "[ERROR] Problem with the following option of command '$command':"
    echo "------------------------------------------------------------------------------------------"
    cat "$command_options"
    echo "------------------------------------------------------------------------------------------"
    exit 1
  fi
  command=$(echo "$line" | awk '{print $1}')
  echo "==> Test: $command options"
  bash target/debug/mush "$command" --help | grep -i -A5000 "Options:" | tail +2 > "$command_options"
  supported_options=tests/supported/command-options/${command}.txt
  if [ ! -f "$supported_options" ]; then
    echo "[ERROR] The command '$command' seems no longer supported. Please update the test."
    exit 1
  fi
done

exit

echo "==> Test: build"
cd tests/fixtures/complex-app
bash ../../../target/debug/mush.sh build
cd ../../..
echo ""

echo "==> Test: check"
cd tests/fixtures/complex-app
bash ../../../target/debug/mush.sh check
cd ../../..
echo ""

echo "==> Test: init"
rm -fr tests/tmp/test-package && true
mkdir -p tests/tmp/test-package
cd tests/tmp/test-package
bash ../../../target/debug/mush.sh init
cd ../../..
echo ""

echo "==> Test: install"
cd tests/fixtures/complex-app
bash ../../../target/debug/mush.sh install
cd ../../..
echo ""

echo "==> Test: legacy"
cd tests/fixtures/zsh-app
bash ../../../target/debug/mush.sh legacy https://raw.githubusercontent.com/molovo/crash/master/crash
cd ../../..
echo ""

echo "==> Test: new"
rm -fr tests/tmp/new-package && true
mkdir -p tests/tmp
cd tests/tmp
bash ../../target/debug/mush.sh new new-package
cd ../..
echo ""

echo "==> Test: run"
cd tests/fixtures/complex-app
bash ../../../target/debug/mush.sh run
cd ../../..
echo ""

echo "==> Test: publish"
cd tests/fixtures/complex-app
bash ../../../target/debug/mush.sh publish --allow-dirty
cd ../../..
echo ""

echo "(done)"
