
exec_install() {
  local package_name=$MUSH_PACKAGE_NAME
  local package_version=$MUSH_PACKAGE_VERSION
  local bin_name=$MUSH_PACKAGE_NAME
  local pwd=$PWD

  local bin_file=$HOME/.mush/bin/${bin_name}
  local final_file=target/dist/${bin_name}

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
    console_status "Replacing" "${bin_file}"
    console_status "Replaced" "package '${package_name} v${package_version} (${pwd})' with '${package_name} v${package_version} (${pwd})' (executable '${bin_name}')"
  else
    console_status "Installing" "${bin_file}"
    console_status "Installed" "package '${package_name} v${package_version} (${pwd})' (executable '${bin_name}')"
  fi
}

exec_install_from_index() {
  local package_name
  local package_version_constraint

  package_name=$1
  package_version_constraint=$2

  local package_search=$(grep "^${package_name} " "${MUSH_REGISTRY_INDEX}" | head -n 1)

  if [ -z "${package_search}" ]; then
    console_error "could not find '${package_name}' in registry '${MUSH_REGISTRY_URL}' with version '*'"
    exit 101
  fi

  ## TODO: Implement version constraint
  local package_version_selected=1
  local package_src="${MUSH_REGISTRY_SRC}/${package_name}"

  local package_name=$(echo "${package_search}" | awk '{print $1}')
  local package_url=$(echo "${package_search}" | awk '{print $2}')
  local package_path=$(echo "${package_search}" | awk '{print $3}')
  local package_version=$(echo "${package_search}" | awk '{print $4}')

  if [ -d "${package_src}" ]; then
    rm -fr "${package_src}"
  fi

  git clone --branch main --single-branch "${package_url}" "${package_src}" > /dev/null 2>&1
  rm -fr "${package_src}/.git" "${package_src}/.github" || true

  local package_nested_src="${MUSH_REGISTRY_SRC}/${package_name}/${package_path}"

  exec_install_from_src "${package_nested_src}"
}

exec_install_from_src() {
  local package_src=$1

  exec_manifest_lookup "${package_src}"
  exec_legacy_fetch "${package_src}/target/dist"
  exec_legacy_build "${package_src}/target/dist"
  exec_build_from_src "${package_src}"

  if [ -f "${package_src}/src/lib.sh" ]; then
    exec_install_lib_from_src "${package_src}"
  fi

  if [ -f "${package_src}/src/main.sh" ]; then
    exec_install_bin_from_src "${package_src}"
  fi
}

exec_install_bin_from_src() {
  local package_src=$1
  local package_name=$MUSH_PACKAGE_NAME
  local package_version=$MUSH_PACKAGE_VERSION
  local bin_name=$MUSH_PACKAGE_NAME
  local pwd=$PWD

  local bin_file=$HOME/.mush/bin/${bin_name}
  local final_file=${package_src}/target/dist/${bin_name}

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
    console_status "Replacing" "${bin_file}"
    console_status "Replaced" "package '${package_name} v${package_version} (${pwd})' with '${package_name} v${package_version} (${pwd})' (executable '${bin_name}')"
  else
    console_status "Installing" "${bin_file}"
    console_status "Installed" "package '${package_name} v${package_version} (${pwd})' (executable '${bin_name}')"
  fi
}

exec_install_lib_from_src() {
  local package_src=$1
  local package_name=$MUSH_PACKAGE_NAME
  local package_version=$MUSH_PACKAGE_VERSION
  local lib_name=$MUSH_PACKAGE_NAME
  local pwd=$PWD

  local lib_file=${pwd}/lib/${lib_name}
  local lib_package_dir=${pwd}/${MUSH_TARGET_DIR}/packages/${lib_name}
  local lib_package_file=${lib_package_dir}/lib.sh
  local final_file=${package_src}/target/dist/lib.sh

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

  console_status "Finished" "release [optimized] target(s) in 0.18s"

  if [ -f "${lib_file}" ]; then
    console_status "Replacing" "${lib_file}"
    console_status "Replaced" "package '${package_name} v${package_version} (${pwd})' with '${package_name} v${package_version} (${pwd})' (library '${lib_name}')"
  else
    console_status "Installing" "${lib_file}"
    console_status "Installed" "package '${package_name} v${package_version} (${pwd})' (library '${lib_name}')"
  fi
}
