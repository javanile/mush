
legacy() {
  legacy=$1
}

module() {
  module=$1
}

public() {
  public=$1
}

use() {
  use=$1
}


embed() {
 # caller | tail -1

  #MUSH_TARGET_DIR

  eval "$1() { echo \"\"; }"
}

