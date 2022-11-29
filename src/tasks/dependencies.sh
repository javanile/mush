
exec_dependencies() {
  process_dev_dependencies
  process_dev_dependencies_build
}

process_dev_dependencies() {
  echo "${MUSH_DEV_DEPS}" | while IFS=$'\n' read dependency && [ -n "$dependency" ]; do
    package_name=${dependency%=*}
    package_signature=${dependency#*=}

    if [ ! -d "${MUSH_DEPS_DIR}/${package_name}" ]; then
      process_dev_dependency "$package_name" $package_signature
    fi
  done
}

process_dev_dependency() {
  case "$2" in
    git)
      git_dependency "$1" "$3" "$4"
      ;;
  esac
}

process_dev_dependencies_build() {
  echo "${MUSH_DEV_DEPS_BUILD}" | while IFS=$'\n' read dependency && [ -n "$dependency" ]; do
    package_name=${dependency%=*}
    package_script=${dependency#*=}
    package_dir="${MUSH_DEPS_DIR}/${package_name}"

    if [ -d "${package_dir}" ]; then
      local pwd=$PWD
      cd "${package_dir}"
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$pwd"
    fi
  done
}
