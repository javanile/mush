
legacy() {
  source target/debug/legacy/$1.sh
}

module() {
  #echo "Loading module: $1"
  a=0
}

public() {
  public=$1
}

use() {
  source src/assets/server.sh
}
