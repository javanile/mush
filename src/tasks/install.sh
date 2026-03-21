
exec_install_binaries() {
  local binaries
  binaries=$(manifest_get_binaries)

  while IFS= read -r bin_entry; do
    [ -z "${bin_entry}" ] && continue
    manifest_parse_bin_entry "${bin_entry}"
    [ -z "${BIN_NAME}" ] && continue
    if [ "${VERBOSE}" -gt 6 ]; then console_status "Binary" "'${BIN_NAME}' at '${BIN_PATH}'"; fi
  done <<EOF
${binaries}
EOF
}


exec_install() {
  local package_name
  local package_version
  local pwd
  local cp
  local chmod

  package_name=$MUSH_PACKAGE_NAME
  package_version=$MUSH_PACKAGE_VERSION
  pwd="${PWD}"
  cp="cp"
  chmod="chmod"

  mkdir -p "${MUSH_HOME}/bin"

  local binaries
  binaries=$(manifest_get_binaries)

  while IFS= read -r bin_entry; do
    [ -z "${bin_entry}" ] && continue
    manifest_parse_bin_entry "${bin_entry}"
    [ -z "${BIN_NAME}" ] && continue

    local bin_file="${MUSH_HOME}/bin/${BIN_NAME}"
    local final_file="target/release/${BIN_NAME}"

    ${cp} "${final_file}" "${bin_file}"
    ${chmod} +x "${bin_file}"

    if [ -f "${bin_file}" ]; then
      console_status "Replacing" "$(display_path "${bin_file}")"
      console_status "Replaced" "package '${package_name} v${package_version}' with '${package_name} v${package_version}' (executable '${BIN_NAME}')"
    else
      console_status "Installing" "$(display_path "${bin_file}")"
      console_status "Installed" "package '${package_name} v${package_version}' (executable '${BIN_NAME}')"
    fi
  done <<EOF
${binaries}
EOF

  console_status "Finished" "release [optimized] target(s) in 0.18s"
}

exec_install_from_index() {
  local package_entry
  local package_name
  local package_url
  local package_version_constraint
  local dependency_type
  local package_path
  local package_version
  local package_src
  local package_search
  local package_type

  local package_repo
  local package_repo_id

  package_name=$1
  package_version_constraint=$2
  dependency_type=$3

  package_search=$(grep "^${package_name} " "${MUSH_REGISTRY_INDEX}" | head -n 1)

  if [ -z "${package_search}" ]; then
    local version_label="${package_version_constraint:-*}"
    console_error "could not find '${package_name}' in registry '${MUSH_REGISTRY_URL}' with version '${version_label}'"
    exit 101
  fi

  package_entry=$(echo "${package_search}" | cut -d'#' -f1)
  package_name=$(echo "${package_entry}" | awk '{print $1}')
  package_url=$(echo "${package_entry}" | awk '{print $2}')
  package_path=$(echo "${package_entry}" | awk '{print $3}')
  package_version=$(echo "${package_entry}" | awk '{print $4}')

  package_repo_id=$(mush_url_to_id "${package_url}")

  if [ -n "${package_version_constraint}" ] && [ "${package_version_constraint}" != "*" ]; then
    package_version="${package_version_constraint}"
  else
    [ "${VERBOSE}" -gt 2 ] && console_status "Resolving" "latest stable version for '${package_name}'"
    local latest_semver
    latest_semver=$(mush_registry_package_versions "${package_url}" | grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)
    if [ -n "${latest_semver}" ]; then
      package_version="${latest_semver}"
      [ "${VERBOSE}" -gt 0 ] && console_status "Selected" "'${package_name} ${package_version}'"
    else
      package_version=main
      [ "${VERBOSE}" -gt 2 ] && console_status "Selected" "'${package_name}' no semver tags found, using 'main'"
    fi
  fi

  package_src="${MUSH_REGISTRY_SRC}/${package_name}/${package_version}"
  package_repo="${MUSH_REGISTRY_REPO}/${package_repo_id}/${package_version}"

  if [ ! -d "${package_src}" ]; then

    [ "${VERBOSE}" -gt 4 ] && console_status "Cloning" "${package_url}"

    git clone --branch "${package_version}" --single-branch "${package_url}" "${package_src}" > /dev/null 2>&1 && true

    if [ ! -d "${package_src}" ]; then
      git clone --branch "v${package_version}" --single-branch "${package_url}" "${package_src}" > /dev/null 2>&1 && true
    fi

    if [ ! -d "${package_src}" ]; then
      console_error "failed to retrieve '${package_name}' at version '${package_version}' from '${package_url}'"
      exit 101
    fi

    rm -fr "${package_src}/.git" "${package_src}/.github" || true
  fi

  local package_nested_src
  package_nested_src=$(echo "${MUSH_REGISTRY_SRC}/${package_name}/${package_version}/${package_path}" | tr -s '/')

  exec_install_from_src "${package_nested_src}" "${dependency_type}"

  if ! echo "${package_version}" | grep -qE '^v?[0-9]+\.[0-9]+\.[0-9]+$'; then
    if [ "${package_version}" != "${MUSH_PACKAGE_VERSION}" ]; then
      console_warning "Warning" "installed branch '${package_version}' but manifest declares '${MUSH_PACKAGE_VERSION}'"
    fi
  fi

  package_type=$(cat "${package_nested_src}/Manifest.toml" | grep '^type =' | cut -d'"' -f2)

  [ "${VERBOSE}" -gt 6 ] && console_status "Package" "type '${package_type:-lib}'"

  if [ "${package_type}" = "plugin" ]; then
    mkdir -p "${MUSH_HOME}/plugins/${package_name}"
    cp "${package_nested_src}/src/lib.sh" "${MUSH_HOME}/plugins/${package_name}/plugin.sh"
    cp "${package_nested_src}/Manifest.toml" "${MUSH_HOME}/plugins/${package_name}/Manifest.toml"
  fi
}

