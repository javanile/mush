
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

  [ "$VERBOSE" -gt "0" ] && console_status "Indexing" "updating strategy: $update_strategy"

  if [ -f "${MUSH_REGISTRY_CACHE}" ]; then
    while read -r line; do
      [ "$VERBOSE" -gt "2" ] && echo "Entry cache: ${line}"
      [ -z "${line}" ] && continue
      [ "$(echo "$line" | cut -c1)" = "#" ] && continue
      packages_file_url="$(echo "${line}" | awk '{print $1}')"
      packages_cache_hash="$(echo "${line}" | awk '{print $2}')"
      packages_hash="$(curl -I -s -L -H "Pragma: no-cache" -H "Cache-Control: no-cache" "${packages_file_url}" | grep -i ETag | awk '{print $2}' | tr -d '"')"
      if [ "${packages_cache_hash}" = "${packages_hash}" ]; then
        [ "$VERBOSE" -gt "3" ] && echo "Entry cache: ${line} [unchanged]"
      else
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
    console_status "Updating" "index through cache"
  fi
}

mush_registry_index_parse() {
  local packages_file
  local packages_local_file
  local packages_index
  local entry
  local entry_type
  local entry_description
  local package_name
  local package_url
  local package_path
  local package_version
  local packages_file_url
  local packages_hash
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
    [ "$(echo "$line" | cut -c1)" = "#" ] && continue

    entry=$(echo "${line}" | cut -d'#' -f1)
    entry_type=$(echo "${line}" | awk '{print $1}')
    entry_description=$(case "$line" in *#*) echo "$line" | cut -d'#' -f2 ;; *) echo "(no description)" ;; esac)

    case "${entry_type}" in
      "index")
        entry_url=$(echo "${entry}" | awk '{print $2}')
        packages_file_url="${entry_url}/raw/main/.packages"
        packages_hash="$(curl -I -s -L "${packages_file_url}" | grep -i ETag | awk '{print $2}' | tr -d '"')"
        mush_registry_index_parse "${packages_file_url}"
        echo "${packages_file_url} ${packages_hash}" >> "${MUSH_REGISTRY_CACHE}"
        ;;
      "package")
        package_name=$(echo "${entry}" | awk '{print $2}')
        package_url=$(echo "${entry}" | awk '{print $3}')
        package_path=$(echo "${entry}" | awk '{print $4}')
        package_version=$(echo "${entry}" | awk '{print $5}')
        echo "${package_name} ${package_url} ${package_path} ${package_version} # ${entry_description}" >> "${MUSH_REGISTRY_INDEX}"
        ;;
      *)
        console_error "not supported entry type at '${packages_file}'"
        ;;
    esac
  done < "${packages_local_file}"
}

mush_registry_package_versions() {
  local package_url

  package_url=$1

  git ls-remote --heads "$package_url"  | sed 's?.*refs/heads/??' | grep -E '^[a-z]+$'

  git ls-remote --tags "$package_url"  | sed -n 's|.*refs/tags/\(v\?\([0-9]\+\.[0-9]\+\.[0-9]\+\)\)$|\1|p'
}