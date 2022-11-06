
legacy getoptions

#mod assets

#use assets::server::test0

parser_definition() {
  setup   REST help:usage abbr:true -- \
  		"Usage: ${2##*/} [global options...] [command] [options...] [arguments...]"
  msg -- '' 'getoptions subcommand example' ''
  msg -- 'Options:'
  flag    GLOBAL  -g --global    -- "global flag"
  disp    :usage  -h --help
  disp    VERSION    --version

  msg -- '' 'Commands:'
  cmd cmd1 -- "subcommand 1"
  cmd cmd2 -- "subcommand 2"
  cmd build-debug -- "subcommand 3"
  cmd legacy-fetch -- "subcommand 3"
}

main() {
  echo "ARGS: $@"


  #chmod +x target/debug/legacy/getoptions
  #bash target/debug/legacy/gengetoptions library > target/debug/legacy/getoptions.sh

  eval "$(getoptions parser_definition parse "$0") exit 1"
  parse "$@"
  eval "set -- $REST"

  if [ $# -gt 0 ]; then
    cmd=$1
    shift
    case $cmd in
      cmd1)
        eval "$(getoptions parser_definition_cmd1 parse "$0")"
        parse "$@"
        eval "set -- $REST"
        echo "FLAG_A: $FLAG_A"
        ;;
      cmd2)
        eval "$(getoptions parser_definition_cmd2 parse "$0")"
        parse "$@"
        eval "set -- $REST"
        echo "FLAG_B: $FLAG_B"
        ;;
      build-debug)
        run_build_debug "$@"
        ;;
      legacy-fetch)
        run_legacy_fetch "$@"
        ;;
      --) # no subcommand, arguments only
    esac
  fi
}

