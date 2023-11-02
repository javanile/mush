
__plugin_error_trace__feature_error_dumper__hook_build_debug_head_section() {
  local value

  value=$1

  if [ "${value}" = "true" ]; then
    echo "Adding error dumper to the build"
  fi
}
