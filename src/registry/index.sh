
mush_registry_index_update()
{
  MUSH_HOME="${MUSH_HOME:-$HOME/.mush}"
  MUSH_REGISTRY_URL=https://github.com/javanile/mush
  MUSH_REGISTRY_ID=$(echo "${MUSH_REGISTRY_URL}" | tr -s '/:.' '-')
  MUSH_REGISTRY_INDEX="${MUSH_HOME}/registry/index/${MUSH_REGISTRY_ID}.index"
  MUSH_REGISTRY_CACHE="${MUSH_HOME}/registry/index/${MUSH_REGISTRY_ID}.cache"
  MUSH_REGISTRY_SRC="${MUSH_HOME}/registry/src/${MUSH_REGISTRY_ID}"

  local packages_file_url
  local packages_cache_hash
  local packages_hash

  local update_strategy="${1:-lazy}"

  [ "$VERBOSE" -gt "0" ] && console_debug "Indexing" "updating strategy: $update_strategy"

  if [ -f "${MUSH_REGISTRY_CACHE}" ]; then
    while read -r line; do
      [ "$VERBOSE" -gt "2" ] && echo "Entry cache: ${line}"
      [ -z "${line}" ] && continue
      [ "$(echo "$line" | cut -c1)" = "#" ] && continue
      packages_file_url="$(echo "${line}" | awk '{print $1}')"
      packages_cache_hash="$(echo "${line}" | awk '{print $2}')"
      packages_hash="$(curl -I -s -L "${packages_file_url}" | grep -i ETag | awk '{print $2}' | tr -d '"')"
      if [ "${packages_cache_hash}" != "${packages_hash}" ]; then
         rm -fr "${MUSH_HOME}/registry/index" && true
      fi
    done < "${MUSH_REGISTRY_CACHE}"
  fi

  if [ "${update_strategy}" = "full" ]; then
    rm -fr "${MUSH_HOME}/registry/index" && true
  fi

  if [ ! -f "${MUSH_REGISTRY_INDEX}" ]; then
    console_status "Updating" "mush packages index"
    mkdir -p "${MUSH_HOME}/registry/index"
    > "${MUSH_REGISTRY_INDEX}"
    local packages_file_url="${MUSH_REGISTRY_URL}/raw/main/.packages"
    local packages_hash="$(curl -I -s -L "${packages_file_url}" | grep -i ETag | awk '{print $2}' | tr -d '"')"
    echo "${packages_file_url} ${packages_hash}" > "${MUSH_REGISTRY_CACHE}"
    mush_registry_index_parse "${packages_file_url}"
  elif [ "${VERBOSE}" -gt "0" ]; then
    console_debug "Updating" "index through cache"
  fi
}

mush_registry_index_parse() {
  local packages_file
  local packages_local_file
  local packages_index

  local package_description

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
    [ "$(echo "$line" | cut -c1)" = "#" ] && continue

    local entry_type=$(echo "${line}" | awk '{print $1}')
    case "${entry_type}" in
      "index")
        local entry_url=$(echo "${line}" | awk '{print $2}')
        local packages_file_url="${entry_url}/raw/main/.packages"
        local packages_hash="$(curl -I -s -L "${packages_file_url}" | grep -i ETag | awk '{print $2}' | tr -d '"')"
        mush_registry_index_parse "${packages_file_url}"
        echo "${packages_file_url} ${packages_hash}" >> "${MUSH_REGISTRY_CACHE}"
        ;;
      "package")
        local package_name=$(echo "${line}" | awk '{print $2}')
        local package_url=$(echo "${line}" | awk '{print $3}')
        local package_path=$(echo "${line}" | awk '{print $4}')
        local package_version=$(echo "${line}" | awk '{print $5}')
        package_description=$(case "$line" in *#*) echo "$line" | cut -d'#' -f2 ;; *) echo "(no description)" ;; esac)
        echo "${package_name} ${package_url} ${package_path} ${package_version} # ${package_description}" >> "${MUSH_REGISTRY_INDEX}"
        ;;
      *)
        console_error "not supported entry type at '${packages_file}'"
        ;;
    esac
  done < "${packages_local_file}"
}
