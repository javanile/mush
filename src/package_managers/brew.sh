
brew_is_available() {
  command -v brew > /dev/null 2>&1 || return 1
  return 0
}

brew_install() {
  local package_name=$1

  brew install "$package_name"
}