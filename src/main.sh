
legacy lib_getoptions

module api
module commands
module console
module tasks

#use assets::server::test0

VERSION="Mush 0.1.0 (2022-11-17)"

parser_definition() {
  setup REST help:usage abbr:true -- "Shell's build system" ''

  msg   -- 'USAGE:' "  ${2##*/} [OPTIONS] [SUBCOMMAND]" ''

  msg   -- 'OPTIONS:'
  disp  :usage  -h --help                         -- "Print help information"
  disp  VERSION -V --version                      -- "Print version info and exit"
  flag  VERBOSE -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"

  msg   -- '' "See '${2##*/} <command> --help' for more information on a specific command."
  cmd   build -- "Compile the current package"
  cmd   init -- "Create a new package in an existing directory"
  cmd   install -- "Build and install a Mush binary"
  cmd   legacy -- "Add legacy dependencies to a Manifest.toml file"
  cmd   new -- "Create a new Mush package"
}

main() {
  #echo "ARGS: $@"
  #chmod +x target/debug/legacy/getoptions
  #bash target/debug/legacy/gengetoptions library > target/debug/legacy/getoptions.sh

  if [ $# -eq 0 ]; then
    eval "set -- --help"
  fi

  eval "$(getoptions parser_definition parse "$0") exit 1"
  parse "$@"
  eval "set -- $REST"

  #echo "V $VERBOSE"


  if [ $# -gt 0 ]; then
    cmd=$1
    shift
    case $cmd in
      build)
        run_build "$@"
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
      --) # no subcommand, arguments only
    esac
  fi
}

