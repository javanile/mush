
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
  local bold
  local green
  local reset

  eval "$(getoptions parser_definition_info parse "$0")"
  parse "$@"
  eval "set -- $REST"

  package_name="$1"

  if [ -z "${package_name}" ]; then
    console_error "the following required arguments were not provided: PACKAGE"
    exit 1
  fi

  mush_env
  mush_registry_index_update

  while IFS= read -r line; do
    [ -z "$line" ] && continue
    case "$line" in \#*) continue ;; esac

    case "$line" in
      "$package_name "*)
        [ "${VERBOSE}" -gt 2 ] && echo "Found: $line"
        package_entry="${line%%#*}"
        package_description="$(printf '%s\n' "${line}" | sed -n 's/^[^#]*# *\([^ ]\(.*\)\)/\1/p')"
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

    bold=$(mush_color '\033[1m')
    green=$(mush_color '\033[32m')
    cyan=$(mush_color '\033[36m')
    yellow=$(mush_color '\033[33m')
    reset=$(mush_color '\033[0m')

    echo "${bold}Name:${reset} ${green}${package_name}${reset}"
    [ -n "$package_description" ] && echo "${bold}Desc:${reset} ${cyan}${package_description}${reset}"
    echo "${bold}Repo:${reset} ${cyan}${package_url}${reset}"
    [ -n "$package_path" ] && echo "${bold}Path:${reset} ${cyan}${package_path}${reset}"

    echo ""
    echo "${bold}Versions:${reset}"

    echo -n "${yellow}"
    mush_registry_package_versions "$package_url" | sed 's/^/ - /'
    echo -n "${reset}"

    #echo "Entry: $package_entry"
  else
    console_error "could not find '$package_name' in registry '${MUSH_REGISTRY_URL}'" >&2
    exit 101
  fi
}
