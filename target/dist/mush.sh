#!/usr/bin/env bash
set -e

legacy() {
  legacy=$1
}

module() {
  module=$1
}

public() {
  public=$1
}

use() {
  use=$1
}
# [getoptions] License: Creative Commons Zero v1.0 Universal
# https://github.com/ko1nksm/getoptions (v3.3.0)
getoptions() {
	_error='' _on=1 _no='' _export='' _plus='' _mode='' _alt='' _rest='' _def=''
	_flags='' _nflags='' _opts='' _help='' _abbr='' _cmds='' _init=@empty IFS=' '
	[ $# -lt 2 ] && set -- "${1:?No parser definition}" -
	[ "$2" = - ] && _def=getoptions_parse

	i='					'
	while eval "_${#i}() { echo \"$i\$@\"; }"; [ "$i" ]; do i=${i#?}; done

	quote() {
		q="$2'" r=''
		while [ "$q" ]; do r="$r${q%%\'*}'\''" && q=${q#*\'}; done
		q="'${r%????}'" && q=${q#\'\'} && q=${q%\'\'}
		eval "$1=\${q:-\"''\"}"
	}
	code() {
		[ "${1#:}" = "$1" ] && c=3 || c=4
		eval "[ ! \${$c:+x} ] || $2 \"\$$c\""
	}
	sw() { sw="$sw${sw:+|}$1"; }
	kv() { eval "${2-}${1%%:*}=\${1#*:}"; }
	loop() { [ $# -gt 1 ] && [ "$2" != -- ]; }

	invoke() { eval '"_$@"'; }
	prehook() { invoke "$@"; }
	for i in setup flag param option disp msg; do
		eval "$i() { prehook $i \"\$@\"; }"
	done

	args() {
		on=$_on no=$_no export=$_export init=$_init _hasarg=$1 && shift
		while loop "$@" && shift; do
			case $1 in
				-?) [ "$_hasarg" ] && _opts="$_opts${1#-}" || _flags="$_flags${1#-}" ;;
				+?) _plus=1 _nflags="$_nflags${1#+}" ;;
				[!-+]*) kv "$1"
			esac
		done
	}
	defvar() {
		case $init in
			@none) : ;;
			@export) code "$1" _0 "export $1" ;;
			@empty) code "$1" _0 "${export:+export }$1=''" ;;
			@unset) code "$1" _0 "unset $1 ||:" "unset OPTARG ||:; ${1#:}" ;;
			*)
				case $init in @*) eval "init=\"=\${${init#@}}\""; esac
				case $init in [!=]*) _0 "$init"; return 0; esac
				quote init "${init#=}"
				code "$1" _0 "${export:+export }$1=$init" "OPTARG=$init; ${1#:}"
		esac
	}
	_setup() {
		[ "${1#-}" ] && _rest=$1
		while loop "$@" && shift; do kv "$1" _; done
	}
	_flag() { args '' "$@"; defvar "$@"; }
	_param() { args 1 "$@"; defvar "$@"; }
	_option() { args 1 "$@"; defvar "$@"; }
	_disp() { args '' "$@"; }
	_msg() { args '' _ "$@"; }

	cmd() { _mode=@ _cmds="$_cmds${_cmds:+|}'$1'"; }
	"$@"
	cmd() { :; }
	_0 "${_rest:?}=''"

	_0 "${_def:-$2}() {"
	_1 'OPTIND=$(($#+1))'
	_1 'while OPTARG= && [ $# -gt 0 ]; do'
	[ "$_abbr" ] && getoptions_abbr "$@"

	args() {
		sw='' validate='' pattern='' counter='' on=$_on no=$_no export=$_export
		while loop "$@" && shift; do
			case $1 in
				--\{no-\}*) i=${1#--?no-?}; sw "'--$i'|'--no-$i'" ;;
				--with\{out\}-*) i=${1#--*-}; sw "'--with-$i'|'--without-$i'" ;;
				[-+]? | --*) sw "'$1'" ;;
				*) kv "$1"
			esac
		done
		quote on "$on"
		quote no "$no"
	}
	setup() { :; }
	_flag() {
		args "$@"
		[ "$counter" ] && on=1 no=-1 v="\$((\${$1:-0}+\$OPTARG))" || v=''
		_3 "$sw)"
		_4 '[ "${OPTARG:-}" ] && OPTARG=${OPTARG#*\=} && set "noarg" "$1" && break'
		_4 "eval '[ \${OPTARG+x} ] &&:' && OPTARG=$on || OPTARG=$no"
		valid "$1" "${v:-\$OPTARG}"
		_4 ';;'
	}
	_param() {
		args "$@"
		_3 "$sw)"
		_4 '[ $# -le 1 ] && set "required" "$1" && break'
		_4 'OPTARG=$2'
		valid "$1" '$OPTARG'
		_4 'shift ;;'
	}
	_option() {
		args "$@"
		_3 "$sw)"
		_4 'set -- "$1" "$@"'
		_4 '[ ${OPTARG+x} ] && {'
		_5 'case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac'
		_5 '[ "${OPTARG:-}" ] && { shift; OPTARG=$2; } ||' "OPTARG=$on"
		_4 "} || OPTARG=$no"
		valid "$1" '$OPTARG'
		_4 'shift ;;'
	}
	valid() {
		set -- "$validate" "$pattern" "$1" "$2"
		[ "$1" ] && _4 "$1 || { set -- ${1%% *}:\$? \"\$1\" $1; break; }"
		[ "$2" ] && {
			_4 "case \$OPTARG in $2) ;;"
			_5 '*) set "pattern:'"$2"'" "$1"; break'
			_4 "esac"
		}
		code "$3" _4 "${export:+export }$3=\"$4\"" "${3#:}"
	}
	_disp() {
		args "$@"
		_3 "$sw)"
		code "$1" _4 "echo \"\${$1}\"" "${1#:}"
		_4 'exit 0 ;;'
	}
	_msg() { :; }

	[ "$_alt" ] && _2 'case $1 in -[!-]?*) set -- "-$@"; esac'
	_2 'case $1 in'
	_wa() { _4 "eval 'set -- $1' \${1+'\"\$@\"'}"; }
	_op() {
		_3 "$1) OPTARG=\$1; shift"
		_wa '"${OPTARG%"${OPTARG#??}"}" '"$2"'"${OPTARG#??}"'
		_4 "$3"
	}
	_3 '--?*=*) OPTARG=$1; shift'
	_wa '"${OPTARG%%\=*}" "${OPTARG#*\=}"'
	_4 ';;'
	_3 '--no-*|--without-*) unset OPTARG ;;'
	[ "$_alt" ] || {
		[ "$_opts" ] && _op "-[$_opts]?*" '' ';;'
		[ ! "$_flags" ] || _op "-[$_flags]?*" - 'OPTARG= ;;'
	}
	[ "$_plus" ] && {
		[ "$_nflags" ] && _op "+[$_nflags]?*" + 'unset OPTARG ;;'
		_3 '+*) unset OPTARG ;;'
	}
	_2 'esac'
	_2 'case $1 in'
	"$@"
	rest() {
		_4 'while [ $# -gt 0 ]; do'
		_5 "$_rest=\"\${$_rest}" '\"\${$(($OPTIND-$#))}\""'
		_5 'shift'
		_4 'done'
		_4 'break ;;'
	}
	_3 '--)'
	[ "$_mode" = @ ] || _4 'shift'
	rest
	_3 "[-${_plus:++}]?*)" 'set "unknown" "$1"; break ;;'
	_3 '*)'
	case $_mode in
		@)
			_4 "case \$1 in ${_cmds:-*}) ;;"
			_5 '*) set "notcmd" "$1"; break'
			_4 'esac'
			rest ;;
		+) rest ;;
		*) _4 "$_rest=\"\${$_rest}" '\"\${$(($OPTIND-$#))}\""'
	esac
	_2 'esac'
	_2 'shift'
	_1 'done'
	_1 '[ $# -eq 0 ] && { OPTIND=1; unset OPTARG; return 0; }'
	_1 'case $1 in'
	_2 'unknown) set "Unrecognized option: $2" "$@" ;;'
	_2 'noarg) set "Does not allow an argument: $2" "$@" ;;'
	_2 'required) set "Requires an argument: $2" "$@" ;;'
	_2 'pattern:*) set "Does not match the pattern (${1#*:}): $2" "$@" ;;'
	_2 'notcmd) set "Not a command: $2" "$@" ;;'
	_2 '*) set "Validation error ($1): $2" "$@"'
	_1 'esac'
	[ "$_error" ] && _1 "$_error" '"$@" >&2 || exit $?'
	_1 'echo "$1" >&2'
	_1 'exit 1'
	_0 '}'

	[ "$_help" ] && eval "shift 2; getoptions_help $1 $_help" ${3+'"$@"'}
	[ "$_def" ] && _0 "eval $_def \${1+'\"\$@\"'}; eval set -- \"\${$_rest}\""
	_0 '# Do not execute' # exit 1
}
# [getoptions_abbr] License: Creative Commons Zero v1.0 Universal
# https://github.com/ko1nksm/getoptions (v3.3.0)
getoptions_abbr() {
	abbr() {
		_3 "case '$1' in"
		_4 '"$1") OPTARG=; break ;;'
		_4 '$1*) OPTARG="$OPTARG '"$1"'"'
		_3 'esac'
	}
	args() {
		abbr=1
		shift
		for i; do
			case $i in
				--) break ;;
				[!-+]*) eval "${i%%:*}=\${i#*:}"
			esac
		done
		[ "$abbr" ] || return 0

		for i; do
			case $i in
				--) break ;;
				--\{no-\}*) abbr "--${i#--\{no-\}}"; abbr "--no-${i#--\{no-\}}" ;;
				--*) abbr "$i"
			esac
		done
	}
	setup() { :; }
	for i in flag param option disp; do
		eval "_$i()" '{ args "$@"; }'
	done
	msg() { :; }
	_2 'set -- "${1%%\=*}" "${1#*\=}" "$@"'
	[ "$_alt" ] && _2 'case $1 in -[!-]?*) set -- "-$@"; esac'
	_2 'while [ ${#1} -gt 2 ]; do'
	_3 'case $1 in (*[!a-zA-Z0-9_-]*) break; esac'
	"$@"
	_3 'break'
	_2 'done'
	_2 'case ${OPTARG# } in'
	_3 '*\ *)'
	_4 'eval "set -- $OPTARG $1 $OPTARG"'
	_4 'OPTIND=$((($#+1)/2)) OPTARG=$1; shift'
	_4 'while [ $# -gt "$OPTIND" ]; do OPTARG="$OPTARG, $1"; shift; done'
	_4 'set "Ambiguous option: $1 (could be $OPTARG)" ambiguous "$@"'
	[ "$_error" ] && _4 "$_error" '"$@" >&2 || exit $?'
	_4 'echo "$1" >&2'
	_4 'exit 1 ;;'
	_3 '?*)'
	_4 '[ "$2" = "$3" ] || OPTARG="$OPTARG=$2"'
	_4 "shift 3; eval 'set -- \"\${OPTARG# }\"' \${1+'\"\$@\"'}; OPTARG= ;;"
	_3 '*) shift 2'
	_2 'esac'
}
# [getoptions_help] License: Creative Commons Zero v1.0 Universal
# https://github.com/ko1nksm/getoptions (v3.3.0)
getoptions_help() {
	_width='30,12' _plus='' _leading='  '

	pad() { p=$2; while [ ${#p} -lt "$3" ]; do p="$p "; done; eval "$1=\$p"; }
	kv() { eval "${2-}${1%%:*}=\${1#*:}"; }
	sw() { pad sw "$sw${sw:+, }" "$1"; sw="$sw$2"; }

	args() {
		_type=$1 var=${2%% *} sw='' label='' hidden='' && shift 2
		while [ $# -gt 0 ] && i=$1 && shift && [ "$i" != -- ]; do
			case $i in
				--*) sw $((${_plus:+4}+4)) "$i" ;;
				-?) sw 0 "$i" ;;
				+?) [ ! "$_plus" ] || sw 4 "$i" ;;
				*) [ "$_type" = setup ] && kv "$i" _; kv "$i"
			esac
		done
		[ "$hidden" ] && return 0 || len=${_width%,*}

		[ "$label" ] || case $_type in
			setup | msg) label='' len=0 ;;
			flag | disp) label="$sw " ;;
			param) label="$sw $var " ;;
			option) label="${sw}[=$var] "
		esac
		[ "$_type" = cmd ] && label=${label:-$var } len=${_width#*,}
		pad label "${label:+$_leading}$label" "$len"
		[ ${#label} -le "$len" ] && [ $# -gt 0 ] && label="$label$1" && shift
		echo "$label"
		pad label '' "$len"
		for i; do echo "$label$i"; done
	}

	for i in setup flag param option disp 'msg -' cmd; do
		eval "${i% *}() { args $i \"\$@\"; }"
	done

	echo "$2() {"
	echo "cat<<'GETOPTIONSHERE'"
	"$@"
	echo "GETOPTIONSHERE"
	echo "}"
}

exec_legacy_build() {
  legacy=1
  #echo "Legacy build"
}

parser_definition_build() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_build() {
  eval "$(getoptions parser_definition_build parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_manifest_lookup

  exec_legacy_build

  if [ "$BUILD_TARGET" = "debug" ]; then
    exec_build_debug "$@"
  else
    exec_build_dist "$@"
  fi
}

parser_definition_legacy() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} legacy [options...] [arguments...]"
	msg -- '' 'getoptions subcommand example' ''
	msg -- 'Options:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	disp    :usage       -h --help
}

