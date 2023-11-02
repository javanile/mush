
extern package code_dumper

mush_errors_explain() {
    echo "Explain: $1"
}

error_package_not_found() {
  local package_name=$MUSH_PACKAGE_NAME
  local extern_package_name=$1
  local debug_file=$2
  local debug_line

  debug_line=$(awk "/extern package ${extern_package_name}/{ print NR; exit }" "${debug_file}")
  [ -z "${debug_line}" ] && debug_line=$(awk "/${extern_package_name}/{ print NR; exit }" "${debug_file}")
  [ -z "${debug_line}" ] && debug_line=1

  echo "error[E0463]: can't find package for '${extern_package_name}'"
  code_dumper "${debug_file}" "${debug_line}" "${extern_package_name}" "..."
  echo ""
  echo "For more information about this error, try 'mush --explain E0463'."
  echo "error: could not compile '${package_name}' due to previous error"
}

error_E0583_file_not_found() {
  local package_name
  local module_name
  local debug_file
  local debug_line

  package_name=$MUSH_PACKAGE_NAME
  module_name=$1
  debug_file=$2
  debug_line=$3

  console_error_code "E0583" "file not found for module '${module_name}'"
  code_dumper "${debug_file}" "${debug_line}" "${module_name}" "..."
  echo ""
  echo "For more information about this error, try 'mush --explain E0463'."
  echo "error: could not compile '${package_name}' due to previous error"
}
