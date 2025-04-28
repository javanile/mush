


compile_file() {
  local src_file
  local build_file
  local manifest_directory
  local build_mode

  src_file=$1
  build_file=$2
  manifest_directory=${3:-$PWD}
  build_mode=${4:-debug}

  [ "${VERBOSE}" -gt 5 ] && echo "Compile file '${src_file}' for '${build_mode}' to '${build_file}' from '${manifest_directory}'"

  # Analyze file for syntax errors
  bash -n "${src_file}"

  if [ -n "${build_file}" ]; then
    cat "${src_file}" >> "${build_file}"
    #sed '/^[[:space:]]*$/d' "${src_file}" >> "${build_file}"
  fi

  compile_scan_legacy "${src_file}" "${build_file}" "${manifest_directory}" "${build_mode}"

  compile_scan_public "${src_file}" "${build_file}" "${manifest_directory}" "${build_mode}"

  compile_scan_module "${src_file}" "${build_file}" "${manifest_directory}" "${build_mode}"

  compile_scan_extern_package "${src_file}" "${build_file}" "${manifest_directory}" "${build_mode}"

  compile_scan_embed "${src_file}" "${build_file}" "${manifest_directory}" "${build_mode}"
}

compile_scan_legacy() {
  local src_file=$1
  local build_file=$2
  local legacy_dir=$3/target/$4/legacy

  grep -n '^legacy [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local legacy_name=$(echo "${line#*legacy}" | xargs)
    local legacy_file="${legacy_dir}/__${legacy_name}.sh"
    local legacy_dir_file="${legacy_dir}/${legacy_name}/__${legacy_name}.sh"
    #echo "LEGACY: $legacy_file"
    if [ -e "${legacy_file}" ]; then
      console_info "Legacy" "file '${legacy_file}' as module file"
      if [ -n "${build_file}" ]; then
        #cat "${legacy_file}" >> "${build_file}"
        sed '/^[[:space:]]*$/d' "${legacy_file}" >> "${build_file}"
      fi
    elif [ -e "${legacy_dir_file}" ]; then
      console_info "Legacy" "file '${public_dir_file}' as directory module file"
    else
      console_error "file not found for module '${legacy_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To add the module '${legacy_name}', type 'mush legacy --name ${legacy_name} <MODULE_URL>'."
      exit 101
    fi
  done

  return 0
}

compile_scan_public() {
  local src_file=$1
  local build_file=$2
  local public_dir=$(dirname "$src_file")

  grep -n '^public [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local public_name=$(echo "${line#*public}" | xargs)
    local public_file="${public_dir}/${public_name}.sh"
    local public_dir_file="${public_dir}/${public_name}/module.sh"

    if [ -e "${public_file}" ]; then
      console_info "Public" "file '${public_file}' as module file"
      compile_file "${public_file}" "${build_file}"
    elif [ -e "${public_dir_file}" ]; then
      console_info "Public" "file '${public_dir_file}' as directory module file"
      compile_file "${public_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${public_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${public_name}', create file '${public_file}' or '${public_dir_file}'."
      exit 101
    fi
  done

  return 0
}

compile_scan_module() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname "$src_file")
  local root_src_file

  grep -n '^module [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    root_src_file=

    local module_name=$(echo "${line#*module}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"

    if [ "${module_dir}" = "examples" ]; then
      [ -f "src/${module_name}.sh" ] && root_src_file="src/${module_name}.sh"
      [ -f "src/${module_name}/module.sh" ] && root_src_file="src/${module_name}/module.sh"
    fi

    if [ -e "${module_file}" ]; then
      console_info "Import" "file '${module_file}' as module file"
      compile_file "${module_file}" "${build_file}"
    elif [ -e "${module_dir_file}" ]; then
      console_info "Import" "file '${module_dir_file}' as directory module file"
      compile_file "${module_dir_file}" "${build_file}"
    elif [ -n "${root_src_file}" ]; then
      console_info "Import" "file '${root_src_file}' as module file"
      compile_file "${root_src_file}" "${build_file}"
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${module_name}', create file '${module_file}' or '${module_dir_file}'."
      error_E0583_file_not_found "${module_name}" "${src_file}" "${line%:*}"
      exit 101
    fi
  done

  return 0
}

compile_scan_extern_package() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname "${src_file}")
  local extern_package_dir=${MUSH_TARGET_PATH}

  grep -n '^extern package [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local package_name=$(echo "${line#*package}" | xargs)
    local package_file="${extern_package_dir}/packages/${package_name}/lib.sh"
    if [ -e "${package_file}" ]; then
      console_info "Import" "file '${package_file}' as package file"
      if [ -n "${build_file}" ]; then
        #cat "${package_file}" >> "${build_file}"
        sed '/^[[:space:]]*$/d' "${package_file}" >> "${build_file}"
      fi
    else
      [ "${VERBOSE}" -gt 6 ] && echo "File not found: ${package_file} (package_dir: ${extern_package_dir})"
      error_package_not_found "${package_name}" "${src_file}" "${line%:*}"
      #console_error "File not found for package '${package_name}'. Look at '${src_file}' on line ${line%:*}"
      #console_log  "To create the module '${module_name}', create file '${module_file}' or '${module_dir_file}'."
      exit 101
    fi
  done

  return 0
}

compile_scan_embed() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname "$src_file")

  grep -n '^embed [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local module_name=$(echo "${line#*embed}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"

    if [ -e "${module_file}" ]; then
      console_info "Embed" "file '${module_file}' as module file"
      if [ -n "$build_file" ]; then
        mush_api_2022_embed "$module_name" "$module_file" >> "${build_file}"
      fi
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${module_name}', create file '${module_file}'."
      exit 101
    fi
  done

  return 0
}
