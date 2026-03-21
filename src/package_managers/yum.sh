
yum_is_available() {
  command -v yum > /dev/null 2>&1 || return 1
  return 0
}

yum_install() {
  local package_name=$1

  if [ "$(id -u)" = "0" ]; then
    yum install -y -q "$package_name"
  else
    echo "[mush] Dependency '$package_name' is not installed."
    echo "[mush] Run the following command to install it:"
    echo ""
    echo "    sudo yum install $package_name"
    echo ""
    echo "[mush] Then re-run: mush install"
    return 1
  fi
}