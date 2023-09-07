
exec_install() {
  local package_name=$MUSH_PACKAGE_NAME
  local package_version=$MUSH_PACKAGE_VERSION
  local bin_name=$MUSH_PACKAGE_NAME

  local bin_file=/usr/local/bin/${bin_name}
  local final_file=target/dist/${bin_name}

  local cp=cp
  local chmod=chmod
  if [[ $EUID -ne 0 ]]; then
      cp="sudo ${cp}"
      chmod="sudo ${chmod}"
  fi

  ${cp} "${final_file}" "${bin_file}"
  ${chmod} +x "${bin_file}"

  echo "Finished release [optimized] target(s) in 0.18s"
  echo "Installing ${bin_file}"
  echo "Installed package 'cask-cli v0.1.0 (/home/francesco/Develop/Javanile/rust-cask)' (executable 'cask')"
}

