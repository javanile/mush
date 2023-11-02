
exec_plugin_load() {
  local plugins_dir

  plugins_dir="$1/plugins"

  if [ -d "$plugins_dir" ]; then
    find "$plugins_dir" -type f -name "*.sh" | while IFS=$'\n' read -r plugin_file; do
      echo "Loading plugin: ${plugin_file}"
      source "${plugin_file}"
      type -t __plugin_error_trace__feature_error_dumper__hook_build_debug_head_section
      __plugin_error_trace__feature_error_dumper__hook_build_debug_head_section() {
        echo "AAAA"
      }
      export -f __plugin_error_trace__feature_error_dumper__hook_build_debug_head_section
    done
  fi
}
