
exec_legacy_build() {
  local target_dir=$1
  local legacy_dir="${target_dir}/legacy"

  [ "${VERBOSE}" -gt 5 ] && echo -e "FETCH:\n${MUSH_LEGACY_FETCH}\nBUILD:\n${MUSH_LEGACY_BUILD}"

  echo "${MUSH_LEGACY_BUILD}" | while IFS=$'\n' read -r package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_file=${legacy_dir}/__${package_name}.sh
    package_script=${package#*=}

    [ "${VERBOSE}" -gt 4 ] && echo "! Building '${package_script}' for '$package_name'"

    if [ ! -f "${package_file}" ]; then
      console_status "Compiling" "$package_name => $package_script ($package_file)"
      mkdir -p "${legacy_dir}"
      local pwd=$PWD
      cd "$legacy_dir"
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$pwd"
    fi
  done
}
