
exec_build_dist() {
  name=$MUSH_PACKAGE_NAME

  #echo "NAME: $name"

  local bin_file=bin/${name}

  local build_file=target/dist/${name}.tmp
  local final_file=target/dist/${name}

  mkdir -p target/dist/

  echo "#!/usr/bin/env bash" > $build_file
  echo "set -e" >> $build_file

  dist_2022 >> $build_file

  echo "## BP004: Compile the entrypoint" >> "${build_file}"
  compile_file "src/main.sh" "${build_file}"

  echo "## BP005: Execute the entrypoint" >> "${build_file}"
  echo "main \"\$@\"" >> "${build_file}"

  ## Generate binary file
  mkdir -p bin/
  chmod +x "${build_file}"
  cp "${build_file}" "${final_file}"
  cp "${final_file}" "${bin_file}"
}
