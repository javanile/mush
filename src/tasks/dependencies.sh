
exec_dependencies() {


  process_dev_dependencies

  echo "DEV"
}

process_dev_dependencies() {

  echo "${MUSH_DEV_DEPS}" | while IFS=$'\n' read dependency && [ -n "$dependency" ]; do

    echo "DEP: $dependency"

    #if [ ! -f "${package_file}" ]; then
    #  console_status "Compiling" "$package_name => $package_script ($package_file)"
    #  local pwd=$PWD
    #  cd "$legacy_dir"
    #  eval "PATH=${PATH}:${PWD} ${package_script}"
    #  cd "$pwd"
    #fi
  done




  echo "DEV: ${MUSH_DEV_DEPS}"
}
