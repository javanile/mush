
parser_definition_info() {
	setup REST help:usage abbr:true -- "Display information about a package in the registry" ''

  msg   -- 'USAGE:' "  ${2##*/} info [OPTIONS] [PACKAGE]" ''

	msg   -- 'OPTIONS:'
  flag  VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag  QUIET          -q --quiet                        -- "Do not print mush log messages"
	disp  :usage         -h --help                         -- "Print help information"
}

run_info() {
  local package_name
  local package_entry

  eval "$(getoptions parser_definition_info parse "$0")"
  parse "$@"
  eval "set -- $REST"

  package_name="$1"

  if [ -z "${package_name}" ]; then
    console_error "the following required arguments were not provided: PACKAGE"
    exit 1
  fi

  mush_registry_index_update

  while IFS= read -r line; do
    [ -z "$line" ] && continue
    case "$line" in \#*) continue ;; esac

    case "$line" in
      "$package_name "*)
        package_entry="${line%%#*}"
        break
        ;;
    esac
  done < "$MUSH_REGISTRY_INDEX"

  if [ -n "$package_entry" ]; then
    # shellcheck disable=SC2086
    set -- $package_entry
    package_name=$1
    package_url=$2
    package_path=$3

    echo "Name: $package_name"
    echo "Url:  $package_url"
    echo "Path: $package_path"
    echo ""
    echo "Versions:"

    mush_registry_package_versions "$package_url" | sed 's/^/ - /'

    #echo "Entry: $package_entry"
  else
    console_error "could not find '$package_name' in registry '${MUSH_REGISTRY_URL}'" >&2
    exit 101
  fi
}
