# @score: 5

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
      plugin_name="$(basename "$(dirname "${plugin_file}")")"
      echo "${plugin_name}=${plugin_file}"
    done
  fi

  # If current package is a plugin is by default listed
  #[ "${VERBOSE}" -gt 7 ] && echo "List plugin: ${MUSH_PACKAGE_NAME} ${MUSH_PACKAGE_TYPE}" >&2
  if [ "${MUSH_PACKAGE_TYPE}" = "plugin" ]; then
    echo "${MUSH_PACKAGE_NAME}=${PWD}/lib/${MUSH_PACKAGE_NAME}"
  fi
}
