
extern package console

module api
module build
module errors
module commands
module package_managers
module registry
module tasks

legacy getoptions

VERSION="Mush 0.1.1 (2023-10-24)"

parser_definition() {
  setup REST error:args_error help:usage abbr:true -- "Shell's build system" ''

  msg   -- 'USAGE:' "  ${2##*/} [OPTIONS] [SUBCOMMAND]" ''

  msg   -- 'OPTIONS:'
  disp  VERSION -V --version                      -- "Print version info and exit"
  param PRINT      --print                        -- "Builder information to print on stdout"
  param EXPLAIN    --explain                      -- "Provide a detailed explanation of an error message"
  flag  VERBOSE -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag  QUIET   -q --quiet                        -- "Do not print cargo log messages"
  disp  :usage  -h --help                         -- "Print help information"

  msg           -- '' "See '${2##*/} <command> --help' for more information on a specific command."
  cmd   build   -- "Compile the current package"
  cmd   check   -- "Analyze the current package and report errors, but don't build it"
  cmd   fetch   -- "Fetch dependencies of a package from the network"
  cmd   init    -- "Create a new package in an existing directory"
  cmd   install -- "Build and install a Mush binary"
  cmd   legacy  -- "Add legacy dependencies to a Manifest.toml file"
  cmd   new     -- "Create a new Mush package"
  cmd   run     -- "Run a binary or example of the local package"
  cmd   test    -- "Run the tests"
  cmd   publish -- "Package and upload this package to the registry"
}

args_error() {
  case "$2" in
    notcmd)
      console_error "no such command: '$3'\n\n\tView all available commands with 'mush --help'"
      ;;
    required)
      console_error "argument to option '$3' missing."
      ;;
    *)
      echo "ERROR: ($2 $3) $1"
  esac
  exit 101
}

main() {
  if [ $# -eq 0 ]; then
    eval "set -- --help"
  fi

  eval "$(getoptions parser_definition parse "$0") exit 1"
  parse "$@"
  eval "set -- $REST"

  if [ -n "${PRINT}" ]; then
    mush_build_print "${PRINT}"
  elif [ -n "${EXPLAIN}" ]; then
    mush_errors_explain "${EXPLAIN}"
  elif [ $# -gt 0 ]; then
    cmd=$1
    shift
    case $cmd in
      build)
        run_build "$@"
        ;;
      check)
        run_check "$@"
        ;;
      fetch)
        run_fetch "$@"
        ;;
      init)
        run_init "$@"
        ;;
      install)
        run_install "$@"
        ;;
      legacy)
        run_legacy "$@"
        ;;
      new)
        run_new "$@"
        ;;
      run)
        run_run "$@"
        ;;
      test)
        run_test "$@"
        ;;
      publish)
        run_publish "$@"
        ;;
      --) # no subcommand, arguments only
    esac
  fi
}
