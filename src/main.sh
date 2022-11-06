
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
  cmd legacy-download -- "subcommand 3"
}

parser_definition_legacy_download() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} legacy-download [options...] [arguments...]"
	msg -- '' 'getoptions subcommand example' ''
	msg -- 'Options:'
	flag    FLAG_C  -c --flag-c
	disp    :usage  -h --help
}

main() {
  echo "ARGS: $@"


  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions -o target/debug/legacy/getoptions
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions -o target/debug/legacy/gengetoptions
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
      legacy-download)
        eval "$(getoptions parser_definition_legacy_download parse "$0")"
        parse "$@"
        eval "set -- $REST"
        echo "FLAG_C: $FLAG_C"
        ;;
      --) # no subcommand, arguments only
    esac
  fi

  echo "GLOBAL: $GLOBAL"
  i=0
  while [ $# -gt 0 ] && i=$((i + 1)); do
    echo "$i: $1"
    shift
  done
}

