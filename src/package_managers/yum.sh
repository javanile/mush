
yum_is_available() {
  command -v yum > /dev/null 2>&1 || return 1
  return 0
}

yum_install() {
  local package_name=$1

  if [ "$(id -u)" = "0" ]; then
    yum install -y -q "$package_name"
  else
    system_dependency_not_root "$package_name" "sudo yum install $package_name"
    return 1
  fi
}
