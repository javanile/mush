
exec_build_debug() {
  local name=$MUSH_PACKAGE_NAME

  local build_file=target/debug/${name}.tmp
  local final_file=target/debug/${name}

  echo "#!/usr/bin/env bash" > $build_file
  echo "set -e" >> $build_file
  echo "source src/boot/debug_2022.sh" >> $build_file
  echo "source src/main.sh" >> $build_file
  echo "main \"\$@\"" >> $build_file

  mv "$build_file" "$final_file"

  echo "Build complete."
}
