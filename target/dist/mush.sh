#!/usr/bin/env bash
set -e

extern() {
  extern=$1
}

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

embed() {
  embed=$1
}


extern package console
extern package json

module api
module commands
module package_managers
module registry
module tasks

legacy getoptions

VERSION="Mush 0.1.0 (2022-11-29)"

parser_definition() {
  setup REST help:usage abbr:true -- "Shell's build system" ''

  msg   -- 'USAGE:' "  ${2##*/} [OPTIONS] [SUBCOMMAND]" ''

  msg   -- 'OPTIONS:'
  disp  VERSION -V --version                      -- "Print version info and exit"
  flag  VERBOSE -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag  QUIET   -q --quiet                        -- "Do not print cargo log messages"
  disp  :usage  -h --help                         -- "Print help information"

  msg   -- '' "See '${2##*/} <command> --help' for more information on a specific command."
  cmd   build -- "Compile the current package"
  cmd   init -- "Create a new package in an existing directory"
  cmd   install -- "Build and install a Mush binary"
  cmd   legacy -- "Add legacy dependencies to a Manifest.toml file"
  cmd   new -- "Create a new Mush package"
  cmd   run -- "Run a binary or example of the local package"
  cmd   publish -- "Package and upload this package to the registry"
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
      run)
        run_run "$@"
        ;;
      publish)
        run_publish "$@"
        ;;
      --) # no subcommand, arguments only
    esac
  fi
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

public embed

embed debug_2022
embed dist_2022

embed_file() {
  local module_name=$1
  local module_file=$2

  echo "$module_name() {"
  echo "  cat <<'EOF'"
  cat "$module_file"
  echo ""
  echo "EOF"
  echo "}"
}
debug_2022() {
  cat <<'EOF'

debug_file() {
  local previous_debug_file=$MUSH_DEBUG_FILE
  MUSH_DEBUG_FILE=$1
  source "$1"
  MUSH_DEBUG_FILE=$previous_debug_file
}

extern() {
  local debug_file=$MUSH_DEBUG_FILE

  if [ "$1" = "package" ]; then
    local package_name=$MUSH_PACKAGE_NAME
    local extern_package_name=$2
    local extern_package_path="${MUSH_TARGET_PATH}/packages/${extern_package_name}"
    local extern_package_lib_file="${MUSH_TARGET_PATH}/packages/${extern_package_name}/src/lib.sh"

    if [ -d "${extern_package_path}" ]; then
      debug_file "${extern_package_lib_file}"
    else
      echo "   Compiling rust-app v0.1.0 (/home/francesco/Develop/Javanile/mush/tests/fixtures/rust-app)"
      echo "error[E0463]: can't find package for '${extern_package_name}'"
      echo " --> ${debug_file}:8:1"
      echo "  |"
      echo "8 | extern crate cavallo;"
      echo "  | ^^^^^^^^^^^^^^^^^^^^^ can't find crate"
      echo ""
      echo "For more information about this error, try 'mush explain E0463'."
      echo "error: could not compile '${package_name}' due to previous error"
      exit 1
    fi
  else
    echo "   Compiling rust-app v0.1.0 (/home/francesco/Develop/Javanile/mush/tests/fixtures/rust-app)"
    echo "error: expected one of 'package' or '{', found '$1'"
    echo " --> ${debug_file}:8:8"
    echo "  |"
    echo "8 | extern cavallo json;"
    echo "  |        ^^^^^^^ expected one of 'package' or '{'"
    echo ""
    echo "error: could not compile '${package_name}' due to previous error"
    exit 1
  fi
}

legacy() {
  local legacy_file="target/debug/legacy/$1.sh"
  local legacy_file_path="${MUSH_DEBUG_PATH}/${legacy_file}"

  if [ ! -f "$legacy_file_path" ]; then
    echo "File not found '${legacy_file}', type 'mush build' to recover this problem." >&2
    exit 101
  fi

  source "${legacy_file_path}"
}

module() {
  local module_name=$1
  local module_file="src/$1.sh"
  local module_file_path="${MUSH_DEBUG_PATH}/${module_file}"
  local module_dir_file="src/$1/module.sh"
  local module_dir_file_path="${MUSH_DEBUG_PATH}/${module_dir_file}"
  local debug_file=$MUSH_DEBUG_FILE
  local package_name=$MUSH_PACKAGE_NAME

  if [ -f "${module_file_path}" ]; then
    source "${module_file_path}"
  elif [ -f "${module_dir_file_path}" ]; then
    MUSH_RUNTIME_MODULE=$1
    source "${module_dir_file_path}"
  else
    echo "   Compiling rust-app v0.1.0 (/home/francesco/Develop/Javanile/mush/tests/fixtures/rust-app)"
    echo "error[E0583]: file not found for module '${module_name}'"
    echo " --> ${debug_file}:4:1"
    echo "  |"
    echo "4 | mod notfound;"
    echo "  | ^^^^^^^^^^^^^"
    echo "  |"
    echo "  = help: to create the module '${module_name}', create file 'src/${module_name}.sh' or 'src/${module_name}/module.sh'"
    echo ""
    echo "For more information about this error, try 'mush explain E0583'."
    echo "error: could not compile '${package_name}' due to previous error"
    exit 1
  fi
}

public() {
  local module_file="src/$MUSH_RUNTIME_MODULE/$1.sh"
  local module_file_path="${MUSH_DEBUG_PATH}/${module_file}"
  local module_dir_file="src/$MUSH_RUNTIME_MODULE/$1/module.sh"
  local module_dir_file_path="${MUSH_DEBUG_PATH}/${module_dir_file}"

  if [ -f "${module_file_path}" ]; then
    source "${module_file_path}"
  elif [ -f "${module_dir_file_path}" ]; then
    source "${module_dir_file_path}"
  fi
}

use() {
  source src/assets/server.sh
}

embed() {
  local module_file="src/${MUSH_RUNTIME_MODULE}/$1.sh"
  local module_file_path="${MUSH_DEBUG_PATH}/${module_file}"

  eval "$(embed_file "$1" "${module_file_path}")"
}

EOF
}
dist_2022() {
  cat <<'EOF'

extern() {
  extern=$1
}

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

embed() {
  embed=$1
}

EOF
}

