
if ! declare -F "extern" > /dev/null; then
  extern() {
    extern=$1
  }
fi

if ! declare -F "legacy" > /dev/null; then
  legacy() {
    legacy=$1
  }
fi

if ! declare -F "module" > /dev/null; then
  module() {
    module=$1
  }
fi

if ! declare -F "public" > /dev/null; then
  public() {
    public=$1
  }
fi

if ! declare -F "use" > /dev/null; then
  use() {
    use=$1
  }
fi

if ! declare -F "embed" > /dev/null; then
  embed() {
    embed=$1
  }
fi
