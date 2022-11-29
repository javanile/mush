
exec_dependencies() {


  process_dev_dependencies

  echo "DEV"
}

process_dev_dependencies() {

  echo "${MUSH_DEV_DEPS}" | while IFS=$'\n' read dependency && [ -n "$dependency" ]; do
    package_name=${dependency%=*}
    signature=${dependency#*=}

    if [ ! -d "${MUSH_DEPS_DIR}/${package_file}" ]; then
      process_dev_dependency "$package_name" $signature
    fi
  done




  echo "DEV: ${MUSH_DEV_DEPS}"
}


process_dev_dependency() {
  case "$2" in
    git)
      git_dependency "$1" "$3" "$4"
      ;;
  esac
}