public add
public build
public init
public install
public legacy
public new
public run
public publish

test0 () {
  echo "TEST"
}
parser_definition_build() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS]" ''

	msg    -- 'OPTIONS:'
  flag   VERBOSE      -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET        -q --quiet                        -- "Do not print cargo log messages"
  param  BUILD_TARGET -t --target                       -- "Build for the specific target"
	disp   :usage       -h --help                         -- "Print help information"
}

run_build() {
  eval "$(getoptions parser_definition_build parse "$0")"
  parse "$@"
  eval "set -- $REST"

  MUSH_TARGET_DIR=target/${BUILD_TARGET:-debug}
  MUSH_DEPS_DIR="${MUSH_TARGET_DIR}/deps"
  mkdir -p "${MUSH_DEPS_DIR}"

  exec_manifest_lookup

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_dependencies "${MUSH_TARGET_DIR}"

  local package_name="${MUSH_PACKAGE_NAME}"
  local package_version="${MUSH_PACKAGE_VERSION}"
  local pwd=${PWD}

  console_status "Compiling" "${package_name} v${package_version} (${pwd})"

  if [ "$BUILD_TARGET" = "dist" ]; then
    exec_build_dist "$@"
  else
    exec_build_debug "$@"
  fi

  console_status "Finished" "dev [unoptimized + debuginfo] target(s) in 0.00s"
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

  exec_manifest_lookup

  MUSH_TARGET_DIR=target/dist

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

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
	setup   REST help:usage abbr:true -- "Run a binary or example of the local package" ''

  msg   -- 'USAGE:' "  ${2##*/} run [OPTIONS] [--] [args]..." ''

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

  MUSH_TARGET_DIR=target/debug

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_build_debug "$@"

  bin_file=target/debug/$MUSH_PACKAGE_NAME

  console_status "Compiling" "'${bin_file}'"

  compile_file "src/main.sh"

  console_status "Running" "'${bin_file}'"

  exec "$bin_file"
}

