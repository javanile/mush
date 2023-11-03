
exec_plugin_list() {
  local plugins_dir
  local plugin_file

  plugins_dir="$1/plugins"

  if [ -d "$plugins_dir" ]; then
    find "$plugins_dir" -type f -name "*.sh" | while IFS=$'\n' read -r plugin_file; do
      echo "Loading plugin: ${plugin_file}" >&2
      echo "${plugin_file}"
    done
  fi
}
