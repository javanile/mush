
mush_color() {
    if [ -n "${MUSH_TERM_COLOR}" ]; then
        printf '%b' "$1"
    fi
}

display_path() {
  local path="${1//$HOME/\~}"
  echo "${path//\/\//\/}"
}
