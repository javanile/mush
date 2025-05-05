
mush_dependency() {
  local package_name
  local package_full_name
  local package_version_constraint
  local dependency_type
  local update_strategy

  package_name=$1
  package_full_name=$2
  package_version_constraint=$3
  dependency_type=$4
  update_strategy=${5:-lazy}

  mush_registry_index_update "${update_strategy}"

  [ "${VERBOSE}" -gt 4 ] && echo "Processing dependency '$1', '$2', 'source=${package_source}'"

  exec_install_from_index "${package_full_name}" "${package_version_constraint}" "${dependency_type}"
}