parser_definition_publish() {
	setup   REST help:usage abbr:true -- "Package and upload this package to the registry" ''

  msg     -- 'USAGE:' "  ${2##*/} publish [OPTIONS]" ''

	msg     -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_publish() {
  eval "$(getoptions parser_definition_publish parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  MUSH_TARGET_DIR=target/dist

  exec_manifest_lookup

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_build_dist "$@"

  exec_publish
}

public apt
public basher
public bpkg
public pip
public git

git_dependency() {
  local pwd=$PWD
  local package_dir=$1
  local package_url=$2
  local package_tag=$3

  cd "${MUSH_DEPS_DIR}" || exit 101

  git clone --depth 1 --branch "$3" "$2" "${package_dir}" > /dev/null 2>&1

  cd "${pwd}" || exit 101
}

public github

github_get_repository() {
  local repository_url=$(git config --get remote.origin.url)

  case "${repository_url}" in
    http*)
      echo "${repository_url}" | sed 's#.*github\.com/##g' | sed 's/\.git$//g'
      ;;
    git*)
      echo "${repository_url}" | cut -d: -f2 | sed 's/\.git$//g'
      ;;
  esac
}

github_create_release() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_tag="$1"

  curl \
     -s -X POST \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     https://api.github.com/repos/${repository}/releases \
     -d "{\"tag_name\":\"${release_tag}\",\"target_commitish\":\"main\",\"name\":\"${release_tag}\",\"body\":\"Description of the release\",\"draft\":false,\"prerelease\":false,\"generate_release_notes\":false}" \
     | grep '"id"' | head -1 | sed 's/[^0-9]*//g'
}

github_upload_release_asset() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_id="$1"
  local asset_name=mush
  local asset_file=target/dist/mush

  curl \
    -s -X POST \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Content-Type: application/octet-stream" \
    https://uploads.github.com/repos/${repository}/releases/$release_id/assets?name=${asset_name} \
    --data-binary @"$asset_file" | sed 's/.*"browser_download_url"//g' | cut -d'"' -f2
}

github_delete_release_asset() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local asset_id="$1"

  curl \
    -s -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/repos/${repository}/releases/assets/${asset_id}
}

github_get_release_asset_id() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_id="$1"
  local asset_name=mush

  curl \
    -s -X GET \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    https://api.github.com/repos/${repository}/releases/${release_id}/assets \
    | grep '^    "id"\|"name"' | paste - - | grep "\"${asset_name}\"" | cut -d, -f1 | cut -d: -f2 | xargs
}

github_get_release_id() {
  local repository="${MUSH_GITHUB_REPOSITORY}"
  local release_tag="$1"

  curl \
    -s -X GET \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "https://api.github.com/repos/${repository}/releases/tags/${release_tag}" \
    | grep '"id"' | head -1 | sed 's/[^0-9]*//g'
}

public build_debug
public build_dist
public init
public install
public legacy_fetch
public legacy_build
public manifest_lookup
public compile
public publish
public dependencies

exec_build_debug() {
  local name=$MUSH_PACKAGE_NAME

  local build_file=target/debug/${name}.tmp
  local final_file=target/debug/${name}

  mkdir -p target/debug/

  compile_file "src/main.sh"

  echo "#!/usr/bin/env bash" > "${build_file}"
  echo "set -e" >> "${build_file}"

  echo "## BP002: Package and debug variables " >> "${build_file}"
  MUSH_DEBUG_PATH=${PWD}
  echo "MUSH_PACKAGE_NAME=${name}" >> "${build_file}"
  echo "MUSH_TARGET_PATH=${PWD}/target/debug/" >> "${build_file}"
  echo "MUSH_DEBUG_PATH=${MUSH_DEBUG_PATH}" >> "${build_file}"

  echo "## BP003: Embedding debug api" >> "${build_file}"
  debug_2022 >> "${build_file}"

  echo "## BP001: Appending entrypoint to debug build" >> "${build_file}"
  echo "debug_file ${MUSH_DEBUG_PATH}/src/main.sh" >> "${build_file}"
  echo "main \"\$@\"" >> "${build_file}"

  mv "${build_file}" "${final_file}"

  chmod +x "${final_file}"
}

