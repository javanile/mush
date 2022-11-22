
exec_legacy_build() {
  local target_dir=$1
  local legacy_dir="${target_dir}/legacy"

  mkdir -p "${legacy_dir}"

  echo "${MUSH_LEGACY_BUILD}" | while IFS=$'\n' read package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_file=${legacy_dir}/${package_name}.sh
    package_script=${package#*=}

    if [ ! -f "${package_file}" ]; then
      console_status "Compiling" "$package_name => $package_script ($package_file)"
      local pwd=$PWD
      cd "$legacy_dir"
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$pwd"
    fi
  done


}
