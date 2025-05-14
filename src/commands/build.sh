
parser_definition_build() {
  setup REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS]" ''

  msg   -- 'OPTIONS:'
  flag  VERBOSE        -v --verbose "counter:true" "init:=${VERBOSE}" -- "Use verbose output (-vv or -vvv to increase level)"

  flag  QUIET          -q --quiet       -- "Do not print mush log messages"
  flag  BUILD_RELEASE  -r --release     -- "Build artifacts in release mode, with optimizations"
  flag  NO_CACHE          --no-cache    -- "Disables the registry cache when build the package"

  param BUILD_TARGET   -t --target      -- "Build for the specific target"
  disp  :usage         -h --help        -- "Print help information"
}

run_build() {
  eval "$(getoptions parser_definition_build parse "$0")"
  parse "$@"
  eval "set -- $REST"

  exec_manifest_lookup "${PWD}"

  mush_feature_hook "build"

  [ "$VERBOSE" -gt "3" ] && echo "Profile init..."
  mush_build_profile_init "${BUILD_RELEASE}"

  [ "$VERBOSE" -gt "3" ] && echo "Profile init..."
  mush_build_script_run "${PWD}"

  [ "$VERBOSE" -gt "3" ] && echo "Legacy fetch..."
  exec_legacy_fetch "${MUSH_TARGET_PATH}"

  [ "$VERBOSE" -gt "3" ] && echo "Legacy build..."
  exec_legacy_build "${MUSH_TARGET_PATH}"

  [ "$VERBOSE" -gt "3" ] && echo "Dependencies..."
  update_strategy=lazy
  exec_dependencies "${MUSH_TARGET_PATH}" "${update_strategy}"

  local package_name="${MUSH_PACKAGE_NAME}"
  local package_version="${MUSH_PACKAGE_VERSION}"
  local pwd=${PWD}

  local src_file=src/main.sh
  local bin_file=${MUSH_TARGET_PATH}/${package_name}
  local out_file=${MUSH_TARGET_PATH}/lib.sh
  local lib_file=src/lib.sh

  console_status "Compiling" "${package_name} v${package_version} (${pwd})"

  if [ -n "${BUILD_RELEASE}" ]; then
    exec_build_release "${MUSH_TARGET_PATH}"
  else
    if [ "$BUILD_TARGET" = "release" ]; then
      exec_build_release "${MUSH_TARGET_PATH}"
    else
      if [ -f "${lib_file}" ]; then
        [ "$VERBOSE" -gt "3" ] && echo "Building lib: ${lib_file}"
        exec_build_lib_debug "${lib_file}" "${out_file}"
      else
        local lib_file=
      fi
      if [ -f "${src_file}" ]; then
        exec_build_bin_debug "src/main.sh" "${bin_file}" "${lib_file}"
      fi
    fi
  fi

  #printenv | grep MUSH_ > "${MUSH_TARGET_PATH}/.vars"

  console_status "Finished" "dev [unoptimized + debuginfo] target(s) in 0.00s"
}