run_legacy() {
  eval "$(getoptions parser_definition_legacy parse "$0")"
  parse "$@"
  eval "set -- $REST"
  echo "FLAG_C: $FLAG_C"
  echo "MODULE_NAME: $MODULE_NAME"

  echo "GLOBAL: $GLOBAL"
  i=0
  while [ $# -gt 0 ] && i=$((i + 1)); do
    module_name=$(basename $1)
    module_file=target/debug/legacy/$module_name
    echo "$i Downloading '$module_name' from $1"
    curl -sL $1 -o $module_file
    chmod +x $module_file
    shift
  done

  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions -o target/debug/legacy/getoptions
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions -o target/debug/legacy/gengetoptions
}

legacy lib_getoptions

module commands
module console
module tasks

#use assets::server::test0

VERSION="Mush 0.1.0 (2022-11-15)"

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


public add
public build
public init
public install
public legacy
public new
public run

test0 () {
  echo "TEST"
}
parser_definition_build() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_build() {
  eval "$(getoptions parser_definition_build parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_manifest_lookup

  exec_legacy_build

  if [ "$BUILD_TARGET" = "debug" ]; then
    exec_build_debug "$@"
  else
    exec_build_dist "$@"
  fi
}

parser_definition_init() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_init() {
  eval "$(getoptions parser_definition_init parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  if [ -e "Manifest.toml" ]; then
    console_error "'cargo init' cannot be run on existing Mush packages"
    exit 101
  fi

  exec_init
}

parser_definition_install() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_install() {
  eval "$(getoptions parser_definition_install parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_legacy_build
  exec_build_dist "$@"
  exec_install
}

parser_definition_legacy() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} legacy [options...] [arguments...]"
	msg -- '' 'getoptions subcommand example' ''
	msg -- 'Options:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	disp    :usage       -h --help
}

