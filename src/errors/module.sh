
error_dump_code() {
  local file=$1
  local line=$2
  local source=$(sed -n "${line}p" "${file}")

  echo -e "${ESCAPE}[1m${ESCAPE}[38;5;12m --> ${ESCAPE}[0m${file}:${line}:1"
  echo -e "${ESCAPE}[1m${ESCAPE}[38;5;12m  |${ESCAPE}[0m"
  echo -e "${ESCAPE}[1m${ESCAPE}[38;5;12m${line} | ${ESCAPE}[0m$source"
  echo -e "${ESCAPE}[1m${ESCAPE}[38;5;12m  | ${ESCAPE}[0m^^^^^^^^^^^^^^^^^^^^^ can't find crate"
  echo -e ""
}

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

error_E0583_file_not_found() {
  local package_name=$MUSH_PACKAGE_NAME
  local module_name=$1
  local debug_file=$2
  local debug_line=$3

  console_error_code "E0583" "file not found for module '${module_name}'"
  error_dump_code "${debug_file}" "${debug_line}"

  echo "For more information about this error, try 'mush explain E0463'."
  echo "error: could not compile '${package_name}' due to previous error"
}
