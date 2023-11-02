
exec_plugin_load() {
  local plugins_dir

  plugins_dir="$1/plugins"

  if [ -d "$plugins_dir" ]; then
    find "$plugins_dir" -type f -name "*.sh" | while IFS=$'\n' read -r plugin_file; do
      echo "Loading plugin: ${plugin_file}"
      source "${plugin_file}"
    done
  fi
}
