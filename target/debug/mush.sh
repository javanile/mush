#!/usr/bin/env bash
set -e

## BP002: Package and debug variables 
MUSH_PACKAGE_NAME=mush
MUSH_DEBUG_PATH=/home/francesco/Develop/Javanile/mush
MUSH_TARGET_PATH="${MUSH_DEBUG_PATH}/target/debug"

## BP003: Embedding debug api
debug_file() {
  local previous_debug_file=$MUSH_DEBUG_FILE
  MUSH_DEBUG_FILE=$1
  source "$1"
  MUSH_DEBUG_FILE=$previous_debug_file
}
extern() {
  local debug_file=$MUSH_DEBUG_FILE
  if [ "$1" = "package" ]; then
    local package_name=$MUSH_PACKAGE_NAME
    local extern_package_name=$2
    local extern_package_path="${MUSH_TARGET_PATH}/packages/${extern_package_name}"
    local extern_package_lib_file="${MUSH_TARGET_PATH}/packages/${extern_package_name}/src/lib.sh"
    if [ -d "${extern_package_path}" ]; then
      debug_file "${extern_package_lib_file}"
    else
      echo "   Compiling rust-app v0.1.0 (/home/francesco/Develop/Javanile/mush/tests/fixtures/rust-app)"
      error_package_not_found "${extern_package_name}" "${debug_file}"
      exit 1
    fi
  else
    echo "   Compiling rust-app v0.1.0 (/home/francesco/Develop/Javanile/mush/tests/fixtures/rust-app)"
    echo "error: expected one of 'package' or '{', found '$1'"
    echo " --> ${debug_file}:8:8"
    echo "  |"
    echo "8 | extern cavallo json;"
    echo "  |        ^^^^^^^ expected one of 'package' or '{'"
    echo ""
    echo "error: could not compile '${package_name}' due to previous error"
    exit 1
  fi
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
  local package_name=$MUSH_PACKAGE_NAME
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
    echo "For more information about this error, try 'mush explain E0583'."
    echo "error: could not compile '${package_name}' due to previous error"
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

## BP001: Appending entrypoint to debug build
debug_file "${MUSH_DEBUG_PATH}/src/main.sh"
main "$@"
