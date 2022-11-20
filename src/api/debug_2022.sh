
embed api_debug_2022

legacy() {
  source target/debug/legacy/$1.sh
}

module() {
  local module_file=src/$1.sh
  local module_dir_file=src/$1/module.sh
  if [ -f "$module_file" ]; then
    source "$module_file"
  else
    MUSH_RUNTIME_MODULE=$1
    source "$module_dir_file"
  fi
}

public() {
  echo "PUBLIC: $1 $MUSH_RUNTIME_MODULE"
  public=$1

  local module_file=src/$MUSH_RUNTIME_MODULE/$1.sh
  local module_dir_file=src/$MUSH_RUNTIME_MODULE/$1/module.sh

  echo $module_file
  if [ -f "$module_file" ]; then
    source "$module_file"
  elif [ -f "$module_dir_file" ]; then
    source "$module_dir_file"
  fi
}

use() {
  source src/assets/server.sh
}
