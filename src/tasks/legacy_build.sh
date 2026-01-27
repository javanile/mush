# @score: 5

exec_legacy_build() {
  local target_dir
  local legacy_dir
  local temp_pwd

  target_dir=$1
  legacy_dir="${target_dir}/legacy"

  [ "${VERBOSE}" -gt 5 ] && echo -e "FETCH:\n${MUSH_LEGACY_FETCH}\nBUILD:\n${MUSH_LEGACY_BUILD}"

  echo "${MUSH_LEGACY_BUILD}" | while IFS=$'\n' read -r package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_file=${legacy_dir}/__${package_name}.sh
    package_script=${package#*=}

    [ "${VERBOSE}" -gt 4 ] && echo "! Building '${package_script}' for '$package_name'"

    if [ ! -f "${package_file}" ]; then
      console_status "Compiling" "$package_name => $package_script ($package_file)"
      mkdir -p "${legacy_dir}"
      temp_pwd=$PWD
      cd "$legacy_dir" || exit 101
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$temp_pwd" || exit 101
    fi
  done
}
