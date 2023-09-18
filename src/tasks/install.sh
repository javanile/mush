
exec_install() {
  local package_name=$MUSH_PACKAGE_NAME
  local package_version=$MUSH_PACKAGE_VERSION
  local bin_name=$MUSH_PACKAGE_NAME
  local pwd=$PWD

  local bin_file=$HOME/.mush/bin/${bin_name}
  local final_file=target/dist/${bin_name}

  local cp=cp
  local chmod=chmod
  if [[ $EUID -ne 0 ]]; then
      cp="sudo ${cp}"
      chmod="sudo ${chmod}"
  fi

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
  local package_name=$1

  local package_search=$(grep "^${package_name} " "${MUSH_REGISTRY_INDEX}" | head -n 1)

  if [ -z "${package_search}" ]; then
    console_error "could not find '${package_name}' in registry '${MUSH_REGISTRY_URL}' with version '*'"
    exit 101
  fi

  local package_src="${MUSH_REGISTRY_SRC}/${package_name}"

  local package_name=$(echo "${package_search}" | awk '{print $1}')
  local package_url=$(echo "${package_search}" | awk '{print $2}')
  local package_path=$(echo "${package_search}" | awk '{print $3}')
  local package_version=$(echo "${package_search}" | awk '{print $4}')

  if [ ! -d "$package_src" ]; then
    git clone --branch main --single-branch "${package_url}" "${package_src}"
  fi

  local package_src="${MUSH_REGISTRY_SRC}/${package_name}/${package_path}"

  #echo "${package_src}/Manifest.toml"
  #cat "${package_src}/Manifest.toml"

  exec_install_from_src "${package_src}"
}

exec_install_from_src() {
  local package_src=$1

  local package_name=$MUSH_PACKAGE_NAME
  local package_version=$MUSH_PACKAGE_VERSION
  local bin_name=$MUSH_PACKAGE_NAME
  local pwd=$PWD

  local bin_file=$HOME/.mush/bin/${bin_name}
  local final_file=target/dist/${bin_name}

  local cp=cp
  local chmod=chmod
  if [[ $EUID -ne 0 ]]; then
      cp="sudo ${cp}"
      chmod="sudo ${chmod}"
  fi

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
