
exec_dependencies() {
  process_dependencies
  process_dependencies_build
  process_dev_dependencies
  process_dev_dependencies_build
}

process_dependencies() {
  echo "${MUSH_DEPS}" | while IFS=$'\n' read -r dependency && [ -n "$dependency" ]; do
    [ "${VERBOSE}" -gt 4 ] && echo "Parsing dependency '$dependency'"

    local package_name=${dependency%=*}
    local package_signature=${dependency#*=}

    if [ ! -d "${MUSH_DEPS_DIR}/${package_name}" ]; then
      process_dependency "$package_name" "$package_signature"
    fi
  done
}

process_dependency() {
  local package_name
  local package_source
  local package_full_name
  local package_version_constraint

  package_name="$1"

  if [ "$2" = "*" ]; then
    package_source="mush"
    package_full_name="${package_name}"
    package_version_constraint="*"
  else
    package_source="${2%% *}"
    package_full_name=$(echo "$your_variable" | awk '{print $2}')
    package_version_constraint=$(echo "$your_variable" | awk '{print $3}')
  fi

  [ "${VERBOSE}" -gt 4 ] && echo "Processing dependency '$1', '$2', 'source=${package_source}'"

  case "${package_source}" in
    git)
      git_dependency "${package_name}" "${package_full_name}" "${package_version_constraint}"
      ;;
    mush)
      mush_dependency "${package_name}" "${package_full_name}" "${package_version_constraint}"
      ;;
    *)
      console_error "Unsupported package manager '${package_source}' for '$1' on Manifest.toml"
      exit 101
      ;;
  esac
}

process_dependencies_build() {
  echo "${MUSH_DEPS_BUILD}" | while IFS=$'\n' read dependency && [ -n "$dependency" ]; do
    local package_name=${dependency%=*}
    local package_script=${dependency#*=}
    local package_dir="${MUSH_DEPS_DIR}/${package_name}"

    if [ -d "${package_dir}" ]; then
      local pwd=$PWD
      cd "${package_dir}"
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$pwd"
    fi
  done
}

process_dev_dependencies() {
  echo "${MUSH_DEV_DEPS}" | while IFS=$'\n' read -r dependency && [ -n "$dependency" ]; do
    local package_name=${dependency%=*}
    local package_signature=${dependency#*=}

    if [ ! -d "${MUSH_DEPS_DIR}/${package_name}" ]; then
      process_dev_dependency "$package_name" "$package_signature"
    fi
  done
}

process_dev_dependency() {
  case "$2" in
    git)
      git_dependency "$1" "$3" "$4"
      ;;
    mush)
      mush_dependency "$1" "$3" "$4"
      ;;
    *)
      console_error "Unsupported package manager '$2' for '$1' on Manifest.toml"
      exit 101
      ;;
  esac
}

process_dev_dependencies_build() {
  echo "${MUSH_DEV_DEPS_BUILD}" | while IFS=$'\n' read dependency && [ -n "$dependency" ]; do
    local package_name=${dependency%=*}
    local package_script=${dependency#*=}
    local package_dir="${MUSH_DEPS_DIR}/${package_name}"

    if [ -d "${package_dir}" ]; then
      local pwd=$PWD
      cd "${package_dir}"
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$pwd"
    fi
  done
}
