
exec_install() {
  local bin_file=/usr/local/bin/mush
  local final_file=target/dist/mush

  local cp=cp
  local chmod=chmod
  if [[ $EUID -ne 0 ]]; then
      cp="sudo ${cp}"
      chmod="sudo ${chmod}"
  fi

  ${cp} ${final_file} ${bin_file}
  ${chmod} +x ${bin_file}

  echo "Finished release [optimized] target(s) in 0.18s"
  echo "Installing /home/francesco/.cargo/bin/cask"
  echo "Installed package 'cask-cli v0.1.0 (/home/francesco/Develop/Javanile/rust-cask)' (executable 'cask')"
}