exec_build_dist() {
  name=$MUSH_PACKAGE_NAME

  #echo "NAME: $name"

  local bin_file=bin/${name}

  local build_file=target/dist/${name}.tmp
  local final_file=target/dist/${name}

  mkdir -p target/dist/

  echo "#!/usr/bin/env bash" > $build_file
  echo "set -e" >> $build_file

  dist_2022 >> $build_file

  compile_file "src/main.sh" "${build_file}"

  echo "main \"\$@\"" >> $build_file

  mkdir -p bin/

  cp ${build_file} ${final_file}
  cp ${final_file} ${bin_file}

  chmod +x ${bin_file}
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


exec_legacy_fetch() {
  local target_dir=$1
  local legacy_dir="${target_dir}/legacy"

  mkdir -p "${legacy_dir}"

  echo "${MUSH_LEGACY_FETCH}" | while IFS=$'\n' read package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_file=${legacy_dir}/${package_name}.sh
    package_bin=${legacy_dir}/${package_name}
    package_url=${package#*=}

    if [ ! -f "${package_file}" ]; then
      console_status "Downloading" "$package_name => $package_url ($package_file)"
      curl -s -L -X GET -o "${package_file}" "${package_url}"
      ln "${package_file}" "${package_bin}"
      chmod +x "${package_bin}"
    fi
  done
}

exec_legacy_build() {
  local target_dir=$1
  local legacy_dir="${target_dir}/legacy"

  mkdir -p "${legacy_dir}"

  echo "${MUSH_LEGACY_BUILD}" | while IFS=$'\n' read package && [ -n "$package" ]; do
    package_name=${package%=*}
    package_file=${legacy_dir}/${package_name}.sh
    package_script=${package#*=}

    if [ ! -f "${package_file}" ]; then
      console_status "Compiling" "$package_name => $package_script ($package_file)"
      local pwd=$PWD
      cd "$legacy_dir"
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$pwd"
    fi
  done


}

exec_manifest_lookup() {
  local pwd=$PWD

  MUSH_MANIFEST_DIR="${PWD}"

  if [ ! -f "Manifest.toml" ]; then
    console_error "could not find 'Manifest.toml' in '$pwd' or any parent directory"
    exit 101
  fi

  manifest_parse

  if [ -z "$MUSH_PACKAGE_VERSION" ]; then
    console_error "failed to parse manifest at '$pwd/Manifest.toml'\n\nCaused by:\n  missing field 'version' for key 'package'"
    exit 101
  fi
}

manifest_parse() {
    #echo "S:"
    newline=$'\n'
    section=MUSH_USTABLE
    while IFS= read line || [[ -n "${line}" ]]; do
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      line_number=$((line_number + 1))
      [[ -z "${line}" ]] && continue
      [[ "${line::1}" == "#" ]] && continue
      case $line in
        "[package]")
          section=MUSH_PACKAGE
          ;;
        "[dependencies]")
          section=MUSH_DEPS
          ;;
        "[dependencies-build]")
          section=MUSH_DEPS_BUILD
          ;;
        "[dev-dependencies]")
          section=MUSH_DEV_DEPS
          ;;
        "[dev-dependencies-build]")
          section=MUSH_DEV_DEPS_BUILD
          ;;
        "[legacy-fetch]")
          section=MUSH_LEGACY_FETCH
          ;;
        "[legacy-build]")
          section=MUSH_LEGACY_BUILD
          ;;
        "[dev-legacy-fetch]")
          section=MUSH_DEV_LEGACY_FETCH
          ;;
        "[dev-legacy-build]")
          section=MUSH_DEV_LEGACY_BUILD
          ;;
        [a-z]*)
          case $section in
            MUSH_PACKAGE)
              field=$(echo "$line" | cut -d'=' -f1 | xargs | awk '{ print toupper($0) }')
              value=$(echo "$line" | cut -d'=' -f2 | xargs)
              eval "${section}_${field}=\$value"
              ;;
            MUSH_LEGACY_FETCH)
              package=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_')
              url=$(echo "$line" | cut -d'=' -f2 | xargs)
              MUSH_LEGACY_FETCH="${MUSH_LEGACY_FETCH}${package}=${url}${newline}"
              ;;
            MUSH_LEGACY_BUILD)
              package=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_')
              script=$(echo "$line" | cut -d'=' -f2 | xargs)
              MUSH_LEGACY_BUILD="${MUSH_LEGACY_FETCH}${package}=${script}${newline}"
              ;;
            MUSH_DEV_DEPS)
              package=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_')
              signature=$(echo "$line" | cut -d'=' -f2 | xargs)
              MUSH_DEV_DEPS="${MUSH_DEV_DEPS}${package}=${signature}${newline}"
              ;;
            MUSH_DEV_DEPS_BUILD)
              package=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_')
              script=$(echo "$line" | cut -d'=' -f2 | xargs)
              MUSH_DEV_DEPS_BUILD="${MUSH_DEV_DEPS_BUILD}${package}=${script}${newline}"
              ;;
            *)
              ;;
          esac
          ;;
        *)
          ;;
      esac
      #echo "L: $line"
    done < "Manifest.toml"
    #echo "E."
}

