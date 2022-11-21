
exec_build_dist() {
  name=$MUSH_PACKAGE_NAME

  #echo "NAME: $name"

  local bin_file=bin/${name}

  local build_file=target/dist/${name}.tmp
  local final_file=target/dist/${name}

  echo "#!/usr/bin/env bash" > $build_file
  echo "set -e" >> $build_file

  dist_2022 >> $build_file

  cat target/debug/legacy/getoptions.sh >> $build_file

  build_dist_parse "src/main.sh" "${build_file}"

  echo "main \"\$@\"" >> $build_file

  mkdir -p bin/

  cp ${build_file} ${final_file}
  cp ${final_file} ${bin_file}

  chmod +x ${bin_file}

  console_done "Build complete."
}

build_dist_parse() {
  local src_file=$1
  local build_file=$2

  cat "${src_file}" >> "${build_file}"

  build_dist_parse_public "${src_file}" "${build_file}"

  build_dist_parse_module "${src_file}" "${build_file}"

  build_dist_parse_embed "${src_file}" "${build_file}"

  return 0
}

build_dist_parse_public() {
  local src_file=$1
  local build_file=$2
  local public_dir=$(dirname $src_file)

  grep -n '^public [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local public_name=$(echo "${line#*public}" | xargs)
    local public_file="${public_dir}/${public_name}.sh"
    local public_dir_file="${public_dir}/${public_name}/module.sh"
    if [ -e "${public_file}" ]; then
      console_log "Public '${public_file}' as module file"
      build_dist_parse "${public_file}" "${build_file}"
    elif [ -e "${public_dir_file}" ]; then
      console_log "Public '${public_dir_file}' as directory module file"
      build_dist_parse "${public_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${public_name}'. Look at '${src_file}' on line ${line%:*}"
      console_info  "To create the module '${public_name}', create file '${public_file}' or '${public_dir_file}'."
      exit 101
    fi
  done

  return 0
}

build_dist_parse_module() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname $src_file)

  grep -n '^module [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local module_name=$(echo "${line#*module}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"
    if [ -e "${module_file}" ]; then
      console_log "Import '${module_file}' as module file"
      build_dist_parse "${module_file}" "${build_file}"
    elif [ -e "${module_dir_file}" ]; then
      console_log "Import '${module_dir_file}' as directory module file"
      build_dist_parse "${module_dir_file}" "${build_file}"
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_info  "To create the module '${module_name}', create file '${module_file}' or '${module_dir_file}'."
      exit 101
    fi
  done

  return 0
}

build_dist_parse_embed() {
  local src_file=$1
  local build_file=$2
  local module_dir=$(dirname $src_file)

  grep -n '^embed [a-z][a-z0-9_]*$' "${src_file}" | while read -r line; do
    local module_name=$(echo "${line#*embed}" | xargs)
    local module_file="${module_dir}/${module_name}.sh"
    local module_dir_file="${module_dir}/${module_name}/module.sh"
    if [ -e "${module_file}" ]; then
      console_log "Embed '${module_file}' as module file"
      embed_file "$module_name" "$module_file" >> $build_file
    else
      console_error "File not found for module '${module_name}'. Look at '${src_file}' on line ${line%:*}"
      console_info  "To create the module '${module_name}', create file '${module_file}'."
      exit 101
    fi
  done

  return 0
}
