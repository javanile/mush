
pacman_is_available() {
  command -v pacman > /dev/null 2>&1 || return 1
  return 0
}

pacman_install() {
  local package_name=$1

  if [ "$(id -u)" = "0" ]; then
    pacman -S --noconfirm "$package_name"
  else
    echo "[mush] Dependency '$package_name' is not installed."
    echo "[mush] Run the following command to install it:"
    echo ""
    echo "    sudo pacman -S $package_name"
    echo ""
    echo "[mush] Then re-run: mush install"
    return 1
  fi
}