compile_file() {
  #echo "COMPILE: $1 ($PWD)"

  local src_file=$1
  local build_file=$2

  if [ -n "${build_file}" ]; then
    cat "${src_file}" >> "${build_file}"
  fi

  compile_scan_legacy "${src_file}" "${build_file}"

  compile_scan_public "${src_file}" "${build_file}"

  compile_scan_module "${src_file}" "${build_file}"

  compile_scan_embed "${src_file}" "${build_file}"

  return 0
}

compile_scan_legacy() {
  local src_file=$1
  local build_file=$2
  local legacy_dir=target/debug/legacy

  grep -n '^legacy [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local legacy_name=$(echo "${line#*legacy}" | xargs)
    local legacy_file="${legacy_dir}/${legacy_name}.sh"
    local legacy_dir_file="${legacy_dir}/${legacy_name}/${legacy_name}.sh"
    #echo "LEGACY: $legacy_file"
    if [ -e "${legacy_file}" ]; then
      console_info "Legacy" "file '${legacy_file}' as module file"
      if [ -n "${build_file}" ]; then
        cat "${legacy_file}" >> "${build_file}"
      fi
    elif [ -e "${legacy_dir_file}" ]; then
      console_info "Legacy" "file '${public_dir_file}' as directory module file"
    else
      console_error "file not found for module '${legacy_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To add the module '${legacy_name}', type 'mush legacy --name ${legacy_name} <MODULE_URL>'."
      exit 101
    fi
  done

  return 0
}

compile_scan_public() {
  local src_file=$1
  local build_file=$2
  local public_dir=$(dirname "$src_file")

  grep -n '^public [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local public_name=$(echo "${line#*public}" | xargs)
    local public_file="${public_dir}/${public_name}.sh"
    local public_dir_file="${public_dir}/${public_name}/module.sh"

    if [ -e "${public_file}" ]; then
      console_info "Public" "file '${public_file}' as module file"
      compile_file "${public_file}" "${build_file}"
    elif [ -e "${public_dir_file}" ]; then
      console_info "Public" "file '${public_dir_file}' as directory module file"
      compile_file "${public_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${public_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${public_name}', create file '${public_file}' or '${public_dir_file}'."
      exit 101
    fi
  done

  return 0
}

compile_scan_module() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname $src_file)

  grep -n '^module [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local module_name=$(echo "${line#*module}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"
    if [ -e "${module_file}" ]; then
      console_info "Import" "file '${module_file}' as module file"
      compile_file "${module_file}" "${build_file}"
    elif [ -e "${module_dir_file}" ]; then
      console_info "Import" "file '${module_dir_file}' as directory module file"
      compile_file "${module_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${module_name}', create file '${module_file}' or '${module_dir_file}'."
      exit 101
    fi
  done

  return 0
}