exec_install_from_src() {
  local package_src
  local dependency_type
  local reset_deps_dir=0

  package_src=$1
  dependency_type=$2

  exec_manifest_lookup "${package_src}"

  [ "${VERBOSE}" -gt 6 ] && console_status "Installing" "'${MUSH_PACKAGE_NAME}' from source '$(display_path "${package_src}")'"

  if [ "${MUSH_PACKAGE_TYPE}" = "plugin" ] && [ "${dependency_type}" = "prod" ]; then
    console_error "cannot install plugin '${MUSH_PACKAGE_NAME}' as a non dev-dependency, move it from [dependencies] to [dev-dependencies] in your Manifest.toml file."
    exit 101
  fi

  exec_legacy_fetch "${package_src}/target/release"
  exec_legacy_build "${package_src}/target/release"

  if [ -z "${MUSH_DEPS_DIR}" ]; then
    MUSH_TARGET_PATH="${package_src}/target/release"
    MUSH_DEPS_DIR="${MUSH_TARGET_PATH}/packages"
    reset_deps_dir=1
  fi

  exec_dependencies

  exec_build_from_src "${package_src}"

  if [ -f "${package_src}/src/lib.sh" ]; then
    exec_install_lib_from_src "${package_src}"
  fi

  if [ -f "${package_src}/src/main.sh" ]; then
    exec_install_bin_from_src "${package_src}"
  fi

  if [ "${reset_deps_dir}" -eq 1 ]; then
    MUSH_DEPS_DIR=""
    MUSH_TARGET_PATH=""
  fi
}

exec_install_bin_from_src() {
  local package_src=$1
  local package_name=$MUSH_PACKAGE_NAME
  local package_version=$MUSH_PACKAGE_VERSION
  local bin_name=$MUSH_PACKAGE_NAME
  local pwd=$PWD

  local bin_file=$HOME/.mush/bin/${bin_name}
  local final_file=${package_src}/target/release/${bin_name}

  local cp=cp
  local chmod=chmod
  #if [[ $EUID -ne 0 ]]; then
  #    cp="sudo ${cp}"
  #    chmod="sudo ${chmod}"
  #fi

  ${cp} "${final_file}" "${bin_file}"
  ${chmod} +x "${bin_file}"

  console_status "Finished" "release [optimized] target(s) in 0.18s"

  if [ -f "${bin_file}" ]; then
    console_status "Replacing" "$(display_path "${bin_file}")"
    console_status "Replaced" "package '${package_name} v${package_version}' with '${package_name} v${package_version}' (executable '${bin_name}')"
  else
    console_status "Installing" "$(display_path "${bin_file}")"
    console_status "Installed" "package '${package_name} v${package_version}' (executable '${bin_name}')"
  fi
}

exec_install_lib_from_src() {
  local package_src=$1
  local package_name=$MUSH_PACKAGE_NAME
  local package_version=$MUSH_PACKAGE_VERSION
  local lib_name=$MUSH_PACKAGE_NAME
  local pwd=$PWD

  local lib_file=${pwd}/lib/${lib_name}
  local lib_package_dir=${pwd}/${MUSH_TARGET_PATH}/packages/${lib_name}
  local lib_package_file=${lib_package_dir}/lib.sh
  local lib_plugin_dir=${pwd}/${MUSH_TARGET_PATH}/plugins
  local lib_plugin_file=${lib_plugin_dir}/${lib_name}.sh
  local final_file=${package_src}/target/release/lib.sh

  local cp=cp
  local chmod=chmod
  #if [[ $EUID -ne 0 ]]; then
  #    cp="sudo ${cp}"
  #    chmod="sudo ${chmod}"
  #fi

  mkdir -p "${pwd}/lib" "${lib_package_dir}"

  ${cp} "${final_file}" "${lib_file}"
  ${cp} "${final_file}" "${lib_package_file}"

  ${chmod} +x "${lib_file}" "${lib_package_file}"

  if [ -n "${MUSH_DEPS_DIR}" ]; then
    mkdir -p "${MUSH_DEPS_DIR}/${lib_name}"
    ${cp} "${final_file}" "${MUSH_DEPS_DIR}/${lib_name}/lib.sh"
    ${chmod} +x "${MUSH_DEPS_DIR}/${lib_name}/lib.sh"
  fi

  if [ "${MUSH_PACKAGE_TYPE}" = "plugin" ]; then
    mkdir -p "${lib_plugin_dir}"
    ${cp} "${final_file}" "${lib_plugin_file}"
    ${chmod} +x "${lib_plugin_file}"
  fi

  console_status "Finished" "release [optimized] target(s) in 0.18s"

  if [ -f "${lib_file}" ]; then
    console_status "Replacing" "$(display_path "${lib_file}")"
    console_status "Replaced" "package '${package_name} v${package_version}' with '${package_name} v${package_version}' (library '${lib_name}')"
  else
    console_status "Installing" "$(display_path "${lib_file}")"
    console_status "Installed" "package '${package_name} v${package_version}' (library '${lib_name}')"
  fi
}
