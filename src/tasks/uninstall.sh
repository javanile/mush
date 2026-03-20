
exec_uninstall() {
  local package_name="$1"
  local bin_name="${BIN_NAME:-$1}"
  local bin_file="${MUSH_HOME}/bin/${bin_name}"
  local plugin_dir="${MUSH_HOME}/plugins/${package_name}"
  local found=0

  if [ -f "${bin_file}" ]; then
    rm -f "${bin_file}"
    console_status "Removing" "${bin_file}"
    console_status "Removed" "package '${package_name}' (executable '${bin_name}')"
    found=1
  fi

  if [ -d "${plugin_dir}" ]; then
    rm -rf "${plugin_dir}"
    console_status "Removing" "${plugin_dir}"
    console_status "Removed" "plugin '${package_name}'"
    found=1
  fi

  if [ "${found}" -eq 0 ]; then
    console_error "package '${package_name}' is not installed"
    exit 101
  fi

  if [ -n "${PURGE}" ]; then
    local registry_src="${MUSH_HOME}/registry/src"
    local purged=0
    for registry_dir in "${registry_src}"/*/; do
      local cache_dir="${registry_dir}${package_name}"
      if [ -d "${cache_dir}" ]; then
        rm -rf "${cache_dir}"
        console_status "Purging" "${cache_dir}"
        purged=1
      fi
    done
    [ "${purged}" -eq 0 ] && [ "${VERBOSE}" -gt 0 ] && console_status "Purge" "no registry cache found for '${package_name}'"
  fi
}