compile_scan_embed() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname "$src_file")

  grep -n '^embed [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local module_name=$(echo "${line#*embed}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"

    if [ -e "${module_file}" ]; then
      console_info "Embed" "file '${module_file}' as module file"
      if [ -n "$build_file" ]; then
        embed_file "$module_name" "$module_file" >> $build_file
      fi
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${module_name}', create file '${module_file}'."
      exit 101
    fi
  done

  return 0
}

exec_publish() {
  local bin_file=/usr/local/bin/mush
  local final_file=target/dist/mush
  local package_name="${MUSH_PACKAGE_NAME}"
  local release_tag="${MUSH_PACKAGE_VERSION}"

  MUSH_GITHUB_REPOSITORY="$(github_get_repository)"

  ## TODO: add the following message when an index will be implemented
  # Updating crates.io index

  ## TODO: add the following message when no stuff
  # warning: manifest has no documentation, homepage or repository.
  # See https://mush.javanile.org/manifest.html#package-metadata for more info.

  if [ ! -z "$(git status --porcelain)" ]; then
    local changed_files="$(git status -s | cut -c4-)"
    local error="some files in the working directory contain changes that were not yet committed into git:"
    local hint="to proceed despite this and include the uncommitted changes, pass the '--allow-dirty' flag"
    console_error "$error\n\n${changed_files}\n\n${hint}"
    exit 101
  fi

  #    Updating crates.io index
  # warning: manifest has no documentation, homepage or repository.
  # See https://doc.rust-lang.org/cargo/reference/manifest.html#package-metadata for more info.
  #   Packaging cask-cli v0.2.0 (/Users/francescobianco/Develop/Javanile/rust-cask)
  #   Verifying cask-cli v0.2.0 (/Users/francescobianco/Develop/Javanile/rust-cask)
  #  Downloaded rand_core v0.6.4
  #  Downloaded 9 crates (2.5 MB) in 1.90s (largest was `run_script` at 1.1 MB)
  #   Compiling serde_yaml v0.9.14
  #   Compiling cask-cli v0.2.0 (/Users/francescobianco/Develop/Javanile/rust-cask/target/package/cask-cli-0.2.0)
  #    Finished dev [unoptimized + debuginfo] target(s) in 13.89s
  #   Uploading cask-cli v0.2.0 (/Users/francescobian

  [ -f .env ] && source .env

  ## Create or update the git tag
  git tag -f -a "$release_tag" -m "Tag $release_tag" > /dev/null 2>&1
  git push origin "$release_tag" -f > /dev/null 2>&1

  release_id="$(github_get_release_id "${release_tag}")"

  if [ -z "${release_id}" ]; then
    release_id=$(github_create_release "${release_tag}")
  fi

  asset_id="$(github_get_release_asset_id "${release_id}")"

  if [ -n "${asset_id}" ]; then
    github_delete_release_asset "${asset_id}"
  fi

  console_status "Uploading" "${package_name} v${release_tag} ($PWD)"

  download_url="$(github_upload_release_asset "${release_id}")"
}

exec_dependencies() {
  process_dev_dependencies
  process_dev_dependencies_build
}

process_dev_dependencies() {
  echo "${MUSH_DEV_DEPS}" | while IFS=$'\n' read dependency && [ -n "$dependency" ]; do
    local package_name=${dependency%=*}
    local package_signature=${dependency#*=}

    if [ ! -d "${MUSH_DEPS_DIR}/${package_name}" ]; then
      process_dev_dependency "$package_name" $package_signature
    fi
  done
}

process_dev_dependency() {
  case "$2" in
    git)
      git_dependency "$1" "$3" "$4"
      ;;
  esac
}

process_dev_dependencies_build() {
  echo "${MUSH_DEV_DEPS_BUILD}" | while IFS=$'\n' read dependency && [ -n "$dependency" ]; do
    local package_name=${dependency%=*}
    local package_script=${dependency#*=}
    local package_dir="${MUSH_DEPS_DIR}/${package_name}"

    if [ -d "${package_dir}" ]; then
      local pwd=$PWD
      cd "${package_dir}"
      eval "PATH=${PATH}:${PWD} ${package_script}"
      cd "$pwd"
    fi
  done
}
main "$@"
