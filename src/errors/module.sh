
error_package_not_found() {
  local package_name=$MUSH_PACKAGE_NAME
  local extern_package_name=$1
  local debug_file=$2

  echo "error[E0463]: can't find package for '${extern_package_name}'"
  echo " --> ${debug_file}:8:1"
  echo "  |"
  echo "8 | extern crate cavallo;"
  echo "  | ^^^^^^^^^^^^^^^^^^^^^ can't find crate"
  echo ""
  echo "For more information about this error, try 'mush explain E0463'."
  echo "error: could not compile '${package_name}' due to previous error"
}

