
parser_definition_build() {
  setup REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS]" ''

  msg   -- 'OPTIONS:'
  flag  VERBOSE        -v --verbose "counter:true" "init:=${VERBOSE}" -- "Use verbose output (-vv or -vvv to increase level)"

  flag  QUIET          -q --quiet       -- "Do not print mush log messages"
  param EXAMPLE_NAME      --example     -- "Name of example to build"
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

  [ "$VERBOSE" -gt "3" ] && console_status "Profile" "initializing build profile"
  mush_build_profile_init "${BUILD_RELEASE}"

  [ "$VERBOSE" -gt "3" ] && console_status "Script" "running build script"
  mush_build_script_run "${PWD}"

  [ "$VERBOSE" -gt "3" ] && console_status "Legacy" "fetching legacy dependencies"
  exec_legacy_fetch "${MUSH_TARGET_PATH}"

  [ "$VERBOSE" -gt "3" ] && console_status "Legacy" "building legacy dependencies"
  exec_legacy_build "${MUSH_TARGET_PATH}"

  [ "$VERBOSE" -gt "3" ] && console_status "Resolving" "package dependencies"
  update_strategy=lazy
  MUSH_DEPS_DIR="${MUSH_TARGET_PATH}/packages"
  exec_dependencies "${MUSH_TARGET_PATH}" "${update_strategy}"

  local package_name="${MUSH_PACKAGE_NAME}"
  local package_version="${MUSH_PACKAGE_VERSION}"
  local pwd=${PWD}

  local out_file=${MUSH_TARGET_PATH}/lib.sh
  local lib_file=src/lib.sh

  console_status "Compiling" "${package_name} v${package_version} (${pwd})"

  if [ -n "${BUILD_RELEASE}" ] || [ "$BUILD_TARGET" = "release" ]; then
    exec_build_release "${MUSH_TARGET_PATH}"
  else
    if [ -f "${lib_file}" ]; then
      [ "$VERBOSE" -gt "3" ] && echo "Building lib: ${lib_file}" >&2
      exec_build_lib_debug "${lib_file}" "${out_file}"
    else
      lib_file=
    fi

    if [ -n "${EXAMPLE_NAME}" ]; then
      # Build single example
      local src_file=examples/$EXAMPLE_NAME.sh
      local bin_file=target/debug/examples/$EXAMPLE_NAME

      if [ ! -f "${src_file}" ]; then
        console_error "no example target named '${EXAMPLE_NAME}'."
        echo ""
        local examples=$(find examples/ -type f -name '*.sh' -exec basename {} .sh \; 2>/dev/null | sed 's/^/    /')
        [ -n "${examples}" ] && echo -e "Available example targets:\n${examples}\n"
        exit 101
      fi

      exec_build_bin_debug "${src_file}" "${bin_file}" "${lib_file}"
      compile_file "${src_file}"
    else
      # Build all binaries
      local binaries
      binaries=$(manifest_get_binaries)

      echo "${binaries}" | while IFS= read -r bin_entry; do
        [ -z "${bin_entry}" ] && continue
        manifest_parse_bin_entry "${bin_entry}"
        [ -z "${BIN_NAME}" ] && continue
        local bin_file="${MUSH_TARGET_PATH}/${BIN_NAME}"
        exec_build_bin_debug "${BIN_PATH}" "${bin_file}" "${lib_file}"
      done
    fi
  fi

  #printenv | grep MUSH_ > "${MUSH_TARGET_PATH}/.vars"

  console_status "Finished" "dev [unoptimized + debuginfo] target(s) in 0.00s"
}
