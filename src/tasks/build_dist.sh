
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

  cat target/debug/legacy/getoptions.sh >> $build_file

  compile_file "src/main.sh" "${build_file}"

  echo "main \"\$@\"" >> $build_file

  mkdir -p bin/

  cp ${build_file} ${final_file}
  cp ${final_file} ${bin_file}

  chmod +x ${bin_file}
}

