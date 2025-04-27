
exec_dependencies() {
  ## TODO: Expected output
  #  Downloaded syn v2.0.37
  #  Downloaded 1 crate (243.2 KB) in 0.46s
  #   Compiling proc-macro2 v1.0.67
  #   Compiling unicode-ident v1.0.12
  #   Compiling serde v1.0.188
  #   Compiling quote v1.0.33
  #   Compiling syn v2.0.37
  #   Compiling serde_derive v1.0.188
  #   Compiling rust-lib v0.1.0 (/home/francesco/Develop/Javanile/mush/tests/fixtures/rust-lib)
  #    Finished dev [unoptimized + debuginfo] target(s) in 4.65s

  process_dependencies dev
  process_dependencies_build dev

  process_dependencies prod
  process_dependencies_build prod
}

process_dependencies() {
  local dependencies_type
  local dependencies_list
  local package_name
  local package_signature

  dependencies_type=$1
  if [ "${dependencies_type}" = "prod" ]; then
    dependencies_list="${MUSH_DEPS}"
  else
    dependencies_list="${MUSH_DEV_DEPS}"
  fi

  echo "${dependencies_list}" | while IFS=$'\n' read -r dependency && [ -n "$dependency" ]; do
    [ "${VERBOSE}" -gt 4 ] && echo "Parsing dependency '$dependency'"

    package_name="${dependency%=*}"
    package_signature="${dependency#*=}"

    if [ ! -d "${MUSH_DEPS_DIR}/${package_name}" ]; then
      process_dependency "${dependencies_type}" "${package_name}" "${package_signature}"
    fi
  done
}

process_dependency() {
  local dependency_type
  local package_name
  local package_source
  local package_full_name
  local package_version_constraint

  dependency_type="$1"
  package_name="$2"

  if [ "$3" = "*" ]; then
    package_source="mush"
    package_full_name="${package_name}"
    package_version_constraint="*"
  else
    package_source="${3%% *}"
    package_full_name=$(echo "$3" | awk '{print $2}')
    package_version_constraint=$(echo "$3" | awk '{print $3}')
  fi

  [ "${VERBOSE}" -gt 4 ] && echo "Processing '$1' dependency '$2', '$3', 'source=${package_source}'"

  case "${package_source}" in
    git)
      git_dependency "${package_name}" "${package_full_name}" "${package_version_constraint}" "${dependency_type}"
      ;;
    mush)
      mush_dependency "${package_name}" "${package_full_name}" "${package_version_constraint}" "${dependency_type}"
      ;;
    bpkg)
      bpkg_dependency "${package_name}" "${package_full_name}" "${package_version_constraint}" "${dependency_type}"
      ;;
    *)
      console_error "Unsupported package manager '${package_source}' for '$1' on Manifest.toml"
      exit 101
      ;;
  esac
}

process_dependencies_build() {
  local dependencies_type
  local dependencies_build

  dependencies_type=$1
  if [ "${dependencies_type}" = "prod" ]; then
    dependencies_build="${MUSH_DEPS_BUILD}"
  else
    dependencies_build="${MUSH_DEV_DEPS_BUILD}"
  fi

  echo "${dependencies_build}" | while IFS=$'\n' read -r dependency && [ -n "$dependency" ]; do
    local package_name=${dependency%=*}
    local package_script=${dependency#*=}
    local package_dir="${MUSH_DEPS_DIR}/${package_name}"

    if [ -d "${package_dir}" ]; then
      local pwd=$PWD
      cd "${package_dir}"
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$pwd"
    fi
  done
}
