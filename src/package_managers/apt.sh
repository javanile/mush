
apt_is_available() {
  command -v apt > /dev/null 2>&1 || return 1
  return 0
}

apt_install() {
  local package_name=$1

  if [ "$(id -u)" = "0" ]; then
    apt-get update -qq && apt-get install -y -qq "$package_name"
  else
    system_dependency_not_root "$package_name" "sudo apt install $package_name"
    return 1
  fi
}