run_legacy() {
  eval "$(getoptions parser_definition_legacy parse "$0")"
  parse "$@"
  eval "set -- $REST"
  echo "FLAG_C: $FLAG_C"
  echo "MODULE_NAME: $MODULE_NAME"

  echo "GLOBAL: $GLOBAL"
  i=0
  while [ $# -gt 0 ] && i=$((i + 1)); do
    module_name=$(basename $1)
    module_file=target/debug/legacy/$module_name
    echo "$i Downloading '$module_name' from $1"
    curl -sL $1 -o $module_file
    chmod +x $module_file
    shift
  done

  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions -o target/debug/legacy/getoptions
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions -o target/debug/legacy/gengetoptions
}

parser_definition_new() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_new() {
  eval "$(getoptions parser_definition_new parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  if [ -e "$1" ]; then
    console_error "Destination '$1' already exists"
    exit 101
  fi

  mkdir -p "$1"

  cd "$1"

  exec_init
}

parser_definition_run() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_run() {
  eval "$(getoptions parser_definition_run parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_manifest_lookup

  exec_legacy_build

  exec_build_debug "$@"
}

# FATAL
# ERROR
# WARNING
# INFO
# DEBUG
# TRACE

case "$(uname -s)" in
  Darwin*)
    ESCAPE='\x1B'
    ;;
  Linux|*)
    ESCAPE='\e'
    ;;
