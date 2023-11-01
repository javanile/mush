
parser_definition_build() {
  setup REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS]" ''

  msg   -- 'OPTIONS:'
  flag  VERBOSE        -v --verbose "counter:true" "init:=${VERBOSE}" -- "Use verbose output (-vv or -vvv to increase level)"

  flag  QUIET          -q --quiet       -- "Do not print mush log messages"
  flag  BUILD_RELEASE  -r --release     -- "Build artifacts in release mode, with optimizations"

  param BUILD_TARGET   -t --target      -- "Build for the specific target"
  disp  :usage         -h --help        -- "Print help information"
}

run_build() {
  eval "$(getoptions parser_definition_build parse "$0")"
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

  exec_feature_hook "build"

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_dependencies "${MUSH_TARGET_DIR}"

  local package_name="${MUSH_PACKAGE_NAME}"
  local package_version="${MUSH_PACKAGE_VERSION}"
  local pwd=${PWD}

  local src_file=src/main.sh
  local bin_file=${MUSH_TARGET_DIR}/${package_name}
  local lib_file=src/lib.sh

  console_status "Compiling" "${package_name} v${package_version} (${pwd})"

  if [ -n "${BUILD_RELEASE}" ]; then
    exec_build_release "$@"
  else
    if [ "$BUILD_TARGET" = "dist" ]; then
      exec_build_release "$@"
    else
      if [ -f "${lib_file}" ]; then
        compile_file "${lib_file}"
      else
        local lib_file=
      fi
      if [ -f "${src_file}" ]; then
        exec_build_debug "src/main.sh" "${bin_file}" "${lib_file}"
      fi
    fi
  fi

  #printenv | grep MUSH_ > "${MUSH_TARGET_DIR}/.vars"

  console_status "Finished" "dev [unoptimized + debuginfo] target(s) in 0.00s"
}
