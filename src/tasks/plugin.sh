
exec_plugin_list() {
  local plugins_dir
  local plugin_file
  local plugin_name

  # Global installed plugin
  plugins_dir="${MUSH_HOME}/plugins"
  if [ -d "$plugins_dir" ]; then
    find "$plugins_dir" -type f -name "plugin.sh" | while IFS=$'\n' read -r plugin_file; do
      plugin_name="$(basename "$(dirname "${plugin_file}")")"
      echo "${plugin_name}=${plugin_file}"
    done
  fi

  # Project related plugin
  plugins_dir="$1/plugins"
  if [ -d "$plugins_dir" ]; then
    find "$plugins_dir" -type f -name "plugin.sh" | while IFS=$'\n' read -r plugin_file; do
      echo "Found plugin: ${plugin_file}" >&2
      plugin_name="$(basename "$(dirname "${plugin_file}")")"
      echo "${plugin_name}=${plugin_file}"
    done
  fi
}
