
legacy lib_getoptions

module commands
module console
module tasks

#use assets::server::test0

VERSION="Mush 0.1.0 (2022-11-11)"

parser_definition() {
  setup REST help:usage abbr:true -- "Shell's build system" ''

  msg   -- 'USAGE:' "  ${2##*/} [OPTIONS] [SUBCOMMAND]" ''

  msg   -- 'OPTIONS:'
  flag  GLOBAL  -g --global                       -- "Global flag"
  disp  :usage  -h --help                         -- "Print help information"
  disp  VERSION -V --version                      -- "Print version info and exit"
  flag  VERBOSE -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"

  msg   -- '' "See '${2##*/} <command> --help' for more information on a specific command."
  cmd   build -- "Compile the current package"
  cmd   legacy -- "Add legacy dependencies to a Manifest.toml file"
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
      legacy)
        run_legacy "$@"
        ;;
      --) # no subcommand, arguments only
    esac
  fi
}

