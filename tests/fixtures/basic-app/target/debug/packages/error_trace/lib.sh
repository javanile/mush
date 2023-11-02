#!/usr/bin/env bash
## BP010: Release metadata
## @build_type: lib
## @build_date: 2023-11-02T18:10:36Z
set -e
extern() {
  extern=$1
}
legacy() {
  legacy=$1
}
module() {
  module=$1
}
public() {
  public=$1
}
use() {
  use=$1
}
embed() {
  embed=$1
}
## BP004: Compile the entrypoint

__plugin_error_trace__feature_error_dumper__hook_build_debug_head_section() {
  local value

  value=$1

  if [ "${value}" = "true" ]; then
    echo "Adding error dumper to the build"
  fi
}

export -f __plugin_error_trace__feature_error_dumper__hook_build_debug_head_section
