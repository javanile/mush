
exec_legacy_fetch() {
  local target_dir=$1
  local legacy_dir="${target_dir}/legacy"

  echo "${MUSH_LEGACY_FETCH}" | while IFS=$'\n' read -r package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_bin=${legacy_dir}/${package_name}
    package_signature=${package#*=}
    package_type=${package_signature%% *}
    package_url=${package_signature#* }

    [ "${VERBOSE}" -gt 4 ] && echo "Process legacy source of type '$package_type' with url '$package_url' for '$package_name'"

    case "${package_type}" in
      git)
        echo "NOT IMPLEMENTED YET!"
        exit 101
        ;;
      file)
        package_file=${legacy_dir}/${package_name}.sh
        if [ ! -f "${package_file}" ]; then
          console_status "Downloading" "$package_name => $package_url ($package_file)"
          mkdir -p "${legacy_dir}"
          curl -s -L -X GET -o "${package_file}" "${package_url}"
          ln "${package_file}" "${package_bin}"
          chmod +x "${package_bin}"
        fi
        ;;
      *)
        console_error "Unsupported legacy package type '$package_type' for '$package_name' on Manifest.toml"
        exit 101
        ;;
    esac
  done
}
