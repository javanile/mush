
mush_dependency() {
  echo "MUST DEP: $1 $2 $3"

  exec_index_update

  exec_install_from_index "$2"
}
