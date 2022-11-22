
exec_legacy_fetch() {
  local target_dir=$1
  local legacy_dir="${target_dir}/legacy"

  mkdir -p "${legacy_dir}"

  echo "${MUSH_LEGACY_FETCH}" | while IFS=$'\n' read package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_file=${legacy_dir}/${package_name}.sh
    package_bin=${legacy_dir}/${package_name}
    package_url=${package#*=}

    if [ ! -f "${package_file}" ]; then
      console_status "Downloading" "$package_name => $package_url ($package_file)"
      curl -s -L -X GET -o "${package_file}" "${package_url}"
      ln "${package_file}" "${package_bin}"
      chmod +x "${package_bin}"
    fi
  done
}
