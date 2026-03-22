
parser_definition_add() {
  setup   REST help:usage abbr:true -- "Add a dependency to the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} add [OPTIONS] <package[@version]>..." ''

  msg    -- 'OPTIONS:'
  flag   VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET          -q --quiet                        -- "Do not print mush log messages"
  flag   DEV               --dev                          -- "Add as a dev-dependency"
  disp   :usage         -h --help                         -- "Print help information"
}

run_add() {
  eval "$(getoptions parser_definition_add parse "$0")"
  parse "$@"
  eval "set -- $REST"

  if [ $# -eq 0 ]; then
    console_error "no packages specified\n\n    Usage: mush add <package[@version]>... [--dev]"
    exit 101
  fi

  exec_manifest_lookup "${PWD}"
  mush_registry_index_update

  local dep_type dep_section
  if [ -n "${DEV}" ]; then
    dep_type="dev"
    dep_section="dev-dependencies"
  else
    dep_type="prod"
    dep_section="dependencies"
  fi

  while [ $# -gt 0 ]; do
    local package_name package_version
    package_name="$1"
    package_version=""

    if echo "$package_name" | grep -q '@'; then
      package_version="${package_name##*@}"
      package_name="${package_name%%@*}"
    fi

    [ "${VERBOSE}" -gt 0 ] && console_status "Adding" "'${package_name}' to [${dep_section}]"

    local project_manifest_dir="${MUSH_MANIFEST_DIR}"
    MUSH_TARGET_PATH="target/release"
    MUSH_DEPS_DIR="${PWD}/target/release/packages"
    mkdir -p "${MUSH_DEPS_DIR}"
    exec_install_from_index "${package_name}" "${package_version}" "${dep_type}"
    MUSH_MANIFEST_DIR="${project_manifest_dir}"
    manifest_add_dependency "${package_name}" "${package_version}" "${dep_section}"

    console_status "Added" "'${package_name}' to [${dep_section}] in 'Manifest.toml'"

    shift
  done
}