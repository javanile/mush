
exec_legacy_fetch() {
  local target_dir=$1
  local legacy_dir="${target_dir}/legacy"

  mkdir -p "${legacy_dir}"

  #echo "${MUSH_LEGACY_FETCH}"
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions -o target/debug/legacy/getoptions
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions -o target/debug/legacy/gengetoptions

  echo "${MUSH_LEGACY_FETCH}" | while IFS=$'\n' read package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_file=${legacy_dir}/${package_name}.sh
    package_url=${package#*=}

    if [ ! -f "${package_file}" ]; then
      console_status "Downloading" "$package_name => $package_url ($package_file)"
      curl -s -X GET -o "${package_file}" "${package_url}"
    fi
  done
}
