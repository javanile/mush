sed_extract_lines() {
  local file="$1"
  local pattern="$2"
  local output_file="$3"
  
  if [ -n "$output_file" ]; then
    sed -n "/${pattern}/p" "$file" > "$output_file"
  else
    sed -n "/${pattern}/p" "$file"
  fi
}