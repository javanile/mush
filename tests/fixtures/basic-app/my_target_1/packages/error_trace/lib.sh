#!/usr/bin/env bash
## BP010: Release metadata
## @build_type: lib
## @build_date: 2023-11-13T22:52:48Z
set -e
use() { return 0; }
extern() { return 0; }
legacy() { return 0; }
module() { return 0; }
public() { return 0; }
embed() { return 0; }
## BP004: Compile the entrypoint

__plugin_error_trace__feature_error_dumper__hook_build_debug_head_section() {
  local value
  local build_file

  value=$1
  build_file=$2

  if [ "${value}" = "true" ]; then
    echo "Adding error dumper to the build file: ${build_file}"
  fi
}
