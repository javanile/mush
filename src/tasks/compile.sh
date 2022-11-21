
compile_file() {
  local src_file=$1
  local build_file=$2

  if [ -n "${build_file}" ]; then
    cat "${src_file}" >> "${build_file}"
  fi

  compile_scan_public "${src_file}" "${build_file}"

  compile_scan_module "${src_file}" "${build_file}"

  compile_scan_embed "${src_file}" "${build_file}"

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
  local module_dir=$(dirname $src_file)

  grep -n '^module [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local module_name=$(echo "${line#*module}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"
    if [ -e "${module_file}" ]; then
      console_info "Import" "file '${module_file}' as module file"
      compile_file "${module_file}" "${build_file}"
    elif [ -e "${module_dir_file}" ]; then
      console_info "Import" "file '${module_dir_file}' as directory module file"
      compile_file "${module_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${module_name}', create file '${module_file}' or '${module_dir_file}'."
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
        embed_file "$module_name" "$module_file" >> $build_file
      fi
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_log  "To create the module '${module_name}', create file '${module_file}'."
      exit 101
    fi
  done

  return 0
}
