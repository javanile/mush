
exec_build_release() {
  name=$MUSH_PACKAGE_NAME

  #echo "NAME: $name"

  local bin_file=bin/${name}

  local build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local build_file=target/dist/${name}.tmp
  local final_file=target/dist/${name}

  mkdir -p target/dist/

  echo "#!/usr/bin/env bash" > $build_file
  echo "## BP010: Release metadata" >> "${build_file}"
  echo "## @build_date: ${build_date}" >> "${build_file}"

  echo "set -e" >> $build_file

  dist_2022 >> $build_file

  echo "## BP004: Compile the entrypoint" >> "${build_file}"
  compile_file "src/main.sh" "${build_file}"

  echo "## BP005: Execute the entrypoint" >> "${build_file}"
  echo "main \"\$@\"" >> "${build_file}"

  ## Generate binary on target
  cp "${build_file}" "${final_file}"
  chmod +x "${final_file}"

  ## Generate binary on root
  mkdir -p bin/
  cp "${final_file}" "${bin_file}"
  chmod +x "${bin_file}"
}
