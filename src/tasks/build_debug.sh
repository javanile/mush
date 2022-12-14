
exec_build_debug() {
  local name=$MUSH_PACKAGE_NAME

  local build_file=target/debug/${name}.tmp
  local final_file=target/debug/${name}

  mkdir -p target/debug/

  compile_file "src/main.sh"

  echo "#!/usr/bin/env bash" > $build_file
  echo "set -e" >> $build_file

  MUSH_DEBUG_PATH=${PWD}
  echo "MUSH_DEBUG_PATH=${MUSH_DEBUG_PATH}" >> $build_file

  debug_2022 >> $build_file

  echo "source ${MUSH_DEBUG_PATH}/src/main.sh" >> $build_file
  echo "main \"\$@\"" >> $build_file

  mv "$build_file" "$final_file"

  chmod +x "$final_file"
}
