
mush_path_dependency() {
  local package_name=$1
  local package_path=$2
  local dependency_type=$4

  local resolved_path
  resolved_path=$(cd "${package_path}" 2>/dev/null && pwd)

  if [ -z "${resolved_path}" ] || [ ! -d "${resolved_path}" ]; then
    console_error "path dependency '${package_name}' not found at '${package_path}'"
    exit 101
  fi

  # Ensure MUSH_DEPS_DIR is set so exec_install_from_src does not reset
  # MUSH_TARGET_PATH to the dependency's own target directory.  Keeping
  # MUSH_TARGET_PATH pointing at the caller project's target tree is what
  # makes exec_install_lib_from_src place the plugin under the right path:
  #   <project>/target/release/plugins/<name>/plugin.sh
  if [ -z "${MUSH_DEPS_DIR}" ]; then
    MUSH_DEPS_DIR="${MUSH_TARGET_PATH}/packages"
  fi

  exec_install_from_src "${resolved_path}" "${dependency_type}"
}
