
parser_definition_test() {
	setup   REST help:usage abbr:true -- "Execute all unit and integration tests and build examples of a local package" ''

  msg   -- 'USAGE:' "  ${2##*/} test [OPTIONS] [TESTNAME] [-- [args]...]" ''

  # Arguments:
  #   [TESTNAME]  If specified, only run tests containing this string in their names
  #   [args]...   Arguments for the test binary

	msg    -- 'OPTIONS:'
  flag   VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET          -q --quiet                        -- "Do not print mush log messages"
  flag   BUILD_RELEASE  -r --release                      -- "Build artifacts in release mode, with optimizations"

  param  BUILD_TARGET   -t --target                       -- "Build for the specific target"
	disp   :usage         -h --help                         -- "Print help information"
}

run_test() {
  eval "$(getoptions parser_definition_test parse "$0")"
  parse "$@"
  eval "set -- $REST"

  MUSH_BUILD_MODE=debug
  MUSH_TARGET_DIR=target/debug
  if [ -n "${BUILD_RELEASE}" ]; then
    MUSH_BUILD_MODE=release
    MUSH_TARGET_DIR=target/release
  fi

  MUSH_DEPS_DIR="${MUSH_TARGET_DIR}/deps"
  mkdir -p "${MUSH_DEPS_DIR}"

  exec_manifest_lookup "${PWD}"

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_dependencies "${MUSH_TARGET_DIR}"

  local package_name="${MUSH_PACKAGE_NAME}"
  local package_version="${MUSH_PACKAGE_VERSION}"
  local pwd=${PWD}

  console_status "Compiling" "${package_name} v${package_version} (${pwd})"

  exec_build_test

  bin_file=target/debug/bin/test/$MUSH_PACKAGE_NAME

  console_status "Compiling" "'${bin_file}'"

  exec "$bin_file" "$@"
}
