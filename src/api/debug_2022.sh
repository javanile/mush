
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

embed() {
  local module_file=src/$MUSH_RUNTIME_MODULE/$1.sh
  eval "$(embed_file $1 $module_file)"
}
