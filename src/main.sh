
legacy getoptions

mod assets

#use assets::server::test0

parser_definition() {
  setup REST help:usage abbr:true -- "Shell's build system" ''

  msg   -- 'USAGE:' "  ${2##*/} [OPTIONS] [SUBCOMMAND]" ''

  msg   -- 'OPTIONS:'
  flag  GLOBAL  -g --global  -- "Global flag"
  disp  :usage  -h --help    -- "Print help information"
  disp  VERSION -V --version -- "Print version info and exit"

  msg   -- '' "See '${2##*/} <command> --help' for more information on a specific command."
  cmd   build -- "Compile the current package"
  cmd   legacy -- "Add legacy dependencies to a Manifest.toml file"
}

main() {
  #echo "ARGS: $@"
  #chmod +x target/debug/legacy/getoptions
  #bash target/debug/legacy/gengetoptions library > target/debug/legacy/getoptions.sh

  eval "$(getoptions parser_definition parse "$0") exit 1"
  parse "$@"
  eval "set -- $REST"

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

