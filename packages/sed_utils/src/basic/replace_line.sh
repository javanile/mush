sed_replace_line() {
  local file="$1"
  local line_pattern="$2"
  local replacement="$3"
  local output_file="${4:-$file}"
  
  if [ "$file" != "$output_file" ]; then
    sed "/${line_pattern}/c\\${replacement}" "$file" > "$output_file"
  else
    sed -i "/${line_pattern}/c\\${replacement}" "$file"
  fi
}