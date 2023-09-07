
parser_definition_check() {
	setup   REST help:usage abbr:true -- "Check a local package and all of its dependencies for errors" ''

  msg   -- 'USAGE:' "  ${2##*/} check [OPTIONS]" ''

	msg    -- 'OPTIONS:'
  flag   VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET          -q --quiet                        -- "Do not print cargo log messages"
  flag   BUILD_RELEASE  -r --release                      -- "Build artifacts in release mode, with optimizations"

  param  BUILD_TARGET   -t --target                       -- "Build for the specific target"
	disp   :usage         -h --help                         -- "Print help information"
}

run_check() {
  eval "$(getoptions parser_definition_check parse "$0")"
  parse "$@"
  eval "set -- $REST"

  exec_manifest_lookup

  local package_name="${MUSH_PACKAGE_NAME}"
  local package_version="${MUSH_PACKAGE_VERSION}"
  local pwd=${PWD}

  console_status "Checking" "${package_name} v${package_version} (${pwd})"

  console_status "Finished" "dev [unoptimized + debuginfo] target(s) in 0.00s"
}
