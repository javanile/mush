#!/usr/bin/env bash
## BP010: Release metadata
## @build_type: lib
## @build_date: 2023-11-14T09:34:44Z
set -e
use() { return 0; }
extern() { return 0; }
legacy() { return 0; }
module() { return 0; }
public() { return 0; }
embed() { return 0; }
## BP004: Compile the entrypoint

code_dumper() {
  local file
  local line
  local keyword
  local column
  local source
  local padding
  local keyword_padding
  local message
  local help

  file=$1
  line=$2
  keyword=$3
  message=$4
  help=$5
  source=$(sed -n "${line}p" "${file}")
  column=${source%%$keyword*}
  padding=$(echo "$line" | sed 's/[0-9]/ /g')
  keyword_padding=$(echo "$column" | sed 's/./ /g')
  keyword_size=$(echo "$keyword" | sed 's/./^/g')

  echo -e "\e[0m${padding}\e[0m\e[0m\e[1m\e[38;5;12m--> \e[0m\e[0m${file}:${line}:${#column}\e[0m"
  echo -e "\e[0m${padding} \e[0m\e[0m\e[1m\e[38;5;12m|\e[0m"
  echo -e "\e[0m\e[1m\e[38;5;12m${line}\e[0m\e[0m \e[0m\e[0m\e[1m\e[38;5;12m|\e[0m\e[0m \e[0m\e[0m${source}\e[0m"
  echo -e "\e[0m${padding} \e[0m\e[0m\e[1m\e[38;5;12m| ${keyword_padding}\e[0m\e[0m\e[1m\e[38;5;9m${keyword_size}\e[0m\e[0m \e[0m\e[0m\e[1m\e[38;5;9m${message}\e[0m"
  if [ -n "${help}" ]; then
    echo -e "\e[0m${padding} \e[0m\e[0m\e[1m\e[38;5;12m|\e[0m"
    echo -e "\e[0m${padding} \e[0m\e[0m\e[1m\e[38;5;12m= \e[0m\e[1;39mhelp:\e[0m ${help}\e[0m"
  fi
  echo ""
}
