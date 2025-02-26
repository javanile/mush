sed_delete_lines() {
  local file="$1"
  local pattern="$2"
  local output_file="${3:-$file}"
  
  if [ "$file" != "$output_file" ]; then
    sed "/${pattern}/d" "$file" > "$output_file"
  else
    sed -i "/${pattern}/d" "$file"
  fi
}