sed_extract_between() {
  local file="$1"
  local start_pattern="$2"
  local end_pattern="$3"
  local output_file="$4"
  
  if [ -n "$output_file" ]; then
    sed -n "/${start_pattern}/,/${end_pattern}/p" "$file" > "$output_file"
  else
    sed -n "/${start_pattern}/,/${end_pattern}/p" "$file"
  fi
}