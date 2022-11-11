

exec_build_dist() {
  build_file=target/dist/mush.tmp
  final_file=target/dist/mush

  echo "#!/usr/bin/env bash" > $build_file
  #echo "## " >> $build_file
  echo "set -e" >> $build_file
  cat src/boot/dist_2022.sh >> $build_file
  cat target/debug/legacy/getoptions.sh >> $build_file
  cat src/commands/build_debug.sh >> $build_file
  cat source src/commands/legacy_fetch.sh >> $build_file
  cat source src/main.sh >> $build_file
  echo "main \$@" >> $build_file



}
