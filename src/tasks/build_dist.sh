
exec_build_dist() {
  bin_file=bin/mush

  build_file=target/dist/mush.tmp
  final_file=target/dist/mush

  echo "#!/usr/bin/env bash" > $build_file
  #echo "## " >> $build_file
  echo "set -e" >> $build_file
  cat src/boot/dist_2022.sh >> $build_file
  cat target/debug/legacy/getoptions.sh >> $build_file
  cat src/tasks/legacy_build.sh >> $build_file
  cat src/tasks/build_dist.sh >> $build_file
  cat src/commands/build.sh >> $build_file
  cat src/commands/legacy.sh >> $build_file

  build_dist_mod src/main.sh $build_file

  cat src/main.sh >> $build_file
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

build_dist_mod() {
  src_file=$1
  build_file=$2

  grep '^mod [a-z][a-z]*$' "${src_file}" | while read -r line; do
    mod_dir=$(dirname $src_file)
    mod_name=$(echo "${line##mod}" | xargs)
    mod_file="${mod_dir}/${mod_name}.sh"
    mod_dir_file="${mod_dir}/${mod_name}/mod.sh"
    if [ -e "${mod_file}" ]; then
      console_log "Include '${mod_file}' as module file"
      cat "${mod_file}" >> "${build_file}"
    elif [ -e "${mod_dir_file}" ]; then
      console_log "Include '${mod_dir_file}' as directory module file"
      cat "${mod_dir_file}" >> "${build_file}"
    else
      console_error "File not found for module '${mod_name}'. Look at '${src_file}' on line 1"
      console_info  "To create the module '${mod_name}', create file '${mod_file}' or '${mod_dir_file}'."
      exit 0
    fi
  done
}
