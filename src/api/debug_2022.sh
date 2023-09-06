
extern() {
  local a=1
}

legacy() {
  local legacy_file="target/debug/legacy/$1.sh"
  local legacy_file_path="${MUSH_DEBUG_PATH}/${legacy_file}"

  if [ ! -f "$legacy_file_path" ]; then
    echo "File not found '${legacy_file}', type 'mush build' to recover this problem." >&2
    exit 101
  fi

  source "${legacy_file_path}"
}

module() {
  local module_name=$1
  local module_file="src/$1.sh"
  local module_file_path="${MUSH_DEBUG_PATH}/${module_file}"
  local module_dir_file="src/$1/module.sh"
  local module_dir_file_path="${MUSH_DEBUG_PATH}/${module_dir_file}"
  local debug_file=$MUSH_DEBUG_FILE

  if [ -f "${module_file_path}" ]; then
    source "${module_file_path}"
  elif [ -f "${module_dir_file_path}" ]; then
    MUSH_RUNTIME_MODULE=$1
    source "${module_dir_file_path}"
  else
    echo "   Compiling rust-app v0.1.0 (/home/francesco/Develop/Javanile/mush/tests/fixtures/rust-app)"
    echo "error[E0583]: file not found for module '${module_name}'"
    echo " --> ${debug_file}:4:1"
    echo "  |"
    echo "4 | mod notfound;"
    echo "  | ^^^^^^^^^^^^^"
    echo "  |"
    echo "  = help: to create the module '${module_name}', create file 'src/${module_name}.sh' or 'src/${module_name}/module.sh'"
    echo ""
    echo "For more information about this error, try 'rustc --explain E0583'."
    echo "error: could not compile `rust-app` due to previous error"
    exit 1
  fi
}

public() {
  local module_file="src/$MUSH_RUNTIME_MODULE/$1.sh"
  local module_file_path="${MUSH_DEBUG_PATH}/${module_file}"
  local module_dir_file="src/$MUSH_RUNTIME_MODULE/$1/module.sh"
  local module_dir_file_path="${MUSH_DEBUG_PATH}/${module_dir_file}"

  if [ -f "${module_file_path}" ]; then
    source "${module_file_path}"
  elif [ -f "${module_dir_file_path}" ]; then
    source "${module_dir_file_path}"
  fi
}

use() {
  source src/assets/server.sh
}

embed() {
  local module_file="src/${MUSH_RUNTIME_MODULE}/$1.sh"
  local module_file_path="${MUSH_DEBUG_PATH}/${module_file}"

  eval "$(embed_file "$1" "${module_file_path}")"
}
