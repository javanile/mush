
__plugin_error_trace__feature_error_dumper__hook_build_debug_head_section() {
  local value
  local build_file

  value=$1
  build_file=$2

  if [ "${value}" = "true" ]; then
    echo "Adding error dumper to the build file: ${build_file}"
  fi
}
