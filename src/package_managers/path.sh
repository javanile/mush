
mush_path_dependency() {
  local pwd
  local package_name
  local package_full_name
  local package_version_constraint
  local dependency_type
  local package_cache_file
  local package_cache_hash

  pwd=$PWD
  package_name=$1
  package_full_name=$2
  package_version_constraint=$3
  dependency_type=$4

  echo "Path: $package_name"
}
