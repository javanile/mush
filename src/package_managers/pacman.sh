
pacman_is_available() {
  command -v pacman > /dev/null 2>&1 || return 1
  return 0
}

pacman_install() {
  local package_name=$1

  if [ "$(id -u)" = "0" ]; then
    pacman -S --noconfirm "$package_name"
  else
    system_dependency_not_root "$package_name" "sudo pacman -S $package_name"
    return 1
  fi
}