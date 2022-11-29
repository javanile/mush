
git_dependency() {
  local pwd=$PWD
  local package_dir=$1
  local package_url=$2
  local package_tag=$3

  cd "${MUSH_DEPS_DIR}" || exit 101

  git clone --depth 1 --branch "$3" "$2" "${package_dir}" > /dev/null 2>&1

  cd "${pwd}" || exit 101
}