esac

CONSOLE_INDENT="${ESCAPE}[1;33m{Mush}${ESCAPE}[0m"

console_log() {
  console_echo "$1"
}

console_info() {
  console_echo "$1"
}

console_error() {
  console_echo "${ESCAPE}[1;31m$1${ESCAPE}[0m"
}

console_done() {
  console_echo "${ESCAPE}[1;32m$1${ESCAPE}[0m"
}

console_echo() {
  echo -e "${CONSOLE_INDENT} $1"
  CONSOLE_INDENT='      '
}

public build_dist
public init
public install
public manifest_lookup

exec_build_dist() {



  local bin_file=bin/mush

  local build_file=target/dist/mush.tmp
  local final_file=target/dist/mush

  echo "#!/usr/bin/env bash" > $build_file
  #echo "## " >> $build_file
  echo "set -e" >> $build_file
  cat src/boot/dist_2022.sh >> $build_file
  cat target/debug/legacy/getoptions.sh >> $build_file
  cat src/tasks/legacy_build.sh >> $build_file
  #cat src/tasks/build_dist.sh >> $build_file
  cat src/commands/build.sh >> $build_file
  cat src/commands/legacy.sh >> $build_file

  build_dist_parse "src/main.sh" "${build_file}"

  echo "main \"\$@\"" >> $build_file

  mkdir -p bin/

  cp ${build_file} ${final_file}
  cp ${final_file} ${bin_file}

  #echo -e "\e[1;33m{Mush}\e[0m Start"
  #echo -e "       Task completed"
  #echo -e "       Search profile"
  #echo -e "       \e[1;31mError qui cavallo\e[0m"
  #echo -e "       Search profile n2"
  #echo -e "       \e[1;33mFinish.\e[0m"

  chmod +x ${bin_file}

  console_done "Build complete."
}

