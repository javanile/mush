sed_insert_before() {
  local file="$1"
  local line_pattern="$2"
  local content="$3"
  local output_file="${4:-$file}"
  
  if [ "$file" != "$output_file" ]; then
    sed "/${line_pattern}/i\\${content}" "$file" > "$output_file"
  else
    sed -i "/${line_pattern}/i\\${content}" "$file"
  fi
}