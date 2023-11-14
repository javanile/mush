
parser_definition_install() {
  setup   REST help:usage abbr:true -- "Install a Mush binary. Default location is \$HOME/.mush/bin" ''

  msg   -- 'USAGE:' "  ${2##*/} install [OPTIONS] [package]..." ''

  msg    -- 'OPTIONS:'
  flag   VERBOSE        -v --verbose counter:true "init:=${VERBOSE}" -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET          -q --quiet                        -- "Do not print mush log messages"

  param  PACKAGE_PATH      --path                         -- "Filesystem path to local package to install"
  param  BUILD_TARGET   -t --target                       -- "Build for the specific target"
  disp   :usage         -h --help                         -- "Print help information"
}

run_install() {
  eval "$(getoptions parser_definition_install parse "$0")"
  parse "$@"
  eval "set -- $REST"

  if [ -n "$PACKAGE_PATH" ]; then
    local package_path=$(realpath "$PACKAGE_PATH")
    [ "${VERBOSE}" -gt 5 ] && echo "Installing from source path '$PACKAGE_PATH'"
    if [ -f "${package_path}/Manifest.toml" ]; then
      exec_manifest_lookup "${package_path}"
      MUSH_TARGET_PATH=target/release
      exec_legacy_fetch "${MUSH_TARGET_PATH}"
      exec_legacy_build "${MUSH_TARGET_PATH}"
      exec_dependencies "${MUSH_TARGET_PATH}"
      exec_build_release "$@"
      exec_install
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
      mush_registry_index_update
      exec_install_from_index "$1"
    fi
  fi
}
