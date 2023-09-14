
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
