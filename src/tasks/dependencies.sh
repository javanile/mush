
system_dependency_not_root() {
  local package_name=$1
  local install_cmd=$2

  console_error "dependency '${package_name}' is not installed"
  console_hint "run the following command to install it:"
  printf "\n    %s\n\n" "${install_cmd}" >&2
  console_hint "then re-run: mush install"
}

exec_dependencies() {
  local update_strategy
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

  update_strategy="${1:-lazy}"

  process_dependencies "dev" "${update_strategy}"
  process_dependencies_build "dev"

  process_dependencies "prod" "${update_strategy}"
  process_dependencies_build "prod"
}

process_dependencies() {
  local dependencies_type
  local dependencies_list
  local package_name
  local package_signature
  local update_strategy

  dependencies_type=$1
  if [ "${dependencies_type}" = "prod" ]; then
    dependencies_list="${MUSH_DEPS}"
  else
    dependencies_list="${MUSH_DEV_DEPS}"
  fi

  update_strategy="${2:-lazy}"

  echo "${dependencies_list}" | while IFS=$'\n' read -r dependency && [ -n "$dependency" ]; do
    package_name="${dependency%=*}"
    package_signature="${dependency#*=}"

    [ "${VERBOSE}" -gt 4 ] && console_info "Checking" "dependency '${package_name}'"

    if is_system_dependency "${package_signature}"; then
      # System dependencies are processed regardless of MUSH_DEPS_DIR
      process_system_dependency "${package_name}" "${package_signature}"
    elif [ -n "${MUSH_DEPS_DIR}" ] && [ ! -d "${MUSH_DEPS_DIR}/${package_name}" ]; then
      mkdir -p "${MUSH_DEPS_DIR}/${package_name}"
      process_dependency "${dependencies_type}" "${package_name}" "${package_signature}" "${update_strategy}"
    fi
  done
}

process_system_dependency() {
  local package_name=$1
  local package_signature=$2
  local binary_exists

  # Check if binary is already available on PATH (isolated for set -e)
  binary_exists=$(command -v "$package_name" || true)
  if [ -n "$binary_exists" ]; then
    [ "${VERBOSE}" -gt 4 ] && console_info "Satisfied" "system dependency '${package_name}' already installed"
    return 0
  fi

  # Parse multi-registry syntax: "apt jq | yum jq | brew jq"
  local registry_list
  local registry
  local registry_package

  # Split by | and try each registry
  echo "$package_signature" | tr '|' '\n' | while read -r registry_entry; do
    registry_entry=$(echo "$registry_entry" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    registry="${registry_entry%% *}"
    registry_package="${registry_entry#* }"

    # Check if this registry is available
    case "$registry" in
      apt)
        if apt_is_available; then
          apt_install "$registry_package"
          return $?
        fi
        ;;
      yum)
        if yum_is_available; then
          yum_install "$registry_package"
          return $?
        fi
        ;;
      brew)
        if brew_is_available; then
          brew_install "$registry_package"
          return $?
        fi
        ;;
      pacman)
        if pacman_is_available; then
          pacman_install "$registry_package"
          return $?
        fi
        ;;
      pip)
        if pip_is_available; then
          pip_install "$registry_package"
          return $?
        fi
        ;;
    esac
  done

  console_error "No supported package manager found to install '$package_name'"
  return 1
}

is_system_dependency() {
  local package_signature=$1

  # Check if signature contains | (multi-registry) or starts with a known system PM
  case "$package_signature" in
    *"|"*)
      return 0
      ;;
    apt\ *|yum\ *|brew\ *|pacman\ *|pip\ *)
      return 0
      ;;
  esac

  return 1
}

process_dependency() {
  local dependency_type
  local package_name
  local package_source
  local package_full_name
  local package_version_constraint

  dependency_type="$1"
  package_name="$2"

  # Handle system dependencies (multi-registry syntax)
  if is_system_dependency "$3"; then
    process_system_dependency "$package_name" "$3"
    return $?
  fi

  if [ "$3" = "*" ]; then
    package_source="mush"
    package_full_name="${package_name}"
    package_version_constraint="*"
  else
    package_source="${3%% *}"
    package_full_name=$(echo "$3" | awk '{print $2}')
    package_version_constraint=$(echo "$3" | awk '{print $3}')
  fi

  update_strategy=${1:-lazy}

  [ "${VERBOSE}" -gt 4 ] && echo "Processing '$1' dependency '$2', '$3', 'source=${package_source}'"

  case "${package_source}" in
    git)
      git_dependency "${package_name}" "${package_full_name}" "${package_version_constraint}" "${dependency_type}"
      ;;
    mush)
      mush_dependency "${package_name}" "${package_full_name}" "${package_version_constraint}" "${dependency_type}" "${update_strategy}"
      ;;
    path)
      mush_path_dependency "${package_name}" "${package_full_name}" "${package_version_constraint}" "${dependency_type}" "${update_strategy}"
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
