
pip_is_available() {
  command -v pip > /dev/null 2>&1 && return 0
  command -v pip3 > /dev/null 2>&1 && return 0
  return 1
}

pip_install() {
  local package_name=$1

  if command -v pip3 > /dev/null 2>&1; then
    pip3 install "$package_name"
  else
    pip install "$package_name"
  fi
}