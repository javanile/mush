
bpkg_dependency() {
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

  package_cache_file="./deps/.mush_cache/${package_name}"
  package_cache_hash="${package_full_name}"

  [ "${VERBOSE}" -gt 4 ] && echo "Processing 'bpkg' dependency '$package_name', '$package_full_name', 'source=bpkg'"

  if [ -f "$package_cache_file" ] && [ "$(cat "$package_cache_file")" = "$package_cache_hash" ]; then
    echo "Package already exists, skipping..."
  else
    if [ -z "$(command -v bpkg || true)" ]; then
      console_error "failed to run 'bpkg' to fetch dependency '$package_full_name' from remote registry\n\nYou can install it by running:\n  curl -Lo- https://raw.githubusercontent.com/bpkg/bpkg/master/setup.sh | bash"
      exit 101
    fi

    bpkg install "${package_full_name}"

    #mkdir -p bin || true
    #[ -d "./deps/bin" ] && cp -r ./deps/bin/* ./bin/

    if [ -d "./deps" ]; then
      mkdir -p "./deps/.mush_cache" || true
      echo "$package_cache_hash" > "$package_cache_file"
    fi
  fi
}
