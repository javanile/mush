
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
  cat src/main.sh >> $build_file
  echo "main \"\$@\"" >> $build_file

  mkdir -p bin/

  cp ${build_file} ${final_file}
  cp ${final_file} ${bin_file}

  echo -e "\e[1;33m{Mush}\e[0m Start"
  echo -e "       Task completed"
  echo -e "       Search profile"
  echo -e "       \e[1;31mError qui cavallo\e[0m"
  echo -e "       Search profile n2"
  echo -e "       \e[1;33mFinish.\e[0m"

  chmod +x ${bin_file}
}
