
embed() {
  caller | tail -1

  #MUSH_TARGET_DIR

  eval "$1() { echo \"CIAO\"; }"
}