build_dist_parse() {
  local src_file=$1
  local build_file=$2

  cat "${src_file}" >> "${build_file}"

  build_dist_parse_public "${src_file}" "${build_file}"

  build_dist_parse_module "${src_file}" "${build_file}"

  return 0
}

build_dist_parse_public() {
  local src_file=$1
  local build_file=$2
  local public_dir=$(dirname $src_file)

  grep -n '^public [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local public_name=$(echo "${line#*public}" | xargs)
    local public_file="${public_dir}/${public_name}.sh"
    local public_dir_file="${public_dir}/${public_name}/module.sh"
    if [ -e "${public_file}" ]; then
      console_log "Public '${public_file}' as module file"
      build_dist_parse "${public_file}" "${build_file}"
    elif [ -e "${public_dir_file}" ]; then
      console_log "Public '${public_dir_file}' as directory module file"
      build_dist_parse "${public_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${public_name}'. Look at '${src_file}' on line ${line%:*}"
      console_info  "To create the module '${public_name}', create file '${public_file}' or '${public_dir_file}'."
      exit 0
    fi
  done

  return 0
}

build_dist_parse_module() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname $src_file)

  grep -n '^module [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local module_name=$(echo "${line#*module}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"
    if [ -e "${module_file}" ]; then
      console_log "Import '${module_file}' as module file"
      build_dist_parse "${module_file}" "${build_file}"
    elif [ -e "${module_dir_file}" ]; then
      console_log "Import '${module_dir_file}' as directory module file"
      build_dist_parse "${module_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_info  "To create the module '${module_name}', create file '${module_file}' or '${module_dir_file}'."
      exit 0
    fi
  done

  return 0
}

exec_init() {
  local package_name=$(basename "$PWD")
  local manifest_file=Manifest.toml
  local main_file=src/main.sh
  local lib_file=src/lib.sh

  mkdir -p src

  echo "[package]" > ${manifest_file}
  echo "name = \"${package_name}\"" >> ${manifest_file}
  echo "version = \"0.1.0\"" >> ${manifest_file}
  echo "edition = \"2022\"" >> ${manifest_file}
  echo "" >> ${manifest_file}
  echo "# See more keys and their definitions at https://mush.javanile.org/manifest.html" >> ${manifest_file}
  echo "" >> ${manifest_file}
  echo "[dependencies]" >> ${manifest_file}

  if [ ! -f "${main_file}" ]; then
    echo "" > ${main_file}
    echo "main() {" >> ${main_file}
    echo "  echo \"Hello World!\"" >> ${main_file}
    echo "}" >> ${main_file}
  fi
}

exec_install() {
  local bin_file=/usr/local/bin/mush
  local final_file=target/dist/mush

  local cp=cp
  local chmod=chmod
  if [[ $EUID -ne 0 ]]; then
      cp="sudo ${cp}"
      chmod="sudo ${chmod}"
  fi

  ${cp} ${final_file} ${bin_file}
  ${chmod} +x ${bin_file}

  echo "Finished release [optimized] target(s) in 0.18s"
  echo "Installing /home/francesco/.cargo/bin/cask"
  echo "Installed package 'cask-cli v0.1.0 (/home/francesco/Develop/Javanile/rust-cask)' (executable 'cask')"
}


exec_manifest_lookup() {
  pwd=$PWD
  if [ ! -f "Manifest.toml" ]; then
    console_error "Could not find 'Manifest.toml' in '$pwd' or any parent directory."
    exit 101
  fi
}
main "$@"
