
parser_definition_install() {
  setup   REST help:usage abbr:true -- "Install a Mush binary. Default location is \$HOME/.mush/bin" ''

  msg   -- 'USAGE:' "  ${2##*/} install [OPTIONS] [package]..." ''

  msg    -- 'OPTIONS:'
  flag   VERBOSE         -v --verbose counter:true "init:=${VERBOSE}" -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET           -q --quiet                        -- "Do not print mush log messages"

  param  PACKAGE_VERSION    --version                      -- "Specify a version to install"
  param  PACKAGE_PATH       --path                         -- "Filesystem path to local package to install"
  param  BUILD_TARGET    -t --target                       -- "Build for the specific target"
  flag   LIST            -l --list                         -- "List all installed packages and their versions"
  flag   FORCE           -f --force                        -- "Force overwriting existing crates or binaries"

  disp   :usage          -h --help                         -- "Print help information"
}

run_install() {
  eval "$(getoptions parser_definition_install parse "$0")"
  parse "$@"
  eval "set -- $REST"

  local temp_pwd
  local package_path
  local index_update

  mush_env

  if [ -n "${LIST}" ]; then
    if [ -z "$(command -v tree 2>/dev/null || true)" ]; then
      temp_pwd=$PWD
      cd "$MUSH_HOME/registry/src" || exit 1
      find . -maxdepth 3 -type d | sed -e 's;[^/]*/;|__;g;s;__|;  |;g'
      cd "$temp_pwd" || exit 1
    else
      tree -d -L 3 "$MUSH_HOME/registry/src" | sed '$d'
    fi
  elif [ -n "$PACKAGE_PATH" ]; then
    package_path=$(realpath "$PACKAGE_PATH")

    [ "${VERBOSE}" -gt 5 ] && console_info "Installing" "path='$PACKAGE_PATH' realpath='$package_path'"

    if [ -f "${package_path}/Manifest.toml" ]; then
      exec_manifest_lookup "${package_path}"
      if [ "${MUSH_PACKAGE_TYPE}" = "plugin" ]; then
        echo "Install plugin: $MUSH_PACKAGE_NAME"
      else
        MUSH_TARGET_PATH=target/release
        exec_legacy_fetch "${MUSH_TARGET_PATH}"
        exec_legacy_build "${MUSH_TARGET_PATH}"
        exec_dependencies "${MUSH_TARGET_PATH}"
        exec_build_release "$@"
        exec_install_binaries
        exec_install
      fi
    else
      console_error "'${package_path}' does not contain a Manifest.toml file. --path must point to a directory containing a Manifest.toml file."
    fi
  else
    if [ "$#" -eq 0 ]; then
      if [ -f "Manifest.toml" ]; then
        console_error "Using 'mush install' to install the binaries for the package in current working directory is not supported, use 'mush install --path .' instead. Use 'mush build' if you want to simply build the package."
      else
        console_error "'${PWD}' is not a package root; specify a package to install, or use --path or --git to specify an alternate source."
      fi
    else
      [ -n "${FORCE}" ] && index_update=full
      mush_registry_index_update "${index_update}"
      exec_install_from_index "$1" "${PACKAGE_VERSION}"
    fi
  fi
}
