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
  command=$(echo "$line" | awk '{print $1}')
  echo "==> Test: $command options"
  bash target/debug/mush "$command" --help | grep -i -A5000 "Options:" | tail +2 | tr -s ",()" " " | awk '{$1=$1;print}' > "$command_options"
  common_options=tests/supported/command-options/common.txt
  supported_options=tests/supported/command-options/${command}.txt
  if [ ! -f "$supported_options" ]; then
    echo "[ERROR] The command '$command' seems no longer supported. Please update the test."
    exit 1
  fi
  cp "$command_options" "$supported_options.tmp"
  while read -r option_line; do
    option=$(echo "$option_line" | awk '{print $1}')
    echo "==> Test: $command option $option"
    is_common=0
    is_supported=0
    while read -r common_option_line; do
      [ "$common_option_line" = "$option_line" ] && is_common=1 && break
    done < "$common_options"
    while read -r supported_option_line; do
      [ "$supported_option_line" = "$option_line" ] && is_supported=1 && break
    done < "$supported_options"
    if [ "$is_common" -eq 0 ] && [ "$is_supported" -eq 0 ]; then
      echo "[ERROR] The option '$option' of command '$command' seems no longer supported. Please update the test."
      echo "        Signature: $option_line"
      exit 1
    fi
  done < "$supported_options.tmp"
  rm "$supported_options.tmp"
  while read -r supported_option; do
    is_implemented=0
    option=$(echo "$supported_option" | awk '{print $1}')
    while read -r option_line; do
      [ "$supported_option" = "$option_line" ] && is_implemented=1 && break
    done < "$command_options"
    if [ "$is_implemented" -eq 0 ]; then
      echo "[ERROR] The option '$option' of command '$command' is not implemented. Please update the test."
      exit 1
    fi
  done < "$supported_options"
done
