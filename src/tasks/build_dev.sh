



exec_build_dev() {
  build_file=target/debug/mush.tmp
  final_file=target/debug/mush

  echo "#!/usr/bin/env bash" > $build_file
  echo "## " >> $build_file
  echo "set -e" >> $build_file
  echo "source src/boot/debug_2022.sh" >> $build_file
  echo "source target/debug/legacy/getoptions.sh" >> $build_file
  echo "source src/commands/build_debug.sh" >> $build_file
  echo "source src/commands/legacy_fetch.sh" >> $build_file
  echo "source src/main.sh" >> $build_file
  echo "main \$@" >> $build_file

  mv $build_file $final_file

  echo "Build complete."
}
