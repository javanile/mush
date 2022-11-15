
exec_build_dist() {

  #echo "error: could not find `Cargo.toml` in `/home/francesco` or any parent directory"

  local bin_file=bin/mush

  local build_file=target/dist/mush.tmp
  local final_file=target/dist/mush

  echo "#!/usr/bin/env bash" > $build_file
  #echo "## " >> $build_file
  echo "set -e" >> $build_file
  cat src/boot/dist_2022.sh >> $build_file
  cat target/debug/legacy/getoptions.sh >> $build_file
  cat src/tasks/legacy_build.sh >> $build_file
  #cat src/tasks/build_dist.sh >> $build_file
  cat src/commands/build.sh >> $build_file
  cat src/commands/legacy.sh >> $build_file

  build_dist_parse "src/main.sh" "${build_file}"

  echo "main \"\$@\"" >> $build_file

  mkdir -p bin/

  cp ${build_file} ${final_file}
  cp ${final_file} ${bin_file}

  #echo -e "\e[1;33m{Mush}\e[0m Start"
  #echo -e "       Task completed"
  #echo -e "       Search profile"
  #echo -e "       \e[1;31mError qui cavallo\e[0m"
  #echo -e "       Search profile n2"
  #echo -e "       \e[1;33mFinish.\e[0m"

  chmod +x ${bin_file}

  console_done "Build complete."
}

build_dist_parse() {
  local src_file=$1
  local build_file=$2

  cat "${src_file}" >> "${build_file}"

  build_dist_parse_public "${src_file}" "${build_file}"

  build_dist_parse_module "${src_file}" "${build_file}"

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
      exit 0
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
      exit 0
    fi
  done

  return 0
}
