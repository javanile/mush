
mush_registry_index_update()
{
  MUSH_HOME="${MUSH_HOME:-$HOME/.mush}"
  MUSH_REGISTRY_URL=https://github.com/javanile/mush
  MUSH_REGISTRY_ID=$(echo "${MUSH_REGISTRY_URL}" | tr -s '/:.' '-')
  MUSH_REGISTRY_INDEX="${MUSH_HOME}/registry/index/${MUSH_REGISTRY_ID}"
  MUSH_REGISTRY_SRC="${MUSH_HOME}/registry/src/${MUSH_REGISTRY_ID}"

  local update_strategy="${1:-lazy}"

  if [ "${update_strategy}" = "full" ]; then
    rm -fr "${MUSH_HOME}/registry/index" && true
  fi

  if [ ! -f "${MUSH_REGISTRY_INDEX}" ]; then
    console_status "Updating" "mush packages index"
    mkdir -p "${MUSH_HOME}/registry/index"
    > "${MUSH_REGISTRY_INDEX}"
    mush_registry_index_parse "${MUSH_REGISTRY_URL}/raw/main/.packages"
  fi
}

mush_registry_index_parse() {
  local packages_file
  local packages_local_file
  local packages_index

  packages_file=$1
  packages_local_file="${MUSH_HOME}/registry/index/$(echo "${packages_file}" | tr -s '/:.' '-')"
  packages_index="${MUSH_HOME}/registry/index/$(echo "${packages_file}" | tr -s '/:.' '-')"

  curl -s -L -H 'Cache-Control: no-cache, no-store' "${packages_file}" > "${packages_local_file}"

  #sort -t "|" -k 1,1 -o "${packages_local_file}" "${packages_local_file}"

  if [ ! -s "${packages_local_file}" ]; then
    console_error "spurious network error: Couldn't retrieve '.packages' file at '${packages_file}'"
  fi

  while read -r line; do
    #echo "Entry: ${line}"
    [ -z "${line}" ] && continue
    [ "${line:0:1}" = "#" ] && continue

    local entry_type=$(echo "${line}" | awk '{print $1}')
    case "${entry_type}" in
      "index")
        local entry_url=$(echo "${line}" | awk '{print $2}')
        mush_registry_index_parse "${entry_url}/raw/main/.packages"
        ;;
      "package")
        local package_name=$(echo "${line}" | awk '{print $2}')
        local package_url=$(echo "${line}" | awk '{print $3}')
        local package_path=$(echo "${line}" | awk '{print $4}')
        local package_version=$(echo "${line}" | awk '{print $5}')
        echo "${package_name} ${package_url} ${package_path} ${package_version}" >> "${MUSH_REGISTRY_INDEX}"
        ;;
      *)
        console_error "not supported entry type at '${packages_file}'"
        ;;
    esac
  done < "${packages_local_file}"
}
